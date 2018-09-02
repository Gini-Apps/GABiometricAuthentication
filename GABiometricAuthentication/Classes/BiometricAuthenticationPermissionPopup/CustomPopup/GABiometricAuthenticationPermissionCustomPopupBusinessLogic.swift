//
//  GABiometricAuthenticationPermissionCustomPopupBusinessLogic.swift
//  GABiometricAuthentication
//
//  Created by ido meirov on 30/08/2018.
//

import Foundation

protocol GABiometricAuthenticationPermissionCustomPopupBusinessLogicDelegate: GABiometricAuthenticationPermissionBusinessLogicDelegate
{
    func updateUI(byConfiguration uiConfiguration: GACustomPopupUIConfiguration)
}

class GABiometricAuthenticationPermissionCustomPopupBusinessLogic: GABiometricAuthenticationPermissionBusinessLogic<GACustomPopupConfiguration>
{
    // MARK: - Properties
    weak var delegate: GABiometricAuthenticationPermissionCustomPopupBusinessLogicDelegate?
    
    // MARK: - Override
    override func handleRegisterResults(_ result: RegistrationResult)
    {
        DispatchQueue.main.async { [weak self] in
            
            guard let strongSelf = self else { return }
            strongSelf.onAllowAction = false
            switch result
            {
            case .allow         : strongSelf.configuration.resultBlock(true); strongSelf.delegate?.finish()
            case .doNotAllow    : strongSelf.configuration.resultBlock(false); strongSelf.delegate?.finish()
            case .cancel        : break
            }
        }
    }
    
    override func doNotAllowActionDidFinish()
    {
        delegate?.finish()
    }
    
    
    override func handleViewDidLoad()
    {
        delegate?.updateUI(byConfiguration: configuration.uiConfiguration)
    }
}

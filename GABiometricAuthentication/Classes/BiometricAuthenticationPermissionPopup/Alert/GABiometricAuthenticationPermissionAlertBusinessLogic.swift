//
//  GABiometricAuthenticationPermissionAlertBusinessLogic.swift
//  GABiometricAuthentication
//
//  Created by Ido Meirov on 09/01/2019.
//

import Foundation

class GABiometricAuthenticationPermissionAlertBusinessLogic: GABiometricAuthenticationPermissionBusinessLogic<GAAlertConfiguration>
{
    
    // MARK: - Override
    override func handleRegisterResults(_ result: RegistrationResult)
    {
        DispatchQueue.main.async { [weak self] in
            
            guard let strongSelf = self else { return }
            strongSelf.onAllowAction = false
            switch result
            {
            case .allow         : strongSelf.configuration.resultBlock(true); strongSelf.handleDismiss()
            case .doNotAllow    : strongSelf.configuration.resultBlock(false); strongSelf.handleDismiss()
            case .cancel        : break
            }
        }
    }
    
    override func doNotAllowActionDidFinish()
    {
        handleDismiss()
    }
    
    
    override func handleViewDidLoad()
    {
        
    }
}

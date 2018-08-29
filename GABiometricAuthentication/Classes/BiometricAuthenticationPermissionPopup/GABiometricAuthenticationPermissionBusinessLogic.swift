//
//  GABiometricAuthenticationPermissionBusinessLogic.swift
//  GABiometricAuthentication
//
//  Created by ido meirov on 29/08/2018.
//

import Foundation

protocol GABiometricAuthenticationPermissionBusinessLogicProtocol
{
    var delegate: GABiometricAuthenticationPermissionBusinessLogicDelegate? { get set }
    
    func handleAllowAction()
    func handleDoNotAllowAction()
}

protocol GABiometricAuthenticationPermissionBusinessLogicDelegate: class
{
    func finish()
}

class GABiometricAuthenticationPermissionBusinessLogic: GABiometricAuthenticationPermissionBusinessLogicProtocol
{
    // MARK: - Properties
    private let localizedReason: String
    private let resultBlock: BiometricAuthenticationRegistrationResultBlock
    
    weak var delegate: GABiometricAuthenticationPermissionBusinessLogicDelegate?
    
    // MARK: - Object life cycle
    init(localizedReason: String, resultBlock: @escaping BiometricAuthenticationRegistrationResultBlock)
    {
        self.localizedReason    = localizedReason
        self.resultBlock        = resultBlock
    }
    
    // MARK: - GABiometricAuthenticationPermissionBusinessLogicProtocol
    func handleAllowAction()
    {
        GABiometricAuthenticationService.register(forBiometricLocalAuthenticationWithLocalizedReason: localizedReason) { (success) in
            
            DispatchQueue.main.async { [weak self] in
                
                guard let strongSelf = self else { return }
                
                strongSelf.delegate?.finish()
            }
        }
    }
    
    func handleDoNotAllowAction()
    {
        GABiometricAuthenticationService.updateUserDidShowPermissionForBiometricAuthentication()
        resultBlock(false)
        delegate?.finish()
    }
}

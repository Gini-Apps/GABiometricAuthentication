//
//  GABiometricAuthenticationPermissionBusinessLogic.swift
//  GABiometricAuthentication
//
//  Created by ido meirov on 30/08/2018.
//

import Foundation

protocol GABiometricAuthenticationPermissionBusinessLogicProtocol
{
    func handleAllowAction()
    func handleDoNotAllowAction()
    func handleDismiss()
    func handleViewDidLoad()
}

protocol GABiometricAuthenticationPermissionBusinessLogicDelegate: class
{
    func finish()
}

class GABiometricAuthenticationPermissionBusinessLogic<T: GABiometricAuthenticationPopupConfiguration>: GABiometricAuthenticationPermissionBusinessLogicProtocol
{
    // MARK: - Properties
    var didUpdateShowPermission : Bool
    let configuration           : T
    var onAllowAction           : Bool
    
    // MARK: - Object life cycle
    init(configuration: T)
    {
        self.configuration              = configuration
        self.didUpdateShowPermission    = false
        self.onAllowAction              = false
    }
    
    final func handleAllowAction()
    {
        guard !onAllowAction else { return }
        onAllowAction = true
        didUpdateShowPermission = true
        GABiometricAuthenticationService.register(forBiometricLocalAuthenticationWithLocalizedReason: configuration.localizedReason) { [weak self] (result) in
            
            self?.handleRegisterResults(result)
        }
    }
    
    final func handleDoNotAllowAction()
    {
        GABiometricAuthenticationService.updateUserDidShowPermissionForBiometricAuthentication()
        GABiometricAuthenticationService.setUserRevokeBiometricAuthentication(true)
        didUpdateShowPermission = true
        configuration.resultBlock(false)
        doNotAllowActionDidFinish()
    }
    
    final func handleDismiss()
    {
        guard !didUpdateShowPermission else { return }
        GABiometricAuthenticationService.updateUserDidShowPermissionForBiometricAuthentication()
    }
    
    func handleViewDidLoad()
    {
        
    }
    
    func handleRegisterResults(_ result: RegistrationResult)
    {
        fatalError("must be override by the subclass")
    }
    
    func doNotAllowActionDidFinish()
    {
        fatalError("must be override by the subclass")
    }
}

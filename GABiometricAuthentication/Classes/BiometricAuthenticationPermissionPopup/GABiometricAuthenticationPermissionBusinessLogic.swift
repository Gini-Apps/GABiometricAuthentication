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
    func handleDismiss()
    func handleViewDidLoad()
}

protocol GABiometricAuthenticationPermissionBusinessLogicDelegate: class
{
    func finish()
    func updateUI(byConfiguration uiConfiguration: GAFullScreenUIConfiguration)
}

class GABiometricAuthenticationPermissionBusinessLogic: GABiometricAuthenticationPermissionBusinessLogicProtocol
{
    // MARK: - Properties
    private var didUpdateShowPermission : Bool
    private let configuration           : GAFullScreenConfiguration
    
    weak var delegate: GABiometricAuthenticationPermissionBusinessLogicDelegate?
    
    // MARK: - Object life cycle
    init(configuration: GAFullScreenConfiguration)
    {
        self.configuration              = configuration
        self.didUpdateShowPermission    = false
    }
    
    // MARK: - GABiometricAuthenticationPermissionBusinessLogicProtocol
    func handleAllowAction()
    {
        didUpdateShowPermission = true
        GABiometricAuthenticationService.register(forBiometricLocalAuthenticationWithLocalizedReason: configuration.localizedReason) { (success) in
            
            DispatchQueue.main.async { [weak self] in
                
                guard let strongSelf = self else { return }
                
                strongSelf.configuration.resultBlock(success)
                strongSelf.delegate?.finish()
            }
        }
    }
    
    func handleDoNotAllowAction()
    {
        GABiometricAuthenticationService.updateUserDidShowPermissionForBiometricAuthentication()
        didUpdateShowPermission = true
        configuration.resultBlock(false)
        delegate?.finish()
    }
    
    func handleDismiss()
    {
        guard !didUpdateShowPermission else { return }
        GABiometricAuthenticationService.updateUserDidShowPermissionForBiometricAuthentication()
    }
    
    func handleViewDidLoad()
    {
        delegate?.updateUI(byConfiguration: configuration.uiConfiguration)
    }
}

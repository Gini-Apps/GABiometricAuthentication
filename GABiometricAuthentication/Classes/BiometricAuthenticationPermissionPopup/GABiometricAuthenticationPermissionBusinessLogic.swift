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
    private var onAllowAction           : Bool
    weak var delegate: GABiometricAuthenticationPermissionBusinessLogicDelegate?
    
    // MARK: - Object life cycle
    init(configuration: GAFullScreenConfiguration)
    {
        self.configuration              = configuration
        self.didUpdateShowPermission    = false
        self.onAllowAction              = false
    }
    
    // MARK: - GABiometricAuthenticationPermissionBusinessLogicProtocol
    func handleAllowAction()
    {
        guard !onAllowAction else { return }
        onAllowAction = true
        didUpdateShowPermission = true
        GABiometricAuthenticationService.register(forBiometricLocalAuthenticationWithLocalizedReason: configuration.localizedReason) { (result) in
            
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
    }
    
    func handleDoNotAllowAction()
    {
        GABiometricAuthenticationService.updateUserDidShowPermissionForBiometricAuthentication()
        GABiometricAuthenticationService.setUserRevokeBiometricAuthentication(true)
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

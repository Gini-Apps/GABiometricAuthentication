//
//  GABiometricAuthentication.swift
//  GABiometricAuthentication
//
//  Created by ido meirov on 29/08/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

/// Register popup type full scrren or custom ui
///
/// - fullScrrenUI: show view controoller on full screen and configur the UI by GAFullScreenConfiguration
/// - customUI: show custom ui given by client using GACustomPopupConfiguration
public enum GARegisterType
{
    case fullScrrenUI(GAFullScreenConfiguration)
    case customUI(GACustomPopupConfiguration)
    case alertUI(GAAlertConfiguration)
}

public class GABiometricAuthentication
{
    
    /// Call to LAContext canEvaluatePolicy with deviceOwnerAuthenticationWithBiometrics
    ///
    /// - Returns: true if canEvaluatePolicy succeeded
    public static func canEvaluatePolicyDeviceOwnerAuthenticationWithBiometrics() -> Bool
    {
        return GABiometricAuthenticationService.canEvaluatePolicyDeviceOwnerAuthenticationWithBiometrics()
    }
    
    /// Open custom popup before apple permission for FaceID or TouchID and ask the user to allow FaceID/TouchID,
    /// TouchID do not need toggle apple permission alert so the custom popup is the only one the the  user see.
    /// This will only show the popup one in the app, to toggle apple permission or ask for permission use evaluateBiometricLocalAuthentication.
    ///
    /// - Parameters:
    ///   - type: type of the popup
    ///   - viewController: the parent view controller of the popup
    public static func openRegisterForBiometricAuthentication(usingRegisterType type: GARegisterType, inViewController viewController: UIViewController)
    {
        guard !GABiometricAuthenticationService.userDidShowPermissionForBiometricAuthentication() else
        {
            print("user pass the permission with result: \(!GABiometricAuthenticationService.getUserRevokeBiometricAuthentication())")
            return
        }
        
        guard GABiometricAuthenticationService.canEvaluatePolicyDeviceOwnerAuthenticationWithBiometrics() else { return }
        
        switch type
        {
        case .fullScrrenUI(let configuration):
            
            let popup = GABiometricAuthenticationPermissionFullScreenPopupViewController(nibName: nil)
            popup.configurationUI(byConfiguration: configuration)
            viewController.present(popup, animated: true, completion: nil)
            
        case .customUI(let configuration):
            
            let popup = GABiometricAuthenticationPermissionCustomPopupViewController(nibName: nil)
            popup.configurationUI(byConfiguration: configuration)
            viewController.present(popup, animated: true, completion: nil)
            
        case .alertUI(let configuration):
            
            let alert  = createAlertController(fromConfiguration: configuration)
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    /// Toggle LAContext evaluatePolicy for the first time to toggle apple permission alert
    ///
    /// - Parameters:
    ///   - localizedReason: why you need user BiometricAuthentication this will pass to LAContext evaluatePolicy
    ///   - resultBlock: the LAContext evaluatePolicy result
    public static func registerForFaceID(localizedReason: String, result resultBlock: @escaping BiometricAuthenticationRegistrationSuccessBlock)
    {
        GABiometricAuthenticationService.register(forFaceIDWithLocalizedReason: localizedReason, result: resultBlock)
    }
    
    /// Stops the toggle of evaluateBiometricLocalAuthentication if get true (saved in user default)
    ///
    /// - Parameter isRevoke: should stop evaluateBiometricLocalAuthentication
    public static func setUserRevokeBiometricAuthentication(_ isRevoke: Bool)
    {
        GABiometricAuthenticationService.setUserRevokeBiometricAuthentication(isRevoke)
    }
    
    
    /// Get the current value of UserRevokeBiometricAuthentication
    ///
    /// - Returns: the value of setUserRevokeBiometricAuthentication default false
    public static func getUserRevokeBiometricAuthentication() -> Bool
    {
        return GABiometricAuthenticationService.getUserRevokeBiometricAuthentication()
    }
    
    
    /// Toggle LAContext evaluatePolicy
    ///
    /// - Parameters:
    ///   - localizedReason: Reason for the use of BiometricLocalAuthentication
    ///   - result: the result of evaluatePolicy
    public static func evaluateBiometricLocalAuthentication(localizedReason: String, withResult result: @escaping BiometricAuthenticationResultBlock)
    {
        GABiometricAuthenticationService.evaluateBiometricLocalAuthentication(localizedReason: localizedReason, withResult: result)
    }

    /// Call this if you get FaceID/TouchID is locked to toggle passcode to unlock the FaceID/TouchID
    ///
    /// - Parameters:
    ///   - resultBlock: the result of passcode
    public static func unlockBiometricLocalAuthentication(byLocalizedReason localizedReason: String = "Access your password", withResult resultBlock: @escaping BiometricAuthenticationRegistrationSuccessBlock)
    {
        GABiometricAuthenticationService.unlockBiometricLocalAuthentication(byLocalizedReason: localizedReason, withResult: resultBlock)
    }
}

extension GABiometricAuthentication
{
    
    /// Create UIAlertController with style alert by configuration object
    ///
    /// - Parameter configuration: the GAAlertConfiguration object
    /// - Returns: alertConroller with style alert
    private static func createAlertController(fromConfiguration configuration: GAAlertConfiguration) -> UIAlertController
    {
        let alertController = GAAlertController(configuration: configuration)
        
        return alertController
    }
}


class GAAlertController: UIAlertController
{
    
    convenience init(configuration: GAAlertConfiguration)
    {
        let bb = GABiometricAuthenticationPermissionAlertBusinessLogic(configuration: configuration)
        let uiConfiguration = configuration.uiConfiguration
        self.init(title: uiConfiguration.titleText, message: uiConfiguration.descriptionText, preferredStyle: .alert)
        
        let allowAction = UIAlertAction(title: uiConfiguration.allowButtonConfiguration.text, style: uiConfiguration.allowButtonConfiguration.style)
        { (action) in
            
            bb.handleAllowAction()
        }
        
        let doNotAllowAction = UIAlertAction(title: uiConfiguration.doNotAllowButtonConfiguration.text, style: uiConfiguration.doNotAllowButtonConfiguration.style)
        { (action) in
            
            bb.handleDoNotAllowAction()
        }
        
        addAction(allowAction)
        addAction(doNotAllowAction)
    }
}

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

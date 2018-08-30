//
//  GABiometricAuthentication.swift
//  GABiometricAuthentication
//
//  Created by ido meirov on 29/08/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

public enum GARegisterType
{
    case fullScrrenUI(GAFullScreenConfiguration)
    case customUI(GACustomPopupConfiguration)
}

public class GABiometricAuthentication
{
    public static func openRegisterForBiometricAuthentication(usingRegisterType type: GARegisterType, inViewController viewController: UIViewController)
    {
        guard !GABiometricAuthenticationService.userDidShowPermissionForBiometricAuthentication() else
        {
            print("user pass the permission with result: \(!GABiometricAuthenticationService.getUserRevokeBiometricAuthentication())")
            return
        }
        
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
        }
    }
    
    public static func registerForFaceID(localizedReason: String, result resultBlock: @escaping BiometricAuthenticationRegistrationSuccessBlock)
    {
        GABiometricAuthenticationService.register(forFaceIDWithLocalizedReason: localizedReason, result: resultBlock)
    }
    
    public class func setUserRevokeBiometricAuthentication(_ isRevoke: Bool)
    {
        GABiometricAuthenticationService.setUserRevokeBiometricAuthentication(isRevoke)
    }
    
    public class func getUserRevokeBiometricAuthentication() -> Bool
    {
        return GABiometricAuthenticationService.getUserRevokeBiometricAuthentication()
    }
    
    public class func evaluateBiometricLocalAuthentication(localizedReason: String, withResult result: @escaping BiometricAuthenticationResultBlock)
    {
        GABiometricAuthenticationService.evaluateBiometricLocalAuthentication(localizedReason: localizedReason, withResult: result)
    }
    
    public class func unlockBiometricLocalAuthentication(withResult resultBlock: @escaping BiometricAuthenticationRegistrationSuccessBlock)
    {
        GABiometricAuthenticationService.unlockBiometricLocalAuthentication(withResult: resultBlock)
    }
}


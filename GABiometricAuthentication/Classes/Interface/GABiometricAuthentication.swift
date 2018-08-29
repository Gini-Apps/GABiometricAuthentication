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
    case customUI(GACustomUIConfiguration)
}

public struct GACustomUIConfiguration
{
    let localizedReason: String
}

public class GABiometricAuthentication
{
    public static func openRegisterForBiometricAuthentication(usingRegisterType type: GARegisterType, inViewController viewController: UIViewController)
    {
        //guard GABiometricAuthenticationService.userDidShowPermissionForBiometricAuthentication() else { return }
        
        switch type
        {
        case .fullScrrenUI(let configuration):
            
            let popup = GABiometricAuthenticationPermissionPopup(nibName: nil)
            popup.configurationUI(byConfiguration: configuration)
            viewController.present(popup, animated: true, completion: nil)
            
        default: break
        }
    }
    
    public static func registerForFaceID(localizedReason: String, result resultBlock: @escaping BiometricAuthenticationRegistrationSuccessBlock)
    {
        GABiometricAuthenticationService.register(forFaceIDWithLocalizedReason: localizedReason, result: resultBlock)
    }
}


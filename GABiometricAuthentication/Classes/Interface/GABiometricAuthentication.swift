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
    case defaultUI(GADefaultUIConfiguration)
    case customUI(GACustomUIConfiguration)
}

public struct GADefaultUIConfiguration
{
    let localizedReason: String
    let resultBlock: BiometricAuthenticationRegistrationResultBlock
}

public struct GACustomUIConfiguration
{
    let localizedReason: String
}

public class GABiometricAuthentication
{
    public static func registerForBiometricAuthentication(usingRegisterType type: GARegisterType, localizedReason: String, result resultBlock: @escaping BiometricAuthenticationRegistrationResultBlock)
    {
        
    }
    
    public static func registerForFaceID(localizedReason: String, result resultBlock: @escaping BiometricAuthenticationRegistrationResultBlock)
    {
        GABiometricAuthenticationService.register(forFaceIDWithLocalizedReason: localizedReason, result: resultBlock)
    }
}


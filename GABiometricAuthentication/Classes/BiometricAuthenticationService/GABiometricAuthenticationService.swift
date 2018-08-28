//
//  GABiometricAuthenticationService.swift
//  GACustomPopup_Example
//
//  Created by ido meirov on 28/08/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import LocalAuthentication

enum BiometricAuthenticationResult
{
    case notRegister
    case success
    case failed
    case userFallback
    case userCancel
    case systemCancel
    case notEvaluated
    case unknowError
    case lockout
    case userRevoke
}

typealias BiometricAuthenticationResultBlock = (BiometricAuthenticationResult) -> Void

class GABiometricAuthenticationService
{
    private static let BIOMETRIC_REGISTER_KEY = "RegisterForBiometricLocalAuthenticationKey"
    private static let BIOMETRIC_AUTHENTICATION_REVOKE_KEY = "BiometricAuthenticationRevokeKey"
    
    class func userDidShowPermissionForBiometricAuthentication() -> Bool
    {
        let userDefaults = UserDefaults.standard
        return userDefaults.bool(forKey: BIOMETRIC_REGISTER_KEY)
    }
    
    class func register(forBiometricLocalAuthenticationResult resultBlock: ((_ success: Bool) -> Void)? = nil)
    {
        if GABiometricAuthenticationService.getUserRevokeBiometricAuthentication()
        {
            resultBlock?(false)
            return
        }
        
        let context = LAContext()
        var authError: NSError? = nil
        if !context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError)
        {
            resultBlock?(false)
            if let aDescription = authError?.description
            {
                print("Register for biometric authentication did failed with error: \(aDescription)")
            }
            return
        }
        
        if GABiometricAuthenticationService.userDidShowPermissionForBiometricAuthentication()
        {
            resultBlock?(true)
            return
        }
        
        GABiometricAuthenticationService.updateUserDidShowPermissionForBiometricAuthentication()
        
        // ask for user permission not needed for TouchID
        if #available(iOS 11.0, *)
        {
            switch context.biometryType
            {
            case .touchID:
                resultBlock?(true)
                return
                
            default:
                break
            }
        }
        else
        {
            resultBlock?(true)
            return
        }
        
        GABiometricAuthenticationService.evaluateBiometricLocalAuthentication(withResult: { result in
            
            switch result
            {
            case .success: resultBlock?(true)
            default         : resultBlock?(false)
            }
        })
    }
    
    class func evaluateBiometricLocalAuthentication(withResult result: @escaping BiometricAuthenticationResultBlock)
    {
        if GABiometricAuthenticationService.getUserRevokeBiometricAuthentication() == true
        {
            result(.userRevoke)
            return
        }
        
        if !GABiometricAuthenticationService.userDidShowPermissionForBiometricAuthentication()
        {
            result(.notRegister)
            return
        }
        
        let context = LAContext()
        var authError: NSError? = nil
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError)
        {
            GABiometricAuthenticationService.evaluatePolicy(using: context, withResult: result)
        }
        else
        {
            if let aDescription = authError?.description
            {
                print("Biometric evaluate did failed with error: \(aDescription)")
            }
            
            if authError?.code == Int(kLAErrorBiometryLockout)
            {
                result(.lockout)
            }
            else
            {
                result(.notEvaluated)
            }
            return
        }
    }
    
    class func unlockBiometricLocalAuthentication(withResult resultBlock: @escaping (_ success: Bool) -> Void)
    {
        if GABiometricAuthenticationService.getUserRevokeBiometricAuthentication() == true
        {
            resultBlock(false)
            return
        }
        
        let context = LAContext()
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Access your password", reply: { success, error in
            
            DispatchQueue.main.async(execute: {
                
                resultBlock(success)
            })
            
        })
    }
    
    class func getUserRevokeBiometricAuthentication() -> Bool
    {
        return UserDefaults.standard.bool(forKey: BIOMETRIC_AUTHENTICATION_REVOKE_KEY)
    }
    
    class func setUserRevokeBiometricAuthentication(_ isRevoke: Bool)
    {
        let userDefaults = UserDefaults.standard
        userDefaults.set(isRevoke, forKey: BIOMETRIC_AUTHENTICATION_REVOKE_KEY)
        userDefaults.synchronize()
    }
    
    class func updateUserDidShowPermissionForBiometricAuthentication()
    {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: BIOMETRIC_REGISTER_KEY)
        userDefaults.synchronize()
    }
    
    class func evaluatePolicy(using context: LAContext?, withResult result: @escaping BiometricAuthenticationResultBlock)
    {
        let myLocalizedReasonString = "Authenticate and log into your account."
        context?.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString, reply: { success, error in
            
            if success
            {
                DispatchQueue.main.async(execute: {
                    
                    result(.success)
                })
            }
            else
            {
                if error != nil
                {
                    let authnticationResult: BiometricAuthenticationResult = GABiometricAuthenticationService.evaluateError(error!)
                    
                    DispatchQueue.main.async(execute: {
                        
                        result(authnticationResult)
                    })
                }
                else
                {
                    DispatchQueue.main.async(execute: {
                        
                        result(.failed)
                    })
                }
            }
        })
    }
    
    class func evaluateError(_ error: Error) -> BiometricAuthenticationResult
    {
        var result: BiometricAuthenticationResult
        
        if #available(iOS 11.0, *)
        {
            switch (error as NSError).code
            {
            case LAError.Code.userFallback.rawValue            : result = .userFallback
            case LAError.Code.userCancel.rawValue            : result = .userCancel
            case LAError.Code.systemCancel.rawValue            : result = .systemCancel
            case LAError.Code.biometryLockout.rawValue        : result = .lockout
            case LAError.Code.authenticationFailed.rawValue    : result = .failed
            default: result = .unknowError
            }
        }
        else
        {
            switch (error as NSError).code
            {
            case LAError.Code.userFallback.rawValue            : result = .userFallback
            case LAError.Code.userCancel.rawValue            : result = .userCancel
            case LAError.Code.systemCancel.rawValue            : result = .systemCancel
            case LAError.Code.authenticationFailed.rawValue : result = .failed
            default: result = .unknowError
            }
        }
        
        return result
    }
}

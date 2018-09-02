//
//  GABiometricAuthenticationService.swift
//  GABiometricAuthentication
//
//  Created by ido meirov on 28/08/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import LocalAuthentication

public enum BiometricAuthenticationResult
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

enum RegistrationResult
{
    case cancel
    case allow
    case doNotAllow
}

public typealias BiometricAuthenticationResultBlock = (BiometricAuthenticationResult) -> Void
public typealias BiometricAuthenticationRegistrationSuccessBlock = (_ success: Bool) -> Void

typealias BiometricAuthenticationRegistrationResultBlock = (RegistrationResult) -> Void

class GABiometricAuthenticationService
{
    // MARK: - Property
    private static let BIOMETRIC_REGISTER_KEY = "RegisterForBiometricLocalAuthenticationKey"
    private static let BIOMETRIC_AUTHENTICATION_REVOKE_KEY = "BiometricAuthenticationRevokeKey"
    
    // MARK: - User Defaults Functions
    class func userDidShowPermissionForBiometricAuthentication() -> Bool
    {
        let userDefaults = UserDefaults.standard
        return userDefaults.bool(forKey: BIOMETRIC_REGISTER_KEY)
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
    
    // MARK: - Can Evaluate Policy
    class func canEvaluatePolicyDeviceOwnerAuthenticationWithBiometrics() -> Bool
    {
        let context = LAContext()
        var authError: NSError? = nil
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) else
        {
            return false
        }
        
        return true
    }
    
    // MARK: - Register
    class func register(forBiometricLocalAuthenticationWithLocalizedReason localizedReason: String, authenticationForTouchID: Bool = true, result resultBlock: @escaping BiometricAuthenticationRegistrationResultBlock)
    {
        if GABiometricAuthenticationService.getUserRevokeBiometricAuthentication()
        {
            resultBlock(.doNotAllow)
            return
        }
        
        let context = LAContext()
        var authError: NSError? = nil
        if !context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError)
        {
            resultBlock(.doNotAllow)
            if let aDescription = authError?.description
            {
                print("Register for biometric authentication did failed with error: \(aDescription)")
            }
            return
        }
        
        if GABiometricAuthenticationService.userDidShowPermissionForBiometricAuthentication()
        {
            resultBlock(.allow)
            return
        }
        
        // ask for user permission not needed for TouchID
        if !authenticationForTouchID
        {
            if #available(iOS 11.0, *)
            {
                switch context.biometryType
                {
                case .touchID:
                    resultBlock(.allow)
                    return
                    
                default:
                    break
                }
            }
            else
            {
                resultBlock(.allow)
                return
            }
        }
        
        GABiometricAuthenticationService.evaluatePolicy(using: context, withLocalizedReason: localizedReason) { (result) in
            
            switch result
            {
            case .success:
                
                resultBlock(.allow)
                GABiometricAuthenticationService.updateUserDidShowPermissionForBiometricAuthentication()
                
            case .userCancel:
                
                if #available(iOS 11.0, *)
                {
                    switch context.biometryType
                    {
                    case .touchID: resultBlock(.cancel)
                    default: GABiometricAuthenticationService.updateUserDidShowPermissionForBiometricAuthentication(); resultBlock(.allow)
                    }
                }
                else
                {
                    resultBlock(.cancel)
                }
                
            default:
                
                GABiometricAuthenticationService.updateUserDidShowPermissionForBiometricAuthentication()
                resultBlock(.doNotAllow)
            }
        }
    }
    
    class func register(forFaceIDWithLocalizedReason localizedReason: String, result resultBlock: @escaping BiometricAuthenticationRegistrationSuccessBlock)
    {
        GABiometricAuthenticationService.register(forBiometricLocalAuthenticationWithLocalizedReason: localizedReason, authenticationForTouchID: false) { (result) in
            
            switch result
            {
            case .doNotAllow    : resultBlock(false)
            default             : resultBlock(true)
            }
        }
    }
    
    // MARK: - Evaluate Biometric Local Authentication
    class func evaluateBiometricLocalAuthentication(localizedReason: String, withResult result: @escaping BiometricAuthenticationResultBlock)
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
            GABiometricAuthenticationService.evaluatePolicy(using: context, withLocalizedReason: localizedReason,  withResult: result)
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

    class func evaluatePolicy(using context: LAContext?, withLocalizedReason localizedReason: String, withResult result: @escaping BiometricAuthenticationResultBlock)
    {
        context?.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReason, reply: { success, error in
            
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
    
    // MARK: - Unlock Biometric Local Authentication
    class func unlockBiometricLocalAuthentication(withResult resultBlock: @escaping BiometricAuthenticationRegistrationSuccessBlock)
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
    
    // MARK: - Errors 
    private class func evaluateError(_ error: Error) -> BiometricAuthenticationResult
    {
        var result: BiometricAuthenticationResult
        
        if #available(iOS 11.0, *)
        {
            switch (error as NSError).code
            {
            case LAError.Code.userFallback.rawValue         : result = .userFallback
            case LAError.Code.userCancel.rawValue           : result = .userCancel
            case LAError.Code.systemCancel.rawValue         : result = .systemCancel
            case LAError.Code.biometryLockout.rawValue      : result = .lockout
            case LAError.Code.authenticationFailed.rawValue : result = .failed
            default: result = .unknowError
            }
        }
        else
        {
            switch (error as NSError).code
            {
            case LAError.Code.userFallback.rawValue         : result = .userFallback
            case LAError.Code.userCancel.rawValue           : result = .userCancel
            case LAError.Code.systemCancel.rawValue         : result = .systemCancel
            case LAError.Code.authenticationFailed.rawValue : result = .failed
            default: result = .unknowError
            }
        }
        
        return result
    }
}

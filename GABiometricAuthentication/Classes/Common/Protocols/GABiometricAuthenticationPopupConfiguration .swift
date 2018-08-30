//
//  GABiometricAuthenticationPopupConfiguration .swift
//  GABiometricAuthentication
//
//  Created by ido meirov on 30/08/2018.
//

import Foundation

public protocol GABiometricAuthenticationPopupConfiguration
{
    var localizedReason  : String { get }
    var resultBlock      : BiometricAuthenticationRegistrationSuccessBlock { get }
}

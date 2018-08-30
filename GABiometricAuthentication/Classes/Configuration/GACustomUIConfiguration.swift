//
//  GACustomUIConfiguration.swift
//  GABiometricAuthentication
//
//  Created by ido meirov on 29/08/2018.
//

import UIKit

public struct GACustomUIConfiguration: GABiometricAuthenticationPopupConfiguration
{
    public let localizedReason  : String
    public let resultBlock      : BiometricAuthenticationRegistrationSuccessBlock

}

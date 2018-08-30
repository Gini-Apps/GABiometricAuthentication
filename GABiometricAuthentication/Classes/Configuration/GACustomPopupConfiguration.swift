//
//  GACustomPopupConfiguration.swift
//  GABiometricAuthentication
//
//  Created by ido meirov on 29/08/2018.
//

import UIKit

public struct GACustomPopupConfiguration: GABiometricAuthenticationPopupConfiguration
{
    public let localizedReason  : String
    public let resultBlock      : BiometricAuthenticationRegistrationSuccessBlock
    public let uiConfiguration  : GACustomPopupUIConfiguration

    public init(uiConfiguration: GACustomPopupUIConfiguration, localizedReason: String, resultBlock: @escaping BiometricAuthenticationRegistrationSuccessBlock)
    {
        self.localizedReason    = localizedReason
        self.resultBlock        = resultBlock
        self.uiConfiguration    = uiConfiguration
    }
}

public protocol CustomPopupUI
{
    var continerView        : UIView    { get }
    var allowButton         : UIButton! { get }
    var doNotAllowButton    : UIButton! { get }
}

public struct GACustomPopupUIConfiguration
{
    public let customPopupUI   : CustomPopupUI
    public let popupSize       : CGSize
    
    public init(customPopupUI: CustomPopupUI, popupSize: CGSize)
    {
        self.customPopupUI  = customPopupUI
        self.popupSize      = popupSize
    }
}

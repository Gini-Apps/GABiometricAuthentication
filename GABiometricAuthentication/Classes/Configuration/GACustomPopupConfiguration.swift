//
//  GACustomPopupConfiguration.swift
//  GABiometricAuthentication
//
//  Created by ido meirov on 29/08/2018.
//

import UIKit


/// Configuration object for custom biometricAuthentication user permission popup
public struct GACustomPopupConfiguration: GABiometricAuthenticationPopupConfiguration
{
    // MARK: - Properties
    public let localizedReason  : String
    public let resultBlock      : BiometricAuthenticationRegistrationSuccessBlock
    public let uiConfiguration  : GACustomPopupUIConfiguration

    // MARK: - Object life cycle
    
    /// create instance of GACustomPopupConfiguration
    ///
    /// - Parameters:
    ///   - uiConfiguration: the ui configuration object
    ///   - localizedReason: localizedReason for the LAContext
    ///   - resultBlock: the result block
    public init(uiConfiguration: GACustomPopupUIConfiguration, localizedReason: String, resultBlock: @escaping BiometricAuthenticationRegistrationSuccessBlock)
    {
        self.localizedReason    = localizedReason
        self.resultBlock        = resultBlock
        self.uiConfiguration    = uiConfiguration
    }
}

/// The view that you want to add to the popup must contain two buttons: "allow" and "doNotAllow", as subviews of the continerView
public protocol CustomPopupUI
{
    var continerView        : UIView    { get }
    var allowButton         : UIButton! { get } // must be subview of continerView
    var doNotAllowButton    : UIButton! { get } // must be subview of continerView
}


public struct GACustomPopupUIConfiguration
{
    // MARK: - Properties
    public let customPopupUI   : CustomPopupUI
    public let popupSize       : CGSize
    
    // MARK: - Object life cycle
    
    /// create instance of GACustomPopupUIConfiguration
    ///
    /// - Parameters:
    ///   - customPopupUI: the object that implement CustomPopupUI, contain the ui for the popup
    ///   - popupSize: the popup size on the screen 
    public init(customPopupUI: CustomPopupUI, popupSize: CGSize)
    {
        self.customPopupUI  = customPopupUI
        self.popupSize      = popupSize
    }
}

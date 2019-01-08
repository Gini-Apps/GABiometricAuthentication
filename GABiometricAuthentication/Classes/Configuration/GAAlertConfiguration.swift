//
//  GAAlertConfiguration.swift
//  GABiometricAuthentication
//
//  Created by Ido Meirov on 08/01/2019.
//

import UIKit

public class GAAlertConfiguration: GABiometricAuthenticationPopupConfiguration
{
    // MARK: - Properties
    public let uiConfiguration  : GAAlertUIConfiguration // UI Configuration
    public let localizedReason  : String // localizedReason for the LAContext
    public let resultBlock      : BiometricAuthenticationRegistrationSuccessBlock // the result block
    
    // MARK: - Object life cycle
    
    /// create instance of GAFullScreenConfiguration
    ///
    /// - Parameters:
    ///   - uiConfiguration: the ui configuration
    ///   - localizedReason: localizedReason for the LAContext
    ///   - resultBlock: the result block
    public init(uiConfiguration: GAAlertUIConfiguration = GAAlertUIConfiguration(), localizedReason: String, resultBlock: @escaping BiometricAuthenticationRegistrationSuccessBlock)
    {
        self.localizedReason    = localizedReason
        self.resultBlock        = resultBlock
        self.uiConfiguration    = uiConfiguration
    }
}

public struct GAAlertUIConfiguration
{
    // MARK: - Properties
    public let titleText                        : String
    public let descriptionText                  : String
    public let allowButtonConfiguration         : GAAlertButtonConfiguration
    public let doNotAllowButtonConfiguration    : GAAlertButtonConfiguration
    
    // MARK: - Object life cycle
    
    /// create instance of GAFullScreenUIConfiguration
    ///
    /// - Parameters:
    ///   - titleText: title text
    ///   - descriptionText: description text
    ///   - allowButtonConfiguration: the allow button configuration object
    ///   - dontAllowButtonConfiguration: the do not allow button configuration object
    public init(titleText: String = String(""), descriptionText: String = String(""),  allowButtonConfiguration: GAAlertButtonConfiguration = GAAlertButtonConfiguration(text: "Allow", style: .default), dontAllowButtonConfiguration: GAAlertButtonConfiguration = GAAlertButtonConfiguration(text: "Don't Allow", style: .cancel))
    {
        self.titleText                      = titleText
        self.descriptionText                = descriptionText
        self.allowButtonConfiguration       = allowButtonConfiguration
        self.doNotAllowButtonConfiguration   = dontAllowButtonConfiguration
    }
}

public struct GAAlertButtonConfiguration
{
    // MARK: - Typealias
    public typealias GAAlertButtonStyle = UIAlertAction.Style
    // MARK: - Properties
    public let text     : String
    public let style    : GAAlertButtonStyle
    
    // MARK: - Object life cycle
    
    /// create instance of GAFullScreenButtonConfiguration
    ///
    /// - Parameters:
    ///   - style: button style
    ///   - text: button title for normal state
    public init(text: String, style: GAAlertButtonStyle)
    {
        self.style   = style
        self.text    = text
    }
}

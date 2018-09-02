//
//  GAFullScreenConfigurations.swift
//  GABiometricAuthentication
//
//  Created by ido meirov on 29/08/2018.
//

import UIKit


/// Configuration object for full screen biometricAuthentication user permission popup
public struct GAFullScreenConfiguration: GABiometricAuthenticationPopupConfiguration
{
    // MARK: - Properties
    public let uiConfiguration  : GAFullScreenUIConfiguration // UI Configuration
    public let localizedReason  : String // localizedReason for the LAContext
    public let resultBlock      : BiometricAuthenticationRegistrationSuccessBlock // the result block
    
    // MARK: - Object life cycle
    
    /// create instance of GAFullScreenConfiguration
    ///
    /// - Parameters:
    ///   - uiConfiguration: the ui configuration
    ///   - localizedReason: localizedReason for the LAContext
    ///   - resultBlock: the result block
    public init(uiConfiguration: GAFullScreenUIConfiguration = GAFullScreenUIConfiguration(), localizedReason: String, resultBlock: @escaping BiometricAuthenticationRegistrationSuccessBlock)
    {
        self.localizedReason    = localizedReason
        self.resultBlock        = resultBlock
        self.uiConfiguration    = uiConfiguration
    }
}

public struct GAFullScreenUIConfiguration
{
    // MARK: - Properties
    public let titleText                        : NSAttributedString
    public let descriptionText                  : NSAttributedString
    public let backgroundColor                  : UIColor
    public let centerImage                      : UIImage?
    public let allowButtonConfiguration         : GAFullScreenButtonConfiguration
    public let doNotAllowButtonConfiguration    : GAFullScreenButtonConfiguration
    
    // MARK: - Object life cycle
    
    /// create instance of GAFullScreenUIConfiguration
    ///
    /// - Parameters:
    ///   - titleText: title text
    ///   - descriptionText: description text
    ///   - backgroundColor: popup backgroundColor
    ///   - centerImage: popup center image
    ///   - allowButtonConfiguration: the allow button configuration object
    ///   - dontAllowButtonConfiguration: the do not allow button configuration object
    public init(titleText: NSAttributedString = NSAttributedString(string: ""), descriptionText: NSAttributedString = NSAttributedString(string: ""), backgroundColor: UIColor = UIColor.white, centerImage: UIImage? = nil, allowButtonConfiguration: GAFullScreenButtonConfiguration = GAFullScreenButtonConfiguration(text: "Allow"), dontAllowButtonConfiguration: GAFullScreenButtonConfiguration = GAFullScreenButtonConfiguration(text: "Don't Allow"))
    {
        self.titleText                      = titleText
        self.descriptionText                = descriptionText
        self.backgroundColor                = backgroundColor
        self.centerImage                    = centerImage
        self.allowButtonConfiguration       = allowButtonConfiguration
        self.doNotAllowButtonConfiguration   = dontAllowButtonConfiguration
    }
}

public struct GAFullScreenButtonConfiguration
{
    // MARK: - Properties
    public let backgroundColor  : UIColor
    public let textColor        : UIColor
    public let text             : String
    
    // MARK: - Object life cycle
    
    /// create instance of GAFullScreenButtonConfiguration
    ///
    /// - Parameters:
    ///   - backgroundColor: button backgroundColor
    ///   - textColor: button tint color
    ///   - text: button title for normal state
    public init(backgroundColor: UIColor = UIColor.clear, textColor: UIColor = UIColor(red: 0.0 / 255.0, green: 122.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0), text: String)
    {
        self.backgroundColor    = backgroundColor
        self.textColor          = textColor
        self.text               = text
    }
}

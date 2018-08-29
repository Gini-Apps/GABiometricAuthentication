//
//  GAFullScreenConfigurations.swift
//  GABiometricAuthentication
//
//  Created by ido meirov on 29/08/2018.
//

import UIKit

public struct GAFullScreenConfiguration
{
    public let uiConfiguration  : GAFullScreenUIConfiguration
    public let localizedReason  : String
    public let resultBlock      : BiometricAuthenticationRegistrationSuccessBlock
    
    public init(uiConfiguration: GAFullScreenUIConfiguration = GAFullScreenUIConfiguration(), localizedReason: String, resultBlock: @escaping BiometricAuthenticationRegistrationSuccessBlock)
    {
        self.localizedReason    = localizedReason
        self.resultBlock        = resultBlock
        self.uiConfiguration    = uiConfiguration
    }
}

public struct GAFullScreenUIConfiguration
{
    public let titleText                        : NSAttributedString
    public let descriptionText                  : NSAttributedString
    public let backgroundColor                  : UIColor
    public let centerImage                      : UIImage?
    public let allowButtonConfiguration         : GAFullScreenButtonConfiguration
    public let doNotAllowButtonConfiguration    : GAFullScreenButtonConfiguration
    
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
    public let backgroundColor  : UIColor
    public let textColor        : UIColor
    public let text             : String
    
    public init(backgroundColor: UIColor = UIColor.clear, textColor: UIColor = UIColor(red: 0.0 / 255.0, green: 122.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0), text: String)
    {
        self.backgroundColor    = backgroundColor
        self.textColor          = textColor
        self.text               = text
    }
}

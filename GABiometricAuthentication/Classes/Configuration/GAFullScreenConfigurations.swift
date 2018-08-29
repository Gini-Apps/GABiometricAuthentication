//
//  GAFullScreenConfigurations.swift
//  GABiometricAuthentication
//
//  Created by ido meirov on 29/08/2018.
//

import UIKit

public struct GAFullScreenConfiguration
{
    public let localizedReason  : String
    public let resultBlock      : BiometricAuthenticationRegistrationResultBlock
    public let uiConfiguration  : GAFullScreenUIConfiguration
    
    public init(localizedReason: String, resultBlock: @escaping BiometricAuthenticationRegistrationResultBlock)
    {
        self.localizedReason    = localizedReason
        self.resultBlock        = resultBlock
        self.uiConfiguration    = GAFullScreenUIConfiguration(titleText: NSAttributedString(string: "jasbndjkasbdkjbsa"))
    }
}

public struct GAFullScreenUIConfiguration
{
    public let titleText                    : NSAttributedString
    public let descriptionText              : NSAttributedString
    public let backgroundColor              : UIColor
    public let centerImage                  : UIImage
    public let allowButtonConfiguration     : GAFullScreenButtonConfiguration
    public let dontAllowButtonConfiguration : GAFullScreenButtonConfiguration
}

public struct GAFullScreenButtonConfiguration
{
    public let backgroundColor  : UIColor
    public let textColor        : UIColor
    public let text             : String
    
    init(backgroundColor: UIColor = UIColor.clear, textColor: UIColor = UIColor.blue, text: String)
    {
        self.backgroundColor    = backgroundColor
        self.textColor          = textColor
        self.text               = text
    }
}

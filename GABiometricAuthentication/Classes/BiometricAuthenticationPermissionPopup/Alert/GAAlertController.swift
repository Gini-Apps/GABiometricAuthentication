//
//  GAAlertController.swift
//  GABiometricAuthentication
//
//  Created by Ido Meirov on 09/01/2019.
//

import UIKit

class GAAlertController: UIAlertController
{
    
    convenience init(configuration: GAAlertConfiguration)
    {
        let bb = GABiometricAuthenticationPermissionAlertBusinessLogic(configuration: configuration)
        let uiConfiguration = configuration.uiConfiguration
        self.init(title: uiConfiguration.titleText, message: uiConfiguration.descriptionText, preferredStyle: .alert)
        
        let allowAction = UIAlertAction(title: uiConfiguration.allowButtonConfiguration.text, style: uiConfiguration.allowButtonConfiguration.style)
        { (action) in
            
            bb.handleAllowAction()
        }
        
        let doNotAllowAction = UIAlertAction(title: uiConfiguration.doNotAllowButtonConfiguration.text, style: uiConfiguration.doNotAllowButtonConfiguration.style)
        { (action) in
            
            bb.handleDoNotAllowAction()
        }
        
        addAction(allowAction)
        addAction(doNotAllowAction)
    }
}

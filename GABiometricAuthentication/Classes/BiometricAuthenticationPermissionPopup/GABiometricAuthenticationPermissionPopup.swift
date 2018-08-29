//
//  GABiometricAuthenticationPermissionPopup.swift
//  GABiometricAuthentication
//
//  Created by ido meirov on 24/04/2018.
//  Copyright © 2018 Gini-Apps. All rights reserved.
//

import UIKit

public class GABiometricAuthenticationPermissionPopup: GABasePopAlertViewController
{
    // MARK: - IBOutlet
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var messageBodyLabel: UILabel!
    
    // MARK: - Properties
    private var businessLogic: GABiometricAuthenticationPermissionBusinessLogicProtocol?
    
    // MARK: - Method
    func configurationUI(byConfiguration configuration: GADefaultUIConfiguration)
    {
        businessLogic = GABiometricAuthenticationPermissionBusinessLogic(localizedReason: configuration.localizedReason, resultBlock: configuration.resultBlock)
        businessLogic?.delegate = self
    }
    
    // MARK: - IBAction
    @IBAction func doneButtonDidTap()
    {
        dismiss(animated: true)
    }
}

extension GABiometricAuthenticationPermissionPopup: GABiometricAuthenticationPermissionBusinessLogicDelegate
{
    func finish()
    {
        dismiss(animated: true)
    }
}

extension GABiometricAuthenticationPermissionPopup: PopoverTransitionAnimationProtocol
{
    public var viewForTransitionAnimation: UIView { return baseView }
}

extension GABiometricAuthenticationPermissionPopup: ClassInfoable {}

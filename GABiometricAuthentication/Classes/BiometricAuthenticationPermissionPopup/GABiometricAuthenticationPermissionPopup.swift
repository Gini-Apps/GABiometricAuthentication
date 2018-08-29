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
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Properties
    private var businessLogic: GABiometricAuthenticationPermissionBusinessLogicProtocol?
    
    // MARK: - View life cycle
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        businessLogic?.handleViewDidLoad()
    }
    
    // MARK: - Method
    func configurationUI(byConfiguration configuration: GAFullScreenConfiguration)
    {
        businessLogic = GABiometricAuthenticationPermissionBusinessLogic(configuration: configuration)
        businessLogic?.delegate = self
    }
    
    // MARK: - IBAction
    @IBAction func doneButtonDidTap()
    {
        guard let businessLogic = businessLogic else
        {
            dismiss(animated: true)
            return
        }
        
        businessLogic.handleAllowAction()
    }
}

extension GABiometricAuthenticationPermissionPopup: GABiometricAuthenticationPermissionBusinessLogicDelegate
{
    func updateUI(byConfiguration uiConfiguration: GAFullScreenUIConfiguration)
    {
        titleLabel.attributedText = uiConfiguration.titleText
    }
    
    func finish()
    {
        businessLogic?.handleDismiss()
        dismiss(animated: true)
    }
}

extension GABiometricAuthenticationPermissionPopup: PopoverTransitionAnimationProtocol
{
    public var viewForTransitionAnimation: UIView { return baseView }
}

extension GABiometricAuthenticationPermissionPopup: ClassInfoable {}

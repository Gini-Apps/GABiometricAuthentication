//
//  GABiometricAuthenticationPermissionCustomPopup.swift
//  GABiometricAuthentication
//
//  Created by ido meirov on 24/04/2018.
//  Copyright © 2018 Gini-Apps. All rights reserved.
//

import UIKit

public class GABiometricAuthenticationPermissionCustomPopupViewController: GABasePopAlertViewController
{
    // MARK: - IBOutlet
    @IBOutlet weak var baseView                 : UIView!
    @IBOutlet weak var heightLayoutConstraint   : NSLayoutConstraint!
    @IBOutlet weak var widthLayoutConstraint    : NSLayoutConstraint!
    
    // MARK: - Properties
    private var businessLogic: GABiometricAuthenticationPermissionCustomPopupBusinessLogic?
    
    // MARK: - View life cycle
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        businessLogic?.handleViewDidLoad()
        transitionController.dismissOnBackgroundViewDidPrass = false
    }
    
    // MARK: - Method
    func configurationUI(byConfiguration configuration: GACustomPopupConfiguration)
    {
        let biometricAuthenticationPermissionBusinessLogic = GABiometricAuthenticationPermissionCustomPopupBusinessLogic(configuration: configuration)
        biometricAuthenticationPermissionBusinessLogic.delegate = self
        businessLogic = biometricAuthenticationPermissionBusinessLogic
    }
    
    // MARK: - IBAction
    @IBAction func allowButtonDidTap()
    {
        guard let businessLogic = businessLogic else
        {
            dismiss(animated: true)
            return
        }
        
        businessLogic.handleAllowAction()
    }
    
    @IBAction func doNotAllowButtonDidTap()
    {
        guard let businessLogic = businessLogic else
        {
            dismiss(animated: true)
            return
        }
        
        businessLogic.handleDoNotAllowAction()
    }
}

// MARK: - GABiometricAuthenticationPermissionFullScreenBusinessLogicDelegate
extension GABiometricAuthenticationPermissionCustomPopupViewController: GABiometricAuthenticationPermissionCustomPopupBusinessLogicDelegate
{
    func updateUI(byConfiguration uiConfiguration: GACustomPopupUIConfiguration)
    {
        baseView.addSubview(uiConfiguration.customPopupUI.continerView)
        uiConfiguration.customPopupUI.continerView.addConstraintsToFillSuperView()
        
        uiConfiguration.customPopupUI.allowButton.addTarget(self, action: #selector(allowButtonDidTap), for: .touchUpInside)
        uiConfiguration.customPopupUI.doNotAllowButton.addTarget(self, action: #selector(doNotAllowButtonDidTap), for: .touchUpInside)
        
        heightLayoutConstraint.constant     = uiConfiguration.popupSize.height
        widthLayoutConstraint.constant      = uiConfiguration.popupSize.width
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    func finish()
    {
        businessLogic?.handleDismiss()
        dismiss(animated: true)
    }
}

// MARK: - PopoverTransitionAnimationProtocol
extension GABiometricAuthenticationPermissionCustomPopupViewController: PopoverTransitionAnimationProtocol
{
    public var viewForTransitionAnimation: UIView { return baseView }
}


//
//  GABiometricAuthenticationPermissionPopup.swift
//  Evrit-ios
//
//  Created by ido meirov on 24/04/2018.
//  Copyright © 2018 Gini-Apps. All rights reserved.
//

import UIKit

public class GABiometricAuthenticationPermissionPopup: GABasePopAlertViewController
{
    @IBOutlet weak var baseView: UIView!
 
    @IBOutlet weak var messageBodyLabel: UILabel!
    public var confirmDidPress: MethodPointer?
    
    @IBAction func doneButtonDidTap()
    {
        confirmDidPress?()
        dismiss(animated: true)
    }
}

extension GABiometricAuthenticationPermissionPopup: PopoverTransitionAnimationProtocol
{
    public var viewForTransitionAnimation: UIView { return baseView }
}

extension GABiometricAuthenticationPermissionPopup: CellInfoable {}

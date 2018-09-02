//
//  GABasePopAlertViewController.swift
//  GABiometricAuthentication
//
//  Created by ido meirov on 12/12/2017.
//  Copyright © 2017 Gini-Apps. All rights reserved.
//

import UIKit

open class GABasePopAlertViewController: UIViewController
{
    public let transitionController = GAPopoverAlertTransition()
    public var customPresentationStyle = PresentationStyle.scale
    
    public override init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = Bundle(for: GABasePopAlertViewController.self))
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup()
    {
        modalPresentationStyle   = .custom
        transitioningDelegate    = transitionController
    }

    deinit
    {
        print("GABasePopAlertViewController Deinit")
    }

    @IBAction public func cancelButtonDidPress(_ sender: Any)
    {
        self.dismiss(animated: true)
    }
}

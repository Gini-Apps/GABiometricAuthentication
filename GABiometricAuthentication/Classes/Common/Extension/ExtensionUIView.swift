//
//  ExtensionUIView.swift
//  GABiometricAuthentication
//
//  Created by ido meirov on 30/08/2018.
//

import Foundation

extension UIView
{
    func addConstraintsToFillSuperView()
    {
        guard superview != nil else { return }
        
        let views = ["self":self]
        translatesAutoresizingMaskIntoConstraints = false
        let   verticalConstraints   = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[self]-0-|", metrics: nil, views: views)
        let horizontalConstraints   = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[self]-0-|", metrics: nil, views: views)
        NSLayoutConstraint.activate(horizontalConstraints + verticalConstraints)
    }
}

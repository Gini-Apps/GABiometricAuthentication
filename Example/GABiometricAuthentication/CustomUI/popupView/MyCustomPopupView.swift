//
//  MyCustomPopupView.swift
//  GABiometricAuthentication_Example
//
//  Created by ido meirov on 30/08/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import GABiometricAuthentication

class MyCustomPopupView: UIView, NibDesignableProtocol, CustomPopupUI
{
    var continerView: UIView
    {
        return self
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak var allowButton      : UIButton!
    @IBOutlet weak var doNotAllowButton : UIButton!

    // MARK: - Object life cycle
    private enum InitMethod
    {
        case coder(NSCoder)
        case frame(CGRect)
    }
    // MARK: - Initialization
    public convenience override init(frame: CGRect)
    {
        self.init(InitMethod.frame(frame))
    }
    
    public convenience required init(coder aDecoder: NSCoder)
    {
        self.init(InitMethod.coder(aDecoder))
    }
    
    private init(_ initMethod: InitMethod)
    {
        switch initMethod
        {
        case let .coder(coder): super.init(coder: coder)!
        case let .frame(frame): super.init(frame: frame)
        }
        setupNib()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

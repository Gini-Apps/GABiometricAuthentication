//
//  CustomPopupViewController.swift
//  GABiometricAuthentication_Example
//
//  Created by ido meirov on 30/08/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import GABiometricAuthentication

class CustomPopupViewController: UIViewController
{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerFullScreenDidPrass(_ sender: Any)
    {
        let view = MyCustomPopupView(frame: CGRect.zero)
        
        let uiconfiguration = GACustomPopupUIConfiguration(customPopupUI: view, popupSize: self.view.bounds.size)

        let configuration = GACustomPopupConfiguration(uiConfiguration: uiconfiguration, localizedReason: "enter for password") { (result) in
            
        }
        
        GABiometricAuthentication.openRegisterForBiometricAuthentication(usingRegisterType: .customUI(configuration), inViewController: self)
    }
    
    @IBAction func registerCustomSizeDidPrass(_ sender: Any)
    {
        let view = MyCustomPopupView(frame: CGRect.zero)
        
        let uiconfiguration = GACustomPopupUIConfiguration(customPopupUI: view, popupSize: CGSize(width: 309.0, height: 284.0))
        
        let configuration = GACustomPopupConfiguration(uiConfiguration: uiconfiguration, localizedReason: "enter for password") { (result) in
            
        }
        
        GABiometricAuthentication.openRegisterForBiometricAuthentication(usingRegisterType: .customUI(configuration), inViewController: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

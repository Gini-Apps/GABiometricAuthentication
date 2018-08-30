//
//  ViewController.swift
//  GABiometricAuthentication
//
//  Created by idoMeirov on 08/28/2018.
//  Copyright (c) 2018 idoMeirov. All rights reserved.
//

import UIKit
import GABiometricAuthentication

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func registerDidPrass(_ sender: Any)
    {
        let uiconfiguration = GAFullScreenUIConfiguration(titleText: NSAttributedString(string: "title"), descriptionText: NSAttributedString(string: "description"), backgroundColor: .white, centerImage: UIImage(named: "touch-id"), allowButtonConfiguration: GAFullScreenButtonConfiguration(backgroundColor: .black, textColor: .white, text: "Allow"), dontAllowButtonConfiguration: GAFullScreenButtonConfiguration(backgroundColor: .black, textColor: .white, text: "Do not Allow"))
        
        let configuration = GAFullScreenConfiguration(uiConfiguration: uiconfiguration, localizedReason: "enter for password") { (result) in
            
            
        }
        
        GABiometricAuthentication.openRegisterForBiometricAuthentication(usingRegisterType: .fullScrrenUI(configuration), inViewController: self)
    }
}


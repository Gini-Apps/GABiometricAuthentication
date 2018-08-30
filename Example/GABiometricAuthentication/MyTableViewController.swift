//
//  MyTableViewController.swift
//  GABiometricAuthentication_Example
//
//  Created by ido meirov on 30/08/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import GABiometricAuthentication

class MyTableViewController: UITableViewController
{
    @IBOutlet weak var revokeSwitch: UISwitch!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        revokeSwitch.isOn = !GABiometricAuthentication.getUserRevokeBiometricAuthentication()
    }
    
    @IBAction func updateUerRevoke(_ sender: UISwitch)
    {
        GABiometricAuthentication.setUserRevokeBiometricAuthentication(!sender.isOn)
    }
}

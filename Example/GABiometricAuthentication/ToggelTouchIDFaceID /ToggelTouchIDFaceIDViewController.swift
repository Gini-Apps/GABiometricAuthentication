//
//  ToggelTouchIDFaceID ViewController.swift
//  GABiometricAuthentication_Example
//
//  Created by ido meirov on 30/08/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import GABiometricAuthentication

class ToggelTouchIDFaceIDViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggelTouchIDFaceIDDidTap(_ sender: Any)
    {
        GABiometricAuthentication.evaluateBiometricLocalAuthentication(localizedReason: "showPassword") { [weak self] (result) in
            
            guard let strongSelf = self else { return }
            
            switch result
            {
            case .success   : strongSelf.resultLabel.text = "success"
            default         : strongSelf.resultLabel.text = "failed"
            }
        }
    }

    @IBAction func unlockTouchIDFaceIDDidTap(_ sender: Any)
    {
        GABiometricAuthentication.unlockBiometricLocalAuthentication { [weak self] (result) in
            
            guard let strongSelf = self else { return }
            
            switch result
            {
            case true   : strongSelf.resultLabel.text = "success"
            case false  : strongSelf.resultLabel.text = ""
            }
            
        }
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

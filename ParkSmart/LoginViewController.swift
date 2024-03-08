//
//  LoginViewController.swift
//  PantherTransit
//
//  Created by Andy on 3/5/24.
//

import UIKit

class LoginViewController : UIViewController {
    @IBOutlet weak var parkCode: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        print("Login Button Pressed")
        
        guard let code = parkCode.text else {
            return
        }
        
        // Store the text value in UserDefaults
        UserDefaults.standard.set(code, forKey: "parkCodeValue")
        
        // Optionally, you can synchronize UserDefaults to ensure data is saved immediately
        UserDefaults.standard.synchronize()
        self.performSegue(withIdentifier: "login", sender: self)
    }
    
}

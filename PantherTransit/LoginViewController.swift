//
//  LoginViewController.swift
//  PantherTransit
//
//  Created by Andy on 3/5/24.
//

import UIKit

class LoginViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        print("Login Button Pressed")
        self.performSegue(withIdentifier: "login", sender: self)
    }
    
}

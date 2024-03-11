//
//  SearchViewController.swift
//  ParkSmart
//
//  Initial search page for users to locate their specific lot
//
//  Created by Andy on 3/5/24.
//

import UIKit

class SearchViewController : UIViewController {
    @IBOutlet weak var parkCode: UITextField!
    var recentCodes: [String] = []
    var displacement: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add observer for keyboard show notification
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // Add observer for keyboard hide notification
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Add tap gesture recognizer to dismiss keyboard when tapping outside text field
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        print("Search Button Pressed")
        guard let code = parkCode.text else {
            return
        }
        
        getParkCode(code)
        self.performSegue(withIdentifier: "login", sender: self)
    }
    
    // TODO: Create settings option to toggle recent searches for user preference
    // Function to save a new searched code and manage recent codes
    func getParkCode(_ code: String) {
        if let savedCodes = UserDefaults.standard.stringArray(forKey: "parkCodes") {
            recentCodes = savedCodes
        }
        
        // Remove the code if it exists already
        if let index = recentCodes.firstIndex(of: code) {
            recentCodes.remove(at: index)
        }
        
        recentCodes.insert(code, at: 0)
        if recentCodes.count > 5 {
            recentCodes.removeLast()
        }
        
        UserDefaults.standard.setValue(recentCodes, forKey: "parkCodes")
        
        // Synchronize UserDefaults to ensure data is saved immediately
        UserDefaults.standard.synchronize()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        // Check if the parkCode text field is currently being edited
        if parkCode.isEditing && displacement < 150{
            animateViewMoving(up: true, moveValue: 150)
            displacement += 150
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        // Check if the parkCode text field is currently being edited
        if parkCode.isEditing && displacement > 0 {
            animateViewMoving(up: false, moveValue: 150)
            displacement -= 150
        }
    }
    
    func animateViewMoving(up: Bool, moveValue: CGFloat) {
        let movementDuration: TimeInterval = 0.3
        let movement: CGFloat = (up ? -moveValue : moveValue)
        
        UIView.animate(withDuration: movementDuration) {
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        }
    }
    
    // Function to dismiss keyboard when tapping outside text field
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    deinit {
        // Remove observers when view controller is deallocated
        NotificationCenter.default.removeObserver(self)
    }
}

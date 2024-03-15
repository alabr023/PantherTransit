//
//  SearchViewController.swift
//  ParkSmart
//
//  Initial search page for users to locate their specific lot
//
//  Created by Andy on 3/5/24.
//

import UIKit
import FirebaseDatabase

class SearchViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var lotName: UITextField!
    @IBOutlet weak var autofillList: UITableView!
    
    var recentLots: [String] = []
    var allNames: [String] = []
    var filteredNames: [String] = []
    
    var displacement: Bool = false
    var databaseReference: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get reference to Firebase Database
        databaseReference = Database.database().reference()
        
        // Add observer for keyboard show notification
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // Add observer for keyboard hide notification
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Add tap gesture recognizer to dismiss keyboard when tapping outside text field
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        lotName.delegate = self
        autofillList.delegate = self
        autofillList.dataSource = self
        autofillList.isHidden = true
        autofillList.allowsSelection = true
        autofillList.register(UITableViewCell.self, forCellReuseIdentifier: "autofillNames")
        
        // Fetch data from Firebase and populate the table view
        fetchDataFromFirebase()
    }
    
    @IBAction func onSearchButton(_ sender: Any) {
        print("Search Button Pressed")
        guard let code = lotName.text else {
            return
        }
        
        getParkLot(code)
        self.performSegue(withIdentifier: "login", sender: self)
    }
    
    // TODO: Create settings option to toggle recent searches for user preference
    // Function to save a new searched code and manage recent lots
    func getParkLot(_ lot: String) {
        if let savedLots = UserDefaults.standard.stringArray(forKey: "parkLots") {
            recentLots = savedLots
        }
        
        // Remove the code if it exists already
        if let index = recentLots.firstIndex(of: lot) {
            recentLots.remove(at: index)
        }
        
        recentLots.insert(lot, at: 0)
        if recentLots.count > 5 {
            recentLots.removeLast()
        }
        
        UserDefaults.standard.setValue(recentLots, forKey: "parkLots")
        
        // Synchronize UserDefaults to ensure data is saved immediately
        UserDefaults.standard.synchronize()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        // Check if the parkCode text field is currently being edited
        if lotName.isEditing && !displacement {
            animateViewMoving(up: true, moveValue: 150)
            displacement = !displacement
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        // Check if the parkCode text field is currently being edited
        if lotName.isEditing && displacement {
            animateViewMoving(up: false, moveValue: 150)
            displacement = !displacement
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Show the table view when the text field begins editing
        autofillList.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Hide the table view when the text field ends editing
        autofillList.isHidden = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Construct the full string with the current text field content and the incoming characters
        let searchText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        // Filter the names based on the input
        filteredNames = allNames.filter { $0.lowercased().contains(searchText.lowercased()) }
        
        // Reload the table view with the filtered data
        autofillList.reloadData()
        
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "autofillNames", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        content.text = filteredNames[indexPath.row]
        content.textProperties.alignment = .center
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the selected item
        let selectedItem = filteredNames[indexPath.row]
        print("TAP \(filteredNames)")
        
        // Put the selected item in the text field
        lotName.text = selectedItem
        
        // Hide the keyboard
        lotName.resignFirstResponder()
        
        // Hide the autofill table view
        autofillList.isHidden = true
    }
    
    func fetchDataFromFirebase() {
        // Query to fetch all "name" keys from Firebase
        databaseReference.observeSingleEvent(of: .value) { [weak self] snapshot in
            // Clear existing names before fetching new ones
            self?.allNames.removeAll()
            
            // Iterate through each child of the snapshot
            for case let child as DataSnapshot in snapshot.children {
                // Ensure the child has a "name" key and is a dictionary
                if let name = child.key as? String {
                    // Append the name to the list
                    self?.allNames.append(name)
                }
            }
            
            // Filter the names based on the current input in the text field
            self?.textField(self!.lotName, shouldChangeCharactersIn: NSRange(location: 0, length: self!.lotName.text?.count ?? 0), replacementString: self!.lotName.text ?? "")
        }
    }
    
    deinit {
        // Remove observers when view controller is deallocated
        NotificationCenter.default.removeObserver(self)
    }
}

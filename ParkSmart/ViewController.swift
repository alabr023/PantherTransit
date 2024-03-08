//
//  ViewController.swift
//  ParkSmart
//
//  Created by Andy on 2/19/24.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Reference to your Firebase Database
        let database = Database.database().reference()
        
        // Read data from a specific path in the database
        database.child("Parking_lot_1_test/").observeSingleEvent(of: .value) { (snapshot) in
            // Get the data snapshot
            if let value = snapshot.value as? [String: Any] {
                // Process the data
//                // Example: Read a string value
//                if let stringValue = value["yourKey"] as? String {
//                    print("String value: \(stringValue)")
//                }
                // Example: Read an integer value
                if let intValue = value["Parking_spot_1_test"] as? Int {
                    print("Integer value: \(intValue)")
                }
                // Continue processing other data...
            }
        }
    }
}



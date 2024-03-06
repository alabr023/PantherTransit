//
//  DatabaseViewController.swift
//  PantherTransit
//
//  Created by Andy on 3/5/24.
//

import UIKit
import FirebaseDatabase

class ParkingViewController: UIViewController {

    
    @IBOutlet weak var parkingLabel: UILabel!
    
    var databaseReference: DatabaseReference!
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Get reference to your Firebase Database
        databaseReference = Database.database().reference()

        // Start a timer to read the value every second
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.readParkingSpotValue()
        }
    }

    func readParkingSpotValue() {
        
        var parkingData: String?
        parkingLabel.numberOfLines = 0
        
        // Read data from "Parking_lot_1_test/parking_spot_1_test"
        databaseReference.child("Parking_lot_1_test").child("parking_spot_1_test").observeSingleEvent(of: .value) { (snapshot) in
            // Get the data snapshot
            if let value = snapshot.value as? Int {
                print("Value of parking_spot_1_test: \(value)")
                parkingData = value != 0 ? "Open": "Taken"
            } else {
                print("No value found for parking_spot_1_test")
                parkingData = "Not Found"
            }
            
            self.parkingLabel.text = "Parking_lot_1_test\n\tparking_spot_1_test:\n\t\t\(parkingData!)"
        }
    }

    deinit {
        // Invalidate timer when the view controller is deallocated
        timer?.invalidate()
    }
}

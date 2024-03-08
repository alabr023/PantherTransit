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
    @IBOutlet weak var totalCounter: UILabel!
    
    var databaseReference: DatabaseReference!
    var timer: Timer?
    var savedParkCode: Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Get reference to your Firebase Database
        databaseReference = Database.database().reference()
        
        // Get park code from login to determine which lot
        savedParkCode = UserDefaults.standard.integer(forKey: "parkCodeValue")
        print("Parking code is \(savedParkCode!)")
        
        // Start a timer to read the value every second
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.readParkingSpotValue()
        }
    }

    func readParkingSpotValue() {
        var parkingData: String?
        
        let lotReference = databaseReference.child("Parking_lot_\(savedParkCode!)_test")

        // Read data from "Parking_lot_{given park code}_test"
        lotReference.observeSingleEvent(of: .value) { (snapshot) in
            
            
            // Get the data snapshot
            if let value = snapshot.value as? Int {
                print("Value of parking_spot_\(self.savedParkCode!)_test: \(value)")
                parkingData = value != 0 ? "Open": "Taken"
            } else {
                print("No value found for parking_spot_\(self.savedParkCode!)_test")
                parkingData = "Not Found"
            }
            
            self.parkingLabel.text = "Parking_lot_\(self.savedParkCode!)_test\n\tparking_spot_\(self.savedParkCode!)_test:\n\t\t\(parkingData!)"
        }
    }

    deinit {
        // Invalidate timer when the view controller is deallocated
        timer?.invalidate()
    }
}

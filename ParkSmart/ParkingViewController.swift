//
//  ParkingViewController.swift
//  ParkSmart
//
//  ViewController containing parking lot information and relevant data for users
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
    var currentParkCode: Int = 0
    var parkingCodes: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get reference to Firebase Database
        databaseReference = Database.database().reference()
        
        // Get park code from login to determine which lot data to access
        parkingCodes = UserDefaults.standard.stringArray(forKey: "parkCodes") ?? ["-1"]
        currentParkCode = Int(parkingCodes.first!) ?? -1
        print("Recent parking codes: \(parkingCodes)")
        print("Current code: \(currentParkCode)")
        
        // TODO: Change reading interval to when page is opened or user pulls for refresh or after a set time interval
        // Start a timer to read the value every second
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.readParkingSpotValue()
        }
    }
    
    @IBAction func searchAgain(_ sender: Any) {
        
        Database.database().reference().removeAllObservers()
        timer?.invalidate()
        self.performSegue(withIdentifier: "searchAgain", sender: self)
    }

    func readParkingSpotValue() {
        var parkState: String = ""
        var totalSpots: Int = 0
        var openSpots: Int = 0
        
        let lotReference = databaseReference.child("Parking_lot_\(currentParkCode)_test")
        
        // TODO: Wrap parking data as a TableView
        // Read data from "Parking_lot_{given park code}_test"
        lotReference.observeSingleEvent(of: .value) { (lot) in
            totalSpots = 0
            openSpots = 0
            self.parkingLabel.text = ""
            
            guard lot.exists() else {
                print("No data found under 'lot' node.")
                return
            }
            
            for child in lot.children{
                // Casting the child as a DataSnapshot
                guard let spotSnapshot = child as? DataSnapshot else { continue }
                
                // Extracting key (spot) and value (status) pair
                if let spot = spotSnapshot.key as? String, let status = spotSnapshot.value as? Int {
                    totalSpots += 1
                    openSpots += status != 0 ? 1 : 0
                    parkState = status != 0 ? "Open": "Taken"
                    
                    print("Spot: \(spot), Status: \(parkState)")
                    
                    self.parkingLabel.text! += "Parking_lot_\(self.currentParkCode)_test\n\t\(spot):\n\t\t\(parkState)\n"
                }
            }
            self.totalCounter.text = "Total Spaces Available\n\(openSpots)/\(totalSpots)"
        }
    }
    
    deinit {
        // Invalidate timer when the view controller is deallocated
        timer?.invalidate()
    }
}

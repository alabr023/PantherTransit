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

class ParkingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var totalCounter: UILabel!
    @IBOutlet weak var parkingSpots: UITableView!
    
    var databaseReference: DatabaseReference!
    var timer: Timer?
    var currentParkCode: Int = 0
    var parkingCodes: [String] = []
    var spotStates: [String] = []
    var totalSpots: Int = 0
    var openSpots: Int = 0
    
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
        parkingSpots.delegate = self
        parkingSpots.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalSpots
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = "Parking Spot \(indexPath.row) is \(spotStates[indexPath.row])"
        
        return cell
    }
    
    @IBAction func searchAgain(_ sender: Any) {
        
        Database.database().reference().removeAllObservers()
        timer?.invalidate()
        self.performSegue(withIdentifier: "searchAgain", sender: self)
    }

    func readParkingSpotValue() {
        var parkState: String = ""
        
        let lotReference = databaseReference.child("Parking_lot_\(currentParkCode)_test")
        
        // TODO: Wrap parking data as a TableView
        // Read data from "Parking_lot_{given park code}_test"
        lotReference.observeSingleEvent(of: .value) { (lot) in
            self.totalSpots = 0
            self.openSpots = 0
            self.spotStates.removeAll()
            
            guard lot.exists() else {
                print("No data found under 'lot' node.")
                return
            }
            
            for child in lot.children{
                // Casting the child as a DataSnapshot
                guard let spotSnapshot = child as? DataSnapshot else { continue }
                
                // Extracting key (spot) and value (status) pair
                if let spot = spotSnapshot.key as? String, let status = spotSnapshot.value as? Int {
                    self.totalSpots += 1
                    self.openSpots += status != 0 ? 1 : 0
                    parkState = status != 0 ? "Open": "Taken"
                    self.spotStates.append(parkState)
                    print("Spot: \(spot), Status: \(parkState)")
                }
            }
            self.totalCounter.text = "Total Spaces Available\n\(self.openSpots)/\(self.totalSpots)"
            self.parkingSpots.reloadData()
        }
        
    }
    
    deinit {
        // Invalidate timer when the view controller is deallocated
        timer?.invalidate()
    }
}

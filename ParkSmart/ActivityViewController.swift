//
//  ActivityViewController.swift
//  ParkSmart
//
//  Created by Andy on 3/10/24.
//

import UIKit

class ActivityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var favoriteLots: UITableView!
    @IBOutlet weak var recentLots: UITableView!
    @IBOutlet weak var currentLot: UILabel!
    
    var lots: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoriteLots.dataSource = self
        favoriteLots.delegate = self
        recentLots.dataSource = self
        recentLots.delegate = self
        
        currentLot.text = UserDefaults.standard.stringArray(forKey: "parkLots")?.first
    }
    
    @IBAction func addFavorite(_ sender: Any) {
        print(currentLot.text!)
        if let temp = UserDefaults.standard.stringArray(forKey: "favoriteLots") {
            lots = temp
        }
        
        if let index = lots.firstIndex(of: currentLot.text!) {
            return
        }
        
        lots.insert(currentLot.text!, at: 0)
        
        UserDefaults.standard.setValue(lots, forKey: "favoriteLots")
        
        // Synchronize UserDefaults to ensure data is saved immediately
        UserDefaults.standard.synchronize()
        
        favoriteLots.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows: Int = 0
        
        if tableView == recentLots {
            rows = UserDefaults.standard.stringArray(forKey: "parkLots")?.count ?? 0
        }
        else if tableView == favoriteLots {
            rows = UserDefaults.standard.stringArray(forKey: "favoriteLots")?.count ?? 0
        }
        
        print(rows)
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.textProperties.alignment = .center
        
        if tableView == recentLots {
            content.text = UserDefaults.standard.stringArray(forKey: "parkLots")?[indexPath.row] ?? ""
        }
        else if tableView == favoriteLots {
            content.text = UserDefaults.standard.stringArray(forKey: "favoriteLots")?[indexPath.row] ?? ""
        }
        
        cell.contentConfiguration = content
        print(cell)
        return cell
    }
}

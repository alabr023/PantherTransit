//
//  ActivityViewController.swift
//  ParkSmart
//
//  Created by Andy on 3/10/24.
//

import UIKit

class ActivityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var favoriteCodes: UITableView!
    @IBOutlet weak var recentCodes: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoriteCodes.dataSource = self
        favoriteCodes.delegate = self
        recentCodes.dataSource = self
        recentCodes.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows: Int = 0
        
        if tableView == recentCodes {
            rows = UserDefaults.standard.stringArray(forKey: "parkCodes")?.count ?? 0
        }
        else if tableView == favoriteCodes {
            rows = UserDefaults.standard.stringArray(forKey: "favoriteCodes")?.count ?? 0
        }
        
        print(rows)
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.textProperties.alignment = .center
        
        if tableView == recentCodes {
            content.text = UserDefaults.standard.stringArray(forKey: "parkCodes")?[indexPath.row] ?? ""
        }
        else if tableView == favoriteCodes {
            content.text = UserDefaults.standard.stringArray(forKey: "favoriteCodes")?[indexPath.row] ?? ""
        }
        
        cell.contentConfiguration = content
        print(cell)
        return cell
    }
}

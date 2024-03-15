//
//  ContactViewController.swift
//  ParkSmart
//
//  Created by Liana Adaza on 3/13/24.
//

import UIKit

class ContactViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendMessageURL(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://forms.office.com/r/mEA46wdB1D")!)
        dismiss(animated: true, completion: nil)
    }
}

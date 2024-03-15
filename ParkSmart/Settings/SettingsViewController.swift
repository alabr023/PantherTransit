//
//  SettingsViewController.swift
//  ParkSmart
//
//  Created by Andy on 3/8/24.
//

import UIKit

class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func privPolicyModal(_ sender: Any) {
        guard let privPolicyVC = storyboard?.instantiateViewController(withIdentifier: "privPolicyModal") as? PrivPolicyViewController else {
            fatalError("Unable to instantiate privPolicyModal from the storyboard.")
        }
            let nav = UINavigationController(rootViewController: privPolicyVC)
            nav.modalPresentationStyle = .pageSheet

            if let sheet = nav.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.preferredCornerRadius = 25
                sheet.prefersGrabberVisible = true
            }
            present(nav, animated: true, completion: nil)
        }
    
    @IBAction func accessibilityModal(_ sender: Any) {
        guard let accessibilityVC = storyboard?.instantiateViewController(withIdentifier: "accessibilityModal") as? AccessibilityViewController else {
            fatalError("Unable to instantiate accessibilityModal from the storyboard.")
        }
            let nav = UINavigationController(rootViewController: accessibilityVC)
            nav.modalPresentationStyle = .pageSheet

            if let sheet = nav.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.preferredCornerRadius = 25
                sheet.prefersGrabberVisible = true
            }
            present(nav, animated: true, completion: nil)
    }
    
    @IBAction func contactModal(_ sender: Any) {
        guard let contactVC = storyboard?.instantiateViewController(withIdentifier: "contactModal") as? ContactViewController else {
            fatalError("Unable to instantiate contactModal from the storyboard.")
        }
            let nav = UINavigationController(rootViewController: contactVC)
            nav.modalPresentationStyle = .pageSheet

            if let sheet = nav.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.preferredCornerRadius = 25
                sheet.prefersGrabberVisible = true
            }
            present(nav, animated: true, completion: nil)
    }
    
}

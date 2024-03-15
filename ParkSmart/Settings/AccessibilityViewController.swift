//
//  AccessibilityViewController.swift
//  ParkSmart
//
//  Created by Liana Adaza on 3/13/24.
//

import UIKit

class AccessibilityViewController: UIViewController {
    
    @IBOutlet weak var lightButton: UIButton!
    var isLightButtonSelected = false
    
    @IBOutlet weak var darkButton: UIButton!
    var isDarkButtonSelected = false
    
    @IBOutlet weak var defaultButton: UIButton!
    var isDefaultButtonSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func lightPress(_ sender: Any) {
        if !isLightButtonSelected {
              lightButton.setImage(UIImage(systemName: "circlebadge.fill"), for: .normal)
              isLightButtonSelected = true
              
              // Deselect the other buttons
              darkButton.setImage(UIImage(systemName: "circlebadge"), for: .normal)
              isDarkButtonSelected = false
              defaultButton.setImage(UIImage(systemName: "circlebadge"), for: .normal)
              isDefaultButtonSelected = false
          }
    }
    
    @IBAction func darkPress(_ sender: Any) {
        if !isDarkButtonSelected {
            darkButton.setImage(UIImage(systemName: "circlebadge.fill"), for: .normal)
            isDarkButtonSelected = true
            
            // Deselect the other buttons
            lightButton.setImage(UIImage(systemName: "circlebadge"), for: .normal)
            isLightButtonSelected = false
            defaultButton.setImage(UIImage(systemName: "circlebadge"), for: .normal)
            isDefaultButtonSelected = false
          }
    }
    
    @IBAction func defaultPress(_ sender: Any) {
        if !isDefaultButtonSelected {
            defaultButton.setImage(UIImage(systemName: "circlebadge.fill"), for: .normal)
            isDefaultButtonSelected = true
            
            // Deselect the other buttons
            lightButton.setImage(UIImage(systemName: "circlebadge"), for: .normal)
            isLightButtonSelected = false
            darkButton.setImage(UIImage(systemName: "circlebadge"), for: .normal)
            isDarkButtonSelected = false
          }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if isLightButtonSelected{
            
        } else if isDarkButtonSelected {
            
        } else if isDefaultButtonSelected {
            
        }
        dismiss(animated: true, completion: nil)
    }
}

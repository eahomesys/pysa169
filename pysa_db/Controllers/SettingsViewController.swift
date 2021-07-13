//
//  SettingsViewController.swift
//  pysa_db
//
//  Created by Eric Anderson on 7/5/21.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    
    @IBOutlet weak var FBTextField: UITextField!
    @IBOutlet weak var IGTextField: UITextField!
    @IBOutlet weak var SacTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
        FBTextField?.text = "https://www.facebook.com/groups/1341829992632914/"
        IGTextField?.text = "https://www.instagram.com/provo_ysa169/"
        SacTextField?.text = "https://docs.google.com/document/d/19VPgedHzorjvxQMjr6veAxNVzWLYArj_L7q4FmSOrEM/edit?usp=sharing"
    }
    
}



//
//  RegisterViewController.swift
//  pysa_db
//
//  Created by Eric Anderson on 6/26/21.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func registerPressed(_ sender: UIButton) {
        //Register and return to home page to log in
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    let myAlert = UIAlertController(title: "Error", message: e.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let myOKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                    myAlert.addAction(myOKAction)
                    self.present(myAlert, animated: true, completion: nil)
                } else {
                    //Navigate to the ChatViewController
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
        
    }
    
}

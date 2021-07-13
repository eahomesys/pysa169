//
//  ViewController.swift
//  pysa_db
//
//  Created by Eric Anderson on 6/26/21.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //emailTextField.text = ""
        //passwordTextField.text = ""
        
    }
    
    

    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                if let e = error {
                    let myAlert = UIAlertController(title: "Error", message: e.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let myOKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                    myAlert.addAction(myOKAction)
                    self!.present(myAlert, animated: true, completion: nil)
                    
                } else {
                    //Navigate to the LoginViewController
                    let myAlert = UIAlertController(title: "Success", message: "You have successfully logged in!", preferredStyle: UIAlertController.Style.alert)
                    let myOKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { _ in
                        self!.performSegue(withIdentifier: K.loginSegue, sender: self)
                    }
                    myAlert.addAction(myOKAction)
                    self!.present(myAlert, animated: true, completion: nil)
                    
                }
            }
            
        }
    }
    
}




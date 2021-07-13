//
//  AddMemberViewController.swift
//  pysa_db
//
//  Created by Eric Anderson on 6/28/21.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

class AddMemberViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var aptTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var uploadBtn: UIBarButtonItem!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    @IBOutlet weak var birthdateTextField: UITextField!
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var whereFromTextField: UITextField!
    
    
    
    let db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    
    
    var imageName = ""
    var pgTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.doneBtn.isEnabled = true
        self.doneBtn.tintColor = UIColor.systemTeal
        self.uploadBtn.isEnabled = false
        self.uploadBtn.tintColor = UIColor.clear

    }
    
    @IBAction func uploadPressed(_ sender: UIBarButtonItem) {
        // this displays the photo picker
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
        
        
    }
    
    @IBAction func doneBarPressed(_ sender: UIBarButtonItem) {
        if let firstName = firstNameTextField.text,
           let lastName = lastNameTextField.text,
           let address = addressTextField.text,
           let aptNum = aptTextField.text,
           let phone = phoneTextField.text,
           let email = emailTextField.text,
           let birthdate = birthdateTextField.text,
           let status = statusTextField.text,
           let gender = genderTextField.text,
           let wherefrom = whereFromTextField.text
           {
            db.collection(K.FStore.collectionName).document("\(lastName) \(firstName)").setData([
            //db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.firstNameField: firstName,
                K.FStore.lastNameField: lastName,
                K.FStore.addressField: address,
                K.FStore.aptField: aptNum,
                K.FStore.phoneField: phone,
                K.FStore.emailField: email,
                K.FStore.dateField: Date().timeIntervalSince1970,
                K.FStore.pictureURL: String(),
                K.FStore.BirthDate: birthdate,
                K.FStore.Status: status,
                K.FStore.Gender: gender,
                K.FStore.WhereFrom: wherefrom
            ]) { error in
                if let e = error {
                    let myAlert = UIAlertController(title: "Error", message: "There was an issue saving data to Firestore, \(e.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
                    let myOKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                    myAlert.addAction(myOKAction)
                    self.present(myAlert, animated: true, completion: nil)
                } else {
                    let myAlert = UIAlertController(title: "Success", message: "You have successfully saved your data!", preferredStyle: UIAlertController.Style.alert)
                    let myOKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { _ in
                        DispatchQueue.main.async {
                            self.firstNameTextField.isUserInteractionEnabled = false
                            self.lastNameTextField.isUserInteractionEnabled = false
                            self.addressTextField.isUserInteractionEnabled = false
                            self.aptTextField.isUserInteractionEnabled = false
                            self.phoneTextField.isUserInteractionEnabled = false
                            self.emailTextField.isUserInteractionEnabled = false
                            self.birthdateTextField.isUserInteractionEnabled = false
                            self.statusTextField.isUserInteractionEnabled = false
                            self.genderTextField.isUserInteractionEnabled = false
                            self.whereFromTextField.isUserInteractionEnabled = false
                        }
                        
                        //self.navigationController?.popViewController(animated: true)
                        
                        self.navigationItem.rightBarButtonItems?.remove(at: 0)
                        self.uploadBtn.isEnabled = true
                        self.uploadBtn.tintColor = UIColor.systemTeal
                        
                        self.imageName.append(contentsOf: "\(lastName)\(firstName)")
                    }
                    myAlert.addAction(myOKAction)
                    self.present(myAlert, animated: true, completion: nil)
                    
                    
                    
                }
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 1) else {
            return
        }
        
        // upload image data
        
        storage.child("images/\(imageName).jpg").putData(imageData, metadata: nil) { _, error in
            guard error == nil else {
                let myAlert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let myOKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                myAlert.addAction(myOKAction)
                self.present(myAlert, animated: true, completion: nil)
                return
            }
            self.storage.child("images/\(self.imageName).jpg").downloadURL { url, error in
                guard let url = url, error == nil else {
                    return
                }
                let urlString = url.absoluteString
                
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
                
                
                if let firstName = self.firstNameTextField.text,
                   let lastName = self.lastNameTextField.text
                   {
                    self.db.collection(K.FStore.collectionName).document("\(lastName) \(firstName)").setData([
                    //db.collection(K.FStore.collectionName).addDocument(data: [
                        K.FStore.pictureURL: urlString as Any
                    ], merge: true) { error in
                        if let e = error {
                            print("error with pictureURL to Firebase \(e)")
                        } else {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
                
            }
        }
        // get download url
        //save download url to user defaults
        
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    
}

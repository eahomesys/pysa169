//
//  EditMemberViewController.swift
//  pysa_db
//
//  Created by Eric Anderson on 6/29/21.
//

import UIKit
import Firebase
import FirebaseStorage

class EditMemberViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var aptTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    @IBOutlet weak var uploadBtn: UIBarButtonItem!
    @IBOutlet weak var birthdateTextField: UITextField!
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var whereFromTextField: UITextField!
    @IBOutlet weak var schoolTextField: UITextField!
    @IBOutlet weak var majorTextField: UITextField!
    @IBOutlet weak var employmentTextField: UITextField!
    @IBOutlet weak var missionlocationTextField: UITextField!
    @IBOutlet weak var secondlangTextField: UITextField!
    
    @IBOutlet weak var orgTextField: UITextField!
    @IBOutlet weak var committeeTextField: UITextField!
    @IBOutlet weak var callingTextField: UITextField!
    @IBOutlet weak var hegroupTextField: UITextField!
    
    @IBOutlet weak var emergencyTextField: UITextField!
    @IBOutlet weak var engagedTextField: UITextField!
    @IBOutlet weak var fianceTextField: UITextField!
    @IBOutlet weak var marriageTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    
    let db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    
    var members: MemberModel?
    var myImage: UIImage?
    var imageName = ""
    var urlString: String?
    var pgTitle: String?
    var ward = "169"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.urlString = " "
        self.title = pgTitle ?? "Add"
        print(members ?? "empty")
        
        if title == "Edit" {
            fillTextFields()
        }
        
        setButtons()
        
    }
    
    func fillTextFields() {
        firstNameTextField.text = members?.FirstName
        lastNameTextField.text = members?.LastName
        addressTextField.text = members?.Address
        aptTextField.text = members?.Apt_no
        phoneTextField.text = members?.Phone
        emailTextField.text = members?.Email
        urlString = members!.PictureURL
        imageView.image = myImage
        imageName = "\(members!.LastName)\(members!.FirstName)"
        birthdateTextField.text = members?.BirthDate
        statusTextField.text = members?.Status
        genderTextField.text = members?.Gender
        whereFromTextField.text = members?.WhereFrom
        schoolTextField.text = members?.School
        majorTextField.text = members?.Major
        employmentTextField.text = members?.Employment
        missionlocationTextField.text = members?.MissionLocation
        secondlangTextField.text = members?.SecondLang
        
        orgTextField.text = members?.Org
        committeeTextField.text = members?.Committee
        callingTextField.text = members?.Calling
        hegroupTextField.text = members?.HEGroup
        
        emergencyTextField.text = members?.Emergency
        engagedTextField.text = members?.Engaged
        fianceTextField.text = members?.Fiance
        marriageTextField.text = members?.MarriageDate
        notesTextField.text = members?.Notes
        
        
    }
    
    func setButtons() {
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
    
    
    @IBAction func donePressed(_ sender: Any) {
        if let firstName = firstNameTextField.text,
           let lastName = lastNameTextField.text,
           let address = addressTextField.text,
           let aptNum = aptTextField.text,
           let phone = phoneTextField.text,
           let email = emailTextField.text,
           let birthdate = birthdateTextField.text,
           let status = statusTextField.text,
           let gender = genderTextField.text,
           let wherefrom = whereFromTextField.text,
           let school = schoolTextField.text,
           let major = majorTextField.text,
           let employment = employmentTextField.text,
           let missionlocation = missionlocationTextField.text,
           let secondlang = secondlangTextField.text,
           
           let org = orgTextField.text,
           let committee = committeeTextField.text,
           let calling = callingTextField.text,
           let hegroup = hegroupTextField.text,
           
           let emergency = emergencyTextField.text,
           let engaged = engagedTextField.text,
           let fiance = fianceTextField.text,
           let marriage = marriageTextField.text,
           let notes = notesTextField.text
        
           {
            //change this to db.collection(K.FStore.collectionName).document("firstname lastname").setData(data: [
            db.collection(K.FStore.collectionName).document("\(lastName) \(firstName)").setData([
                K.FStore.firstNameField: firstName,
                K.FStore.lastNameField: lastName,
                K.FStore.addressField: address,
                K.FStore.aptField: aptNum,
                K.FStore.phoneField: phone,
                K.FStore.emailField: email,
                K.FStore.dateField: Date().timeIntervalSince1970,
                K.FStore.pictureURL: urlString as Any,
                K.FStore.BirthDate: birthdate,
                K.FStore.Status: status,
                K.FStore.Gender: gender,
                K.FStore.WhereFrom: wherefrom,
                K.FStore.School: school,
                K.FStore.Major: major,
                K.FStore.Employment: employment,
                K.FStore.MissionLocation: missionlocation,
                K.FStore.SecondLang: secondlang,
                
                K.FStore.Org: org,
                K.FStore.Committee: committee,
                K.FStore.Calling: calling,
                K.FStore.HEGroup: hegroup,
                K.FStore.Ward: ward,
                
                K.FStore.Emergency: emergency,
                K.FStore.Engaged: engaged,
                K.FStore.Fiance: fiance,
                K.FStore.MarriageDate: marriage,
                K.FStore.Notes: notes
                
            ], merge: true) { error in
                if let e = error {
                    let myAlert = UIAlertController(title: "Error", message: "There was an issue updating data to Firestore, \(e.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
                    let myOKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                    myAlert.addAction(myOKAction)
                    self.present(myAlert, animated: true, completion: nil)
                } else {
                    let myAlert = UIAlertController(title: "Success", message: "You have successfully updated your data!", preferredStyle: UIAlertController.Style.alert)
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
                            self.schoolTextField.isUserInteractionEnabled = false
                            self.majorTextField.isUserInteractionEnabled = false
                            self.employmentTextField.isUserInteractionEnabled = false
                            self.missionlocationTextField.isUserInteractionEnabled = false
                            self.secondlangTextField.isUserInteractionEnabled = false
                            
                            self.orgTextField.isUserInteractionEnabled = false
                            self.committeeTextField.isUserInteractionEnabled = false
                            self.callingTextField.isUserInteractionEnabled = false
                            self.hegroupTextField.isUserInteractionEnabled = false
                            
                            self.emergencyTextField.isUserInteractionEnabled = false
                            self.engagedTextField.isUserInteractionEnabled = false
                            self.fianceTextField.isUserInteractionEnabled = false
                            self.marriageTextField.isUserInteractionEnabled = false
                            self.notesTextField.isUserInteractionEnabled = false

                        }
                        
                        //self.navigationController?.popViewController(animated: true)
                        self.navigationItem.rightBarButtonItems?.remove(at: 0)
                        self.uploadBtn.isEnabled = true
                        self.uploadBtn.tintColor = UIColor.systemTeal
                    }
                    myAlert.addAction(myOKAction)
                    self.present(myAlert, animated: true, completion: nil)
                    
                    self.imageName = "\(lastName)\(firstName)"
                    
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
        print("Image name at upload: \(imageName).jpg")
        
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
                            //self.navigationController?.popViewController(animated: true)
                            self.performSegue(withIdentifier: K.returnToMemberView, sender: self)
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
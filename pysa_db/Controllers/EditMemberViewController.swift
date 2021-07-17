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
    
    var callingSelection: String?
    var callingList = ["None", "Bishop", "President", "First Counselor", "Second Counselor", "Secretary", "Teacher", "Co-chair", "Executive Secretary", "Asst Executive Secretary", "Group Leader", "Ordinance Worker", "Consultant-Family History", "Temple Prep Teacher", "Ward Temple and Family History Leader", "Ward Mission Leader", "Asst Ward Mission Leader", "Ward Clerk", "Ward Clerk-Membership", "Ward Clerk-Finance", "Ministering Secretary", "Service Coordinator", "Activities Coordinator", "Sacrament Coordinator", "Music Chairman", "Music Director", "Choir Director", "Pianist", "Chorister", "Ward Employment Specialist", "Ward Missionary", "Member"]

    var committeeSelection: String?
    var committeeList = ["None", "PEC","Home Evening Committee","Institute Committee","Sunday School","Temple and Family History Committee","Publicity Committee","Music Committee", "Self Reliance Committee" ,"Missionary Committee","Service Committee","Activities Committee","Elders Quorum 1","Elders Quorum 2","Relief Society 1","Relief Society 2"]

    var addressSelection: String?
    var addressList = ["None", "BDA","L on 8th","Old Academy"]
    
    var statusSelection: String?
    var statusList = ["Current", "Past"]
    
    var genderSelection: String?
    var genderList = ["F", "M"]
    
    var schoolSelection: String?
    var schoolList = ["None", "BYU", "UVU", "Other"]
    
    var orgSelection: String?
    var orgList = ["None","Elders Quorum 1","Elders Quorum 2","Relief Society 1","Relief Society 2"]
    
    var heSelection: String?
    var heList = ["None", "1","2","3","4","5","6"]
    
    var engagedSelection: String?
    var engagedList = ["Yes", "No"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.urlString = " "
        self.title = pgTitle ?? "Add"
        print(members ?? "empty")
        
        if title == "Edit" {
            fillTextFields()
        }
        
        setButtons()
        
        createPickerView()
        dismissPickerView()
        
        self.birthdateTextField.setInputViewDatePicker(target: self, selector: #selector(tapDone1)) //1
        self.marriageTextField.setInputViewDatePicker(target: self, selector: #selector(tapDone2)) //1
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
    
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        callingTextField.inputView = pickerView
        committeeTextField.inputView = pickerView
        addressTextField.inputView = pickerView
        statusTextField.inputView = pickerView
        genderTextField.inputView = pickerView
        schoolTextField.inputView = pickerView
        orgTextField.inputView = pickerView
        hegroupTextField.inputView = pickerView
        engagedTextField.inputView = pickerView
        
    }
    
    func dismissPickerView() {
       let toolBar = UIToolbar()
       toolBar.sizeToFit()
       let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
       toolBar.setItems([button], animated: true)
       toolBar.isUserInteractionEnabled = true
        callingTextField.inputAccessoryView = toolBar
        committeeTextField.inputAccessoryView = toolBar
        addressTextField.inputAccessoryView = toolBar
        statusTextField.inputAccessoryView = toolBar
        genderTextField.inputAccessoryView = toolBar
        schoolTextField.inputAccessoryView = toolBar
        orgTextField.inputAccessoryView = toolBar
        hegroupTextField.inputAccessoryView = toolBar
        engagedTextField.inputAccessoryView = toolBar
    }
    
    @objc func action() {
          view.endEditing(true)
    }
    
    //2
    @objc func tapDone1() {
        
        if let datePicker = self.birthdateTextField.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "dd MMM yyyy"
            //dateformatter.dateStyle = .medium // 2-3
            self.birthdateTextField.text = dateformatter.string(from: datePicker.date) //2-4
            
        }
        self.birthdateTextField.resignFirstResponder() // 2-5
    }
    
    @objc func tapDone2() {
        if let datePicker = self.marriageTextField.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "dd MMM yyyy"
            //dateformatter.dateStyle = .medium // 2-3
            self.marriageTextField.text = dateformatter.string(from: datePicker.date) //2-4
            
        }
        self.marriageTextField.resignFirstResponder() // 2-5
    }
            

}

extension EditMemberViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (self.committeeTextField.isEditing == true) {
            return committeeList.count
        }
        else if (self.addressTextField.isEditing == true) {
            return addressList.count
        }
        else if (self.statusTextField.isEditing == true) {
            return statusList.count
        }
        else if (self.genderTextField.isEditing == true) {
            return genderList.count
        }
        else if (self.schoolTextField.isEditing == true) {
            return schoolList.count
        }
        else if (self.orgTextField.isEditing == true) {
            return orgList.count
        }
        else if (self.hegroupTextField.isEditing == true) {
            return heList.count
        }
        else if (self.engagedTextField.isEditing == true) {
            return engagedList.count
        }
        else {
            return callingList.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (self.committeeTextField.isEditing == true) {
            return committeeList[row]
        }
        else if (self.addressTextField.isEditing == true) {
            return addressList[row]
        }
        else if (self.statusTextField.isEditing == true) {
            return statusList[row]
        }
        else if (self.genderTextField.isEditing == true) {
            return genderList[row]
        }
        else if (self.schoolTextField.isEditing == true) {
            return schoolList[row]
        }
        else if (self.orgTextField.isEditing == true) {
            return orgList[row]
        }
        else if (self.hegroupTextField.isEditing == true) {
            return heList[row]
        }
        else if (self.engagedTextField.isEditing == true) {
            return engagedList[row]
        }
        else {
            return callingList[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (self.committeeTextField.isEditing == true) {
            committeeSelection = committeeList[row]
            committeeTextField.text = committeeSelection
        }
        else if (self.addressTextField.isEditing == true) {
            addressSelection = addressList[row]
            addressTextField.text = addressSelection
        }
        else if (self.statusTextField.isEditing == true) {
            statusSelection = statusList[row]
            statusTextField.text = statusSelection
        }
        else if (self.genderTextField.isEditing == true) {
            genderSelection = genderList[row]
            genderTextField.text = genderSelection
        }
        else if (self.schoolTextField.isEditing == true) {
            schoolSelection = schoolList[row]
            schoolTextField.text = schoolSelection
        }
        else if (self.orgTextField.isEditing == true) {
            orgSelection = orgList[row]
            orgTextField.text = orgSelection
        }
        else if (self.hegroupTextField.isEditing == true) {
            heSelection = heList[row]
            hegroupTextField.text = heSelection
        }
        else if (self.engagedTextField.isEditing == true) {
            engagedSelection = engagedList[row]
            engagedTextField.text = engagedSelection
        }
        else {
            callingSelection = callingList[row]
            callingTextField.text = callingSelection
        }
    }
}

extension UITextField {
    
    func setInputViewDatePicker(target: Any, selector: Selector) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        datePicker.datePickerMode = .date //2
        // iOS 14 and above
        if #available(iOS 14, *) {// Added condition for iOS 14
          datePicker.preferredDatePickerStyle = .wheels
          datePicker.sizeToFit()
        }
        self.inputView = datePicker //3
        
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar //9
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
}

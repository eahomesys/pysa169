//
//  MemberViewController.swift
//  pysa_db
//
//  Created by Eric Anderson on 6/26/21.
//

import UIKit
import Firebase
import FirebaseStorage
import SideMenu

class MemberViewController: UIViewController, MenuControllerDelegate {
    private var sideMenu: SideMenuNavigationController?
    private var filter = K.FStore.lastNameField
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    
    var members: [MemberModel] = []
    var image: UIImage = UIImage(named: "picture")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Directory"
        let menu = MenuViewController(with: SideMenuItem.allCases)
        
        menu.delegate = self
        
        sideMenu = SideMenuNavigationController(rootViewController: menu)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
        
        sideMenu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        
        
    }
    
    
    func didSelectMenuItem(named: SideMenuItem) {
        sideMenu?.dismiss(animated: true, completion: {
            print(named)
            

            
            switch named {
            case .directory:
                self.filter = K.FStore.lastNameField
                self.title = "Directory"
                self.loadMessages()
            case .directoryFN:
                self.filter = K.FStore.firstNameField
                self.title = "Directory - First Name"
                self.loadMessages()
            case .committees:
                // tableView with heading and rows
                self.filter = K.FStore.lastNameField
                self.title = "Directory"
                self.loadMessages()
                GroupTableViewController.GlobalVariable.myString = K.FStore.Committee
                self.performSegue(withIdentifier: K.MemberToGroupView, sender: self)
            case .eqrsLeadership:
                // tableView with heading and rows
                self.filter = K.FStore.lastNameField
                self.title = "Directory"
                self.loadMessages()
                GroupTableViewController.GlobalVariable.myString = K.FStore.Calling
                self.performSegue(withIdentifier: K.MemberToGroupView, sender: self)
            case .eqrsMembers:
                // tableView with heading and rows
                self.filter = K.FStore.lastNameField
                self.title = "Directory"
                self.loadMessages()
                GroupTableViewController.GlobalVariable.myString = K.FStore.Org
                self.performSegue(withIdentifier: K.MemberToGroupView, sender: self)
            case .heGroups:
                // tableView with heading and rows
                self.filter = K.FStore.lastNameField
                self.title = "Directory"
                self.loadMessages()
                GroupTableViewController.GlobalVariable.myString = K.FStore.HEGroup
                self.performSegue(withIdentifier: K.MemberToGroupView, sender: self)
            case .apartmentList:
                // tableView with heading and rows
                self.filter = K.FStore.lastNameField
                self.title = "Directory"
                self.loadMessages()
                GroupTableViewController.GlobalVariable.myString = K.FStore.addressField
                self.performSegue(withIdentifier: K.MemberToGroupView, sender: self)
            case .missions:
                // tableView with heading and rows
                self.filter = K.FStore.lastNameField
                self.title = "Directory"
                self.loadMessages()
                GroupTableViewController.GlobalVariable.myString = K.FStore.MissionLocation
                self.performSegue(withIdentifier: K.MemberToGroupView, sender: self)
            case .languages:
                // tableView with heading and rows
                self.filter = K.FStore.lastNameField
                self.title = "Directory"
                self.loadMessages()
                GroupTableViewController.GlobalVariable.myString = K.FStore.SecondLang
                self.performSegue(withIdentifier: K.MemberToGroupView, sender: self)
            case .noCalling:
                self.filter = K.FStore.Calling
                self.title = "Members without Callings"
                self.loadMessages()
            case .major:
                // tableView with heading and rows
                self.filter = K.FStore.lastNameField
                self.title = "Directory"
                self.loadMessages()
                GroupTableViewController.GlobalVariable.myString = K.FStore.Major
                self.performSegue(withIdentifier: K.MemberToGroupView, sender: self)
            case .prevMember:
                self.filter = K.FStore.Status
                self.title = "Previous Members"
                self.loadMessages()
            case .ward:
                print("\(named): I got to ward")
                self.performSegue(withIdentifier: K.MemberToWard, sender: self)
            case .sacrament:
                self.performSegue(withIdentifier: K.MemberToWeb, sender: self)
            case .logout:
                print("\(named): I got to logout")
                do {
                      try Auth.auth().signOut()
                        self.navigationController?.popToRootViewController(animated: true)
                    } catch let signOutError as NSError {
                      print ("Error signing out: %@", signOutError)
                    }
            case .settings:
                print("\(named): I got to settings")
                self.performSegue(withIdentifier: K.MemberToSettings, sender: self)
            }
            
        })
    }
    
    func loadMessages() {
        
        if (filter == "Address") {
            twoFilters(filter2: K.FStore.aptField)
        } else if (filter == "Status") {
            whereFilters(filter: K.FStore.Status, condition: "Past")
        } else if (filter == "Calling") {
            whereFilters(filter: K.FStore.Calling, condition: "")
        } else {
            oneFilter()
        }
    }
    
    func oneFilter(){
        db.collection(K.FStore.collectionName).whereField(K.FStore.Status, isEqualTo: "Current").order(by: filter).addSnapshotListener { [self] querySnapshot, error in
            self.members = []
            if let e = error {
                print("There was an issue retreiving data from Firestore, \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let LastName = data[K.FStore.lastNameField] as? String,
                           let FirstName = data[K.FStore.firstNameField] as? String,
                           let Address = data[K.FStore.addressField] as? String,
                           let Apt_no = data[K.FStore.aptField] as? String,
                           let Email = data[K.FStore.emailField] as? String,
                           let Phone = data[K.FStore.phoneField] as? String,
                           let PictureURL = data[K.FStore.pictureURL] as? String,
                           let BirthDate = data[K.FStore.BirthDate] as? String,
                           let Status = data[K.FStore.Status] as? String,
                           let Gender = data[K.FStore.Gender] as? String,
                           let WhereFrom = data[K.FStore.WhereFrom] as? String,
                           
                           let School = data[K.FStore.School] as? String,
                           let Major = data[K.FStore.Major] as? String,
                           let Employment = data[K.FStore.Employment] as? String,
                           let MissionLocation = data[K.FStore.MissionLocation] as? String,
                           let SecondLang = data[K.FStore.SecondLang] as? String,
                           
                           let Org = data[K.FStore.Org] as? String,
                           let Committee = data[K.FStore.Committee] as? String,
                           let Calling = data[K.FStore.Calling] as? String,
                           let HEGroup = data[K.FStore.HEGroup] as? String,
                           let Emergency = data[K.FStore.Emergency] as? String,
                           let Notes = data[K.FStore.Notes] as? String,
                           let Ward = data[K.FStore.Ward] as? String,
                           let Engaged = data[K.FStore.Engaged] as? String,
                           let Fiance = data[K.FStore.Fiance] as? String,
                           let MarriageDate = data[K.FStore.MarriageDate] as? String
                        
                           {
                            let newMember = MemberModel(FirstName: FirstName, LastName: LastName, Address: Address, Apt_no: Apt_no, Email: Email, Phone: Phone, PictureURL: PictureURL, BirthDate: BirthDate, Status: Status, Gender: Gender, WhereFrom: WhereFrom, School: School, Major: Major, Employment: Employment, MissionLocation: MissionLocation, SecondLang: SecondLang, Org: Org, Committee: Committee, Calling: Calling, HEGroup: HEGroup, Emergency: Emergency, Notes: Notes, Ward: Ward, Engaged: Engaged, Fiance: Fiance, MarriageDate: MarriageDate)
                            self.members.append(newMember)
                            
                            //print(self.members)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.members.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                            
                            
                            
                        }
                    }
                }
            }
        } // end closure
    }
    
    
    
    func twoFilters(filter2: String){
        db.collection(K.FStore.collectionName).order(by: filter).order(by: filter2).addSnapshotListener { [self] querySnapshot, error in
            self.members = []
            if let e = error {
                print("There was an issue retreiving data from Firestore, \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let LastName = data[K.FStore.lastNameField] as? String,
                           let FirstName = data[K.FStore.firstNameField] as? String,
                           let Address = data[K.FStore.addressField] as? String,
                           let Apt_no = data[K.FStore.aptField] as? String,
                           let Email = data[K.FStore.emailField] as? String,
                           let Phone = data[K.FStore.phoneField] as? String,
                           let PictureURL = data[K.FStore.pictureURL] as? String,
                           let BirthDate = data[K.FStore.BirthDate] as? String,
                           let Status = data[K.FStore.Status] as? String,
                           let Gender = data[K.FStore.Gender] as? String,
                           let WhereFrom = data[K.FStore.WhereFrom] as? String,
                           
                           let School = data[K.FStore.School] as? String,
                           let Major = data[K.FStore.Major] as? String,
                           let Employment = data[K.FStore.Employment] as? String,
                           let MissionLocation = data[K.FStore.MissionLocation] as? String,
                           let SecondLang = data[K.FStore.SecondLang] as? String,
                           
                           let Org = data[K.FStore.Org] as? String,
                           let Committee = data[K.FStore.Committee] as? String,
                           let Calling = data[K.FStore.Calling] as? String,
                           let HEGroup = data[K.FStore.HEGroup] as? String,
                           
                           let Emergency = data[K.FStore.Emergency] as? String,
                           let Notes = data[K.FStore.Notes] as? String,
                           let Ward = data[K.FStore.Ward] as? String,
                           let Engaged = data[K.FStore.Engaged] as? String,
                           let Fiance = data[K.FStore.Fiance] as? String,
                           let MarriageDate = data[K.FStore.MarriageDate] as? String
                        
                           {
                            let newMember = MemberModel(FirstName: FirstName, LastName: LastName, Address: Address, Apt_no: Apt_no, Email: Email, Phone: Phone, PictureURL: PictureURL, BirthDate: BirthDate, Status: Status, Gender: Gender, WhereFrom: WhereFrom, School: School, Major: Major, Employment: Employment, MissionLocation: MissionLocation, SecondLang: SecondLang, Org: Org, Committee: Committee, Calling: Calling, HEGroup: HEGroup, Emergency: Emergency, Notes: Notes, Ward: Ward, Engaged: Engaged, Fiance: Fiance, MarriageDate: MarriageDate)
                            self.members.append(newMember)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.members.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                            
                            
                            
                        }
                    }
                }
            }
        } // end closure
    }
    
    func whereFilters(filter: String, condition: String){
        db.collection(K.FStore.collectionName).whereField(filter, isEqualTo: condition).addSnapshotListener { [self] querySnapshot, error in
            self.members = []
            if let e = error {
                print("There was an issue retreiving data from Firestore, \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let LastName = data[K.FStore.lastNameField] as? String,
                           let FirstName = data[K.FStore.firstNameField] as? String,
                           let Address = data[K.FStore.addressField] as? String,
                           let Apt_no = data[K.FStore.aptField] as? String,
                           let Email = data[K.FStore.emailField] as? String,
                           let Phone = data[K.FStore.phoneField] as? String,
                           let PictureURL = data[K.FStore.pictureURL] as? String,
                           let BirthDate = data[K.FStore.BirthDate] as? String,
                           let Status = data[K.FStore.Status] as? String,
                           let Gender = data[K.FStore.Gender] as? String,
                           let WhereFrom = data[K.FStore.WhereFrom] as? String,
                           
                           let School = data[K.FStore.School] as? String,
                           let Major = data[K.FStore.Major] as? String,
                           let Employment = data[K.FStore.Employment] as? String,
                           let MissionLocation = data[K.FStore.MissionLocation] as? String,
                           let SecondLang = data[K.FStore.SecondLang] as? String,
                           
                           let Org = data[K.FStore.Org] as? String,
                           let Committee = data[K.FStore.Committee] as? String,
                           let Calling = data[K.FStore.Calling] as? String,
                           let HEGroup = data[K.FStore.HEGroup] as? String,
                           
                           let Emergency = data[K.FStore.Emergency] as? String,
                           let Notes = data[K.FStore.Notes] as? String,
                           let Ward = data[K.FStore.Ward] as? String,
                           let Engaged = data[K.FStore.Engaged] as? String,
                           let Fiance = data[K.FStore.Fiance] as? String,
                           let MarriageDate = data[K.FStore.MarriageDate] as? String
                        
                           {
                            let newMember = MemberModel(FirstName: FirstName, LastName: LastName, Address: Address, Apt_no: Apt_no, Email: Email, Phone: Phone, PictureURL: PictureURL, BirthDate: BirthDate, Status: Status, Gender: Gender, WhereFrom: WhereFrom, School: School, Major: Major, Employment: Employment, MissionLocation: MissionLocation, SecondLang: SecondLang, Org: Org, Committee: Committee, Calling: Calling, HEGroup: HEGroup, Emergency: Emergency, Notes: Notes, Ward: Ward, Engaged: Engaged, Fiance: Fiance, MarriageDate: MarriageDate)
                            self.members.append(newMember)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: 0, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                            
                            
                            
                        }
                    }
                }
            }
        } // end closure
    }
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        //Navigate to the AddMemberViewController
        self.performSegue(withIdentifier: K.addMemberSegue, sender: self)
    }
    
    @IBAction func menuButtonPressed(_ sender: UIBarButtonItem) {
        present(sideMenu!, animated: true)
    }

}

extension MemberViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MemberCell
        if filter == "FirstName" {
            cell.nameLabel?.text = "\(members[indexPath.row].FirstName) \(members[indexPath.row].LastName)"
        } else {
            cell.nameLabel?.text = "\(members[indexPath.row].LastName) \(members[indexPath.row].FirstName)"
        }
        
        cell.addressLabel?.text = "\(members[indexPath.row].Address) \(members[indexPath.row].Apt_no)"
        cell.phoneLabel?.text = "\(members[indexPath.row].Phone)"
        cell.emailLabel?.text = "\(members[indexPath.row].Email)"
        cell.callingLabel.text = "HE Group:\(members[indexPath.row].HEGroup) Committee:\(members[indexPath.row].Committee)"
        //print(members[indexPath.row].PictureURL)
        
        guard let url = URL(string: members[indexPath.row].PictureURL) else {
            cell.avatarView.image = image
            return cell
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async { [self] in
                image = UIImage(data: data)!
                cell.avatarView.makeRounded()
                cell.avatarView.image = image
            }
        }
        task.resume()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
}

extension MemberViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: K.MemberDetailSegue) as? MemberDetailViewController {
            vc.members = members[indexPath.row]
            
            guard let url = URL(string: members[indexPath.row].PictureURL) else {
                vc.imageView.image = image
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                DispatchQueue.main.async { [self] in
                    image = UIImage(data: data)!
                    vc.imageView.image = image
                }
            }
            task.resume()
            
            
            navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {

            // 1. Delete the member from the Firestore database
            let name = "\(members[indexPath.row].LastName) \(members[indexPath.row].FirstName)"
            
            
            db.collection(K.FStore.collectionName).document(name).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
            


            // 2. Now remove from TableView
            members.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)

        }
    }
    
}

extension UIImageView {

    func makeRounded() {

        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}

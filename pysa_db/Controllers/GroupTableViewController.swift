//
//  GroupTableViewController.swift
//  pysa_db
//
//  Created by Eric Anderson on 7/9/21.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

class GroupTableViewController: UIViewController {

  
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    var miss_lang: [MissLangModel] = []
    
    var section: [String] = []
    var items = [[MissLangModel]]()
    
    var image: UIImage = UIImage(named: "picture")!
    
    // pass in if language or Mission
    struct GlobalVariable {
            static var myString = String()
    }

    var filter = GroupTableViewController.GlobalVariable.myString
    //var filter = "MissionLocation"
    override func viewDidLoad() {
        super.viewDidLoad()
        print("filter: \(filter)")
        title = filter // need to change the title to more verbose version
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        if (filter == "Calling") {
            title = "Leadership"
            orgLeadership()
        }
        else if (filter == "Address")  {
            title = "Apartments"
            apartmentList()
        }
        else {
            // need to change the title to more verbose version
            if(filter == "Major"){
                title = "Field of Study"
            }
            else if(filter == "SecondLang"){
                title = "Languages"
            }
            else if(filter == "MissionLocation"){
                title = "Missions"
            }
            else if(filter == "HEGroup"){
                title = "Home Evening Groups"
            }
            else if (filter == "Org") {
                title = "EQ-RS Membership"
            }
            else if (filter == "Committee") {
                title = "Committees"
            }
            loadMessages()
        }
    }
    

    func loadMessages() {
        //db.collection(K.FStore.collectionName).order(by: filter).addSnapshotListener { [self] querySnapshot, error in
        db.collection(K.FStore.collectionName).whereField(K.FStore.Status, isEqualTo: "Current").order(by: filter).addSnapshotListener { [self] querySnapshot, error in
            self.miss_lang = []
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
                           let PictureURL = data[K.FStore.pictureURL] as? String,
                           let MissionLocation = data[K.FStore.MissionLocation] as? String,
                           let SecondLang = data[K.FStore.SecondLang] as? String,
                           let Major = data[K.FStore.Major] as? String,
                           let Org = data[K.FStore.Org] as? String,
                           let Committee = data[K.FStore.Committee] as? String,
                           let Calling = data[K.FStore.Calling] as? String,
                           let HEGroup = data[K.FStore.HEGroup] as? String
                        
                           {
                            let newMiss_Lang = MissLangModel(FirstName: FirstName, LastName: LastName, Address: Address, Apt_no: Apt_no, PictureURL: PictureURL, MissionLocation: MissionLocation, SecondLang: SecondLang, Major: Major, Org: Org, Committee: Committee, Calling: Calling, HEGroup: HEGroup)
                            //print(newMiss_Lang)
                            self.miss_lang.append(newMiss_Lang)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: 0, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                            
                            
                            
                        }
                        
                    }
                    for member in miss_lang {
                        if(filter == "MissionLocation"){
                            section.append(member.MissionLocation)
                        }
                        else if(filter == "SecondLang") {
                            section.append(member.SecondLang)
                        }
                        else if(filter == "Major") {
                            section.append(member.Major)
                        }
                        else if(filter == "Org") {
                            section.append(member.Org)
                        }
                        else if(filter == "Committee") {
                            section.append(member.Committee)
                        }
                        else if(filter == "HEGroup") {
                            section.append(member.HEGroup)
                        }
                    }

                    section = section.removingDuplicates()
                    
                    let index1 = 0...miss_lang.count - 1
                    let index2 = 0...section.count - 1
                    var rows: [MissLangModel] = []

                    for num2 in index2 {
                        for num1 in index1 {
                            
                            if(filter == "MissionLocation"){
                                if(String(miss_lang[num1].MissionLocation) == String(section[num2])){
                                    rows.append(miss_lang[num1])
                                }
                            }
                            else if(filter == "SecondLang"){
                                if(String(miss_lang[num1].SecondLang) == String(section[num2])){
                                    rows.append(miss_lang[num1])
                                }
                            }
                            else if(filter == "Major"){
                                if(String(miss_lang[num1].Major) == String(section[num2])){
                                    rows.append(miss_lang[num1])
                                }
                            }
                            else if(filter == "Org"){
                                if(String(miss_lang[num1].Org) == String(section[num2])){
                                    rows.append(miss_lang[num1])
                                }
                            }
                            else if(filter == "Committee"){
                                if(String(miss_lang[num1].Committee) == String(section[num2])){
                                    rows.append(miss_lang[num1])
                                }
                            }
                            else if(filter == "HEGroup"){
                                if(String(miss_lang[num1].HEGroup) == String(section[num2])){
                                    rows.append(miss_lang[num1])
                                }
                            }
                            
                            
                        }
                        items.append(rows)
                        rows = []

                    }

                }
            }
        } // end closure
        // ********* section ***************************************
        
        
    }
    
    func orgLeadership() {
        //db.collection(K.FStore.collectionName).order(by: filter).addSnapshotListener { [self] querySnapshot, error in
        db.collection(K.FStore.collectionName)
            .whereField(K.FStore.Calling, in: ["President", "First Counselor", "Second Counselor", "Secretary"])
            .order(by: "Org").addSnapshotListener { [self] querySnapshot, error in
            self.miss_lang = []
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
                           let PictureURL = data[K.FStore.pictureURL] as? String,
                           let MissionLocation = data[K.FStore.MissionLocation] as? String,
                           let SecondLang = data[K.FStore.SecondLang] as? String,
                           let Major = data[K.FStore.Major] as? String,
                           let Org = data[K.FStore.Org] as? String,
                           let Committee = data[K.FStore.Committee] as? String,
                           let Calling = data[K.FStore.Calling] as? String,
                           let HEGroup = data[K.FStore.HEGroup] as? String
                        
                           {
                            let newMiss_Lang = MissLangModel(FirstName: FirstName, LastName: LastName, Address: Address, Apt_no: Apt_no, PictureURL: PictureURL, MissionLocation: MissionLocation, SecondLang: SecondLang, Major: Major, Org: Org, Committee: Committee, Calling: Calling, HEGroup: HEGroup)
                            //print(newMiss_Lang)
                            self.miss_lang.append(newMiss_Lang)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: 0, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                            
                            
                            
                        }
                        
                    }
                    for member in miss_lang {
                        section.append(member.Org)
                    }

                    section = section.removingDuplicates()
                    
                    let index1 = 0...miss_lang.count - 1
                    let index2 = 0...section.count - 1
                    var rows: [MissLangModel] = []

                    for num2 in index2 {
                        for num1 in index1 {
                            if(String(miss_lang[num1].Org) == String(section[num2])){
                                rows.append(miss_lang[num1])
                            }
                        }
                        items.append(rows)
                        rows = []

                    }

                }
            }
        } // end closure
        // ********* section ***************************************
        
        
    }
    
    func apartmentList() {
        //db.collection(K.FStore.collectionName).order(by: filter).addSnapshotListener { [self] querySnapshot, error in
        db.collection(K.FStore.collectionName)
            .order(by: "Address")
            .order(by: "Apt_no").addSnapshotListener { [self] querySnapshot, error in
            self.miss_lang = []
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
                           let PictureURL = data[K.FStore.pictureURL] as? String,
                           let MissionLocation = data[K.FStore.MissionLocation] as? String,
                           let SecondLang = data[K.FStore.SecondLang] as? String,
                           let Major = data[K.FStore.Major] as? String,
                           let Org = data[K.FStore.Org] as? String,
                           let Committee = data[K.FStore.Committee] as? String,
                           let Calling = data[K.FStore.Calling] as? String,
                           let HEGroup = data[K.FStore.HEGroup] as? String
                        
                           {
                            let newMiss_Lang = MissLangModel(FirstName: FirstName, LastName: LastName, Address: Address, Apt_no: Apt_no, PictureURL: PictureURL, MissionLocation: MissionLocation, SecondLang: SecondLang, Major: Major, Org: Org, Committee: Committee, Calling: Calling, HEGroup: HEGroup)
                            //print(newMiss_Lang)
                            self.miss_lang.append(newMiss_Lang)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: 0, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                            
                            
                            
                        }
                        
                    }
                    for member in miss_lang {
                        section.append(member.Address)
                    }

                    section = section.removingDuplicates()
                    
                    print("section: \(section)")
                    
                    let index1 = 0...miss_lang.count - 1
                    let index2 = 0...section.count - 1
                    var rows: [MissLangModel] = []

                    for num2 in index2 {
                        for num1 in index1 {
                            if(String(miss_lang[num1].Address) == String(section[num2])){
                                rows.append(miss_lang[num1])
                            }
                        }
                        items.append(rows)
                        rows = []

                    }
                    
                }
            }
        } // end closure
        // ********* section ***************************************
        
        print(items)
    }
    
}


extension GroupTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("numberOfRowsInSection: \(self.items[section].count)")
        return self.items[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //print("numberOfSections: \(self.section.count)")
        return self.section.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //print("titleForHeaderInSection: \(self.section[section])")
        
        if(filter == "HEGroup"){
            return "Group \(self.section[section])"
        }
        else {
            return self.section[section]
        }
        
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = .gray
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.systemTeal
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //print("indexPath.section: \(indexPath.section)")
        //print("indexPath.row: \(indexPath.row)")
            cell.imageView?.image = image
            cell.textLabel?.textColor = .black
        if(filter == "Calling") {
            cell.textLabel?.text = "\(self.items[indexPath.section][indexPath.row].LastName) \(self.items[indexPath.section][indexPath.row].FirstName) - \(self.items[indexPath.section][indexPath.row].Calling)"
        }
        if(filter == "Address") {
            cell.textLabel?.text = "\(self.items[indexPath.section][indexPath.row].LastName) \(self.items[indexPath.section][indexPath.row].FirstName) - \(self.items[indexPath.section][indexPath.row].Apt_no)"
        }
        else {
            cell.textLabel?.text = "\(self.items[indexPath.section][indexPath.row].LastName) \(self.items[indexPath.section][indexPath.row].FirstName)"
        }
            
        
            

        guard let url = URL(string: items[indexPath.section][indexPath.row].PictureURL) else {
            cell.imageView?.image = image
            return cell
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }

            DispatchQueue.main.async { [self] in
                image = UIImage(data: data)!
                cell.imageView?.makeRounded()
                cell.imageView?.image = image
            }
        }
        task.resume()
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    
}




extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

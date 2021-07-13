//
//  MenuViewController.swift
//  pysa_db
//
//  Created by Eric Anderson on 7/5/21.
//

import UIKit

protocol MenuControllerDelegate {
    func didSelectMenuItem(named: SideMenuItem)
}

enum SideMenuItem: String, CaseIterable {
    case directory = "Directory"
    case directoryFN = "Directory - First Name"
    case committees = "Committees"
    case eqrsLeadership = "EQ & RS Leadership"
    case eqrsMembers = "EQ & RS Membership"
    case heGroups = "HE Groups"
    case apartmentList = "Apartment List"
    case missions = "Missions"
    case languages = "Languages"
    case noCalling = "No Callings"
    case major = "Major"
    case prevMember = "Previous Members"
    case ward = "Ward"
    case sacrament = "Sacrament"
    case logout = "Logout"
    case settings = "Settings"
}

class MenuViewController: UITableViewController {
    
    let section = ["Reports", "Ward & Stake", "General"]
    
    let items = [["Directory", "Directory - First Name",
                  "Committees","EQ & RS Leadership",
                  "EQ & RS Membership",
                  "HE Groups",
                  "Apartment List",
                  "Missions",
                  "Languages",
                  "No Callings",
                  "Major",
                  "Previous Members"], ["My Ward", "Sacrament Program"],["Logout", "Settings" ]]
    
    public var delegate: MenuControllerDelegate?

    private let menuItems: [SideMenuItem]
    private let color = UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1)
    
    init(with menuItems: [SideMenuItem]) {
        self.menuItems = menuItems
        super.init(nibName: nil, bundle: nil)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = color
        view.backgroundColor = color
        title = "Menu"
    }
    
    // MARK: - Table view data source

   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items[section].count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.section.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.section[section]
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = color
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.systemTeal
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
            
            //cell.imageView?.image = UIImage(systemName: "square.and.pencil")
            //cell.textLabel?.text = menuItems[indexPath.row].rawValue
            cell.textLabel?.text = self.items[indexPath.section][indexPath.row]
            cell.indentationLevel = 1
            cell.indentationWidth = 20.0; //or any width you like
            cell.textLabel?.textColor = .white
            cell.backgroundColor = color
            cell.contentView.backgroundColor = color
        
        return cell

        }
    
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        // Relay info about the selected menu to the MemberViewCOntroller
        let selectedItemText = self.items[indexPath.section][indexPath.row]
        var selectedItem = menuItems[indexPath.row]
        
            if selectedItemText == "My Ward" {
                selectedItem = menuItems[12]
            }
        
            if selectedItemText == "Sacrament Program" {
                selectedItem = menuItems[13]
            }
            if selectedItemText == "Logout" {
                selectedItem = menuItems[14]
            }
        
            if selectedItemText == "Settings" {
                selectedItem = menuItems[15]
            }
        
        delegate?.didSelectMenuItem(named: selectedItem)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30.0
    }

}

//
//  MemberDetailViewController.swift
//  pysa_db
//
//  Created by Eric Anderson on 6/29/21.
//

import Foundation
import UIKit

class MemberDetailViewController: UIViewController {
    @IBOutlet weak var navigationTitle: UINavigationItem!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var firstNameText: UILabel!
    @IBOutlet weak var lastNameText: UILabel!
    @IBOutlet weak var addressText: UILabel!
    @IBOutlet weak var aptNumText: UILabel!
    @IBOutlet weak var phoneNumText: UILabel!
    @IBOutlet weak var emailAddrText: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var birthDateText: UILabel!
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var genderText: UILabel!
    @IBOutlet weak var whereFromText: UILabel!
    @IBOutlet weak var schoolText: UILabel!
    @IBOutlet weak var majorText: UILabel!
    @IBOutlet weak var employmentText: UILabel!
    @IBOutlet weak var missionlocationText: UILabel!
    @IBOutlet weak var secondlangText: UILabel!
    
    @IBOutlet weak var orgText: UILabel!
    @IBOutlet weak var committeeText: UILabel!
    @IBOutlet weak var callingText: UILabel!
    @IBOutlet weak var hegroupText: UILabel!
    @IBOutlet weak var engagedText: UILabel!
    @IBOutlet weak var fianceText: UILabel!
    @IBOutlet weak var marriageText: UILabel!
    @IBOutlet weak var emergencyText: UILabel!
    @IBOutlet weak var notesText: UILabel!
    
    var members: MemberModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        notesText.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        // add code here
        self.title = "\(members!.LastName) \(members!.FirstName)"
        firstNameText.text = members?.FirstName
        lastNameText.text = members?.LastName
        addressText.text = members?.Address
        aptNumText.text = members?.Apt_no
        phoneNumText.text = members?.Phone
        emailAddrText.text = members?.Email
        birthDateText.text = members?.BirthDate
        statusText.text = members?.Status
        genderText.text = members?.Gender
        whereFromText.text = members?.WhereFrom
        schoolText.text = members?.School
        majorText.text = members?.Major
        employmentText.text = members?.Employment
        missionlocationText.text = members?.MissionLocation
        secondlangText.text = members?.SecondLang
        
        orgText.text = members?.Org
        committeeText.text = members?.Committee
        callingText.text = members?.Calling
        hegroupText.text = members?.HEGroup
        
        engagedText.text = members?.Engaged
        fianceText.text = members?.Fiance
        marriageText.text = members?.MarriageDate
        emergencyText.text = members?.Emergency
        notesText.text = members?.Notes
        
        
        print(members ?? "empty")
        
    }
    @IBAction func EditPressed(_ sender: UIBarButtonItem) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: K.EditMemberSegue) as? EditMemberViewController {
            vc.members = members
            vc.myImage = imageView.image
            vc.pgTitle = "Edit"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}


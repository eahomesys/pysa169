//
//  Constants.swift
//  pysa_db
//
//  Created by Eric Anderson on 6/26/21.
//

struct K {
    static let appName = "PYSA Tools"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MemberCell"
    static let registerSegue = "RegisterToMember"
    static let loginSegue = "LoginToMember"
    static let addMemberSegue = "MemberToAdd"
    static let MemberDetailSegue = "MemberDetail"
    static let EditMemberSegue = "DetailToEdit"
    static let returnToMemberView = "returnToMemberView"
    static let MemberToSettings = "MemberToSettings"
    static let MemberToGroupView = "MemberToGroupView"
    static let MemberToWard = "MemberToWard"
    static let MemberToWeb = "MemberToWeb"
    
    struct FStore {
        static let collectionName = "members"
        static let firstNameField = "FirstName"
        static let lastNameField = "LastName"
        static let addressField = "Address"
        static let aptField = "Apt_no"
        static let emailField = "Email"
        static let phoneField = "Phone"
        static let dateField = "date"
        static let pictureURL = "pictureURL"
        static let BirthDate = "BirthDate"
        
        static let Status = "Status"
        static let Gender = "Gender"
        static let WhereFrom = "WhereFrom"
        
        static let School = "School"
        static let Major = "Major"
        static let Employment = "Employment"
        
        static let MissionLocation = "MissionLocation"
        static let SecondLang = "SecondLang"
        
        static let Org = "Org"
        static let Committee = "Committee"
        static let Calling = "Calling"
        static let HEGroup = "HEGroup"
        
        static let Emergency = "Emergency"
        static let Notes = "Notes"
        
        static let Ward = "Ward"
        
        static let Engaged = "Engaged"
        static let Fiance = "Fiance"
        static let MarriageDate = "MarriageDate"
    }
}

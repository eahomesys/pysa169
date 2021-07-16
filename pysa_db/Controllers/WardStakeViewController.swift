//
//  WardStakeViewController.swift
//  pysa_db
//
//  Created by Eric Anderson on 7/12/21.
//

import UIKit
import Firebase

class WardStakeViewController: UIViewController {

    @IBOutlet weak var wardLabel: UILabel!
    @IBOutlet weak var stakeLabel: UILabel!
    @IBOutlet weak var bishopLabel: UILabel!
    @IBOutlet weak var firstCounselorLabel: UILabel!
    @IBOutlet weak var secondCounselorLabel: UILabel!
    @IBOutlet weak var execSecLabel: UILabel!
    @IBOutlet weak var wardClerkLabel: UILabel!
    @IBOutlet weak var meetingLocationLabel: UILabel!
    @IBOutlet weak var sacramentLabel: UILabel!
    
    let db = Firestore.firestore()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Ward & Stake"
        loadData()
        // Do any additional setup after loading the view.
    }
    
    func loadData() {
        let collection = db.collection("Ward")
        let query = collection.document("169")
        
        query.addSnapshotListener { [self] documentSnapshot, error in
            guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                  }
                  guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                  }
                    print("Current data: \(data)")
                    stakeLabel.text = data["Stake"] as? String
            bishopLabel.text = "\(String(describing: data["Bishop"] as? String))\n\(String(describing: data["BishPhone"] as? String))"
                    firstCounselorLabel.text = "\(String(describing: data["FirstCounselor"] as? String))\n\(String(describing: data["FirstCPhone"] as? String))"
                    secondCounselorLabel.text = "\(String(describing: data["SecCounselor"] as? String))\n\(String(describing: data["SecCPhone"] as? String))"
                    execSecLabel.text = "\(String(describing: data["ExecSec"] as? String))\n\(String(describing: data["ExecSecPhone"] as? String))"
                    wardClerkLabel.text = "\(String(describing: data["WardClerk"] as? String))\n\(String(describing: data["WardCPhone"] as? String))"
                    meetingLocationLabel.text = data["location"] as? String
                    sacramentLabel.text = "\(String(describing: data["SacTime"] as? String))\n\(String(describing: data["SecondHourMtg"] as? String))"
            
                }
    }
}

extension Optional: CustomStringConvertible {

    public var description: String {
        switch self {
        case .some(let wrappedValue):
            return "\(wrappedValue)"
        default:
            return "<nil>"
        }
    }
}

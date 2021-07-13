//
//  WebViewController.swift
//  pysa_db
//
//  Created by Eric Anderson on 7/12/21.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
//    override func loadView() {
//        webView = WKWebView()
//        webView.navigationDelegate = self
//        view = webView
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sacrament Program"
        let url = URL(string: "https://docs.google.com/document/d/19VPgedHzorjvxQMjr6veAxNVzWLYArj_L7q4FmSOrEM/edit?usp=sharing")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = false
        

        // Do any additional setup after loading the view.
    }
    
    
}

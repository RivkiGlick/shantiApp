//
//  TermsAndConditionsViewController.swift
//  
//
//  Created by hodaya ohana on 03/01/2016.
//
//

import UIKit

class TermsAndConditionsViewController: GlobalViewController {

    @IBOutlet weak var webViewTermsAndConditions: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = nil
        
          self.title = NSLocalizedString("Terms and Conditions", comment: "")  as String/*"הרשמה"*/
        
        let url = NSURL (string: "https://media.termsfeed.com/pdf/terms-and-conditions-template.pdf");
        let requestObj = NSURLRequest(URL: url!);
        if self.webViewTermsAndConditions != nil
        {
        self.webViewTermsAndConditions.loadRequest(requestObj);
        }
     
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

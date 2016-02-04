//
//  PrivacyPolicyViewController.swift
//  
//
//  Created by hodaya ohana on 04/01/2016.
//
//

import UIKit

class PrivacyPolicyViewController: GlobalViewController {

        @IBOutlet weak var webViewPrivacyPolicy: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = nil
        
          self.title = NSLocalizedString("Privacy Policy", comment: "")  as String/*"הרשמה"*/
        
        let url = NSURL (string: "https://media.termsfeed.com/pdf/privacy-policy-template.pdf");
        let requestObj = NSURLRequest(URL: url!);
        if self.webViewPrivacyPolicy != nil
        {
            self.webViewPrivacyPolicy.loadRequest(requestObj);
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  FillingDetailsViewController.swift
//  Shanti
//
//  Created by hodaya ohana on 2/22/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

class FillingDetailsViewController: GlobalViewController,UITextViewDelegate {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtProfession: UITextField!
    @IBOutlet weak var txtHobby: UITextField!
    @IBOutlet weak var txtMoreDetails: UITextView!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    var btnSkip: UIBarButtonItem!
    
    var user: User = User()
    override func viewDidLoad() {
        let tapGesture = UITapGestureRecognizer(target: self, action: "dismissControllers")
        self.view.addGestureRecognizer(tapGesture)
        
        self.setNavigationConfig()
        self.setSubviewsGraphics()
        self.setSubviewsFrames()
        self.txtMoreDetails.delegate = self
        self.txtMoreDetails.selectedTextRange  = txtMoreDetails.textRangeFromPosition(txtMoreDetails.beginningOfDocument, toPosition: txtMoreDetails.beginningOfDocument)
        
        
        
    }
    
    func dismissControllers()
    {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1)
        
        self.txtProfession.resignFirstResponder()
        self.txtHobby.resignFirstResponder()
        self.txtMoreDetails.resignFirstResponder()
        
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        UIView.commitAnimations()
    }
    
    func setNavigationConfig(){
        self.title = NSLocalizedString("Completing details", comment: "")  as String/*"השלמת פרטים"*/
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.rightBarButtonItem = nil
        
        var skip = UIButton()
        skip.setTitle(NSLocalizedString("Skip", comment: "")  as String/*"דלג"*/, forState: UIControlState.Normal)
        skip.setTitle(NSLocalizedString("Skip", comment: "")  as String/*"דלג"*/, forState: UIControlState.Highlighted)
        skip.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        skip.sizeToFit()
        skip.addTarget(self, action: "setUserPreferences:", forControlEvents: UIControlEvents.TouchUpInside)
        btnSkip = UIBarButtonItem(customView: skip)
        self.navigationItem.setRightBarButtonItem(self.btnSkip, animated: true)
        
        var controllers = self.navigationController?.viewControllers as [AnyObject]!
        
        for view in controllers{
            if view.isKindOfClass(MainPage){
                self.navigationItem.rightBarButtonItem = nil // has to append after setNavigationConfig func
                break
            }
        }
    }
    
    func setSubviewsGraphics(){
        
        //textAlignment
        var space: CGFloat = 10
        var textAlignment: NSTextAlignment = .Left
        let languageId = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) as! String
        if languageId == "he"{
            textAlignment = .Right
            space = -space
        }
        
        lblTitle.textAlignment = textAlignment
        txtProfession.textAlignment = textAlignment
        txtHobby.textAlignment = textAlignment
        txtMoreDetails.textAlignment = textAlignment
        lblSubTitle.textAlignment = textAlignment
        
        //make cornerRadius and location placeHolder to the UITextField
        for view in self.view.subviews{
            if view.isKindOfClass(UITextField){
                view.layer.cornerRadius = 8
                view.layer.sublayerTransform = CATransform3DMakeTranslation(space,0,0)
            }
        }
        
        
        lblTitle.text = NSLocalizedString("Complete your profile", comment: "")  as String/*"השלם את הפרטים שלך"*/
        lblTitle.sizeToFit()
        lblTitle.textColor = UIColor(red: 191.0/255.0, green: 196.0/255.0, blue: 201.0/255.0, alpha: 1)
        
        txtProfession.placeholder = NSLocalizedString("Profession or Occupation", comment: "")  as String/*"מקצוע או תחום עיסוק"*/
        txtProfession.sizeToFit()
        txtProfession.textColor = UIColor(red: 128.0/255.0, green: 137.0/255.0, blue: 148.0/255.0, alpha: 1)
        
        txtHobby.placeholder = NSLocalizedString("Hobby", comment: "")  as String/*"תחביב"*/
        txtHobby.sizeToFit()
        txtHobby.textColor = UIColor(red: 128.0/255.0, green: 137.0/255.0, blue: 148.0/255.0, alpha: 1)
        
        txtMoreDetails.text = NSLocalizedString("More details", comment: "")  as String/*"עוד פרטים"*/
        txtMoreDetails.textColor = UIColor(red: 128.0/255.0, green: 137.0/255.0, blue: 148.0/255.0, alpha: 1)
        txtMoreDetails.layer.cornerRadius = txtHobby.layer.cornerRadius
        txtMoreDetails.layer.shadowColor = txtHobby.layer.shadowColor
        txtMoreDetails.layer.shadowOffset = txtHobby.layer.shadowOffset
        txtMoreDetails.layer.shadowOpacity = txtHobby.layer.shadowOpacity
        txtMoreDetails.layer.shadowPath = txtHobby.layer.shadowPath
        txtMoreDetails.layer.shadowRadius = txtHobby.layer.shadowRadius
        txtMoreDetails.layer.borderColor = txtHobby.layer.borderColor
        txtMoreDetails.layer.borderWidth = txtHobby.layer.borderWidth
        
        lblSubTitle.text = (NSLocalizedString("Tell people in your group about your trips.  Is there anything you particularly interested in", comment: "")  as String) + " " + NSLocalizedString("Is there anythong significant in your life that you want to share with them", comment: "")  as String/*"ספר למשתמשים שבקבוצתך על סגנון הטיולים שלך, האם יש משהו שאתה מתעניין בו במיוחד?\nהאם יש משהו משמעותי בחייך שאתה רוצה לחלוק אותו איתם?"*/
        lblSubTitle.textColor = UIColor(red: 176.0/255.0, green: 0.0/255.0, blue: 247.0/255.0,
            alpha: 0.8)
        
        lblSubTitle.numberOfLines = 0
        lblSubTitle.sizeToFit()
        
        btnSave.setTitle(NSLocalizedString("End", comment: "")  as String/*"סיום"*/, forState: UIControlState.Normal)
        btnSave.setTitle(NSLocalizedString("End", comment: "")  as String/*"סיום"*/, forState: UIControlState.Normal)
        btnSave.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btnSave.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        btnSave.backgroundColor = UIColor(red: 176.0/255.0, green: 0.0/255.0, blue: 247.0/255.0,
            alpha: 0.8)
        btnSave.titleLabel!.textAlignment = NSTextAlignment.Right
        btnSave.sizeToFit()
        btnSave.layer.cornerRadius = 3.0;
        btnSave.layer.shadowRadius = 1.0
        btnSave.layer.shadowOffset = CGSizeMake(0, -1.0)
        btnSave.layer.shadowColor = UIColor(red: 30/255.0, green: 10/255.0, blue: 40/255.0, alpha: 0.75).CGColor
    }
    
    func setSubviewsFrames(){
        let txtsWidth = CGFloat(291.5)
        let txtsHight = CGFloat(46.0)
        let txtsX = (UIScreen.mainScreen().bounds.size.width - txtsWidth)/2
        let txtViewHight = 2.5 * txtsHight
        let spaceFomeScreenEnd = CGFloat(UIScreen.mainScreen().bounds.size.height - UIScreen.mainScreen().bounds.size.height/6)//
        let spaceBetweenLabelsToTexts = CGFloat(11.5)
        let spaceBetweenTxtFields = CGFloat(11.5)
        let spaceForSubTitle = CGFloat(50)
        lblSubTitle.sizeToFit()
        
    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        let currentText:NSString = txtMoreDetails.text
        let updatedText = currentText.stringByReplacingCharactersInRange(range, withString:text)
        
        
        if updatedText.isEmpty {
            
            txtMoreDetails.text = NSLocalizedString("More details", comment: "")  as String
            txtMoreDetails.textColor = UIColor.lightGrayColor()
            txtMoreDetails.selectedTextRange = txtMoreDetails.textRangeFromPosition(textView.beginningOfDocument, toPosition: txtMoreDetails.beginningOfDocument)
            
            return false
        }
            
            
        else if !text.isEmpty {
            txtMoreDetails.text = ""
            txtMoreDetails.textColor = UIColor.blackColor()
        }
        
        return true
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        
        if  txtMoreDetails.text == NSLocalizedString("More details", comment: "")  as String{
            txtMoreDetails.selectedTextRange = txtMoreDetails.textRangeFromPosition(txtMoreDetails.beginningOfDocument, toPosition: txtMoreDetails.beginningOfDocument)
        }
        
    }
    
    
    
    
    @IBAction func saveChangesInServer(sender: AnyObject) {
        self.user.nvHobby = txtHobby.text
        self.user.nvProfession = txtProfession.text
        //add to user nvComment property
        
        var generic = Generic()
        generic.showNativeActivityIndicator(self)
        //FIXME1.11
        var userDics:NSMutableDictionary = ["newUser":User.getUserDictionary(self.user)]
        Connection.connectionToService("UpdateUser", params: /*User.getUserDictionary(self.user)*/userDics, completion: {
            data -> Void in
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("UpdateUser:\(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            if json != nil{
                if let parseJSON = json {
                    let returnedUser = User.parseUserJson(JSON(parseJSON))
                    if (returnedUser.iUserId != -1 && returnedUser.iUserId != 0){
                        let SearchView: SearchSettingsViewController = self.storyboard!.instantiateViewControllerWithIdentifier("SearchSettingsViewControllerId") as! SearchSettingsViewController
                        
                        SearchView.userSearchSettings.iUserId = self.user.iUserId
                        generic.hideNativeActivityIndicator(self)
                        self.navigationController!.pushViewController(SearchView, animated: true)
                    } else {
                        generic.hideNativeActivityIndicator(self)
                        var alert = UIAlertController(title: "Error", message: "Fail update youre profile picture", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            }else{
                generic.hideNativeActivityIndicator(self)
                var alert = UIAlertController(title: "Server error", message: "Fail update youre profile picture", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            generic.hideNativeActivityIndicator(self)
        })
    }
    
    func setUserPreferences(sender: AnyObject) {
        let SearchView: SearchSettingsViewController = self.storyboard!.instantiateViewControllerWithIdentifier("SearchSettingsViewControllerId") as! SearchSettingsViewController
        SearchView.userSearchSettings.iUserId = self.user.iUserId
        self.navigationController!.pushViewController(SearchView, animated: true)
    }
}

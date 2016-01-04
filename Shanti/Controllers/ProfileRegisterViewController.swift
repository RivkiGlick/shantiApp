//
//  ProfileRegisterViewController.swift
//  Shanti
//
//  Created by hodaya ohana on 1/22/15.
//  Copyright (c) 2015 webit. All rights reserved.
//NSLocalizedString("", comment: "")  as String

import UIKit

class ProfileRegisterViewController: GlobalViewController,UITextFieldDelegate,UIGestureRecognizerDelegate,PopupViewControllerDelegate
{
    
    @IBOutlet weak var lblMyProfile: UILabel!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtBirthdate: UITextField!
    @IBOutlet weak var txtMaleOrFemale: UITextField!
    @IBOutlet weak var txtReligion: UITextField!
    @IBOutlet weak var txtLanguages: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    
    var userRegister:User = User()
    
    var countriesArry: NSMutableArray = NSMutableArray()
    var languageArry: NSMutableArray = NSMutableArray()
    var religionsArry: NSMutableArray = NSMutableArray()
    var religionLevelArry: NSMutableArray = NSMutableArray()
    var ageRangeArry: NSMutableArray = NSMutableArray()
    var gendersArry: NSMutableArray = NSMutableArray()
    
    var tableList: NSMutableArray = NSMutableArray()
    var datePicker: UIDatePicker = UIDatePicker()
    
    var keyboardSize: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setDelegates()
        self.addPageGraphics()
        self.navigationItem.rightBarButtonItem = nil
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "dismissControllers")
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        
        // arrays handle
        countriesArry = ApplicationData.sharedApplicationDataInstance.countriesArry
        languageArry = ApplicationData.sharedApplicationDataInstance.languageArry
        religionsArry = ApplicationData.sharedApplicationDataInstance.religionsArry
        religionLevelArry = ApplicationData.sharedApplicationDataInstance.religionLevelArry
        ageRangeArry = ApplicationData.sharedApplicationDataInstance.ageRangeArry
        gendersArry = ApplicationData.sharedApplicationDataInstance.gendersArry
        
        var toolBar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 44))
        var toolBarBtn = UIBarButtonItem(title: NSLocalizedString(NSLocalizedString("Select", comment: "")  as String/*"בחר"*/, comment: ""), style: .Plain, target: self, action: "toolBarItemClicked:")
        toolBar.setItems([toolBarBtn], animated: true)
        toolBar.backgroundColor = datePicker.backgroundColor
        
        datePicker.datePickerMode = UIDatePickerMode.Date
        
        self.txtBirthdate.inputView = datePicker
        self.txtBirthdate.inputAccessoryView = toolBar
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.dismissControllers()
    }
    
    func setDelegates(){
        self.txtCountry.delegate = self
        self.txtBirthdate.delegate = self
        self.txtMaleOrFemale.delegate = self
        self.txtReligion.delegate = self
        self.txtLanguages.delegate = self
    }
    
    func addPageGraphics(){
        self.title = NSLocalizedString("Signing up", comment: "")  as String/*"הרשמה"*/
        
        //texts
        lblMyProfile.text = NSLocalizedString("Set up your profile", comment: "")  as String/*"הגדר את הפרופיל שלך"*/
        txtCountry.placeholder = NSLocalizedString("Country of residence", comment: "")  as String/*"ארץ מגורים"*/
        txtBirthdate.placeholder = NSLocalizedString("Date of Birth", comment: "")  as String/*"תאריך לידה"*/
        txtMaleOrFemale.placeholder = NSLocalizedString("Gender", comment: "")  as String/*"מגדר"*/
        txtReligion.placeholder = NSLocalizedString("Faith", comment: "")  as String/*"דת"*/
        //        txtHowReligion.placeholder = "יחס לדת"
        txtLanguages.placeholder = NSLocalizedString("Spoken languages", comment: "")  as String/*"שפות"*/
        btnRegister.setTitle(NSLocalizedString("Sign Up", comment: "")  as String/*"הרשם"*/, forState: UIControlState.Normal)
        
        lblMyProfile.sizeToFit()
        txtCountry.sizeToFit()
        txtBirthdate.sizeToFit()
        txtMaleOrFemale.sizeToFit()
        txtReligion.sizeToFit()
        //        txtHowReligion.sizeToFit()
        txtLanguages.sizeToFit()
        btnRegister.sizeToFit()
        //lblConditions.sizeToFit()
        
        //colors
        lblMyProfile.textColor = UIColor(red: 191.0/255.0, green: 196.0/255.0, blue: 201.0/255.0, alpha: 1)
        txtCountry.textColor = UIColor(red: 128.0/255.0, green: 137.0/255.0, blue: 148.0/255.0, alpha: 1)
        txtBirthdate.textColor = UIColor(red: 128.0/255.0, green: 137.0/255.0, blue: 148.0/255.0, alpha: 1)
        txtMaleOrFemale.textColor = UIColor(red: 128.0/255.0, green: 137.0/255.0, blue: 148.0/255.0, alpha: 1)
        txtReligion.textColor = UIColor(red: 128.0/255.0, green: 137.0/255.0, blue: 148.0/255.0, alpha: 1)
        txtLanguages.textColor = UIColor(red: 128.0/255.0, green: 137.0/255.0, blue: 148.0/255.0, alpha: 1)
        btnRegister.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btnRegister.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        btnRegister.backgroundColor = UIColor(red: 176.0/255.0, green: 0.0/255.0, blue: 247.0/255.0, alpha: 0.8)
        
        btnRegister.sizeToFit()
        
        //Shadows settings
        btnRegister.layer.shadowRadius = 1.0
        btnRegister.layer.shadowOffset = CGSizeMake(0, -1.0)
        btnRegister.layer.shadowColor = UIColor(red: 30/255.0, green: 10/255.0, blue: 40/255.0, alpha: 0.75).CGColor
        
        
        //textAlignment
        var space: CGFloat = 10
        var textAlignment: NSTextAlignment = .Left
        let languageId = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) as! String
        if languageId == "he"{
            textAlignment = .Right
            space = -space
        }
        
        txtCountry.textAlignment = textAlignment
        txtBirthdate.textAlignment = textAlignment
        txtMaleOrFemale.textAlignment = textAlignment
        txtReligion.textAlignment = textAlignment
        txtLanguages.textAlignment = textAlignment
        lblMyProfile.textAlignment = textAlignment
        
        //make cornerRadius and location placeHolder to the UITextField
        for view in self.view.subviews{
            if view.isKindOfClass(UITextField){
                view.layer.cornerRadius = 8
                view.layer.sublayerTransform = CATransform3DMakeTranslation(space,0,0)
            }
            if view.isKindOfClass(UIButton){
                view.layer.cornerRadius = 3.0
            }
        }
        //FIXME:prefix
        txtCountry.text = ActiveUser.sharedInstace.oCountry.nvValue
        //frames
        let txtsWidth = CGFloat(291.5)
        let txtsHight = CGFloat(42.0)
        let spaceFomeScreenEnd = CGFloat(65)
        let spaceBetweenLoginBtnToForgotPassBtn = CGFloat(11.5)
        let spaceBetweenTxtFields = CGFloat(11.5)
        
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool{
        if touch.view.isKindOfClass(UITableViewCell) {
            return false
        }else if touch.view.superview!.isKindOfClass(UITableViewCell){
            return false
        }else if touch.view.superview!.superview!.isKindOfClass(UITableViewCell){
            return false
        }
        return true
    }
    
    func dismissControllers(){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1)
        
        self.txtCountry.resignFirstResponder()
        self.txtBirthdate.resignFirstResponder()
        self.txtMaleOrFemale.resignFirstResponder()
        self.txtReligion.resignFirstResponder()
        //        self.txtHowReligion.resignFirstResponder()
        self.txtLanguages.resignFirstResponder()
        
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        
        UIView.commitAnimations()
    }
    
    override func popBack(sender: AnyObject){
        var controllers = self.navigationController?.viewControllers as [AnyObject]!
        
        for view in controllers{
            if view.isKindOfClass(RegisterViewController){
                self.navigationController?.popToViewController(view as! UIViewController, animated: true)
                break
            }
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == txtBirthdate{
            return true
        }
        
        textField.resignFirstResponder()
        
        let popupView: PopubViewController = PopubViewController(nibName: "PopubViewController", bundle: nil)
        popupView.parentView = self
        popupView.delegate = self
        switch (textField) {
            //  FIXME:prefix
        case txtCountry:
            popupView.mode = "Countries"
            break
            
            
            
        case txtMaleOrFemale:
            popupView.mode = "Gender"
            break
            
        case txtReligion:
            popupView.mode = "Religion"
            break
        case txtLanguages:
            popupView.mode = "Language"
            
        default: break
        }
        
        if (popupView.mode != "") {
            self.presentPopupViewController(popupView, animationType: MJPopupViewAnimationFade)
        }
        
        
        return false
    }
    func didEndSelection(arraySelections: [CodeValue], mode: String) {
        self.dismissPopupViewControllerWithanimationType(MJPopupViewAnimationFade)
        switch mode{
            //FIXME:prefix
        case "Countries":
            if let codeVal = (arraySelections as NSArray).objectAtIndex(0) as? CodeValue{
                self.userRegister.oCountry = codeVal
                
                if codeVal.iKeyId == -1 {
                    self.txtCountry.text = nil
                }else{
                    self.txtCountry.text = codeVal.nvValue
                }
            }
            break
        case "Gender":
            if let codeVal = (arraySelections as NSArray).objectAtIndex(0) as? CodeValue{
                self.userRegister.iGenderId = codeVal.iKeyId
                
                if codeVal.iKeyId == -1 {
                    self.txtMaleOrFemale.text = nil
                }else{
                    self.txtMaleOrFemale.text = codeVal.nvValue
                }
            }
            break
        case "Religion":
            if let codeVal = (arraySelections as NSArray).objectAtIndex(0) as? CodeValue{
                self.userRegister.iReligionId = codeVal.iKeyId
                
                if codeVal.iKeyId == -1 {
                    self.txtReligion.text = nil
                }else{
                    self.txtReligion.text = codeVal.nvValue
                }
            }
            break
        case "ReligionLevel":
            if let codeVal = (arraySelections as NSArray).objectAtIndex(0) as? CodeValue{
                self.userRegister.iReligiousLevelId = codeVal.iKeyId
                
                if codeVal.iKeyId == -1 {
                    //                    self.txtHowReligion.text = nil
                }else{
                    //                    self.txtHowReligion.text = codeVal.nvValue
                }
            }
            break
            
        default:
            break
        }
    }
    
    
    //    func toolBarItemClicked(sender: AnyObject){
    //        var dateFormatter = NSDateFormatter()
    //        dateFormatter.dateFormat = "dd/MM/yyyy"
    //        let dateStr = dateFormatter.stringFromDate(datePicker.date)
    //
    ////        var date = NSDate()
    //        let myDateString = String(Int64(datePicker.date.timeIntervalSince1970 * 1000))
    //        println("Seconds = \(myDateString)")
    //
    //
    //
    //        self.txtBirthdate.text = dateStr
    //        self.userRegister.dtBirthDate = ("/Date(\(myDateString))/")
    //        self.txtBirthdate.resignFirstResponder()
    //    }
    func toolBarItemClicked(sender: AnyObject){
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateStr = dateFormatter.stringFromDate(datePicker.date)
        self.txtBirthdate.text = dateStr
        self.userRegister.dtBirthDate = dateStr
        self.txtBirthdate.resignFirstResponder()
    }
    
    @IBAction func btnRegister(sender: AnyObject){
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        var generic = Generic()
        generic.showNativeActivityIndicator(self)
        self.userRegister.oCountry = ActiveUser.sharedInstace.oCountry
        
        var dicUser:NSDictionary=User.getUserDictionary (userRegister)
        println(dicUser.objectForKey("nvUserPassword"))
        
        var userDics:NSDictionary = ["newUser":User.getUserDictionary (self.userRegister)]
        println("userDics:\(userDics)")
        
        Connection.connectionToService("SetUser", params:userDics, completion: {data -> Void in
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("SetUser:\(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            var user: User = User()
            if let parseJSON = json {
                user = User.parseUserJson(JSON(parseJSON))
                if user.iUserId != 0 && user.iUserId != -1{
                    NSUserDefaults.standardUserDefaults().setObject(self.userRegister.oUserMemberShip.nvUserName, forKey: "userName")
                    NSUserDefaults.standardUserDefaults().setObject(self.userRegister.oUserMemberShip.nvUserPassword, forKey: "password")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    let pictureProfileView: ProfilePictureViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ProfilePictureViewControllerId") as! ProfilePictureViewController
                    pictureProfileView.user = user
                    self.navigationController!.pushViewController(pictureProfileView, animated: true)
                }else {
                    generic.hideNativeActivityIndicator(self)
                    var alert = UIAlertController(title:NSLocalizedString("Error", comment: "")  as String /*"שגיאה"*/, message: NSLocalizedString("Registration failed", comment: "")  as String/*"הרשמה נכשלה"*/, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title:NSLocalizedString("Confirmation", comment: "")  as String /*"אישור"*/, style: UIAlertActionStyle.Cancel, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
            }else{
                generic.hideNativeActivityIndicator(self)
                var alert = UIAlertController(title: NSLocalizedString("Error", comment: "")  as String/*"שגיאה"*/, message:NSLocalizedString("Registration failed", comment: "")  as String /*"הרשמה נכשלה"*/, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Confirmation", comment: "")  as String/*"אישור"*/, style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            generic.hideNativeActivityIndicator(self)
        })
    }
    //FIXME:9.11.15
    func didEndSelectionKey(arraySelections: [KeyValue], mode: String)
    {
        
        self.dismissPopupViewControllerWithanimationType(MJPopupViewAnimationFade)
        
        
        if arraySelections.count > 0{
            self.txtLanguages.text = ""
            self.userRegister.oLanguages.removeAllObjects()
            for (index,element) in enumerate(arraySelections) {
                //  var val = element.iKeyId
                if element.nvKey != "-1" {
                    self.userRegister.oLanguages.addObject(element)
                    self.txtLanguages.text = self.txtLanguages.text + element.nvValue + ", "
                }
            }
            
        }else{
            self.txtLanguages.text = nil
        }
    }
    
}

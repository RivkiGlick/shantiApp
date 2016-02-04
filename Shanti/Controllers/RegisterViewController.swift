//
//  RegisterViewController.swift
//  Shanti
//
//  Created by hodaya ohana on 1/15/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

class RegisterViewController:GlobalViewController,UITextFieldDelegate ,UIGestureRecognizerDelegate,PopupViewControllerDelegate
{
    @IBOutlet weak var lblPersonalDetails: UILabel!
    @IBOutlet weak var txtMail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet weak var scrollView_view: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtShantiName: UITextField!
    @IBOutlet weak var txtPrefix: UITextField!
    @IBOutlet weak var lblSpace: UILabel!
    @IBOutlet weak var txtViewTermsConditionsPrivacyPolicy: UITextView!
    @IBOutlet var textFieldToBottomLayoutGuideConstraint: NSLayoutConstraint!
    var loginWay = String()
    var loginWayNow = "-1"
    var userRegister:User = User()
    var prefix: PrefixViewController = PrefixViewController()
    
    var countriesArry: NSMutableArray = NSMutableArray()
    var languageArry: NSMutableArray = NSMutableArray()
    var religionsArry: NSMutableArray = NSMutableArray()
    var religionLevelArry: NSMutableArray = NSMutableArray()
    var ageRangeArry: NSMutableArray = NSMutableArray()
    var gendersArry: NSMutableArray = NSMutableArray()
    //FIXME: Prefix
    var countryPrefixArray: NSMutableArray = NSMutableArray()
    var ThreadFinished = false
    var PrefixId:String=String()
    var keyboardSize: CGRect!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var temp:Bool = true
    
override func viewWillLayoutSubviews() {
    if self.scrollView.frame.size.height > self.view.frame.size.height
    {
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,self.scrollView.frame.size.height + 180)
    }
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.addPageGraphics()
        self.setDelegates()
        var txtvalid: UITextField

        
        if let loginWay = NSUserDefaults.standardUserDefaults().valueForKey("loginWay") as? String
        {
            loginWayNow = (loginWay as? String)!
        }
//       loginWayNow = NSUserDefaults.standardUserDefaults().valueForKey("loginWay") as! String
            if loginWayNow == "faceBook" || loginWayNow == "google+"
//        if appDelegate.isGoogle == true || appDelegate.isFaceBook == true
        {
            txtName.text = ActiveUser.sharedInstace.nvFirstName
            txtLastName.text = ActiveUser.sharedInstace.nvLastName
            txtPassword.enabled = false
            txtMail.text = ActiveUser.sharedInstace.nvEmail
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "dismissControllers")
        //FIXME:prefix
        tapGesture.delegate = self
        
        self.view.addGestureRecognizer(tapGesture)
        
        keyboardSize = CGRectMake(0, UIScreen.mainScreen().bounds.size.height - 253, UIScreen.mainScreen().bounds.size.width, 253)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setKeyboardFrame:", name: UIKeyboardWillShowNotification, object: nil)
        self.txtPhone.keyboardType = UIKeyboardType.PhonePad
        self.txtPrefix.keyboardType = UIKeyboardType.PhonePad
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.dismissControllers()
    }
    
    func addPageGraphics(){
        
        //Signing up
        self.title = NSLocalizedString("Signing up", comment: "")  as String //"הרשמה"
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.rightBarButtonItem = nil
        lblPersonalDetails.text = NSLocalizedString("Personal details", comment: "")  as String // "פרטים אישיים"
        txtMail.placeholder =  NSLocalizedString("Email", comment: "") as String // "מייל"
        txtPassword.placeholder = NSLocalizedString("Password", comment: "")  as String //"סיסמה"
        txtName.placeholder = NSLocalizedString("First Name", comment: "")  as String // "שם פרטי"
        txtLastName.placeholder = NSLocalizedString("Last Name", comment: "")  as String // "שם משפחה"
        txtPhone.placeholder = NSLocalizedString("Mobile", comment: "")  as String // "נייד"
        btnContinue.setTitle(NSLocalizedString("Continued", comment: "")  as String, forState: UIControlState.Normal)
     
        
        
        var myString:NSString = NSLocalizedString("By signing up with shanty I agree to all the terms and conditions of the people, groups and their personal details, and privacy policy as specified in the Company's articles.", comment: "")  as String
        
        
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "Helvetica", size: 14.0)!])
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.purpleMedium(), range: NSMakeRange(0, myString.length))
        let languageId = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) as! String
        if languageId == "he"
        {
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSRange(location:80,length:17))
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSRange(location:29,length:16))
        }
        else
        {
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSRange(location:120,length:15))
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSRange(location:44,length:22))
        }
        self.txtViewTermsConditionsPrivacyPolicy.attributedText = myMutableString
        self.txtViewTermsConditionsPrivacyPolicy.sizeToFit()
        self.txtViewTermsConditionsPrivacyPolicy.editable = false
        
        let   tapGesture = UITapGestureRecognizer(target: self, action: "textTapped:")
        tapGesture.numberOfTapsRequired = 1
        self.txtViewTermsConditionsPrivacyPolicy.addGestureRecognizer(tapGesture)
        
        txtShantiName.placeholder =  NSLocalizedString("User name", comment: "")  as String // "שם משתמש"
        lblSpace.text = "-"
        
        txtPrefix.text = prefix.getPrefix()
        var str = prefix.getPrefixNum()
        
        let popupView: PopubViewController = PopubViewController(nibName: "PopubViewController", bundle: nil)
        popupView.countryPrefixArray = ApplicationData.sharedApplicationDataInstance.countryPrefixArray
        for  num in popupView.countryPrefixArray
        {
            if (num as! KeyValue).nvValueParam == str
            {
                ActiveUser.sharedInstace.oCountry.nvValue = (num as! KeyValue).nvValue
            }
        }
        
        lblPersonalDetails.sizeToFit()
        txtMail.sizeToFit()
        txtPassword.sizeToFit()
        txtName.sizeToFit()
        txtLastName.sizeToFit()
        txtPhone.sizeToFit()
        txtPrefix.sizeToFit()
        btnContinue.sizeToFit()
        txtShantiName.sizeToFit()
        lblSpace.sizeToFit()
        
        //colors
        lblPersonalDetails.textColor = UIColor(red: 191.0/255.0, green: 196.0/255.0, blue: 201.0/255.0, alpha: 1)
        lblSpace.textColor = lblPersonalDetails.textColor
        txtMail.textColor = UIColor(red: 128.0/255.0, green: 137.0/255.0, blue: 148.0/255.0, alpha: 1)
        txtPassword.textColor = UIColor(red: 128.0/255.0, green: 137.0/255.0, blue: 148.0/255.0, alpha: 1)
        txtName.textColor = UIColor(red: 128.0/255.0, green: 137.0/255.0, blue: 148.0/255.0, alpha: 1)
        txtLastName.textColor = UIColor(red: 128.0/255.0, green: 137.0/255.0, blue: 148.0/255.0, alpha: 1)
        txtPhone.textColor = UIColor(red: 128.0/255.0, green: 137.0/255.0, blue: 148.0/255.0, alpha: 1)
        txtPrefix.textColor = UIColor(red: 128.0/255.0, green: 137.0/255.0, blue: 148.0/255.0, alpha: 1)
        txtShantiName.textColor = UIColor(red: 128.0/255.0, green: 137.0/255.0, blue: 148.0/255.0, alpha: 1)
        
        btnContinue.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btnContinue.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        btnContinue.backgroundColor = UIColor(red: 176.0/255.0, green: 0.0/255.0, blue: 247.0/255.0, alpha: 0.8)
        
        btnContinue.sizeToFit()
        btnContinue.layer.cornerRadius = 3.0;
        
        //Shadows settings
        btnContinue.layer.shadowRadius = 1.0
        btnContinue.layer.shadowOffset = CGSizeMake(0, -1.0)
        btnContinue.layer.shadowColor = UIColor(red: 30/255.0, green: 10/255.0, blue: 40/255.0, alpha: 0.75).CGColor
        
        //textAlignment
        var space: CGFloat = 10
        var textAlignment: NSTextAlignment = .Left
//        let languageId = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) as! String
        if languageId == "he"{
            textAlignment = .Right
            space = -space
        }
        
        txtPhone.textAlignment = textAlignment
        txtPrefix.textAlignment = .Center
        txtPassword.textAlignment = textAlignment
        txtName.textAlignment = textAlignment
        txtLastName.textAlignment = textAlignment
        txtPassword.textAlignment = textAlignment
        txtMail.textAlignment = textAlignment
        txtShantiName.textAlignment = textAlignment
        lblPersonalDetails.textAlignment = textAlignment
        
        //make cornerRadius and location placeHolder to the UITextField
        for view in self.scrollView_view.subviews{
            if view.isKindOfClass(UITextField){
                view.layer.cornerRadius = 8
                if (view as! UIView) != txtPrefix{
                    view.layer.sublayerTransform = CATransform3DMakeTranslation(space,0,0)
                }
                
            }
        }
        
        
        //frames
        let txtsWidth = CGFloat(291.5)
        let txtsHight = CGFloat(46.0)
        let spaceFomeScreenEnd = CGFloat(65)
        let spaceBetweenLoginBtnToForgotPassBtn = CGFloat(11.5)
        let spaceBetweenTxtFields = CGFloat(11.5)
        let spaceBetweenPrefixToPhone = CGFloat(44)
        let prefixW = CGFloat(82)
        
        self.btnContinue.frame = CGRectMake((UIScreen.mainScreen().bounds.size.width - txtsWidth)/2, UIScreen.mainScreen().bounds.size.height - spaceFomeScreenEnd - txtsHight, txtsWidth, txtsHight)
        self.txtPrefix.frame = CGRectMake(self.btnContinue.frame.origin.x, self.btnContinue.frame.origin.y - spaceBetweenTxtFields - txtsHight, prefixW, txtsHight)
        let phonW = CGFloat((self.btnContinue.frame.origin.x + self.btnContinue.frame.size.width) - (self.txtPrefix.frame.origin.x + self.txtPrefix.frame.size.width + spaceBetweenPrefixToPhone))
        self.txtPhone.frame = CGRectMake(self.txtPrefix.frame.origin.x + self.txtPrefix.frame.size.width + spaceBetweenPrefixToPhone, self.txtPrefix.frame.origin.y, phonW, txtsHight)
        let calcX = self.txtPrefix.frame.origin.x + self.txtPrefix.frame.size.width
        
        let lblX = CGFloat(calcX + ((self.txtPhone.frame.origin.x) - (self.txtPrefix.frame.origin.x + self.txtPrefix.frame.size.width))/2)
        let lblY = CGFloat(self.txtPrefix.frame.origin.y + (txtsHight - self.lblSpace.frame.size.height)/2)
        self.lblSpace.frame = CGRectMake(lblX, lblY, self.lblSpace.frame.size.width, self.lblSpace.frame.size.height)
        self.txtLastName.frame = CGRectMake(self.btnContinue.frame.origin.x, self.txtPhone.frame.origin.y - spaceBetweenTxtFields - txtsHight , txtsWidth, txtsHight)
        self.txtName.frame = CGRectMake(self.btnContinue.frame.origin.x, self.txtLastName.frame.origin.y - spaceBetweenTxtFields - txtsHight, txtsWidth, txtsHight)
        self.txtPassword.frame = CGRectMake(self.btnContinue.frame.origin.x, self.txtName.frame.origin.y - spaceBetweenTxtFields - txtsHight, txtsWidth, txtsHight)
        self.txtShantiName.frame = CGRectMake(self.btnContinue.frame.origin.x,  self.txtPassword.frame.origin.y - spaceBetweenTxtFields - txtsHight , txtsWidth, txtsHight)
        self.txtMail.frame = CGRectMake(self.btnContinue.frame.origin.x,  self.txtShantiName.frame.origin.y - spaceBetweenTxtFields - txtsHight , txtsWidth, txtsHight)
        self.lblPersonalDetails.frame = CGRectMake(self.btnContinue.frame.origin.x,  self.txtMail.frame.origin.y - spaceBetweenTxtFields - self.lblPersonalDetails.frame.size.height, txtsWidth, self.lblPersonalDetails.frame.size.height)
       
        
    }
    
    func setDelegates(){
        self.txtMail.delegate = self
        self.txtPassword.delegate = self
        self.txtName.delegate = self
        self.txtLastName.delegate = self
        self.txtPhone.delegate = self
        self.txtShantiName.delegate = self
        self.txtPrefix.delegate = self
    }
    
    func dismissControllers()
    {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1)
        self.txtMail.resignFirstResponder()
        self.txtPassword.resignFirstResponder()
        self.txtName.resignFirstResponder()
        self.txtLastName.resignFirstResponder()
        self.txtPhone.resignFirstResponder()
        self.txtShantiName.resignFirstResponder()
        self.txtPrefix.resignFirstResponder()
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,self.scrollView.frame.size.height)
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        UIView.commitAnimations()
    }
    //FIXME:prefix 10.11
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
    //FIXME:prefix
    override func popBack(sender: AnyObject){
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    func keyboardWillHide(sender: NSNotification) {
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.textFieldToBottomLayoutGuideConstraint?.constant -= keyboardSize.height
        }
    }
    
    func setKeyboardFrame(notification: NSNotification){
        keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        
    }
    //FIXME:prefix
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.scrollView.frame = CGRectMake(0, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height)
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,self.scrollView.frame.size.height+150)
        
        if textField == txtPrefix{
            
            self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height)
            
            let popupView: PopubViewController = PopubViewController(nibName: "PopubViewController", bundle: nil)
            popupView.parentView = self
            popupView.delegate = self
            switch (textField) {
            case txtPrefix:
                popupView.mode = "countryPrefixArray"
                break
                
            default: break
            }
            
            if (popupView.mode != "") {
                self.presentPopupViewController(popupView, animationType: MJPopupViewAnimationFade)
            }
            return false
            
            
        }
        else
        {
            println(self.view.frame)
            if textField.frame.origin.y + textField.frame.size.height + self.view.frame.origin.y >= UIScreen.mainScreen().bounds.size.height - keyboardSize.height{
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(1)
                self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - (textField.frame.origin.y + textField.frame.size.height - (UIScreen.mainScreen().bounds.size.height - keyboardSize.height)) - 30, self.view.frame.size.width, self.view.frame.size.height)
                UIView.commitAnimations()
            }
            return true
        }
        
        
        
        
    }
    
    
    
    func didEndSelectionKey(arraySelections: [KeyValue], mode: String) {
        self.dismissPopupViewControllerWithanimationType(MJPopupViewAnimationFade)
        var codeVal1 = (arraySelections as NSArray).objectAtIndex(0) as? KeyValue
        if let codeVal = (arraySelections as NSArray).objectAtIndex(0) as? KeyValue
        {
            
            var i:Int=Int()
            ActiveUser.sharedInstace.oCountry.nvValue = codeVal.nvValue
            var stringNumber = codeVal.nvKey
            i = Int(stringNumber.toInt()!)
            ActiveUser.sharedInstace.oCountry.iKeyId = i as Int
            PrefixId=codeVal.nvValueParam
            self.txtPrefix.text = "+" + codeVal.nvValueParam
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,self.scrollView.frame.size.height)
        textField.resignFirstResponder()
        return true
    }
    
    func isValidEmail(testStr:String) -> Bool {
        println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        var emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluateWithObject(testStr)
        return result
    }    
    func isValidPhone(testStr:String) -> Bool {
        println("validate calendar: \(testStr)")
        let phoneRegEx = "^[0-9]{9}$"
        
        var phoneTest = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        let result = phoneTest.evaluateWithObject(testStr)
        return result
    }
    
    func isValidPassword(testStr:String) -> Bool {
        println("validate calendar: \(testStr)")
       // let passwordRegEx = "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8}$"
        let passwordRegEx = "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8}$"
        var PasswordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        let result = PasswordTest.evaluateWithObject(testStr)
        return result
    }

    
    func isValidPhonePrefix(testStr:String) -> Bool
    {
        if testStr.hasPrefix("0")
        {
            return false
        }
        else
        {
            return true
        }
    }
    //FIXME:prefix
    func checkRequiredFields() -> Bool
    {
        var whatToReturn = false
            if self.loginWayNow == "faceBook" || self.loginWayNow == "google+"
//
        {
            if self.checkByGooglPlus() == true
            {
                whatToReturn = true
                
            }
        }
        else
        {
            if txtPassword.text != nil && txtPassword.text != "" && txtPassword.text != " " &&
                isValidPassword(txtPassword.text) && txtMail.text != nil && txtMail.text != "" && txtMail.text != " " && isValidEmail(txtMail.text) && txtName.text != "" && txtLastName.text != "" && txtShantiName.text != nil && txtShantiName.text != "" && txtShantiName.text != " "
            {
                if txtPhone.text != nil && isValidPhone(txtPhone.text) && txtPhone.text != "" && txtPhone.text != " " && txtPrefix.text != nil && txtPrefix.text != "" && txtPrefix.text != " " && isValidPhonePrefix(txtPhone.text)
                {
                    whatToReturn = true
                }
                else{
                    whatToReturn = false
                }
                
            }
        }
        return whatToReturn
        
    }
    func checkByGooglPlus()->Bool
    {
        if txtMail.text != nil && txtMail.text != "" && txtMail.text != " "  && txtName.text != "" && isValidEmail(txtMail.text) && txtLastName.text != "" && txtShantiName.text != nil && txtShantiName.text != "" && txtShantiName.text != " "
        {
            self.temp = true
            if txtPhone.text != nil && isValidPhone(txtPhone.text) && txtPhone.text != "" && txtPhone.text != " " && txtPrefix.text != nil && txtPrefix.text != "" && txtPrefix.text != " " && isValidPhonePrefix(txtPhone.text)
            {
                self.temp = true
            }
            else
            {
                self.temp = false
            }
        }
        else
        {
            self.temp = false
        }
        
        return self.temp
    }
    
    @IBAction func continueToNextRegisterPage(sender: AnyObject) {
        
        if (self.checkRequiredFields()){
            Connection.connectionToService("CheckUserDetailsIsFree", params: ["nvShantiName":self.txtShantiName.text,"nvEmail":self.txtMail.text], completion: {
                data -> Void in
                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("CheckShantiNameIsFree:\(strData)")
                
                switch (strData!.integerValue){
                case 0:
                    self.nextPage()
                    break

                case -1:
                    self.txtShantiName.text = ""
                    var alert = UIAlertController(title: "", message: "bad request", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Confirmation", comment: ""), style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    break
                case 2:
                    self.txtShantiName.text = ""
                    var alert = UIAlertController(title: "", message: NSLocalizedString("Username recorded in the system", comment: "") as String, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title:NSLocalizedString("Confirmation", comment: ""), style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    break
                case 3:
                    self.txtMail.text = ""
                    var alert = UIAlertController(title: "", message:  NSLocalizedString("Email address recorded in the system", comment: "") as String, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Confirmation", comment: ""), style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    break
                case 4:
                    self.txtShantiName.text = ""
                    self.txtMail.text = ""//Username and Mail existed within the system, please select other values
                    var alert = UIAlertController(title: "", message:  NSLocalizedString("Username and Mail existed within the system, please select other values", comment: "") as String/*"שם משתמש ומייל קיימים במערכת,\nאנא בחר ערכים אחרים."*/, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Confirmation", comment: ""), style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    break
                default:
                    break
                }
            })
        }
        else
        {
            //            //FIXME:prefix
            var messageAlert: String?
            if !isValidPhone(txtPhone.text){
                messageAlert=NSLocalizedString("Please fill the mobile field nine digits!,Without prefix", comment: "") as String/*"אנא מלא את שדה הנייד בעשר ספרות בלבד!"*/
            }
            else if !isValidPhonePrefix(txtPhone.text){
                messageAlert=NSLocalizedString("Please select the mobile field without the prefix 0", comment: "") as String/*//"0 אנא מלא את שדה הנייד  ללא קידומת !"*/
            }
                
            else{
                if txtPassword.text == "" || txtShantiName.text == "" || txtMail.text == "" || txtPhone.text == ""
                {
                messageAlert=NSLocalizedString("Please select the mandatory fields: Email, Username, and Password, portable prefix", comment: "") as String/*"אנא מלא את שדות החובה: מייל, שם משתמש, סיסמה, נייד וקידומת"*/
                }
            }
            if isValidEmail(txtMail.text) == false{
                messageAlert = NSLocalizedString("Faulty email address", comment: "") as String
                
            }
                else if isValidPassword(txtPassword.text) == false
            {
                messageAlert = NSLocalizedString("Faulty password", comment: "") as String
            }
            else if txtName.text == "" || txtLastName.text == ""
            {
                messageAlert = NSLocalizedString("Please fill the first name and last name field", comment: "") as String

            }

        
//        var messageAlert: String?
//        if !isValidPhone(txtPhone.text){
//            messageAlert=NSLocalizedString("Please fill the mobile field nine digits!,Without prefix", comment: "") as String/*"אנא מלא את שדה הנייד בעשר ספרות בלבד!"*/
//        }else
//        {
//            if !isValidEmail(txtMail.text){
//                messageAlert = NSLocalizedString("Faulty email address", comment: "") as String
//                
//            }
//            else{
//            messageAlert=NSLocalizedString("Please select the mandatory fields: Email, Username, and Password, portable prefix", comment: "") as String/*"אנא מלא את שדות החובה: מייל, שם משתמש, סיסמה, נייד וקידומת"*/
//            }
//
            if messageAlert != "" && messageAlert != nil
            {
            var alert = UIAlertController(title: "", message: messageAlert, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Confirmation", comment: "") as String/*"אשור"*/, style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            }
        }


        }
    
    
    func textTapped(recognizer: UITapGestureRecognizer)
    {
        if let textView = recognizer.view as? UITextView
        {
            if let layoutManager = textView.layoutManager as? NSLayoutManager
            {
                var location: CGPoint = recognizer.locationInView(textView)
                location.x -= textView.textContainerInset.left
                location.y -= textView.textContainerInset.top
                
                var charIndex = layoutManager.characterIndexForPoint(location, inTextContainer: textView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
                
                if charIndex < textView.textStorage.length
                {
                    if charIndex > 44 && charIndex < 66
                    {
                        var termsAndConditionsViewController: TermsAndConditionsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TermsAndConditionsViewControllerId") as! TermsAndConditionsViewController
                        self.navigationController!.pushViewController(termsAndConditionsViewController, animated: true)
                    }
                    else
                        if charIndex > 120 && charIndex < 135
                        {
                            var privacyPolicyViewController: PrivacyPolicyViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PrivacyPolicyViewControllerId") as! PrivacyPolicyViewController
                            self.navigationController!.pushViewController(privacyPolicyViewController, animated: true)
                    }
                }
            }
        }
    }
   
    func nextPage(){
        if (/*self.isValidEmail(txtMail.text)*/true){
            self.userRegister.oUserMemberShip.nvUserName = (txtMail.text != nil ) ? txtMail.text : ""
            self.userRegister.oUserMemberShip.nvUserPassword = (txtPassword.text != nil ) ? txtPassword.text : ""
            self.userRegister.nvEmail = (txtMail.text != nil ) ? txtMail.text : ""
            self.userRegister.nvFirstName = (txtName.text != nil ) ?txtName.text : ""
            self.userRegister.nvLastName = (txtLastName.text != nil ) ?txtLastName.text : ""
            var s:String = PrefixId + txtPhone.text
            self.userRegister.nvPhone = (txtPhone.text != nil ) ? s : ""///*txtPrefix.text + txtPhone.text*/
            self.userRegister.nvShantiName = (txtShantiName.text != nil ) ?txtShantiName.text : ""
            self.userRegister.nvGoogleUserId = ActiveUser.sharedInstace.nvGoogleUserId as String
            self.userRegister.nvFacebookUserId = ActiveUser.sharedInstace.nvFacebookUserId as String
            var generic = Generic()
            
            Connection.connectionToService("SendVerificationCode", params: ["mobilePhone":self.txtPhone.text], completion: {
                data -> Void in
                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("SendVerificationCode:\(strData)")
                var err: NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
                generic.hideNativeActivityIndicator(self)
                if json != nil{
                    var keyVal = KeyValue.parsKeyValueDict(JSON(json!))
                    var verificationView: VerficationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("VerficationViewControllerId") as! VerficationViewController
                    verificationView.userRegister = self.userRegister
                    verificationView.verificationCode = keyVal.nvValue
                    self.navigationController!.pushViewController(verificationView, animated: true)
                    
                }
            })
        }
    }
    //FIXME:prefix
    func didEndSelection(arraySelections: [CodeValue], mode: String)
    {
        
    }
    
}

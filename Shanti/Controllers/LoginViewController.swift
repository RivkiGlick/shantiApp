 //
//  LoginViewController.swift
//  Shanti
//
//  Created by hodaya ohana on 1/15/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

class LoginViewController: GlobalViewController,UIGestureRecognizerDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
     @IBOutlet weak var lblTimer: UILabel!
    var countLoginTimes = 0
    var counter = 0
    var timer:NSTimer = NSTimer()

    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var alertTxtField: UITextField = UITextField()
    override func viewDidLoad() {
                self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        super.viewDidLoad()
         self.addPageGraphics()
        self.setText()

        let tapGesture = UITapGestureRecognizer(target: self, action: "dismissControllers")
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        txtPassword.delegate = self
        txtUserName.delegate = self
        txtUserName.text = (NSUserDefaults.standardUserDefaults().objectForKey("userName") != nil) ? NSUserDefaults.standardUserDefaults().objectForKey("userName") as! String : ""
        txtPassword.text = (NSUserDefaults.standardUserDefaults().objectForKey("password")  != nil) ? NSUserDefaults.standardUserDefaults().objectForKey("password") as! String : ""
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.txtUserName.resignFirstResponder()
        self.txtPassword.resignFirstResponder()
    }
    
    override func popBack(sender: AnyObject){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func addPageGraphics(){
        //textAlignment
        var space: CGFloat = 10
        var textAlignment: NSTextAlignment = .Left
        let languageId = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) as! String
        if languageId == "he"{
            textAlignment = .Right
            space = -space
        }
        txtUserName.textAlignment = textAlignment
        txtPassword.textAlignment = textAlignment
        txtPassword.secureTextEntry = true
       
        //cornerRadius and space in placeHolder
        for view in self.view.subviews{
            if view.isKindOfClass(UITextField){
                view.layer.cornerRadius = 8
                view.layer.sublayerTransform = CATransform3DMakeTranslation(space, 0, 0)
            }
            if view.isKindOfClass(UIButton){
                view.layer.cornerRadius = 3.0
            }
        }
        
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.rightBarButtonItem = nil
        self.title = NSLocalizedString("Login", comment: "") as String
        btnForgotPassword.setTitleColor(UIColor.grayMedium(), forState: UIControlState.Normal)
        btnForgotPassword.sizeToFit()
        
        //btnLogin settings
        btnLogin.backgroundColor = UIColor(red: 176.0/255.0, green: 0.0/255.0, blue: 247.0/255.0, alpha: 0.8)
        btnLogin.sizeToFit()

        btnLogin.layer.shadowOffset = CGSizeMake(0, -1.0)
        btnLogin.layer.shadowColor = UIColor(red: 30/255.0, green: 10/255.0, blue: 40/255.0, alpha: 0.75).CGColor
        
        
        
        
        //frames
        let txtsWidth = CGFloat(291.5)
        let txtsHight = CGFloat(46.0)
        let spaceFomeTop = CGFloat(80)
        let spaceFomeScreenEnd = CGFloat(251.5)
        let spaceBetweenLoginBtnToForgotPassBtn = CGFloat(36)
        let spaceBetweenTxtFields = CGFloat(11.5)
        let controllersX = CGFloat((UIScreen.mainScreen().bounds.size.width - txtsWidth)/2)
        
        let loginWay = NSUserDefaults.standardUserDefaults().valueForKey("loginWay") as? String
        
//        if appDelegate.isFaceBook || appDelegate.isGoogle
            if loginWay == "faceBook" || loginWay == "google+"
        {
            self.txtPassword.enabled = false
        }
    }
    
    func dismissControllers(){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1)
        
        self.txtUserName.resignFirstResponder()
        self.txtPassword.resignFirstResponder()
        
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        
        UIView.commitAnimations()
    }
    
    
    @IBAction func login(sender: AnyObject) {
        let loginWay = NSUserDefaults.standardUserDefaults().valueForKey("loginWay") as? String
       if loginWay == "google+"
//        if appDelegate.isGoogle
        {
            var generic = Generic()
            generic.showNativeActivityIndicator(self)
            NSUserDefaults.standardUserDefaults().setObject(txtUserName.text, forKey: "userName")
            NSUserDefaults.standardUserDefaults().setObject(txtPassword.text, forKey: "password")
            NSUserDefaults.standardUserDefaults().synchronize()
            Connection.connectionToService("LoginGoogle", params: ["id":GPPSignIn.sharedInstance().userID,"DeviceId":455], completion: {data -> Void in
                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Login:\(strData)")
                var err: NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
                if let parseJSON = json
                {
                    ActiveUser.setUser(User.parseUserJson(JSON(parseJSON)))
                    ActiveUser.sharedInstace.oLocation.iDriverId = ActiveUser.sharedInstace.iUserId
                    ActiveUser.sharedInstace.oUserMemberShip.nvUserName = self.txtUserName.text
                    ActiveUser.sharedInstace.oUserMemberShip.nvUserPassword = self.txtPassword.text
                    if (ActiveUser.sharedInstace.iUserId != -1 && ActiveUser.sharedInstace.iUserId != 0)
                    {
                        //MARK:ADD IN SYNCRONE CODE
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        appDelegate.timer=NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "update", userInfo: nil, repeats: true)
                        //FIXME1.11
                        var userDics:NSMutableDictionary = ["newUser":User.getUserDictionary(ActiveUser.sharedInstace)]
                        NSUserDefaults.standardUserDefaults().setValue(/*User.getUserDictionary(ActiveUser.sharedInstace)*/userDics, forKey: "user")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        ActiveUser.loginToQuickBloxWithCurrentUser()
                        ActiveUser.sendDeviceTokenToServer()
                    }
                        
                    else
                    {
                        self.countLoginTimes++
                        self.checkIfLoginMoreThanThreeTimes()
                    }
                    
                    
                }
                
            })
        }
        else
        if loginWay == "faceBook"
//            if appDelegate.isFaceBook
            {
                Connection.connectionToService("LoginFacebook", params: ["id":ActiveUser.sharedInstace.nvFacebookUserId,"DeviceId":455], completion: {data -> Void in
                    var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Login:\(strData)")
                    var err: NSError?
                    var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
                    if let parseJSON = json {
                        ActiveUser.setUser(User.parseUserJson(JSON(parseJSON)))
                        ActiveUser.sharedInstace.oLocation.iDriverId = ActiveUser.sharedInstace.iUserId
                        ActiveUser.sharedInstace.oUserMemberShip.nvUserName = self.txtUserName.text
                        ActiveUser.sharedInstace.oUserMemberShip.nvUserPassword = self.txtPassword.text
                        ActiveUser.sharedInstace.nvFacebookUserId = ActiveUser.sharedInstace.nvFacebookUserId as String
                        
                        if (ActiveUser.sharedInstace.iUserId != -1 && ActiveUser.sharedInstace.iUserId != 0)
                        {
                            //MARK:ADD IN SYNCRONE CODE
                            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                            appDelegate.timer=NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "update", userInfo: nil, repeats: true)
                            //FIXME1.11
                            var userDics:NSMutableDictionary = ["newUser":User.getUserDictionary(ActiveUser.sharedInstace)]
                            NSUserDefaults.standardUserDefaults().setValue(/*User.getUserDictionary(ActiveUser.sharedInstace)*/userDics, forKey: "user")
                            NSUserDefaults.standardUserDefaults().synchronize()
                            ActiveUser.loginToQuickBloxWithCurrentUser()
                            ActiveUser.sendDeviceTokenToServer()
                        }
                        else
                        {
                            self.countLoginTimes++
                            self.checkIfLoginMoreThanThreeTimes()
                        }
                        
                    }
                    
                })

        }
        else
        {
        if txtPassword.text == "" || txtUserName.text == ""
        {
            
            var alert = UIAlertController(title: "נא מלא שם וסיסמא", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "אישור", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        else
        {
        var generic = Generic()
        generic.showNativeActivityIndicator(self)
        NSUserDefaults.standardUserDefaults().setObject(txtUserName.text, forKey: "userName")
        NSUserDefaults.standardUserDefaults().setObject(txtPassword.text, forKey: "password")
        NSUserDefaults.standardUserDefaults().synchronize()
        Connection.connectionToService("Login", params: ["name":txtUserName.text,"id":txtPassword.text, "DeviceId":455 ], completion: {data -> Void in
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Login:\(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            if let parseJSON = json
            {
                ActiveUser.setUser(User.parseUserJson(JSON(parseJSON)))
                ActiveUser.sharedInstace.oLocation.iDriverId = ActiveUser.sharedInstace.iUserId
                ActiveUser.sharedInstace.oUserMemberShip.nvUserName = self.txtUserName.text
                ActiveUser.sharedInstace.oUserMemberShip.nvUserPassword = self.txtPassword.text
                if (ActiveUser.sharedInstace.iUserId != -1 && ActiveUser.sharedInstace.iUserId != 0)
                {
                //MARK:ADD IN SYNCRONE CODE
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.timer=NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "update", userInfo: nil, repeats: true)
                    //FIXME1.11
                    var userDics:NSMutableDictionary = ["newUser":User.getUserDictionary(ActiveUser.sharedInstace)]
                    NSUserDefaults.standardUserDefaults().setValue(/*User.getUserDictionary(ActiveUser.sharedInstace)*/userDics, forKey: "user")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    ActiveUser.loginToQuickBloxWithCurrentUser()
                    ActiveUser.sendDeviceTokenToServer()
                }
                else
                {
                    self.countLoginTimes++
                    self.checkIfLoginMoreThanThreeTimes()
                    generic.hideNativeActivityIndicator(self)
                    
                }
                
            }
        })
        }
        }
    }
    
    func checkIfLoginMoreThanThreeTimes()
    {
        if self.countLoginTimes > 2
        {
            var alert = UIAlertController(title: "", message: NSLocalizedString("You tried three times to enter the apps you have to wait 15 minutes", comment: "") as String, preferredStyle: UIAlertControllerStyle.Alert)
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateLoginTimes", userInfo: nil, repeats: true)
            alert.addAction(UIAlertAction(title:NSLocalizedString("Confirmation", comment: ""), style: UIAlertActionStyle.Cancel, handler: {
                action -> Void in
                
                println()
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            var alert = UIAlertController(title: "", message: NSLocalizedString("The entry details you typed are wrong", comment: "") as String, preferredStyle: UIAlertControllerStyle.Alert)
            self.txtPassword.text = ""
            alert.addAction(UIAlertAction(title:NSLocalizedString("Confirmation", comment: ""), style: UIAlertActionStyle.Cancel, handler: {
                action -> Void in
                
                println()
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func updateLoginTimes()
    {
        ++counter
        self.txtPassword.enabled = false
        self.txtUserName.enabled = false
        self.btnLogin.enabled = false
        self.btnForgotPassword.enabled = false
        
        self.lblTimer.text = "\(self.counter/60)"
        
        if counter > 899
        {
            self.timer.invalidate()
            self.txtPassword.enabled = true
            self.txtUserName.enabled = true
            self.btnLogin.enabled = true
            self.btnForgotPassword.enabled = true
            self.countLoginTimes = 0
            self.counter = 0
        }
    }

    
    func addTextField(textField: UITextField!){
        // add the text field and make the result global
        textField.placeholder = NSLocalizedString("Email", comment: "") as String//Email
        textField.textAlignment = NSTextAlignment.Center
        self.alertTxtField = textField
    }
    
    
    @IBAction func forgotPassword(sender: AnyObject) {
//        var alert = UIAlertController(title: "שכחת סיסמה?", message: "הכנס את כתובת המייל שאיתה נרשמת, ואנו נשלח אליך את הסיסמה.", preferredStyle: UIAlertControllerStyle.Alert)
        var alert = UIAlertController(title: "", message: String((NSLocalizedString("e-mail address you registered with", comment: "") as String)+" , "+(NSLocalizedString("The password will be sent to you by e-mail", comment: "") as String)), preferredStyle: UIAlertControllerStyle.Alert)
//Confirmation
        alert.addTextFieldWithConfigurationHandler(addTextField)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancellation", comment: "") as String, style: UIAlertActionStyle.Cancel, handler: nil))//ביטול
        alert.addAction(UIAlertAction(title:NSLocalizedString("Confirmation", comment: "") as String, style: UIAlertActionStyle.Default, handler:{ action in action.style
            if self.alertTxtField.text != "" && self.alertTxtField.text != " "{
                Connection.connectionToService("ForgotPassword", params: ["nvUserName":self.alertTxtField.text], completion: {
                    data -> Void in
                    var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("ForgotPassword:\(strData)")
                    
                  
                    
                })
            }
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    //MARK: NSLocalizedString Func

    func setText()
    {
        
        let writingDirection = UIApplication.sharedApplication().userInterfaceLayoutDirection
        
//        var localizedLoginOption = NSLocalizedString("Select one of the login options", comment: "")
//        var localizedLogin = NSLocalizedString("Login", comment: "")
//        var localizedSigningUp = NSLocalizedString("Signing up", comment: "")
       // lblTitle.text = localizedLoginOption as String
        
        self.btnLogin.setTitle(NSLocalizedString("Login", comment: "") as String, forState: UIControlState.Normal)
        self.btnLogin.setTitle(NSLocalizedString("Login", comment: "") as String, forState: UIControlState.Highlighted)
      
        self.btnForgotPassword.setTitle(NSLocalizedString("I forgot the password", comment: "") as String, forState: UIControlState.Normal)
        self.btnForgotPassword.setTitle(NSLocalizedString("I forgot the password", comment: "") as String, forState: UIControlState.Highlighted)
        
        //txt place holder
        self.txtUserName.placeholder=NSLocalizedString("Email", comment: "") as String
        self.txtPassword.placeholder=NSLocalizedString("Password", comment: "") as String

        
    }
    func update() {
        var generic = Generic()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.timerCount++
        println(" appDelegate.timerCount++:\(appDelegate.timerCount)")
        
        if appDelegate.isLoginQb
        {
            
            let mainPage: UsersListViewController = self.storyboard!.instantiateViewControllerWithIdentifier("UsersListViewControllerID") as! UsersListViewController
            
            //  let mainPage: MainPage = self.storyboard!.instantiateViewControllerWithIdentifier("MainPageId") as! MainPage
            self.navigationController!.pushViewController(mainPage, animated: true)
            generic.hideNativeActivityIndicator(self)
            appDelegate.timer.invalidate()
        }
        else
        {
            if   appDelegate.timerCount==1000
            {
                var alert = UIAlertController(title: "error", message: "login in quickblox failed", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "אישור", style: UIAlertActionStyle.Cancel, handler: {
                    action -> Void in
                    
                    println()
                }))
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
        }
        // Something cool
    }

}

//
//  ChooseLoginWayViewController.swift
//  Shanti
//
//  Created by hodaya ohana on 1/18/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit
import AddressBook
import MediaPlayer
import AssetsLibrary
import CoreLocation
import CoreMotion

class ChooseLoginWayViewController: UIViewController,FBSDKLoginButtonDelegate,GPPSignInDelegate
{
    
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    
    var googleSignIn: GPPSignIn!
    
    var mail:String = ""
    var name:String = ""
    var lastName:String = ""
    var phone:String = ""
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var userRegister : User = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBarHidden = true
        self.addPageGraphics()
        
        //        let loginView : FBSDKLoginButton = FBSDKLoginButton()
        //        self.view.addSubview(loginView)
        //        loginView.frame = self.btnFacebook.frame
        //        btnFacebook.setTitle("", forState: UIControlState.Normal)
        //        btnFacebook.setTitle("", forState: UIControlState.Highlighted)
        //        btnFacebook.backgroundColor = UIColor.red()
        //        btnFacebook.readPermissions = ["public_profile", "email", "user_friends"]
        //        btnFacebook.delegate = self
        
        googleSignIn = GPPSignIn.sharedInstance()
        googleSignIn.shouldFetchGooglePlusUser = true
        googleSignIn.clientID = "103304875729-q7gf65fvh880lvhg8s3asaqpsmgb4v7l.apps.googleusercontent.com"
        
        googleSignIn.shouldFetchGoogleUserEmail = true
        googleSignIn.shouldFetchGoogleUserID = true
        googleSignIn.scopes = [kGTLAuthScopePlusLogin]
        googleSignIn.delegate = self
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setText()
    {
        
        let writingDirection = UIApplication.sharedApplication().userInterfaceLayoutDirection
        
        var localizedLoginOption = NSLocalizedString("Select one of the login options", comment: "")
        var localizedLogin = NSLocalizedString("Login", comment: "")
        var localizedSigningUp = NSLocalizedString("Signing up", comment: "")
        lblTitle.text = localizedLoginOption as String
        
        btnLogin.setTitle(localizedLogin as String, forState: UIControlState.Normal)
        btnLogin.setTitle(localizedLogin as String, forState: UIControlState.Highlighted)
        
        btnSignup.setTitle(localizedSigningUp as String, forState: UIControlState.Normal)
        btnSignup.setTitle(localizedSigningUp as String, forState: UIControlState.Highlighted)
        
    }
    
    func addPageGraphics(){
        
        //text
        self.setText()
        
        lblTitle.textColor = UIColor(red: 191.0/255.0, green: 196.0/255.0, blue: 201.0/255.0, alpha: 1)
        lblVersion.text = NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as String) as? String
        
        
        //Radius
        btnLogin.layer.cornerRadius = 3.0
        btnSignup.layer.cornerRadius = 3.0
        btnFacebook.layer.cornerRadius = 3.0
        btnGoogle.layer.cornerRadius = 3.0
        
        //Border
        btnLogin.layer.borderWidth = 1.0
        btnLogin.layer.borderColor = UIColor.purpleMedium().CGColor
        btnSignup.layer.borderWidth = 1.0
        btnSignup.layer.borderColor = UIColor.purpleMedium().CGColor
        
        //Shadows settings
        btnFacebook.layer.shadowRadius = 1.0
        btnFacebook.layer.shadowOffset = CGSizeMake(0, -1.0)
        btnFacebook.layer.shadowColor = UIColor(red: 30/255.0, green: 10/255.0, blue: 40/255.0, alpha: 0.75).CGColor
        
        btnGoogle.layer.shadowRadius = 1.0
        btnGoogle.layer.shadowOffset = CGSizeMake(0, -1.0)
        btnGoogle.layer.shadowColor = UIColor(red: 30/255.0, green: 10/255.0, blue: 40/255.0, alpha: 0.75).CGColor
        
        btnLogin.addTarget(self, action: "BtnsBorderColorOnRelease:", forControlEvents: UIControlEvents.TouchDown)
        btnLogin.addTarget(self, action: "BtnsBorderColorOnTouchUpInside:", forControlEvents: UIControlEvents.TouchUpInside)
        btnSignup.addTarget(self, action: "BtnsBorderColorOnRelease:", forControlEvents: UIControlEvents.TouchDown)
        btnSignup.addTarget(self, action: "BtnsBorderColorOnTouchUpInside:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //Frames
        let bigBtnsWidth = CGFloat(291.5)
        let littleBtnsWidth = CGFloat(140.0)
        let btnsHeight = CGFloat(39.0)
        let spaceFomeScreenEnd = CGFloat(115.0)
        let spaceBetweenBtns = CGFloat(15.0)
        let imgLogoSize = CGSizeMake(imgLogo.image!.size.width/2, imgLogo.image!.size.height/2)
        
        
        
        
    }
    
    func BtnsBorderColorOnRelease(sender: AnyObject){ //Touch Down action
        if let presedBtn = sender as? UIButton{
            presedBtn.layer.borderColor = UIColor.grayMedium().CGColor
        }
    }
    
    func BtnsBorderColorOnTouchUpInside(sender: AnyObject){ //Touch Down action
        if let presedBtn = sender as? UIButton{
            presedBtn.layer.borderColor = UIColor.purpleMedium().CGColor
        }
    }
    
    @IBAction func btnGoogleClick(sender: AnyObject)
    {
        NSUserDefaults.standardUserDefaults().setObject("google+", forKey: "loginWay")
        NSUserDefaults.standardUserDefaults().synchronize()
        //        appDelegate.isGoogle = true
        googleSignIn.authenticate()
        
    }
    
    @IBAction func btnLoginWithFacebookClick(sender: AnyObject)
    {
        NSUserDefaults.standardUserDefaults().setObject("faceBook", forKey: "loginWay")
        NSUserDefaults.standardUserDefaults().synchronize()
        //        appDelegate.isFaceBook = true
        var fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager .logInWithReadPermissions(["email"], handler: { (result, error) -> Void in
            if (error == nil){
                var fbloginresult : FBSDKLoginManagerLoginResult = result
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                    fbLoginManager.logOut()
                }
            }
        })
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil)
                {
                    println(result)
                    self.returnUserData(result as! NSDictionary)
                }
            })
        }
    }
    // Facebook Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if ((error) == nil)
        {
            print("User complete")
            appDelegate.isFaceBook = true
            //            self.returnUserData()
        }
    }
    
    func returnUserData(result: NSDictionary)
    {
        
        //                self.appDelegate.isFaceBook = true
        print("fetched user: \(result)")
        let userFirstName : NSString = result.valueForKey("first_name") as! NSString
        print("User First Name is: \(userFirstName)")
        let userLastName : NSString = result.valueForKey("last_name") as! NSString
        print("User last Name is: \(userLastName)")
        let userEmail : NSString = result.valueForKey("email") as! NSString
        print("User Email is: \(userEmail)")
        let facebookID:NSString = result.valueForKey("id") as! NSString
        let pictureURL = "https://graph.facebook.com/\(facebookID)/picture?type=large&return_ssl_resources=1"
        let url = NSURL(string: pictureURL)
        let data = NSData(contentsOfURL: url!)
        
        self.name = userFirstName as String
        self.lastName = userLastName as String
        self.mail = userEmail as String
        ActiveUser.sharedInstace.nvFacebookUserId = facebookID as String
        NSUserDefaults.standardUserDefaults().setObject(ActiveUser.sharedInstace.nvFacebookUserId, forKey: "id")
        NSUserDefaults.standardUserDefaults().setObject("faceBook", forKey: "loginWay")
        NSUserDefaults.standardUserDefaults().synchronize()
        Connection.connectionToService("LoginFacebook", params: ["id":ActiveUser.sharedInstace.nvFacebookUserId], completion: {data -> Void in
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Login:\(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            self.userRegister.nvFacebookUserId = ActiveUser.sharedInstace.nvFacebookUserId
            ActiveUser.sharedInstace.nvFacebookUserId = ActiveUser.sharedInstace.nvFacebookUserId
            if let parseJSON = json {
                ActiveUser.setUser(User.parseUserJson(JSON(parseJSON)))
                ActiveUser.sharedInstace.oLocation.iDriverId = ActiveUser.sharedInstace.iUserId
                ActiveUser.sharedInstace.nvLastName = self.lastName
                ActiveUser.sharedInstace.nvFirstName = self.name
                ActiveUser.sharedInstace.nvEmail = self.mail
                ActiveUser.sharedInstace.nvFacebookUserId = ActiveUser.sharedInstace.nvFacebookUserId as String
                
                
                if (ActiveUser.sharedInstace.iUserId == -1 && ActiveUser.sharedInstace.iUserId != 0)
                {
                    Connection.connectionToService("CheckUserDetailsIsFree", params: ["nvShantiName":"","nvEmail":self.mail], completion: {
                        data -> Void in
                        var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                        println("CheckShantiNameIsFree:\(strData)")
                        
                        if strData!.integerValue != 3 && strData!.integerValue != 4
                        {
                            //
                            let register: RegisterViewController = self.storyboard!.instantiateViewControllerWithIdentifier("RegisterViewControllerId") as! RegisterViewController
                            self.navigationController?.pushViewController(register, animated: true)
                        }
                        else
                        {
                            if strData!.integerValue == 4
                            {
                                Connection.connectionToService("updateFacebookId", params: ["nvUserName":self.mail,"nvGoogleId":ActiveUser.sharedInstace.nvFacebookUserId], completion: {
                                    data -> Void in
                                    var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                                    println("CheckShantiNameIsFree:\(strData)")
                                    
                                    let  userlist:UsersListViewController = self.storyboard!.instantiateViewControllerWithIdentifier("UsersListViewControllerID") as! UsersListViewController
                                    self.navigationController?.pushViewController(userlist, animated: true)
                                })
                            }
                        }
                    })
                    
                    var userDics:NSMutableDictionary = ["newUser":User.getUserDictionary(ActiveUser.sharedInstace)]
                    NSUserDefaults.standardUserDefaults().setValue(/*User.getUserDictionary(ActiveUser.sharedInstace)*/userDics, forKey: "user")
                    NSUserDefaults.standardUserDefaults().synchronize()
                }
                else
                {
                    if ActiveUser.sharedInstace.iUserId > 0
                    {
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        appDelegate.timer=NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "update", userInfo: nil, repeats: true)
                        //FIXME1.11
                        var userDics:NSMutableDictionary = ["newUser":User.getUserDictionary(ActiveUser.sharedInstace)]
                        NSUserDefaults.standardUserDefaults().setValue(/*User.getUserDictionary(ActiveUser.sharedInstace)*/userDics, forKey: "user")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        
                        ActiveUser.loginToQuickBloxWithCurrentUser()
                        ActiveUser.sendDeviceTokenToServer()
                    }
                }
            }
            
        })
        
    }
    //        })
    //    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User Logged Out")
    }
    
    
    // GooglePlush Delegate Methods
    
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        
        //        self.appDelegate.isGoogle = true
        print("received auth \(auth), error \(error)")
        
        if (GPPSignIn.sharedInstance().userID != nil) {
            
            let user = GPPSignIn.sharedInstance().googlePlusUser
            println("user name: " + user.name.JSONString() + "\nemail: ")
            self.name = user.name.givenName as String
            self.lastName = user.name.familyName as String
            self.mail =  googleSignIn.userEmail as String
            if (user.emails != nil){
                print(user.emails.first?.JSONString() ?? "no email")
                
            } else {
                print("no email")
            }
        } else {
            println("User ID is nil")
        }
        NSUserDefaults.standardUserDefaults().setObject("google+", forKey: "loginWay")
        NSUserDefaults.standardUserDefaults().setObject(GPPSignIn.sharedInstance().userID, forKey: "id")
        NSUserDefaults.standardUserDefaults().synchronize()
        Connection.connectionToService("LoginGoogle", params: ["id":GPPSignIn.sharedInstance().userID], completion: {data -> Void in
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Login:\(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            //            var user:User = User()
            self.userRegister.nvGoogleUserId = GPPSignIn.sharedInstance().userID
            ActiveUser.sharedInstace.nvGoogleUserId = GPPSignIn.sharedInstance().userID
            if let parseJSON = json {
                ActiveUser.setUser(User.parseUserJson(JSON(parseJSON)))
                ActiveUser.sharedInstace.oLocation.iDriverId = ActiveUser.sharedInstace.iUserId
                ActiveUser.sharedInstace.nvLastName = self.lastName
                ActiveUser.sharedInstace.nvFirstName = self.name
                ActiveUser.sharedInstace.nvEmail = self.mail
                ActiveUser.sharedInstace.nvGoogleUserId = GPPSignIn.sharedInstance().userID as String
                
                
                if (ActiveUser.sharedInstace.iUserId == -1 && ActiveUser.sharedInstace.iUserId != 0)
                {
                    Connection.connectionToService("CheckUserDetailsIsFree", params: ["nvShantiName":"","nvEmail":self.mail], completion: {
                        data -> Void in
                        var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                        println("CheckShantiNameIsFree:\(strData)")
                        
                        if strData!.integerValue != 3 && strData!.integerValue != 4
                        {
                            //
                            let register: RegisterViewController = self.storyboard!.instantiateViewControllerWithIdentifier("RegisterViewControllerId") as! RegisterViewController
                            self.navigationController?.pushViewController(register, animated: true)
                        }
                        else
                        {
                            if strData!.integerValue == 4
                            {
                                Connection.connectionToService("updateGoogleId", params: ["nvUserName":self.mail,"nvGoogleId":GPPSignIn.sharedInstance().userID], completion: {
                                    data -> Void in
                                    var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                                    println("CheckShantiNameIsFree:\(strData)")
                                    
                                    let  userlist:UsersListViewController = self.storyboard!.instantiateViewControllerWithIdentifier("UsersListViewControllerID") as! UsersListViewController
                                    self.navigationController?.pushViewController(userlist, animated: true)
                                })
                            }
                        }
                    })
                    
                    var userDics:NSMutableDictionary = ["newUser":User.getUserDictionary(ActiveUser.sharedInstace)]
                    NSUserDefaults.standardUserDefaults().setValue(/*User.getUserDictionary(ActiveUser.sharedInstace)*/userDics, forKey: "user")
                    NSUserDefaults.standardUserDefaults().synchronize()
                }
                else
                {
                    if ActiveUser.sharedInstace.iUserId > 0
                    {
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        appDelegate.timer=NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "update", userInfo: nil, repeats: true)
                        //FIXME1.11
                        var userDics:NSMutableDictionary = ["newUser":User.getUserDictionary(ActiveUser.sharedInstace)]
                        NSUserDefaults.standardUserDefaults().setValue(/*User.getUserDictionary(ActiveUser.sharedInstace)*/userDics, forKey: "user")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        
                        ActiveUser.loginToQuickBloxWithCurrentUser()
                        ActiveUser.sendDeviceTokenToServer()
                        
                    }
                    
                }
                
            }
            
        })
        
        
    }
    
    func update() {
        var generic = Generic()
        
        appDelegate.timerCount++
        println(" appDelegate.timerCount++:\(appDelegate.timerCount)")
        
        if appDelegate.isLoginQb
        {
            NSUserDefaults.standardUserDefaults().setObject(self.mail, forKey: "userName")
            //            NSUserDefaults.standardUserDefaults().setObject(txtPassword.text, forKey: "password")
            NSUserDefaults.standardUserDefaults().synchronize()
            let mainPage: UsersListViewController = self.storyboard!.instantiateViewControllerWithIdentifier("UsersListViewControllerID") as! UsersListViewController
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

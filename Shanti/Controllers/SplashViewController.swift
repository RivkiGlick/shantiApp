//
//  SplashViewController.swift
//  Shanti
//
//  Created by hodaya ohana on 3/19/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    var cameFromNotification: Bool = false
    var userInfo: [NSObject : AnyObject]?
    var generic: Generic?
    var check = Bool()
    
    @IBOutlet weak var viewImgLogoLandscape: UIView!
    var frontNavigationController: UINavigationController!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.login()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillLayoutSubviews() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    func rotated()
    {
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
        {
            check = true
            print("landscape")
            self.view.addSubview(viewImgLogoLandscape)
            
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
        {
            print("Portrait")
            if check
            {
            self.view.sendSubviewToBack(viewImgLogoLandscape)
            }
        }
        
    }

    
    func getNavigationController(){
        var rearViewController = RearViewController()
        var rearNavigationController = UINavigationController(rootViewController: rearViewController)
        
        var revealController = SWRevealViewController()
        
        revealController.frontViewController = frontNavigationController
        revealController.rightViewController = rearNavigationController
        
        var wind: UIWindow = UIApplication.sharedApplication().windows[0] as! UIWindow
        wind.rootViewController = revealController
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if  !appDelegate.FiilData
        {
            //initialize the code tables
            ApplicationData.sharedApplicationDataInstance.getNeededTablesFromServer()
            appDelegate.FiilData = true
            
        }
        
    }
    func login()
    {
    var userIdNow = "-1"
        if let userId = NSUserDefaults.standardUserDefaults().valueForKey("id") as? String
        {
            userIdNow = userId
        }
        
        var loginWayNow = "-1"
        if let loginWay = NSUserDefaults.standardUserDefaults().valueForKey("loginWay") as? String
        {
            loginWayNow = loginWay
        }
        
        if loginWayNow == "faceBook"
        {
            if let userDict = NSUserDefaults.standardUserDefaults().valueForKey("user") as? NSDictionary
            {
                
                if let currUserDict = userDict["newUser"] as? NSDictionary
                {
                    
                    var currUser = User.parseUserJson(JSON(currUserDict))
                    Connection.connectionToService("LoginFacebook", params: ["id":userIdNow], completion: {data -> Void in
                        var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                        println("Login:\(strData)")
                        var err: NSError?
                        var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
                        if let parseJSON = json
                        {
                            ActiveUser.setUser(User.parseUserJson(JSON(parseJSON)))
                            ActiveUser.sharedInstace.oLocation.iDriverId = ActiveUser.sharedInstace.iUserId
                            ActiveUser.sharedInstace.oUserMemberShip.nvUserName = currUser.oUserMemberShip.nvUserName
                            ActiveUser.sharedInstace.oUserMemberShip.nvUserPassword = currUser.oUserMemberShip.nvUserPassword
                            if (ActiveUser.sharedInstace.iUserId != -1 && ActiveUser.sharedInstace.iUserId != 0)
                            {
                                //FIXME:add class new user4.11.15
                                var userDics:NSDictionary = ["newUser":User.getUserDictionary (ActiveUser.sharedInstace)]
                                println("userDics:\(userDics)")
                                NSUserDefaults.standardUserDefaults().setValue(userDics, forKey: "user")
                                NSUserDefaults.standardUserDefaults().synchronize()
                                
                                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                                if appDelegate.isLoginQb==false
                                {
                                    //fixme7.11
                                    let mainPage: UsersListViewController = self.storyboard!.instantiateViewControllerWithIdentifier("UsersListViewControllerID") as! UsersListViewController
                                    self.frontNavigationController = UINavigationController(rootViewController: mainPage)
                                    
                                    if self.cameFromNotification && self.userInfo != nil
                                    {
                                    }
                                }
                                else
                                {
                                    ActiveUser.sendDeviceTokenToServer()
                                    let loginOptionView: ChooseLoginWayViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ChooseLoginWayViewControllerId") as! ChooseLoginWayViewController
                                    
                                    let mainPage: UsersListViewController = self.storyboard!.instantiateViewControllerWithIdentifier("UsersListViewControllerID") as! UsersListViewController
                                    
                                    if self.cameFromNotification && self.userInfo != nil{
                                    }
                                    
                                    self.frontNavigationController = UINavigationController(rootViewController: loginOptionView)
                                    self.frontNavigationController.pushViewController(mainPage, animated: true)
                                }
                                
                            }
                            else
                            {
                                let loginOptionView: ChooseLoginWayViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ChooseLoginWayViewControllerId") as! ChooseLoginWayViewController
                                self.frontNavigationController = UINavigationController(rootViewController: loginOptionView)
                            }
                            
                        }
                        else
                        {
                            let loginOptionView: ChooseLoginWayViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ChooseLoginWayViewControllerId") as! ChooseLoginWayViewController
                            self.frontNavigationController = UINavigationController(rootViewController: loginOptionView)
                        }
                        self.getNavigationController()
                        
                    })
                }
                else
                {
                    let loginOptionView: ChooseLoginWayViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ChooseLoginWayViewControllerId") as! ChooseLoginWayViewController
                    self.frontNavigationController = UINavigationController(rootViewController: loginOptionView)
                    self.getNavigationController()
                    
                }
                
            }
            else
            {
                let loginOptionView: ChooseLoginWayViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ChooseLoginWayViewControllerId") as! ChooseLoginWayViewController
                frontNavigationController = UINavigationController(rootViewController: loginOptionView)
                self.getNavigationController()
            }
        }
else
        {
        if loginWayNow == "google+"
        {
            if let userDict = NSUserDefaults.standardUserDefaults().valueForKey("user") as? NSDictionary
            {
                
                if let currUserDict = userDict["newUser"] as? NSDictionary
                {
                    
                    var currUser = User.parseUserJson(JSON(currUserDict))
                    Connection.connectionToService("LoginGoogle", params: ["id":userIdNow], completion: {data -> Void in
                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Login:\(strData)")
                var err: NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
                if let parseJSON = json
                {
                    ActiveUser.setUser(User.parseUserJson(JSON(parseJSON)))
                    ActiveUser.sharedInstace.oLocation.iDriverId = ActiveUser.sharedInstace.iUserId
                    ActiveUser.sharedInstace.oUserMemberShip.nvUserName = currUser.oUserMemberShip.nvUserName
                    ActiveUser.sharedInstace.oUserMemberShip.nvUserPassword = currUser.oUserMemberShip.nvUserPassword
                    if (ActiveUser.sharedInstace.iUserId != -1 && ActiveUser.sharedInstace.iUserId != 0)
                    {
                        //FIXME:add class new user4.11.15
                        var userDics:NSDictionary = ["newUser":User.getUserDictionary (ActiveUser.sharedInstace)]
                        println("userDics:\(userDics)")
                        NSUserDefaults.standardUserDefaults().setValue(userDics, forKey: "user")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        if appDelegate.isLoginQb==false
                        {
                            //fixme7.11
                            let mainPage: UsersListViewController = self.storyboard!.instantiateViewControllerWithIdentifier("UsersListViewControllerID") as! UsersListViewController
                            self.frontNavigationController = UINavigationController(rootViewController: mainPage)
                            
                            if self.cameFromNotification && self.userInfo != nil
                            {
                            }
                        }
                        else
                        {
                            ActiveUser.sendDeviceTokenToServer()
                            let loginOptionView: ChooseLoginWayViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ChooseLoginWayViewControllerId") as! ChooseLoginWayViewController
                            
                            let mainPage: UsersListViewController = self.storyboard!.instantiateViewControllerWithIdentifier("UsersListViewControllerID") as! UsersListViewController
                            
                            if self.cameFromNotification && self.userInfo != nil{
                            }
                            
                            self.frontNavigationController = UINavigationController(rootViewController: loginOptionView)
                            self.frontNavigationController.pushViewController(mainPage, animated: true)
                        }
                        
                    }
                    else
                    {
                        let loginOptionView: ChooseLoginWayViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ChooseLoginWayViewControllerId") as! ChooseLoginWayViewController
                        self.frontNavigationController = UINavigationController(rootViewController: loginOptionView)
                    }
                
                }
                else
                {
                    let loginOptionView: ChooseLoginWayViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ChooseLoginWayViewControllerId") as! ChooseLoginWayViewController
                    self.frontNavigationController = UINavigationController(rootViewController: loginOptionView)
                    }
                    self.getNavigationController()
                
            })
                }
                else
                {
                    let loginOptionView: ChooseLoginWayViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ChooseLoginWayViewControllerId") as! ChooseLoginWayViewController
                    self.frontNavigationController = UINavigationController(rootViewController: loginOptionView)
                    self.getNavigationController()
                    
                }

            }
            else
            {
                let loginOptionView: ChooseLoginWayViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ChooseLoginWayViewControllerId") as! ChooseLoginWayViewController
                frontNavigationController = UINavigationController(rootViewController: loginOptionView)
                self.getNavigationController()
            }
        }
        else
        {
        if let userDict = NSUserDefaults.standardUserDefaults().valueForKey("user") as? NSDictionary
        {
            
            if let currUserDict = userDict["newUser"] as? NSDictionary
            {
                
                var currUser = User.parseUserJson(JSON(currUserDict))
                Connection.connectionToService("Login", params: ["name":currUser.oUserMemberShip.nvUserName,"id":currUser.oUserMemberShip.nvUserPassword], completion: {data -> Void in
                    var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Login:\(strData)")
                    var err: NSError?
                    var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
                    if let parseJSON = json
                    {
                        ActiveUser.setUser(User.parseUserJson(JSON(parseJSON)))
                        ActiveUser.sharedInstace.oLocation.iDriverId = ActiveUser.sharedInstace.iUserId
                        ActiveUser.sharedInstace.oUserMemberShip.nvUserName = currUser.oUserMemberShip.nvUserName
                        ActiveUser.sharedInstace.oUserMemberShip.nvUserPassword = currUser.oUserMemberShip.nvUserPassword
                        
                        if (ActiveUser.sharedInstace.iUserId != -1 && ActiveUser.sharedInstace.iUserId != 0)
                        {
                            //FIXME:add class new user4.11.15
                            var userDics:NSDictionary = ["newUser":User.getUserDictionary (ActiveUser.sharedInstace)]
                            println("userDics:\(userDics)")
                            NSUserDefaults.standardUserDefaults().setValue(userDics, forKey: "user")
                            NSUserDefaults.standardUserDefaults().synchronize()
                            
                            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                            if appDelegate.isLoginQb==false
                            {
                                //fixme7.11
                                let mainPage: UsersListViewController = self.storyboard!.instantiateViewControllerWithIdentifier("UsersListViewControllerID") as! UsersListViewController
                                self.frontNavigationController = UINavigationController(rootViewController: mainPage)
                                
                                if self.cameFromNotification && self.userInfo != nil
                                {
                                }
                            }
                            else
                            {
                                ActiveUser.sendDeviceTokenToServer()
                                let loginOptionView: ChooseLoginWayViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ChooseLoginWayViewControllerId") as! ChooseLoginWayViewController
                                
                                let mainPage: UsersListViewController = self.storyboard!.instantiateViewControllerWithIdentifier("UsersListViewControllerID") as! UsersListViewController
                                
                                if self.cameFromNotification && self.userInfo != nil{
                                }
                                
                                self.frontNavigationController = UINavigationController(rootViewController: loginOptionView)
                                self.frontNavigationController.pushViewController(mainPage, animated: true)
                            }
                            
                        }
                        else
                        {
                            let loginOptionView: ChooseLoginWayViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ChooseLoginWayViewControllerId") as! ChooseLoginWayViewController
                            self.frontNavigationController = UINavigationController(rootViewController: loginOptionView)
                        }
                    }
                    else
                    {
                        let loginOptionView: ChooseLoginWayViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ChooseLoginWayViewControllerId") as! ChooseLoginWayViewController
                        self.frontNavigationController = UINavigationController(rootViewController: loginOptionView)
                    }
                    self.getNavigationController()
                })
            }
            else
            {
                let loginOptionView: ChooseLoginWayViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ChooseLoginWayViewControllerId") as! ChooseLoginWayViewController
                self.frontNavigationController = UINavigationController(rootViewController: loginOptionView)
                self.getNavigationController()
                
            }
        }
        else
        {
            let loginOptionView: ChooseLoginWayViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ChooseLoginWayViewControllerId") as! ChooseLoginWayViewController
            frontNavigationController = UINavigationController(rootViewController: loginOptionView)
            self.getNavigationController()
        }
        }
        }
        
    }
    func update() {
        var generic = Generic()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.timerCount++
        println(" appDelegate.timerCount++:\(appDelegate.timerCount)")
        
        if appDelegate.isLoginQb
        {
            let mainPage: UsersListViewController = self.storyboard!.instantiateViewControllerWithIdentifier("UsersListViewControllerID") as! UsersListViewController
            frontNavigationController = UINavigationController(rootViewController: mainPage)
            self.getNavigationController()
            generic.hideNativeActivityIndicator(self)
            appDelegate.timer.invalidate()
        }
        else
        {
            if   appDelegate.timerCount==40
            {
                var alert = UIAlertController(title: "error", message: "login in quickblox failed", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "אישור", style: UIAlertActionStyle.Cancel, handler: {
                    action -> Void in
                    
                    println()
                }))
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
        }
    }
}

//
//  NavigationController.swift
//  Shanti
//
//  Created by hodaya ohana on 2/18/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    var cameFromNotification: Bool = false
    var userInfo: [NSObject : AnyObject]?
    var generic: Generic?
    
    var frontNavigationController: UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let splash: SplashViewController = self.storyboard!.instantiateViewControllerWithIdentifier("SplashViewControllerId") as! SplashViewController
        var wind: UIWindow = UIApplication.sharedApplication().windows[0] as! UIWindow
        wind.rootViewController = splash
//        self.getNavigationController()
//        self.login()

//        let splash: SplashViewController = self.storyboard!.instantiateViewControllerWithIdentifier("SplashViewControllerId") as! SplashViewController
//        var wind: UIWindow = UIApplication.sharedApplication().windows[0] as! UIWindow
//        wind.rootViewController = splash
//        self.login()

//        if let userDict = NSUserDefaults.standardUserDefaults().valueForKey("user") as? NSDictionary{
//            if let currUserDict = userDict["newUser"] as? NSDictionary{
//                var currUser = User.parseUserJson(JSON(currUserDict))
//                Connection.connectionToService("Login", params: ["name":currUser.oUserMemberShip.nvUserName,"id":currUser.oUserMemberShip.nvUserPassword], completion: {data -> Void in
//                    var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
//                    println("Login:\(strData)")
//                    var err: NSError?
//                    var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
//                    if let parseJSON = json {
//                        ActiveUser.setUser(User.parseUserJson(JSON(parseJSON)))
//                        ActiveUser.sharedInstace.oLocation.iDriverId = ActiveUser.sharedInstace.iUserId
//                        ActiveUser.sharedInstace.oUserMemberShip.nvUserName = currUser.oUserMemberShip.nvUserName
//                        ActiveUser.sharedInstace.oUserMemberShip.nvUserPassword = currUser.oUserMemberShip.nvUserPassword
//                        
//                        if (ActiveUser.sharedInstace.iUserId != -1 && ActiveUser.sharedInstace.iUserId != 0){
//                            
//                            NSUserDefaults.standardUserDefaults().setValue(User.getUserDictionary(ActiveUser.sharedInstace), forKey: "user")
//                            NSUserDefaults.standardUserDefaults().synchronize()
//                            
//                            ActiveUser.loginToQuickBloxWithCurrentUser()
//                            ActiveUser.sendDeviceTokenToServer()
//                            
//                            let loginOptionView: ChooseLoginWayViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ChooseLoginWayViewControllerId") as! ChooseLoginWayViewController
//                            
//                            
//                            
//                            let mainPage: MainPage = self.storyboard!.instantiateViewControllerWithIdentifier("MainPageId") as! MainPage
//                            let mainPageId : MainPage = self.storyboard!.instantiateViewControllerWithIdentifier("MainPageId") as! MainPage
//                         //   let mainPage: UsersListViewController = self.storyboard!.instantiateViewControllerWithIdentifier("UsersListViewControllerId") as! UsersListViewController
//                            if self.cameFromNotification && self.userInfo != nil{
////                                 mainPage.cameFromNotification = true
////                                 mainPage.userInfo = self.userInfo
//                                                                 mainPageId.cameFromNotification = true
//                                                                 mainPageId.userInfo = self.userInfo
//
//                            }
//                            
//                            self.frontNavigationController = UINavigationController(rootViewController: loginOptionView)
//                            self.frontNavigationController.pushViewController(mainPage, animated: true)
//                            
//                        }else{
//                            let loginOptionView: ChooseLoginWayViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ChooseLoginWayViewControllerId") as! ChooseLoginWayViewController
//                            self.frontNavigationController = UINavigationController(rootViewController: loginOptionView)                        }
//                    }else{
//                        let loginOptionView: ChooseLoginWayViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ChooseLoginWayViewControllerId") as! ChooseLoginWayViewController
//                        self.frontNavigationController = UINavigationController(rootViewController: loginOptionView)
//                    }
//                    self.getNavigationController()
//                })
//            }else{
//                let loginOptionView: ChooseLoginWayViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ChooseLoginWayViewControllerId") as! ChooseLoginWayViewController
//                self.frontNavigationController = UINavigationController(rootViewController: loginOptionView)
//                self.getNavigationController()
//                
//            }
//        }else{
//            let loginOptionView: ChooseLoginWayViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ChooseLoginWayViewControllerId") as! ChooseLoginWayViewController
//            frontNavigationController = UINavigationController(rootViewController: loginOptionView)
//            self.getNavigationController()
//        }
        
    }
    
//    func getNavigationController(){
//        var rearViewController = RearViewController()
//        var rearNavigationController = UINavigationController(rootViewController: rearViewController)
//        
//        var revealController = SWRevealViewController()
//        
//        revealController.frontViewController = frontNavigationController
//        revealController.rightViewController = rearNavigationController
//        
//        var wind: UIWindow = UIApplication.sharedApplication().windows[0] as! UIWindow
//        wind.rootViewController = revealController
//        
//        //initialize the code tables
//        ApplicationData.sharedApplicationDataInstance.getNeededTablesFromServer()
//        
//    }
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

        //initialize the code tables
//        ApplicationData.sharedApplicationDataInstance.getNeededTablesFromServer()
        
    }

    func login()
    {
        if let userDict = NSUserDefaults.standardUserDefaults().valueForKey("user") as? NSDictionary{
            if let currUserDict = userDict["newUser"] as? NSDictionary{
                var currUser = User.parseUserJson(JSON(currUserDict))
                Connection.connectionToService("Login", params: ["name":currUser.oUserMemberShip.nvUserName,"id":currUser.oUserMemberShip.nvUserPassword], completion: {data -> Void in
                    var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Login:\(strData)")
                    var err: NSError?
                    var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
                    if let parseJSON = json {
                        ActiveUser.setUser(User.parseUserJson(JSON(parseJSON)))
                        ActiveUser.sharedInstace.oLocation.iDriverId = ActiveUser.sharedInstace.iUserId
                        ActiveUser.sharedInstace.oUserMemberShip.nvUserName = currUser.oUserMemberShip.nvUserName
                        ActiveUser.sharedInstace.oUserMemberShip.nvUserPassword = currUser.oUserMemberShip.nvUserPassword
                        
                        if (ActiveUser.sharedInstace.iUserId != -1 && ActiveUser.sharedInstace.iUserId != 0){
                            //FIXME1.11
                            var userDics:NSMutableDictionary = ["newUser":User.getUserDictionary(ActiveUser.sharedInstace)]
                            NSUserDefaults.standardUserDefaults().setValue(/*User.getUserDictionary(ActiveUser.sharedInstace)*/userDics, forKey: "user")
                            NSUserDefaults.standardUserDefaults().synchronize()
                            
                            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                            if appDelegate.isLoginQb==false
                            {
                                appDelegate.timer=NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "update", userInfo: nil, repeats: true)
                                ActiveUser.loginToQuickBloxWithCurrentUser()
                            }
                            else
                            {
                                ActiveUser.sendDeviceTokenToServer()
                                
                                
                                
                                
                                let loginOptionView: ChooseLoginWayViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ChooseLoginWayViewControllerId") as! ChooseLoginWayViewController
                                
                                //                            let mainPage: MainPage = self.storyboard!.instantiateViewControllerWithIdentifier("MainPageId") as! MainPage
                                //                           let mainPageId : MainPage = self.storyboard!.instantiateViewControllerWithIdentifier("MainPageId") as! MainPage
                                
                                let mainPage: UsersListViewController = self.storyboard!.instantiateViewControllerWithIdentifier("UsersListViewControllerID") as! UsersListViewController
                                
                                if self.cameFromNotification && self.userInfo != nil{
                                    //                                 mainPage.cameFromNotification = true
                                    //                                 mainPage.userInfo = self.userInfo
                                    //                                                                 mainPageId.cameFromNotification = true
                                    //                                                                 mainPageId.userInfo = self.userInfo
                                    
                                }
                                
                                self.frontNavigationController = UINavigationController(rootViewController: loginOptionView)
                                self.frontNavigationController.pushViewController(mainPage, animated: true)
                            }
                            
                        }else{
                            let loginOptionView: ChooseLoginWayViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ChooseLoginWayViewControllerId") as! ChooseLoginWayViewController
                            self.frontNavigationController = UINavigationController(rootViewController: loginOptionView)                        }
                    }else{
                        let loginOptionView: ChooseLoginWayViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ChooseLoginWayViewControllerId") as! ChooseLoginWayViewController
                        self.frontNavigationController = UINavigationController(rootViewController: loginOptionView)
                    }
                    self.getNavigationController()
                })
            }else{
                let loginOptionView: ChooseLoginWayViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ChooseLoginWayViewControllerId") as! ChooseLoginWayViewController
                self.frontNavigationController = UINavigationController(rootViewController: loginOptionView)
                self.getNavigationController()
                
            }
        }else{
            let loginOptionView: ChooseLoginWayViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ChooseLoginWayViewControllerId") as! ChooseLoginWayViewController
            frontNavigationController = UINavigationController(rootViewController: loginOptionView)
            self.getNavigationController()
        }
        
    }
    
    
    //}
    func update() {
        var generic = Generic()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.timerCount++
        println(" appDelegate.timerCount++:\(appDelegate.timerCount)")
        
        if appDelegate.isLoginQb
        {
            self.login()
            //            let mainPage: UsersListViewController = self.storyboard!.instantiateViewControllerWithIdentifier("UsersListViewControllerID") as! UsersListViewController
            //
            //            //  let mainPage: MainPage = self.storyboard!.instantiateViewControllerWithIdentifier("MainPageId") as! MainPage
            //            self.navigationController!.pushViewController(mainPage, animated: true)
            //                                        let loginOptionView: ChooseLoginWayViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ChooseLoginWayViewControllerId") as! ChooseLoginWayViewController
            //            //                            let mainPage: MainPage = self.storyboard!.instantiateViewControllerWithIdentifier("MainPageId") as! MainPage
            //            //                           let mainPageId : MainPage = self.storyboard!.instantiateViewControllerWithIdentifier("MainPageId") as! MainPage
            //
            //            let mainPage: UsersListViewController = self.storyboard!.instantiateViewControllerWithIdentifier("UsersListViewControllerID") as! UsersListViewController
            //
            //            if self.cameFromNotification && self.userInfo != nil{
            //                //                                 mainPage.cameFromNotification = true
            //                //                                 mainPage.userInfo = self.userInfo
            //                //                                                                 mainPageId.cameFromNotification = true
            //                //                                                                 mainPageId.userInfo = self.userInfo
            //
            //            }
            //
            //            self.frontNavigationController = UINavigationController(rootViewController: loginOptionView)
            //            self.frontNavigationController.pushViewController(mainPage, animated: true)
            
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
        // Something cool
    }
   
}



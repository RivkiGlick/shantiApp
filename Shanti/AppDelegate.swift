//
//  AppDelegate.swift
//  Shanti
//
//  Created by hodaya ohana on 12/29/14.
//  Copyright (c) 2014 webit. All rights reserved.
//

import UIKit
//import GoogleMaps

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate{
    var window: UIWindow?
    //    let googleMapsApiKey = "AIzaSyDpcCd6zV9F8aTkvf5k-dGh7XiDQjrxwiE"
    // let googleMapsApiKey = "AIzaSyAhOGrkx1oHPuJNIPbByr_FwED2c1jNgbo" //shanti1
//    let googleMapsApiKey = "AIzaSyDfavKr1htnwcDILYnmmau97xbQseG5pQo" //shantiApple
    let googleMapsApiKey = "AIzaSyBN-ekv7jSgCBz3jdjG8i4l32B5bcfEVfA" //ShantiAppApiKey_Ios
//
    
    var generic = Generic()
    var cameFromlaunchOptions: Bool = false
    var arrayAlerts: NSMutableArray = []
    var arrayUsers: NSMutableArray = []
    var messages: NSMutableArray = []
    var isLoginQb: Bool = false
    //MARK:ADD IN SYNCRONE CODE
    var timer:NSTimer = NSTimer()
    var timerCount: Int = Int()
    var isLoginQbError: Bool = false
    var FiilData: Bool = false
    var didTap = false
    var isGoogle:Bool = false
    var isFaceBook:Bool = false
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        GMSServices.provideAPIKey(googleMapsApiKey)
        
        //Mint.sharedInstance().initAndStartSession("907bf815")
        
        #if DEBUG
            //            // QuickBlox QA
            QBSettings.setAccountKey("tCZN53macn4TmgNpmZ6j")//Account key
            QBApplication.sharedApplication().applicationId = 19515
            QBConnection.registerServiceKey("aYnhGxHcQc6WFf5")//Authorization key
            QBConnection.registerServiceSecret("ZtncanqFZzr7MCh")//Authorization secret
            if self.arrayUsers.count==0
            {
                self.setListUsers()
            }
            
            var dict = ["ProjectName":"Shanti","FunctionName":"QuickBlox QA","ToUTL":"Development"]
            Connection.writeToWebitLog(dict, completion: {
                data -> Void in
                println("finish writeToWebitLog")
            })
            //live
            //        QBSettings.setAccountKey("52Kp1sQpBtNsqKx3MYMf")//Account key
            //        QBApplication.sharedApplication().applicationId = 22214
            //        QBConnection.registerServiceKey("qZP9GXutF5EdXvS")//Authorization key
            //        QBConnection.registerServiceSecret("pcytS4MvD5nF57H")//Authorization secret
            
            #else
            //             QuickBlox
            QBSettings.setAccountKey("52Kp1sQpBtNsqKx3MYMf")//Account key
            QBApplication.sharedApplication().applicationId = 22214
            QBConnection.registerServiceKey("qZP9GXutF5EdXvS")//Authorization key
            QBConnection.registerServiceSecret("pcytS4MvD5nF57H")//Authorization secret
            if self.arrayUsers.count==0
            {
            self.setListUsers()
            }
            //            var dict = ["ProjectName":"Shanti","FunctionName":"QuickBlox Production","ToUTL":"Production"]
            //            Connection.writeToWebitLog(dict, completion: {
            //            data -> Void in
            //            println("finish writeToWebitLog")
            //            })
            
        #endif
        
        //        #if DEBUG
        //            QBSettings.useProductionEnvironmentForPushNotifications = true
        //        #endif
        
        if (UIDevice.currentDevice().systemVersion as NSString).doubleValue >= 8.0{
            // iOS 8 Notifications
            application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Badge |  UIUserNotificationType.Sound |  UIUserNotificationType.Alert, categories: nil))
            application.registerForRemoteNotifications()
        }else{
            // iOS < 8 Notifications
            application.registerForRemoteNotificationTypes(.Badge | .Sound | .Alert)
        }
        
       return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
//        return true
    }
    
    
    func application(application: UIApplication,openURL url: NSURL,sourceApplication: String?,annotation: AnyObject?) -> Bool {
        var whatToReturn = true
        var loginWay = NSUserDefaults.standardUserDefaults().valueForKey("loginWay") as? String
        
        if loginWay == "google+"
        {
            whatToReturn = GPPURLHandler.handleURL(url, sourceApplication:sourceApplication, annotation: annotation)
        }
        else
        {
            whatToReturn = FBSDKApplicationDelegate.sharedInstance().application(application,openURL: url,sourceApplication: sourceApplication,
                annotation: annotation)
        }
    
        
    return whatToReturn
    }

    
    
    func application( application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData ) {
        
        var characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        
        var deviceTokenString: String = ( deviceToken.description as NSString )
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        
        println("deviceToken: \(deviceTokenString)")
        var str: String = deviceTokenString
        NSUserDefaults.standardUserDefaults().setValue(str, forKey: "deviceToken")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        NSUserDefaults.standardUserDefaults().setValue(deviceToken, forKey: "deviceTokenInData")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError){
        println("error:\(error)")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        for (key, value) in userInfo {
            println("\(key): \(value)")
        }
        println("application.applicationState:\(application.applicationState.rawValue)")
        
        if  application.applicationState == UIApplicationState.Background || application.applicationState == UIApplicationState.Inactive{
            UIApplication.sharedApplication().applicationIconBadgeNumber--
            var dict = ["ProjectName":"Shanti","FunctionName":"didReceiveRemoteNotification","ToUTL":"moving to bg mode"]
            Connection.writeToWebitLog(dict, completion: {
                data -> Void in
                println("finish writeToWebitLog")
            })
            self.handleNotificationInBackgroundAndInactiveModes(userInfo,fetchCompletionHandler: completionHandler)
        }else if application.applicationState == UIApplicationState.Active{
            var dict = ["ProjectName":"Shanti","FunctionName":"didReceiveRemoteNotification","ToUTL":"moving to Active mode"]
            Connection.writeToWebitLog(dict, completion: {
                data -> Void in
                println("finish writeToWebitLog")
            })
            self.handleNotificationInActiveMode(userInfo,fetchCompletionHandler: completionHandler)
        }else {
            var dict = ["ProjectName":"Shanti","FunctionName":"didReceiveRemoteNotification","ToUTL":"unrecognize mode"]
            Connection.writeToWebitLog(dict, completion: {
                data -> Void in
                println("finish writeToWebitLog")
            })
        }
    }
    
    func handleNotificationInBackgroundAndInactiveModes(userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void){
        if !self.cameFromlaunchOptions{
            if let notificationType: AnyObject = userInfo["notificationType"] {
                var notiType: AnyObject? = userInfo["notificationType"]
                
                if (notificationType as! String) == String(NOTIFICATION_TYPE.NOTIFICATION_TYPE_NEW_MESSAGE_PRIVATE.rawValue){// privateChat
                    if let userSent = userInfo["userIdSend"] as? String{
                        
                        var mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        var currView = (UIApplication.sharedApplication().windows[0] as! UIWindow).rootViewController! as! SWRevealViewController
                        let navCont = currView.frontViewController as! UINavigationController
                        let lastView: UIViewController = navCont.viewControllers[navCont.viewControllers.count - 1] as! UIViewController
                        
                        generic.showNativeActivityIndicator(lastView)
                        
                        Connection.connectionToService("GetUser", params: ["id":userSent], completion: {
                            data -> Void in
                            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                            println("GetUser:\(strData)")
                            var err: NSError?
                            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
                            if let parseJSON = json {
                                var userDetails = User.parseUserJson(JSON(parseJSON))
                                //FIXME1.11
                                var userDics:NSMutableDictionary = ["newUser":User.getUserDictionary(userDetails)]
                                NSUserDefaults.standardUserDefaults().setValue(/*User.getUserDictionary(userDetails)*/userDics, forKey: "userIdSend")
                                NSUserDefaults.standardUserDefaults().synchronize()
                                self.createChatDialog(userDetails.oUserQuickBlox.ID)
                            }
                            completionHandler(UIBackgroundFetchResult.NoData)
                        })
                        
                    }
                }else if (notificationType as! String) == String(NOTIFICATION_TYPE.NOTIFICATION_TYPE_NEW_MESSAGE_GROUP.rawValue){// GroupChat
                    if let iGroupId = userInfo["iGroupId"] as? String{
                        self.moveToGroupChatView(iGroupId)
                    }
                }else if (notificationType as! String) == String(NOTIFICATION_TYPE.NOTIFICATION_TYPE_APPROVAL_GROUP.rawValue){
                    var mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let pendingView: PendingGroupsViewController = mainStoryboard.instantiateViewControllerWithIdentifier("PendingGroupsViewControllerId") as! PendingGroupsViewController
                    var currView = (UIApplication.sharedApplication().windows[0] as! UIWindow).rootViewController! as! SWRevealViewController
                    let navCont = currView.frontViewController as! UINavigationController
                    let lastView: UIViewController = navCont.viewControllers[navCont.viewControllers.count - 1] as! UIViewController
                    lastView.navigationController?.pushViewController(pendingView, animated: true)
                }else if (notificationType as! String) == String(NOTIFICATION_TYPE.NOTIFICATION_TYPE_GLOBAL_MESSAGE.rawValue){
                    if let userName: AnyObject = userInfo["nvSenderUserFullName"] {
                        if let userIdSend: AnyObject = userInfo["userIdSend"] {
                            var mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            var currView = (UIApplication.sharedApplication().windows[0] as! UIWindow).rootViewController! as! SWRevealViewController
                            let navCont = currView.frontViewController as! UINavigationController
                            let lastView: UIViewController = navCont.viewControllers[navCont.viewControllers.count - 1] as! UIViewController
                            
                            var title = "הודעה כללית מאת \(userName as! String)"
                            if let appsDict: AnyObject = userInfo["aps"]{
                                if let body = appsDict["alert"] as? String{
                                    
                                    var alert = UIAlertController(title: title, message: body, preferredStyle: UIAlertControllerStyle.Alert)
                                    
                                    alert.addAction(UIAlertAction(title: "בטל", style: UIAlertActionStyle.Cancel, handler:nil))
                                    alert.addAction(UIAlertAction(title: "פתח צ׳אט", style: UIAlertActionStyle.Default, handler:{ action in action.style
                                        Connection.connectionToService("GetUser", params: ["id":userIdSend], completion: {
                                            data -> Void in
                                            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                                            println("GetUser:\(strData)")
                                            var err: NSError?
                                            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
                                            if let parseJSON = json {
                                                var userDetails = User.parseUserJson(JSON(parseJSON))
                                                //FIXME1.11
                                                var userDics:NSMutableDictionary = ["newUser":User.getUserDictionary(userDetails)]
                                                NSUserDefaults.standardUserDefaults().setValue(/*User.getUserDictionary(userDetails)*/userDics, forKey: "userIdSend")
                                                NSUserDefaults.standardUserDefaults().synchronize()
                                                self.createChatDialog(userDetails.oUserQuickBlox.ID)
                                            }
                                            completionHandler(UIBackgroundFetchResult.NoData)
                                        })
                                    }))
                                    
                                    lastView.presentViewController(alert, animated: true, completion: nil)
                                    
                                    //                                    let delay = 5.0 * Double(NSEC_PER_SEC)
                                    //                                    var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                                    //                                    dispatch_after(time, dispatch_get_main_queue(), {
                                    //                                        alert.dismissViewControllerAnimated(true, completion: nil)
                                    //                                    })
                                }
                            }
                        }
                    }
                }
            }else{
                var dict = ["ProjectName":"Shanti","FunctionName":"handleNotification","ToUTL":"fail handle with notification in background mode"]
                Connection.writeToWebitLog(dict, completion: {
                    data -> Void in
                    println("finish writeToWebitLog")
                })
                completionHandler(UIBackgroundFetchResult.NoData)
            }
            
        }
    }
    
    func handleNotificationInActiveMode(userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void){
        var dict = ["ProjectName":"Shanti","FunctionName":"handleNotification","ToUTL":"applicationState Active"]
        if let notificationType: AnyObject = userInfo["notificationType"] {
            if (notificationType as! String) == String(NOTIFICATION_TYPE.NOTIFICATION_TYPE_NEW_MESSAGE_PRIVATE.rawValue) || (notificationType as! String) == String(NOTIFICATION_TYPE.NOTIFICATION_TYPE_NEW_MESSAGE_GROUP.rawValue){
                ActiveUser.changeWaintingMessagesCounter(ActiveUser.sharedInstace.waintingMessages + 1)
                completionHandler(UIBackgroundFetchResult.NoData)
            }else if (notificationType as! String) == String(NOTIFICATION_TYPE.NOTIFICATION_TYPE_GLOBAL_MESSAGE.rawValue){
                if let userName: AnyObject = userInfo["nvSenderUserFullName"] {
                    if let userIdSend: AnyObject = userInfo["userIdSend"] {
                        if (userIdSend as! String) != "\(ActiveUser.sharedInstace.iUserId)"{
                            var mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            var currView = (UIApplication.sharedApplication().windows[0] as! UIWindow).rootViewController! as! SWRevealViewController
                            let navCont = currView.frontViewController as! UINavigationController
                            let lastView: UIViewController = navCont.viewControllers[navCont.viewControllers.count - 1] as! UIViewController
                            ///מגיע לכאן
                            var title = "הודעה כללית מאת \(userName as! String)"
                            if let appsDict: AnyObject = userInfo["aps"]{
                                if let body = appsDict["alert"] as? String{
                                    
                                    var alert = UIAlertController(title: title, message: body, preferredStyle: UIAlertControllerStyle.Alert)
                                    alert.addAction(UIAlertAction(title: "בטל", style: UIAlertActionStyle.Cancel, handler:{
                                        action in action.style
                                        self.arrayAlerts.removeLastObject()
                                        self.showAlert(lastView)
                                    }))
                                    alert.addAction(UIAlertAction(title: "פתח צ׳אט", style: UIAlertActionStyle.Default, handler:{ action in action.style
                                        self.arrayAlerts.removeLastObject()
                                        self.showAlert(lastView)
                                        Connection.connectionToService("GetUser", params: ["id":userIdSend], completion: {
                                            data -> Void in
                                            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                                            println("GetUser:\(strData)")
                                            var err: NSError?
                                            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
                                            if let parseJSON = json {
                                                var userDetails = User.parseUserJson(JSON(parseJSON))
                                                //FIXME1.11
                                                var userDics:NSMutableDictionary = ["newUser":User.getUserDictionary(userDetails)]
                                                NSUserDefaults.standardUserDefaults().setValue(/*User.getUserDictionary(userDetails)*/userDics, forKey: "userIdSend")
                                                NSUserDefaults.standardUserDefaults().synchronize()
                                                self.createChatDialog(userDetails.oUserQuickBlox.ID)
                                            }
                                            completionHandler(UIBackgroundFetchResult.NoData)
                                        })
                                    }))
                                    
                                    
                                    arrayAlerts.addObject(alert)
                                    ChatService.instance().playNotificationSound()
                                    self.showAlert(lastView)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func showAlert(lastView: UIViewController){
        if arrayAlerts.count != 0{
            var alertToShow: UIAlertController = arrayAlerts.lastObject as! UIAlertController
            lastView.dismissViewControllerAnimated(true, completion: nil)
            lastView.presentViewController(alertToShow, animated: true, completion:nil)
        }
    }
    
    
    func handleNotificationInExitMode(userInfo: [NSObject : AnyObject]){
        var mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navCont = mainStoryboard.instantiateViewControllerWithIdentifier("NavigationControllerId") as! NavigationController
        navCont.cameFromNotification = true
        navCont.userInfo = userInfo
        self.window?.rootViewController = navCont
        self.window?.makeKeyAndVisible()
    }
    
    func applicationDidBecomeActive(application: UIApplication){
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        //        UIApplication.sharedApplication().cancelAllLocalNotifications()
//        FBSDKAppEvents.activateApp()
        self.sendDeviceTokenToServer()
    }

    
    
    func createChatDialog(userQuickBloxID: Int){
        var chatDialog = QBChatDialog()
        chatDialog.occupantIDs = [userQuickBloxID]
        chatDialog.type = QBChatDialogTypePrivate
        QBChat.createDialog(chatDialog, delegate: self)
    }
    
    func completedWithResult(result: Result) -> Void{
        var dict = ["ProjectName":"Shanti","FunctionName":"completedWithResult","ToUTL":"appDelegate"]
        Connection.writeToWebitLog(dict, completion: {
            data -> Void in
            println("finish writeToWebitLog")
        })
        if (result.success && result.isKindOfClass(QBChatDialogResult)){
            var chatDialog = (result as! QBChatDialogResult).dialog!
            if chatDialog.type.value == QBChatDialogTypePrivate.value{
                self.moveToChatViewController(chatDialog)
            }
        }
    }
    
    
    func moveToChatViewController(chatDialog: QBChatDialog){
        var mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let chatView = mainStoryboard.instantiateViewControllerWithIdentifier("PrivateChatViewControllerId") as! PrivateChatViewController
        chatView.dialog = chatDialog
        if let userDict = NSUserDefaults.standardUserDefaults().valueForKey("userIdSend") as? NSDictionary{
            if let currUserDict = userDict["newUser"] as? NSDictionary{
                var currUser = User.parseUserJson(JSON(currUserDict))
                chatView.user = currUser
                
                NSUserDefaults.standardUserDefaults().removeObjectForKey("userIdSend")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                var currView = (UIApplication.sharedApplication().windows[0] as! UIWindow).rootViewController! as! SWRevealViewController
                if  let navCont = currView.frontViewController as? UINavigationController{
                    if let lastView: UIViewController = navCont.viewControllers[navCont.viewControllers.count - 1] as? UIViewController{
                        generic.hideNativeActivityIndicator(lastView)
                        lastView.navigationController?.pushViewController(chatView, animated: true)
                    }
                }
            }
        }
    }
    
    func moveToGroupChatView(iGroupId: String){
        var mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        Connection.connectionToService("GetGroup", params:["id":iGroupId], completion: {
            data -> Void in
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("GetGroup:\(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            if json != nil{
                if let parseJSON = json {
                    let chatView: ChatGroupViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ChatGroupViewControllerId") as! ChatGroupViewController
                    chatView.currGroup = Group.parseGroupDictionary(parseJSON)
                    
                    var currGroupDialog = QBChatDialog()
                    currGroupDialog.ID = chatView.currGroup.nvQBDialogId
                    currGroupDialog.roomJID = chatView.currGroup.nvQBRoomJid
                    
                    chatView.dialog = currGroupDialog // missing the dialog.recipientID,need to use creatDialog for that.
                    
                    var currView = (UIApplication.sharedApplication().windows[0] as! UIWindow).rootViewController! as! SWRevealViewController
                    if  let navCont = currView.frontViewController as? UINavigationController{
                        if let lastView: UIViewController = navCont.viewControllers[navCont.viewControllers.count - 1] as? UIViewController{
                            lastView.navigationController?.pushViewController(chatView, animated: true)
                        }
                    }
                }
            }
        })
    }
    
    func sendDeviceTokenToServer(){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            if let userDict = NSUserDefaults.standardUserDefaults().valueForKey("user") as? NSDictionary{
                if let currUserDict = userDict["newUser"] as? NSDictionary{
                    var currUser = User.parseUserJson(JSON(currUserDict))
                    currUser.nvTokenId = currUserDict["nvTokenId"] != nil ? currUserDict["nvTokenId"] as! String : " "
                    currUser.iDeviceTypeId = I_DEVICE_TYPE_ID
                    var params = ["iUserId":currUser.iUserId,"nvTokenId":currUser.nvTokenId,"iDeviceType":currUser.iDeviceTypeId]
                    Connection.connectionToService("UpdateTokenAndDevice", params: params, completion: {
                        data -> Void in
                        var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                        println("UpdateTokenAndDevice\(strData)")
                    })
                    
                    var str = String("iUserId:\(currUser.iUserId),nvTokenId:\(currUser.nvTokenId),iDeviceType:\(currUser.iDeviceTypeId)")
                    var dict = ["ProjectName":"Shanti","FunctionName":"device token","Json":str,"ToUTL":SERVICE_URL]
                    Connection.writeToWebitLog(dict, completion: {
                        data -> Void in
                        println("finish writeToWebitLog")
                    })
                }
            }
        })
    }
    
    class func registerForNotificationsInQuickBlox(deviceToken: NSData){
        // Register subscription with device token
        QBRequest.registerSubscriptionForDeviceToken(deviceToken, successBlock: {
            response, subscriptions -> Void in
            println("registration success , subscriptions: \(subscriptions)")
            QBRequest.subscriptionsWithSuccessBlock({
                response  -> Void in
                println("subscriptions success")
                
                }, errorBlock: {
                    error -> Void in
                    println("subscriptions error \(error.description)")
                    
            })
            }, errorBlock: {
                error -> Void in
                println("registration error")
        })
    }
    func setListUsers()
    {
        var language = Int()
        var params = NSMutableDictionary()
        
        let languageId = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) as! String
        if languageId == "he"
        {
            language = 1
        }
        else
        {
            if languageId == "en"
            {
                language = 2
            }
        }
        
                
                params = ["iAppLanguageId":1]
                Connection.connectionToService("GetUsersListToSearch", params:params, completion: {
                    data -> Void in
                    var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                    var err: NSError?
                    var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSArray
                    println("UpdateTokenAndDevice\(json)")
                    
                    if let parseJSON = json {
                        var userDetails = User.parseUserJson(JSON(parseJSON))
                        
                        
                        if (json != nil) {
                            for dict in json!{
                                let currUser: User = User.parseUserJson(JSON(dict))
                                self.arrayUsers.addObject(currUser)

                            }
                            if self.arrayUsers.count>0
                            {
                                var dict = ["ProjectName":"Shanti","FunctionName":"setListUsers","ToUTL":"fillArray users"]
                                println(dict)
                                println(self.arrayUsers)
                                
                                Connection.writeToWebitLog(dict, completion: {
                                    data -> Void in
                                    println("finish writeToWebitLog")
                                })
                            }
                            else
                            {
                                var dict = ["ProjectName":"Shanti","FunctionName":"setListUsers","ToUTL":"is empty users"]
                                println(dict)
                                println(self.arrayUsers)
                                Connection.writeToWebitLog(dict, completion: {
                                    data -> Void in
                                    println("finish writeToWebitLog")
                                })
                            }
                            
                            //                    self.tableView.reloadData()
                        }
                        
                    }
                })
                // }
                
                
            }

            
}

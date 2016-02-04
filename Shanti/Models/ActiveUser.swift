//
//  ActiveUser.swift
//  Shanti
//
//  Created by hodaya ohana on 1/15/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

private let singletonInstance = User()

public class ActiveUser: User, UIAlertViewDelegate {
    
    class var sharedInstace: User{
        return singletonInstance
    }
    var user:ActiveUser = ActiveUser()
    
    class func setUser(user: User){
        singletonInstance.iUserId = user.iUserId
        singletonInstance.iUserType = user.iUserType
        singletonInstance.nvFirstName = user.nvFirstName
        singletonInstance.nvLastName = user.nvLastName
        singletonInstance.nvEmail = user.nvEmail
        singletonInstance.iUserStatusId = user.iUserStatusId
        singletonInstance.nvPhone = user.nvPhone
        singletonInstance.dtBirthDate = user.dtBirthDate
        singletonInstance.oCountry = user.oCountry
        singletonInstance.iReligionId = user.iReligionId
        singletonInstance.sReligion = user.sReligion
        singletonInstance.iReligiousLevelId = user.iReligiousLevelId
        singletonInstance.sReligiousLevel = user.sReligiousLevel
        singletonInstance.nvProfession = user.nvProfession
        singletonInstance.nvHobby = user.nvHobby
        singletonInstance.nvImage = user.nvImage
        singletonInstance.nvCreateDate = user.nvCreateDate
        singletonInstance.oLanguages = user.oLanguages
        singletonInstance.oAddress = user.oAddress
        singletonInstance.oUserMemberShip = user.oUserMemberShip
        singletonInstance.oUserQuickBlox = user.oUserQuickBlox
        singletonInstance.iGenderId = user.iGenderId
        singletonInstance.nvShantiName = user.nvShantiName
        singletonInstance.bIsMainUser = user.bIsMainUser
        singletonInstance.iNumGroupAsMainUser = user.iNumGroupAsMainUser
        singletonInstance.iNumGroupAsMemberUser = user.iNumGroupAsMemberUser
        
        if let str = NSUserDefaults.standardUserDefaults().valueForKey("deviceToken") as? String{
            singletonInstance.nvTokenId = str
        }
        
        singletonInstance.image = ImageHandler.getImageBase64FromUrl(singletonInstance.nvImage)
        singletonInstance.waintingMessages = user.waintingMessages
    }
    
    class func loginToQuickBloxWithCurrentUser(){
//if isConnectedToNetwork() == true
//{
        let reachability: Reachability = Reachability.reachabilityForInternetConnection()
        let networkStatus:ULONG = reachability.currentReachabilityStatus().value
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if networkStatus != 0
        {

        dispatch_async(dispatch_get_main_queue(),{
            // TODO: replace it with the user email & password
            var extendedAuthRequest: QBSessionParameters = QBSessionParameters()
            extendedAuthRequest.userLogin = ActiveUser.sharedInstace.oUserQuickBlox.login
            extendedAuthRequest.userPassword = ActiveUser.sharedInstace.oUserQuickBlox.password
            
            QBRequest.createSessionWithExtendedParameters(extendedAuthRequest, successBlock:
                {
                response, session -> Void in
                
                println("Xmpp login success!")
                var currentUser: QBUUser = QBUUser()
                currentUser.ID = session.userID;
                currentUser.login = ActiveUser.sharedInstace.oUserQuickBlox.login
                currentUser.password = ActiveUser.sharedInstace.oUserQuickBlox.password
                
                ActiveUser.sharedInstace.oUserQuickBlox.ID = Int(currentUser.ID)
                
                ChatService.instance().loginWithUser(currentUser, completionBlock: {
                    println("ChatService login done!")
                    ActiveUser.sharedInstace.didLoginToQB = true
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.isLoginQb = true
                    if let deviceToken = NSUserDefaults.standardUserDefaults().valueForKey("deviceTokenInData") as? NSData{
                        AppDelegate.registerForNotificationsInQuickBlox(deviceToken)
                    }
                })
                }, errorBlock: {
                    response -> Void in
                    println("Xmpp login fail! response:\(response.error) \(response.status)")
                    if response.status == QBResponseStatusCode.UnAuthorized || response.status == QBResponseStatusCode.ValidationFailed || response.status == QBResponseStatusCode.ServerError || response.status == QBResponseStatusCode.Unknown || response.status == QBResponseStatusCode.Accepted || response.status == QBResponseStatusCode.Created || response.status == QBResponseStatusCode.NotFound
                    {
//                        var currView = (UIApplication.sharedApplication().windows[0] as! UIWindow).rootViewController! as! SWRevealViewController
//                        if  let navCont = currView.frontViewController as? UINavigationController{
//                            if let lastView: UIViewController = navCont.viewControllers[navCont.viewControllers.count - 1] as? UIViewController{
//                                var alert = UIAlertController(title: "שגיאה", message: "ארעה שגיאה ברישומך לצאט", preferredStyle: UIAlertControllerStyle.Alert)
//                                alert.addAction(UIAlertAction(title: "נסה להרשם לצאט שוב", style: UIAlertActionStyle.Cancel, handler: {
//                                    action in action.style
//                                    User.sighUpToXmpp(ActiveUser.sharedInstace)
//                                    ActiveUser.loginToQuickBloxWithCurrentUser()
                                    appDelegate.isLoginQbError=true
//                                }))
//                                
//                                alert.addAction(UIAlertAction(title: "בטל", style: UIAlertActionStyle.Default, handler:nil))
//                                lastView.presentViewController(alert, animated: true, completion: nil)
//                                appDelegate.timer.invalidate()
//                            }
//                        }
                        
                    }
                    else
                    {
                        appDelegate.timer.invalidate()
                        var currView = (UIApplication.sharedApplication().windows[0] as! UIWindow).rootViewController! as! SWRevealViewController
                        if  let navCont = currView.frontViewController as? UINavigationController{
                            if let lastView: UIViewController = navCont.viewControllers[navCont.viewControllers.count - 1] as? UIViewController{
                                var alert = UIAlertController(title: "שגיאה", message: "ארעה שגיאה בחיבורי הצאט", preferredStyle: UIAlertControllerStyle.Alert)
                                alert.addAction(UIAlertAction(title: "נסה להתחבר שוב", style: UIAlertActionStyle.Cancel, handler: {
                                    action in action.style
                                    ActiveUser.loginToQuickBloxWithCurrentUser()
                                    }))
//                                alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
//                               lastView.presentViewController(alert, animated: true, completion: nil)
//                                alert.addAction(UIAlertAction(title: "בטל", style: UIAlertActionStyle.Cancel, handler:nil))
                                lastView.presentViewController(alert, animated: true, completion: nil)
                            }
                        }

                        
                    }
            })
        })
       }
        
        else
        {
            print("no internet")
        }
    }
    
    func isConnectedToNetwork()->Bool{
        
        var Status:Bool = false
        let url = NSURL(string: "http://google.com/")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: NSURLResponse?
        
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: nil) as NSData?
        
        if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode == 200 {
                Status = true
            }
        }
        
        return Status
    }
    
    class func sendDeviceTokenToServer()
    {
        dispatch_async(dispatch_get_main_queue(),{
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
    
    class func GetUserGroupsAsMain(){
        Connection.connectionToService("GetUserGroupsAsMain",params: ["id":ActiveUser.sharedInstace.iUserId], completion: {
            data -> Void in
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("GetUserGroupsAsMain:\(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSArray

        })
    }
    
    class func changeWaintingMessagesCounter(counter: Int){
        ActiveUser.sharedInstace.waintingMessages = counter
        
        if ActiveUser.sharedInstace.delegate != nil{
    ActiveUser.sharedInstace.delegate?.changeWaintingMessagesCounter(counter)
        }
    }
  
}
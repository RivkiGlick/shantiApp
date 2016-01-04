//
//  User.swift
//  Shanti
//
//  Created by hodaya ohana on 1/15/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

protocol ActiveUserDelegate{
    func changeWaintingMessagesCounter(counter: Int)
}

public class User: NSObject {
    var nvFacebookUserId:String = String()
    var nvGoogleUserId:String = String()
    var iUserId: Int = Int(-1)
    var iUserType: Int = Int(-1)
    var nvFirstName: String = String()
    var nvLastName: String = String()
    var nvEmail: String = String()
    var iUserStatusId: Int = Int(-1)
    var nvPhone: String = String()
    var nvPhonePrefix: String = String()
    var dtBirthDate: String = String()
    var iReligionId: Int = Int(-1)
    var sReligion: String = String()
    var iReligiousLevelId: Int = Int(-1)
    var sReligiousLevel: String = String()
    var nvProfession: String = String()
    var nvHobby: String = String()
    var nvAboutMe: String = String()
//    nvPhonePrefix
//    nvAboutMe

   
    var nvImage: String = String()
    var nvCreateDate: String = String()
    var oLanguages: NSMutableArray = NSMutableArray()
    var oAddress: Address = Address()
    var oUserMemberShip: UserMembership = UserMembership()
    var oLocation: Location = Location()
    var iGenderId: Int = Int(-1)
    var oUserQuickBlox: UserQuickBlox = UserQuickBlox()
    var iDeviceTypeId: Int = Int(455)
    var nvTokenId: String = String()
    var nvShantiName: String = String()
    var bIsMainUser: Bool = false
    var oCountry: CodeValue = CodeValue()
    var iNumGroupAsMainUser: Int = Int(0)
    var iNumGroupAsMemberUser: Int = Int(0)
    
    var image: UIImage = UIImage() // class property only in the app, not in server!!!
    var waintingMessages: Int = Int(0)// class property only in the app, not in server!!!
    var delegate: ActiveUserDelegate?
    var didLoginToQB: Bool = false
    var bIsActive: Bool = false//add
    var sDistanceString = NSString()//Add
    
    var nvLastBroadcastDate: String = String()
    var  dtLastBroadcastDate: NSDate = NSDate()//add
    var nvDistance: String = String()//add
    var iDistance: Int = Int(0)
    var isOnline: Bool = Bool()

    override init() {
        super.init()
    }
   
    class func parseUserJson(json: JSON) -> User{
        var user = User()
        user.nvGoogleUserId = (json["nvGoogleUserId"].asString != nil ? json["nvGoogleUserId"].asString! : "")
        user.nvFacebookUserId = (json["nvFacebookUserId"].asString != nil ? json["nvFacebookUserId"].asString! : "")
        user.iUserId = (json["iUserId"].asInt != nil) ? json["iUserId"].asInt! : 0
        user.iUserType = (json["iUserType"].asInt != nil) ? json["iUserType"].asInt! : 0
        user.nvFirstName = (json["nvFirstName"].asString != nil) ? json["nvFirstName"].asString! : ""
        user.nvLastName = (json["nvLastName"].asString != nil) ? json["nvLastName"].asString! : ""
        user.nvEmail = (json["nvEmail"].asString != nil) ? json["nvEmail"].asString! : ""
        user.iUserStatusId = (json["iUserStatusId"].asInt != nil) ? json["iUserStatusId"].asInt! : 0
        user.nvPhone = (json["nvPhone"].asString != nil) ? json["nvPhone"].asString! : ""
        user.nvPhonePrefix = (json["nvPhonePrefix"].asString != nil) ? json["nvPhonePrefix"].asString! : ""
        user.dtBirthDate = (json["dtBirthDate"].asString != nil) ? json["dtBirthDate"].asString! : ""
        user.iReligionId = (json["iReligionId"].asInt != nil) ? json["iReligionId"].asInt! : 0
        user.sReligion = (json["sReligion"].asString != nil) ? json["sReligion"].asString! : ""
        user.iReligiousLevelId = (json["iReligiousLevelId"].asInt != nil) ? json["iReligiousLevelId"].asInt! : 0
        user.sReligiousLevel = (json["sReligiousLevel"].asString != nil) ? json["sReligiousLevel"].asString! : ""
        user.nvProfession = (json["nvProfession"].asString != nil) ? json["nvProfession"].asString! : ""
        user.nvHobby = (json["nvHobby"].asString != nil) ? json["nvHobby"].asString! : ""
        user.nvAboutMe = (json["nvAboutMe"].asString != nil) ? json["nvAboutMe"].asString! : ""
        user.nvImage = (json["nvImage"].asString != nil) ? json["nvImage"].asString! : ""
        user.nvCreateDate = (json["nvCreateDate"].asString != nil) ? json["nvCreateDate"].asString! : ""
        user.bIsActive = (json["bIsActive"].asBool != nil) ? json["bIsActive"].asBool! : false
//        user.oLanguages = CodeValue.parsCodeValueJson(json["oLanguages"])
//        for dict in json["oLanguages"]{
//            var js: JSON = dict as JSON
//        }
        user.oAddress = Address.parsAddressJson(json["oAddress"])
        user.oUserMemberShip = UserMembership.parsUserMembershipJson(json["oUserMemberShip"])
        user.oLocation = Location.parseLocationJson(json["oLocation"])
        user.oLocation.iDriverId = user.iUserId
        user.iGenderId = (json["iGenderId"].asInt != nil && json["iGenderId"].asInt != -1) ? json["iGenderId"].asInt! : 0
        user.oUserQuickBlox = UserQuickBlox.parsUserQuickBloxDictionary(json["oUserQuickBlox"])
        user.nvTokenId = (json["nvTokenId"].asString != nil) ? json["nvTokenId"].asString! : ""
        user.iDeviceTypeId = (json["iDeviceTypeId"].asInt != nil) ? json["iDeviceTypeId"].asInt! : 455
        user.nvShantiName = (json["nvShantiName"].asString != nil) ? json["nvShantiName"].asString! : ""
        if json["bIsMainUser"].asBool != nil{
            user.bIsMainUser =  json["bIsMainUser"].asBool!
        }else{
            user.bIsMainUser =  false
        }
        user.oCountry = CodeValue.parsCodeValueJson(json["oCountry"] as JSON)
        user.iNumGroupAsMainUser = (json["iNumGroupAsMainUser"].asInt != nil) ? json["iNumGroupAsMainUser"].asInt! : 0
        user.iNumGroupAsMemberUser = (json["iNumGroupAsMemberUser"].asInt != nil) ? json["iNumGroupAsMemberUser"].asInt! : 0
        
          user.nvLastBroadcastDate = (json["nvLastBroadcastDate"].asString != nil) ? json["nvLastBroadcastDate"].asString! : ""
        
  
        // user.dtLastBroadcastDate=self.getDateFromString(json["nvLastBroadcastDate"].asString!)
        return user
        
    }
    
    class func getUserDictionary(user: User) -> NSDictionary {
        var langDict: NSMutableArray = NSMutableArray()
        let str:String
        //FIXME 9.11.15
        for codVal in user.oLanguages {
            langDict.addObject(KeyValue.getKeyValueDictionary(codVal as! KeyValue))
        }
        
        
        if user.dtBirthDate != ""
        {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"/*find out and place date format from http://userguide.icu-project.org/formatparse/datetime*/
            let date = dateFormatter.dateFromString(user.dtBirthDate)
            if date == nil
            {
                let dateFormatter2 = NSDateFormatter()
                dateFormatter2.dateFormat = "MM/dd/yyyy"
                 let date = dateFormatter2.dateFromString(user.dtBirthDate)

            }
            if date != nil
            {
            let dateFormatter1 = NSDateFormatter()
            dateFormatter1.dateFormat = "MM/dd/yyyy"
            str = dateFormatter1.stringFromDate(date!)
            }
            else
            {
                str=""
            }

                  }
        else
        {
            str=""
        }
        var  params = ["nvFacebookUserId":user.nvFacebookUserId,"nvGoogleUserId":user.nvGoogleUserId,"iUserId":user.iUserId, "iUserType":user.iUserType, "nvFirstName":user.nvFirstName, "nvLastName":user.nvLastName, "nvEmail":user.nvEmail, "iUserStatusId":user.iUserStatusId, "nvPhone":user.nvPhone , "nvPhonePrefix":user.nvPhonePrefix, "nvAboutMe":user.nvAboutMe,"dtBirthDate":str, "oCountry":CodeValue.getCodeValueDictionary(user.oCountry), "iReligionId":user.iReligionId , "sReligion":user.sReligion, "iReligiousLevelId":user.iReligiousLevelId, "sReligiousLevel":user.sReligiousLevel, "nvProfession":user.nvProfession, "nvHobby":user.nvHobby, "nvImage":user.nvImage, "nvCreateDate":user.nvCreateDate, "oAddress":Address.getAddressDictionary(user.oAddress), "oUserMemberShip":UserMembership.getUserMembershipDictionary(user.oUserMemberShip), "iGenderId":user.iGenderId,"oLanguages":langDict,"oUserQuickBlox":UserQuickBlox.getUserQuickBloxDictionary(user.oUserQuickBlox),"nvTokenId":user.nvTokenId,"iDeviceTypeId":user.iDeviceTypeId,"nvShantiName":user.nvShantiName,"iNumGroupAsMainUser":user.iNumGroupAsMainUser,"iNumGroupAsMemberUser":user.iNumGroupAsMemberUser]
        //
        var userDics:NSMutableDictionary = ["newUser":params]
        return params
    }
    
    class func sighUpToXmpp(newUser: User){
        if newUser.oUserQuickBlox.ID == -1
        {
            dispatch_async(dispatch_get_main_queue(),
                {
                println("createSessionWithSuccessBlock")
                QBRequest.createSessionWithSuccessBlock({
                    response,session -> Void in
                    println("success! \(session)")
                    
                    var sighnUpUser: QBUUser = QBUUser()
                    sighnUpUser.login = newUser.nvEmail
                    sighnUpUser.password = "12345678"
                    
                    QBRequest.signUp(sighnUpUser, successBlock: {
                        response,user -> Void in
                        newUser.oUserQuickBlox.login = user.login
                        newUser.oUserQuickBlox.password = sighnUpUser.password
                        newUser.oUserQuickBlox.ID = Int(user.ID)
                        newUser.nvImage = ""
                        
                        println("oUserQuickBlox: \(newUser.oUserQuickBlox)")
                        newUser.nvImage = ""
                        //FIXME1.11
                        var userDics:NSMutableDictionary = ["newUser":User.getUserDictionary(newUser)]
                        Connection.connectionToService("UpdateUser", params:/* User.getUserDictionary(newUser)*/userDics, completion: {
                            data -> Void in
                            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                            println("UpdateUser with xmpp parameters:\(strData)")
                            
                        })
                        
                        }, errorBlock:
                        {
                            response -> Void in
                            println("register to xmpp fail")
                            var currView = (UIApplication.sharedApplication().windows[0] as! UIWindow).rootViewController! as! SWRevealViewController
                            if  let navCont = currView.frontViewController as? UINavigationController{
                                if let lastView: UIViewController = navCont.viewControllers[navCont.viewControllers.count - 1] as? UIViewController{
                                    var alert = UIAlertController(title: "שגיאה", message: "ארעה שגיאה בחיבורך לצאט של שאנטי", preferredStyle: UIAlertControllerStyle.Alert)
                                    alert.addAction(UIAlertAction(title: "נסה להתחבר שוב", style: UIAlertActionStyle.Cancel, handler: nil))
                                    User.sighUpToXmpp(newUser)
                                    alert.addAction(UIAlertAction(title: "בטל", style: UIAlertActionStyle.Default, handler:nil))
                                    lastView.presentViewController(alert, animated: true, completion: nil)
                                }
                            }
                            
                    })
                    
                    }, errorBlock: {response -> Void in
                        println("error: \(response.error)")
                        var currView = (UIApplication.sharedApplication().windows[0] as! UIWindow).rootViewController! as! SWRevealViewController
                        if  let navCont = currView.frontViewController as? UINavigationController{
                            if let lastView: UIViewController = navCont.viewControllers[navCont.viewControllers.count - 1] as? UIViewController{
//                                var alert = UIAlertController(title: "שגיאה", message: "ארעה שגיאה בחיבורי הצאט", preferredStyle: UIAlertControllerStyle.Alert)
                                 var alert = UIAlertController(title:NSLocalizedString("Error", comment: "") as String/*"שגיאה"*/, message:NSLocalizedString("The chat connections are not available, please try again later" , comment: "") as String /* "חיבורי הצ׳אט אינם זמינים, אנא נסה שוב מאוחר יותר"*/, preferredStyle: UIAlertControllerStyle.Alert)
//                                alert.addAction(UIAlertAction(title: "נסה להתחבר שוב", style: UIAlertActionStyle.Cancel, handler: nil))
                                User.sighUpToXmpp(newUser)
                                alert.addAction(UIAlertAction(title: NSLocalizedString("Cancellation" , comment: "") as String /*"בטל"*/, style: UIAlertActionStyle.Default, handler:nil))
                                lastView.presentViewController(alert, animated: true, completion: nil)
                            }
                        }
                        
                })
            })
        }
    }
    
    class func getUserImageBase64(stringUrl: String) -> UIImage{
        var url: NSURL = NSURL(string: stringUrl)!
        var userImg: UIImage = UIImage()
        if let data = NSData(contentsOfURL: url, options: nil, error: nil){
            let image = UIImage(data: data)
            var imageView: UIImageView = UIImageView(image: image)
            imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width/2, imageView.frame.size.height/2)
            userImg = UIImage(data: data)!
        }else{
            url = NSURL(string: "http://qa.webit-track.com/ShantiWS/Files/Users/marker_defualt.png")!
            if let data = NSData(contentsOfURL: url, options: nil, error: nil){
                let image = UIImage(data: data)
                var imageView: UIImageView = UIImageView(image: image)
                imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width/2, imageView.frame.size.height/2)
               userImg = UIImage(data: data)!
            }
        }
        return userImg
    }
    class func getDateFromString(string: String) -> NSDate{
        let dateFormatter = NSDateFormatter()//"yyyy-MM-dd'T'HH:mm:ssZZZZ"
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
        
        if(string.isEmpty)
        {
            var s:NSString="01/01/2000 01:01:01"
            return dateFormatter.dateFromString(s as String)!
        }
        let d:NSDate=dateFormatter.dateFromString(string)!
        
        return dateFormatter.dateFromString(string)!
    }
    
}




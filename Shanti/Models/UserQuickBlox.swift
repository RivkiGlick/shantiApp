//
//  UserQuickBlox.swift
//  Shanti
//
//  Created by hodaya ohana on 2/15/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

class UserQuickBlox: NSObject {
    var iUserId: Int = Int(0)
    var ID: Int = Int(-1)
    var login: String = String("")
    var password: String = String("")

    class func parsUserQuickBloxDictionary(dicJson: JSON) -> UserQuickBlox{
        var oUserQuickBlox: UserQuickBlox = UserQuickBlox()
        let json = JSON(dicJson)
        oUserQuickBlox.iUserId = (json["iUserId"].asInt != nil) ? json["iUserId"].asInt! : 0
        oUserQuickBlox.ID = (json["ID"].asInt != nil) ? json["ID"].asInt! : 0
        oUserQuickBlox.login = (json["login"].asString != nil) ? json["login"].asString! : ""
        oUserQuickBlox.password = (json["password"].asString != nil) ? json["password"].asString! : ""
        
        return oUserQuickBlox
    }
    
    class func getUserQuickBloxDictionary(oUserQuickBlox: UserQuickBlox) -> NSDictionary{
        var params = ["iUserId":oUserQuickBlox.iUserId,"ID":oUserQuickBlox.ID,"login":oUserQuickBlox.login,"password":oUserQuickBlox.password]
        return params
    }
}

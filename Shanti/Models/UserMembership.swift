//
//  UserMembership.swift
//  Shanti
//
//  Created by hodaya ohana on 1/15/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

class UserMembership: NSObject {
    var iUserId: Int = Int()
    var nvUserName: String = String()
    var nvUserPassword: String = String()
    var bIsLocked: Bool = Bool()
    
    override init() {
        super.init()
    }
    
    class func parsUserMembershipJson(dicJson: JSON) -> UserMembership {
        let json = JSON(dicJson)
        var userMembership: UserMembership = UserMembership()
        userMembership.iUserId = (json["iUserId"].asInt != nil) ? json["iUserId"].asInt! : 0
        userMembership.nvUserName = (json["nvUserName"].asString != nil) ? json["nvUserName"].asString! : ""
        userMembership.nvUserPassword = (json["nvUserPassword"].asString != nil) ? json["nvUserPassword"].asString! : ""
        userMembership.bIsLocked = (json["bIsLocked"].asString != nil) ? true : false
        return userMembership
    }
    
    class func getUserMembershipDictionary(userMembership: UserMembership) -> NSDictionary {
        var params = ["iUserId":userMembership.iUserId, "nvUserName":userMembership.nvUserName, "nvUserPassword":userMembership.nvUserPassword, "bIsLocked":userMembership.bIsLocked]
        return params
    }
}

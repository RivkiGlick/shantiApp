//
//  Group.swift
//  Shanti
//
//  Created by hodaya ohana on 2/23/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

class Group: NSObject {
    var iGroupId: Int = Int(-1)
    var nvGroupName: String = String("")
    var iGroupType: Int = Int(-1)
    var nvComment: String = String("")
    var dtCreateDate: String = String("")
    var iMainUserId: Int = Int(-1)
    var iNumOfMembers: Int = Int(1)
    var nvImage: String = String("")
    var UsersList: NSMutableArray = NSMutableArray()
    var nvQBDialogId: String = String("")
    var nvQBRoomJid: String = String("")
    
    override init() {
        super.init()
    }
    
    class func parseGroupDictionary(jsonDict: NSDictionary) -> Group{
        println("json: \(jsonDict)")
        var json = JSON(jsonDict)
        var group = Group()
        group.iGroupId = (json["iGroupId"].asInt != nil) ? json["iGroupId"].asInt! : 0
        group.nvGroupName = (json["nvGroupName"].asString != nil) ? json["nvGroupName"].asString! : ""
        group.iGroupType = (json["iGroupType"].asInt != nil) ? json["iGroupType"].asInt! : 0
        group.nvComment = (json["nvComment"].asString != nil) ? json["nvComment"].asString! : ""
        group.dtCreateDate = (json["dtCreateDate"].asString != nil) ? json["dtCreateDate"].asString! : ""
        group.iMainUserId = (json["iMainUserId"].asInt != nil) ? json["iMainUserId"].asInt! : 0
        group.iNumOfMembers = (json["iNumOfMembers"].asInt != nil) ? json["iNumOfMembers"].asInt! : 0
        group.nvImage = (json["nvImage"].asString != nil) ? json["nvImage"].asString! : ""
        group.nvQBDialogId = (json["nvQBDialogId"].asString != nil) ? json["nvQBDialogId"].asString! : ""
        group.nvQBRoomJid = (json["nvQBRoomJid"].asString != nil) ? json["nvQBRoomJid"].asString! : ""
        
        if let usersArry: NSArray? = jsonDict.valueForKey("UsersList") as? NSArray{
            if usersArry != nil{
                for userDict in usersArry!{
                    group.UsersList.addObject(User.parseUserJson(JSON(userDict)))
                }
            }
        }
        
        return group
    }
    class func getGroupDictionary(currGroup: Group) -> NSDictionary{
        var groupDict: NSDictionary!
        
        var usersDict: NSMutableArray = NSMutableArray()
        
        if currGroup.UsersList.count>0
        {
        for currUser in currGroup.UsersList{
            
            //FIXME:add class new user4.11.15
            var userDics:NSDictionary = ["newUser":User.getUserDictionary (currUser as! User)]
            println("userDics:\(userDics)")
            //            var currDict = User.getUserDictionary(currUser as! User)
            usersDict.addObject(userDics)
        }
        }
        groupDict = ["iGroupId":currGroup.iGroupId,"nvGroupName":currGroup.nvGroupName,"nvComment":currGroup.nvComment,"iGroupType":currGroup.iGroupType,"dtCreateDate":currGroup.dtCreateDate,"iMainUserId":currGroup.iMainUserId,"iNumOfMembers":currGroup.iNumOfMembers,"nvImage":currGroup.nvImage,"UsersList":usersDict,"nvQBDialogId":currGroup.nvQBDialogId,"nvQBRoomJid":currGroup.nvQBRoomJid]
        
        return groupDict
        
    }

//    class func getGroupDictionary(currGroup: Group) -> NSDictionary{
//        var groupDict: NSDictionary!
//       
//        var usersDict: NSMutableArray = NSMutableArray()
//        for currUser in currGroup.UsersList{
//            //FIXME1.11
//            var userDics:NSMutableDictionary = ["newUser":User.getUserDictionary(currUser as! User)]
//
//            var currDict = userDics/*User.getUserDictionary(currUser as! User)*/
//            usersDict.addObject(currDict["newUser"] as! NSDictionary)
//        }
//        
//        groupDict = ["iGroupId":currGroup.iGroupId,"nvGroupName":currGroup.nvGroupName,"nvComment":currGroup.nvComment,"iGroupType":currGroup.iGroupType,"dtCreateDate":currGroup.dtCreateDate,"iMainUserId":currGroup.iMainUserId,"iNumOfMembers":currGroup.iNumOfMembers,"nvImage":currGroup.nvImage,"UsersList":usersDict,"nvQBDialogId":currGroup.nvQBDialogId,"nvQBRoomJid":currGroup.nvQBRoomJid]
//        
//        return groupDict
//    }
}
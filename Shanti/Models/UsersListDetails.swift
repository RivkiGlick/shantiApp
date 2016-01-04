//
//  UsersListDetails.swift
//  Shanti
//
//  Created by hodaya ohana on 4/20/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

class UsersListDetails: NSObject {
    var users:[User] = []
    var usersDetails: String = String("")
    var meetingPoints: [MeetingPoint] = []
    
    class func parsUsersListDetailsDict(jsonDict: NSDictionary)->UsersListDetails{
        var usersListDetails = UsersListDetails()
        var json = JSON(jsonDict)
        if let usersDict = jsonDict.valueForKey("users") as? NSArray{
            for userDict in usersDict{
                usersListDetails.users.append(User.parseUserJson(JSON(userDict)) as User)
            }
        }
        
        if let meetingPointsDict = jsonDict.valueForKey("meetingPoints") as? NSArray{
            for meetingPoint in meetingPointsDict{
                usersListDetails.meetingPoints.append(MeetingPoint.parsMeetingPointDict(meetingPoint as! NSDictionary))
            }
        }

        usersListDetails.usersDetails = (json["usersDetails"].asString != nil) ? json["usersDetails"].asString! : ""
        
        return usersListDetails
    }
}

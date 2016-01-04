//
//  MeetingPoint.swift
//  Shanti
//
//  Created by hodaya ohana on 4/29/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

class MeetingPoint: NSObject {
    var iMeetingPointId: Int = Int(-1)
    var iGroupId: Int = Int(-1)
    var oLocation: Location = Location()
    var dtMeetingTime: String = String()
    var nvTitle: String = String()
    var nvComment: String = String()
    
    class func parsMeetingPointDict(dict: NSDictionary)->MeetingPoint{
        var meetingPoint: MeetingPoint = MeetingPoint()
        var json = JSON(dict)
        
        meetingPoint.iMeetingPointId = (json["iMeetingPointId"].asInt != nil) ? json["iMeetingPointId"].asInt! : -1
        meetingPoint.iGroupId = (json["iGroupId"].asInt != nil) ? json["iGroupId"].asInt! : -1
        meetingPoint.oLocation = Location.parseLocationJson(JSON(dict.valueForKey("oLocation") as! NSDictionary))
        meetingPoint.dtMeetingTime = (json["dtMeetingTime"].asString != nil) ? json["dtMeetingTime"].asString! : ""
        meetingPoint.nvTitle = (json["nvTitle"].asString != nil) ? json["nvTitle"].asString! : ""
        meetingPoint.nvComment = (json["nvComment"].asString != nil) ? json["nvComment"].asString! : ""
        
        return meetingPoint
    }
    
    class func getMeetingPointDict(meetingPoint: MeetingPoint)-> NSDictionary{
        var dict = ["iMeetingPointId":meetingPoint.iMeetingPointId,"iGroupId":meetingPoint.iGroupId,"oLocation":Location.getLocationDictionary(meetingPoint.oLocation),"dtMeetingTime":meetingPoint.dtMeetingTime,"nvTitle":meetingPoint.nvTitle,"nvComment":meetingPoint.nvComment]
        return dict
    }
}

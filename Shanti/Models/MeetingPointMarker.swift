//
//  MeetingPointMarker.swift
//  Shanti
//
//  Created by hodaya ohana on 5/6/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit
//import GoogleMaps

private let markerImg = UIImage(named: "marker_meeting")

class MeetingPointMarker: GMSMarker {
    var meetingPoint: MeetingPoint = MeetingPoint()
    var markerImage : UIImage?{
        set{
            super.icon = self.markerImage
        }get{
            return super.icon
        }
    }
    override init() {
        super.init()
    }

    init(meetingPoint: MeetingPoint) {
        super.init()
        
        self.meetingPoint = meetingPoint
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        var meetingHour = self.meetingPoint.dtMeetingTime.substringWithRange(Range<String.Index>(start: advance(self.meetingPoint.dtMeetingTime.endIndex, -8), end: advance(self.meetingPoint.dtMeetingTime.endIndex,0)))
        meetingHour = meetingHour.substringWithRange(Range<String.Index>(start: advance(meetingHour.startIndex, 0), end: advance(meetingHour.endIndex,-3)))
//        self.icon = ImageProcessor.drawText(meetingHour, inImage: markerImg, atPoint: CGPointMake(10,25))
        self.icon = ImageHandler.drawText(meetingHour, inImage: markerImg!, atPoint:  CGPointMake(10,25))
    }
}

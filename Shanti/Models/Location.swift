//
//  Location.swift
//  Shanti
//
//  Created by hodaya ohana on 1/20/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

class Location: NSObject {
    var dLatitude: Double = Double()
    var dLongitude: Double = Double()
    var iDriverId: Int = Int()
    
     override init() {
        super.init()
    }
    
    class func parseLocationJson(dicJson: JSON) -> Location{
        let json = JSON(dicJson)
        var location = Location()
        location.dLatitude = (json["dLatitude"].asDouble != nil) ? json["dLatitude"].asDouble! : 0
        location.dLongitude = (json["dLongitude"].asDouble != nil) ? json["dLongitude"].asDouble! : 0
        location.iDriverId = (json["iDriverId"].asInt != nil) ? json["iDriverId"].asInt! : 0
        return location
    }
    
    class func getLocationDictionary(location: Location) -> NSDictionary {
        var params: NSDictionary = NSDictionary()
        params = ["dLatitude":location.dLatitude , "dLongitude":location.dLongitude , "iDriverId":location.iDriverId]
        return params
    }
}

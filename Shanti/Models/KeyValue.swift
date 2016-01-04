//
//  KeyValue.swift
//  Shanti
//
//  Created by hodaya ohana on 3/19/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

enum NOTIFICATION_TYPE: Int {
    case NOTIFICATION_TYPE_NEW_MESSAGE_GROUP = 0
    case NOTIFICATION_TYPE_NEW_MESSAGE_PRIVATE = 1
    case NOTIFICATION_TYPE_APPROVAL_GROUP = 2
    case NOTIFICATION_TYPE_GLOBAL_MESSAGE = 3
}

class KeyValue: NSObject {
    
    var nvKey: String = String()
    var nvValue: String = String()
    //FIXME:prefix
    var nvValueParam: String = String()
    class func getKeyValueDictionary(keyVal: KeyValue) -> NSMutableDictionary{
        var params: NSMutableDictionary = NSMutableDictionary()
        
        params = ["nvKey":keyVal.nvKey,"nvValue":keyVal.nvValue]
        return params
    }
    
    class func parsKeyValueDict(json: JSON) -> KeyValue{
        var keyValue = KeyValue()
        keyValue.nvValue = (json["nvValue"].asString != nil) ? json["nvValue"].asString! : ""
        keyValue.nvKey = (json["nvKey"].asString != nil) ? json["nvKey"].asString! : ""
        
        return keyValue
    }
    //FIXME:prefix
    class func parsKeyValueDictPrefix(json: JSON) -> KeyValue{
        var keyValue = KeyValue()
        keyValue.nvValue = (json["nvValue"].asString != nil) ? json["nvValue"].asString! : ""
        keyValue.nvKey = (json["nvKey"].asString != nil) ? json["nvKey"].asString! : ""
        keyValue.nvValueParam = (json["nvValueParam"].asString != nil) ? json["nvValueParam"].asString! : ""
        return keyValue
    }

}

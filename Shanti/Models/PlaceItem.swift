//
//  PlaceItem.swift
//  Shanti
//
//  Created by hodaya ohana on 3/29/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

class PlaceItem: NSObject {
    var iPlaceItemId:Int  = Int(-1)
    var nvPlaceName: String = String("")
    var nvGoogleType: String = String("")

    class func parsPlaceItemJson(json: JSON) -> PlaceItem{
        var currPlaceItem = PlaceItem()
        currPlaceItem.iPlaceItemId = (json["iPlaceItemId"].asInt != nil) ? json["iPlaceItemId"].asInt! : -1
        currPlaceItem.nvPlaceName = (json["nvPlaceName"].asString != nil) ? json["nvPlaceName"].asString! : ""
        currPlaceItem.nvGoogleType = (json["nvGoogleType"].asString != nil) ? json["nvGoogleType"].asString! : ""
        return currPlaceItem
    }
}

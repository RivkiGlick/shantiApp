//
//  PlaceCategory.swift
//  Shanti
//
//  Created by hodaya ohana on 3/29/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

class PlaceCategory: NSObject {
    var iPlaceCategoryId: Int = Int(-1)
    var nvPlaceName: String = String("")
    var nvFontCode: String = String("")
    var nvFontName: String = String("")
    var lPlaceItems: [PlaceItem] = []
    
    class func parsPlaceCategoryJson(jsonDict: NSDictionary) -> PlaceCategory{
        var json = JSON(jsonDict)
        var currPlaceCategory = PlaceCategory()
        currPlaceCategory.iPlaceCategoryId = (json["iPlaceCategoryId"].asInt != nil) ? json["iPlaceCategoryId"].asInt! : -1
        currPlaceCategory.nvPlaceName = (json["nvPlaceName"].asString != nil) ? json["nvPlaceName"].asString! : ""
        currPlaceCategory.nvFontCode = (json["nvFontCode"].asString != nil) ? json["nvFontCode"].asString! : ""
        currPlaceCategory.nvFontName = (json["nvFontName"].asString != nil) ? json["nvFontName"].asString! : ""
        
        if let placesItems: NSArray? = jsonDict.valueForKey("lPlaceItems") as? NSArray{
            if placesItems != nil{
                for placeItemDict in placesItems!
                {
                    var currPlaceItem = PlaceItem.parsPlaceItemJson(JSON(placeItemDict))
                    currPlaceCategory.lPlaceItems.append(currPlaceItem)
                }
            }
        }
        
        
        return currPlaceCategory
    }
}

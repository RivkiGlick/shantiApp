//
//  UserSearchDef.swift
//  Shanti
//
//  Created by hodaya ohana on 1/22/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

class UserSearchDef: NSObject
{
    var iUserSearchDefId: Int = Int()
    var iUserId: Int = Int()
    var iAgeRangeId: Int = Int(-1)
    var Countries: [Int] = []
    var iReligionId: Int = Int(-1)
    var iReligionLevelId: Int = Int(-1)
    var iGenderId: Int = Int(-1)
    var iRadiusId: Int = Int((ApplicationData.sharedApplicationDataInstance.radiusArry[ApplicationData.sharedApplicationDataInstance.radiusArry.count - 1] as! CodeValue).iKeyId)
    var nvComment: Int = Int()
    var bCheckLanguages: Bool = false

    class func getUserSearchDefDict(userDef: UserSearchDef) -> NSDictionary{
        var countriesArry = NSMutableArray()
        
        for (index, element) in enumerate(userDef.Countries){
            countriesArry.addObject(element)
        }
        
        var userSettingsDict = ["iUserSearchDefId":userDef.iUserSearchDefId,"iUserId":userDef.iUserId,"iAgeRangeId":userDef.iAgeRangeId,"Countries":countriesArry,"iReligionId":userDef.iReligionId,"iReigionLevelId":userDef.iReligionLevelId,"iGenderId":userDef.iGenderId,"nvComment":userDef.nvComment,"bCheckLanguages":userDef.bCheckLanguages,"iRadiusId":userDef.iRadiusId]
        return userSettingsDict
    }
}

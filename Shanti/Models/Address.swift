//
//  Address.swift
//  Shanti
//
//  Created by hodaya ohana on 1/15/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

class Address: NSObject {
    var iAddressId: Int = Int(-1)
    var nvFullAddress: String = String()
    var nvCity: String = String()
    var nvStreet: String = String()
    
    override init(){
        super.init()
    }
    
    class func parsAddressJson(dicJson: JSON) -> Address {
        let json = JSON(dicJson)
        var address: Address = Address()
        address.iAddressId = (json["iAddressId"].asInt != nil) ? json["iAddressId"].asInt! : 0
        address.nvFullAddress = (json["nvFullAddress"].asString != nil) ? json["nvFullAddress"].asString! : ""
        address.nvCity = (json["nvCity"].asString != nil) ? json["nvCity"].asString! : ""
        address.nvStreet = (json["nvStreet"].asString != nil) ? json["nvStreet"].asString! : ""
        return address
    }
    
    class func getAddressDictionary(address: Address) -> NSDictionary{
        var params = ["iAddressId": address.iAddressId, "nvFullAddress":address.nvFullAddress, "nvCity":address.nvCity, "nvStreet":address.nvStreet]
        return params
    }
}

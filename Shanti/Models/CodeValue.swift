//
//  CodeValue.swift
//  Shanti
//
//  Created by hodaya ohana on 1/19/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

class CodeValue: NSObject {
    var iKeyId: Int = Int()
    var nvValue: String = String()
    var iTableId: Int = Int()
    override init() {
        super.init()
    }
    
    class func parsCodeValueJson(dicJson: JSON) -> CodeValue {
        var codeValue: CodeValue = CodeValue()
        codeValue.iKeyId = (dicJson["iKeyId"].asInt != nil) ? dicJson["iKeyId"].asInt! : -1
        codeValue.nvValue = (dicJson["nvValue"].asString != nil) ? dicJson["nvValue"].asString! : ""
        codeValue.iTableId = (dicJson["iTableId"].asInt != nil) ? dicJson["iTableId"].asInt! : -1
        
        return codeValue
    }
    
    class func getCodeValueDictionary(codVal: CodeValue) -> NSDictionary {
        var params = ["iKeyId":codVal.iKeyId,"iTableId":codVal.iTableId,"nvValue":codVal.nvValue]
        return params
    }
}

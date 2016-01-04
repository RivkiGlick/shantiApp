//
//  ApplicationData.swift
//  Shanti
//
//  Created by hodaya ohana on 2/1/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit
let COUNTRIES_ID = 16
let LANGUAGE_ID = 11
let RELIGIONS_ID = 12
let AGE_RANGE_ID = 13
let RELIGION_LEVEL_ID = 14
let RADIUS_ID = 17
let GENDER_ID = 20
let GROUP_ID = 18
let I_DEVICE_TYPE_ID = 455
let HEBROW_LANGUAGE = "iw_IL"
let ENGLISH_LANGUAGE = "en_US"
let PrefixTbl_ID = 16

private let ApplicationDataInstance = ApplicationData()
 class ApplicationData: NSObject {
    
    var countriesArry: NSMutableArray = NSMutableArray()
    var languageArry: NSMutableArray = NSMutableArray()
    var religionsArry: NSMutableArray = NSMutableArray()
    var religionLevelArry: NSMutableArray = NSMutableArray()
    var ageRangeArry: NSMutableArray = NSMutableArray()
    var gendersArry: NSMutableArray = NSMutableArray()
    var radiusArry: NSMutableArray = NSMutableArray()
    var groupsArry: [CodeValue] = []

    
    //FIXME: Prefix
    var countryPrefixArray: NSMutableArray = NSMutableArray()
    class var sharedApplicationDataInstance: ApplicationData{
        return ApplicationDataInstance
    }
    
    func getNeededTablesFromServer(){
        
        var preferredLanguage = NSLocale.preferredLanguages()[0] as! String
        
        var langID = NSLocale.preferredLanguages()[0] as! String
        var reg:String
        var regId:Int
        if langID=="en"
        {
            reg="_US"
            regId=1
        }
        else
        {
            langID="iw"//לשאול את בת שבע אם יכולה לשנות עברית לhe
            preferredLanguage="iw"
            reg="_IL"
            regId=2
            
        }
        let language = "\(preferredLanguage)\(reg)"
        var nvLanguage:String = language
        
        
        dispatch_async(dispatch_get_main_queue(),{
            Connection.connectionToService("GetCodeTable", params: ["TableId":COUNTRIES_ID,"nvLanguage":nvLanguage], completion: {
                data -> Void in
                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("countriesArry GetCodeTable:\(strData)")
                var err: NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSArray;
                
                if (json != nil) {
                    for dict in json!{
                        self.countriesArry.addObject(CodeValue.parsCodeValueJson(JSON(dict)) as CodeValue)
                    }
                    
                }
            })
            Connection.connectionToService("GetLanguagesCodeTable", params: ["nvLanguage":preferredLanguage], completion: {
                data -> Void in
                
                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("languageArry GetCodeTable:\(strData)")
                var err: NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSArray;
                
                if (json != nil) {
                    for dict in json!{
                        
                        self.languageArry.addObject(KeyValue.parsKeyValueDict(JSON(dict)) as KeyValue)
                        
                        
                    }
                    
                }
            })
            //FIXME 9.11.15
            Connection.connectionToService("GetCodeTable", params: ["TableId":RELIGIONS_ID,"nvLanguage":nvLanguage], completion: {
                data -> Void in
                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("religionsArry GetCodeTable:\(strData)")
                var err: NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSArray;
                
                if (json != nil) {
                    for dict in json!{
                        self.religionsArry.addObject(CodeValue.parsCodeValueJson(JSON(dict)) as CodeValue)
                    }
                    
                }
            })
            
            Connection.connectionToService("GetCodeTable", params: ["TableId":RELIGION_LEVEL_ID,"nvLanguage":nvLanguage], completion: {
                data -> Void in
                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("religionLevelArry GetCodeTable:\(strData)")
                var err: NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSArray;
                
                if (json != nil) {
                    for dict in json!{
                        self.religionLevelArry.addObject(CodeValue.parsCodeValueJson(JSON(dict)) as CodeValue)
                    }
                    
                }
            })
            
            Connection.connectionToService("GetCodeTable", params: ["TableId":AGE_RANGE_ID,"nvLanguage":nvLanguage], completion: {
                data -> Void in
                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("ageRangeArry GetCodeTable:\(strData)")
                var err: NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSArray;
                
                if (json != nil) {
                    for dict in json!{
                        self.ageRangeArry.addObject(CodeValue.parsCodeValueJson(JSON(dict)) as CodeValue)
                    }
                }
            })
            
            Connection.connectionToService("GetCodeTable", params: ["TableId":RADIUS_ID,"nvLanguage":nvLanguage], completion: {
                data -> Void in
                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("radiusArry GetCodeTable:\(strData)")
                var err: NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSArray;
                
                if (json != nil) {
                    for dict in json!{
                        self.radiusArry.addObject(CodeValue.parsCodeValueJson(JSON(dict)) as CodeValue)
                    }
                }
            })
            
            Connection.connectionToService("GetCodeTable", params: ["TableId":GENDER_ID,"nvLanguage":nvLanguage], completion: {
                data -> Void in
                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("gendersArry GetCodeTable:\(strData)")
                var err: NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSArray;
                
                if (json != nil) {
                    for dict in json!{
                        self.gendersArry.addObject(CodeValue.parsCodeValueJson(JSON(dict)) as CodeValue)
                    }
                }
            })
            
            Connection.connectionToService("GetCodeTable", params: ["TableId":GROUP_ID,"nvLanguage":nvLanguage], completion: {
                data -> Void in
                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("groupsArry GetCodeTable:\(strData)")
                var err: NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSArray;
                
                if (json != nil) {
                    for dict in json!
                    {
                        self.groupsArry.append(CodeValue.parsCodeValueJson(JSON(dict)))
                    }
                }
            })
            //FIXME: Prefix
            
            if   self.countryPrefixArray.count == 0
            {
                Connection.connectionToService("GetCodeTableParam", params: ["TableId":PrefixTbl_ID,"nvLanguage":regId], completion: {
                    data -> Void in
                    var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("countryPrefixArray GetCodeTable:\(strData)")
                    var err: NSError?
                    var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSArray;
                    if self.countryPrefixArray.count==213
                    {
                        
                    }
                    else
                    {
                        if (json != nil) {
                            for dict in json!{
                                self.countryPrefixArray.addObject(KeyValue.parsKeyValueDictPrefix(JSON(dict)) as KeyValue)
                            }
                            
                        }
                    }
                })
            }
            
        })
        
    }
}

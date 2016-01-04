//
//  Connection.swift
//  ShabatGuest
//
//  Created by Racheli Kroiz on 11/12/14.
//  Copyright (c) 2014 Racheli Kleinhendler. All rights reserved.
//

import UIKit

#if DEBUG
    //QA
let SERVICE_URL = "http://qa.webit-track.com/ShantiWS/Service1.svc/"
    #else
    let SERVICE_URL = "http://www.shantiapp.com/ws/Service1.svc/"
#endif

//let apiKey = "AIzaSyBgiTdAP1ag66xnnkNcEmOspMX63_ZW_QI"
//let apiKey = "AIzaSyAV73uSyjIFLmyq7sJaGRvK5AbNEjjQ5wk" //Shant1
//let apiKey = "AIzaSyCQAv6DSn7Co_aDMat1sqLHko7V1xQxo6E" //shantiApple
let apiKey = "AIzaSyAfSHQ1Sp-Wd9M7ik47i0TVTweFPl1yIss" //ShantiAppServerkey

var placesTask = NSURLSessionDataTask()
var session: NSURLSession {
    return NSURLSession.sharedSession()
}

class Connection: NSObject {
    
    
    class func connectionToService(function:String , params : NSDictionary? ,completion:((NSData)-> Void) ) {
        println("\(params)")
        var request = NSMutableURLRequest(URL: NSURL(string: "\(SERVICE_URL)\(function)")!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 120)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        var err: NSError?
        if let data = params{
            request.HTTPBody = NSJSONSerialization.dataWithJSONObject(data, options: nil, error: &err)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        var task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            if let err = error {
                println("err:\(err),error:\(error)")
                return
            }
            // Move to the UI thread
            dispatch_async(dispatch_get_main_queue(),{
                completion(data)
            })
            
        })
        
        task.resume()
        
        //        var dict = ["ProjectName":"Shanti","FunctionName":function,"ToUTL":SERVICE_URL]
        //        Connection.writeToWebitLog(dict, completion: {
        //            data -> Void in
        //            println("finish writeToWebitLog")
        //        })
    }
    
    class func locationToService(function:String , params : NSDictionary? ,completion:((NSData)-> Void) ) {
        //        println("\(params)")
        var request = NSMutableURLRequest(URL: NSURL(string: "\(SERVICE_URL)\(function)")!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 120.0)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        var err: NSError?
        if let data = params{
            request.HTTPBody = NSJSONSerialization.dataWithJSONObject(data, options: nil, error: &err)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        var task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            if let err = error {
                return
            }
            // Move to the UI thread
            //            dispatch_async(dispatch_get_main_queue(),{
            completion(data)
            //            })
            
        })
        
        task.resume()
    }
    
    class func getPlacesInformationFromGooglePlace(coordinate: CLLocationCoordinate2D, radius: Double, searchKeyWord:String, completion:((NSData)-> Void) ){
        var urlString = "https://maps.googleapis.com/maps/api/place/search/json?keyword=\(searchKeyWord)&location=\(coordinate.latitude),\(coordinate.longitude)&radius=\(radius)&key=\(apiKey)"
        var request = NSMutableURLRequest(URL: NSURL(string: urlString)!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 120.0)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        var err: NSError?
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        var task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            if let err = error {
                return
            }
            // Move to the UI thread
            dispatch_async(dispatch_get_main_queue(),{
                completion(data)
            })
            
        })
        
        task.resume()
    }
    
    class func featchPlaceDetailsFromGoogle(placeId: String, language: String,completion:((NSData)-> Void)){
        var urlString = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeId)&key=\(apiKey)&language=\(language)"
        println("urlString:\(urlString)")
        var request = NSMutableURLRequest(URL: NSURL(string: urlString)!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 120.0)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        var err: NSError?
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        var task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            if let err = error {
                return
            }
            // Move to the UI thread
            dispatch_async(dispatch_get_main_queue(),{
                completion(data)
            })
            
        })
        
        task.resume()
    }
    
    class func featchPlacePhotoFromGoogle(maxwidth: Int, photoReference: String,completion:((NSData)-> Void)){
        var urlString = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=\(maxwidth)&photoreference=\(photoReference)&key=\(apiKey)"
        
        println("urlString:\(urlString)")
        var request = NSMutableURLRequest(URL: NSURL(string: urlString)!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 120.0)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        var err: NSError?
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        var task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            if let err = error {
                return
            }
            // Move to the UI thread
            //            dispatch_async(dispatch_get_main_queue(),{
            completion(data)
            //            })
            
        })
        
        task.resume()
    }
    
    class func writeToWebitLog( params : NSDictionary? ,completion:((NSData)-> Void) ){
        let webitLogsUrl = "http://qa.webit-track.com/WebitLogs/LogService.svc/"
        let function = "WriteLog"
        var request = NSMutableURLRequest(URL: NSURL(string: "\(webitLogsUrl)\(function)")!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 120)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        var err: NSError?
        if let data = params{
            request.HTTPBody = NSJSONSerialization.dataWithJSONObject(data, options: nil, error: &err)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        var task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            if let err = error {
                println("err:\(err),error:\(error)")
                return
            }
            
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("WriteLog:\(strData)")
            
        })
        
        task.resume()
    }
    
    class func calculateRoutes(f: CLLocationCoordinate2D, t: CLLocationCoordinate2D,completion:((NSData)-> Void)){

                var saddr = String("\(f.latitude),\(f.longitude)")
                var daddr = String("\(t.latitude),\(t.longitude)")
        

        var request = NSMutableURLRequest(URL: NSURL(string: "http://maps.googleapis.com/maps/api/directions/json?origin=\(saddr)&destination=\(daddr)&mode=walking&sensor=true,&language=he-IL")!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 120.0)
                var session = NSURLSession.sharedSession()
                request.HTTPMethod = "POST"
                var err: NSError?
        
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                var task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
        
                    if let err = error {
                        return
                    }
        
                    // Move to the UI thread
                    dispatch_async(dispatch_get_main_queue(),{
                        completion(data)
                    })
        
                })
        
                task.resume()
    }
    
    class func getArrivalTime(src: CLLocationCoordinate2D, dest: CLLocationCoordinate2D,completion:((NSData)-> Void)){
        var saddr = String("\(src.latitude),\(src.longitude)")
        var daddr = String("\(dest.latitude),\(dest.longitude)")
        
        var request = NSMutableURLRequest(URL: NSURL(string: "http://maps.googleapis.com/maps/api/directions/json?origin=\(saddr)&destination=\(daddr)&mode=walking&sensor=true,&language=he-IL")!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 120.0)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        var err: NSError?
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        var task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            if let err = error {
                return
            }
            
            // Move to the UI thread
            dispatch_async(dispatch_get_main_queue(),{
                completion(data)
            })
            
        })
        
        task.resume()
    }
    
}


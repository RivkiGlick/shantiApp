//
//  LocationsHandler.swift
//  Shanti
//
//  Created by hodaya ohana on 2/2/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

protocol LocationsHandlerDelegate{
    func didUpdateLocation(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    func didUpdateUsersList(usersDict: NSMutableDictionary)
}

class LocationsHandler: NSObject,CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var timeInterval: NSTimer!
    var delegate: LocationsHandlerDelegate?
    var locationsIdentifier: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier()
    var isActive = false
    
    override init(){
        super.init()
        self.setSettings()
    }
    
    func setSettings(){
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func beginBackgroundUpdateTask() -> UIBackgroundTaskIdentifier {
        return UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({})
    }
    
    func startRunning(){
//        locationsIdentifier = self.beginBackgroundUpdateTask()
//        UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({
//            handler -> Void in
        var locationsUpdatesThreasd: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//        dispatch_async(locationsUpdatesThreasd,{
            self.isActive = true
//            while (self.isActive){
                if (UIDevice.currentDevice().systemVersion as NSString).doubleValue >= 8{
                    self.locationManager.requestWhenInUseAuthorization()
                    self.locationManager.startUpdatingLocation()
                }else{
                    self.locationManager.startUpdatingLocation()
                }
//            }
//        })
    }
    
    func stopRunning(){
        UIApplication.sharedApplication().endBackgroundTask(locationsIdentifier)
       self.isActive = false
        if timeInterval != nil{
            timeInterval.invalidate()
        }
        
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse{
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation{
            if self.timeInterval == nil{
                self.timeInterval = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "updateUserLocationInServer", userInfo: nil, repeats: true)
            }
            
            //location.coordinate
            ActiveUser.sharedInstace.oLocation.dLatitude = location.coordinate.latitude
            ActiveUser.sharedInstace.oLocation.dLongitude = location.coordinate.longitude
            
            println(("lat: \(location.coordinate.latitude) long:\(location.coordinate.longitude)"))
            self.delegate?.didUpdateLocation(manager, didUpdateLocations: locations)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println(error)
        var alert = UIAlertController(title: "Error", message: "An error accurate\nPlease check youre GPS connection", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
//        self.presentViewController(alert, animated: true, completion: nil)
    }

    func updateUserLocationInServer(){
        let date = NSDate()
        print("SetLocationGetUsersList date:\(date)")
        let dict = Location.getLocationDictionary(ActiveUser.sharedInstace.oLocation)
        print("dict:\(dict)")
        Connection.connectionToService("SetLocationGetUsersList", params: Location.getLocationDictionary(ActiveUser.sharedInstace.oLocation), completion: { data -> Void in
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("SetLocationGetUsersList:\(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSArray
            
            println("json: \(json)")
            
            if (json != nil) {
                self.updateUsersList(json)
            }
        })
    }
    
    func updateUsersList(jsonDict: NSArray?){
        print("usesList:\(jsonDict)")
        var usersDict: NSMutableDictionary = NSMutableDictionary()
        for userDict in jsonDict! {
            var curUser: User = User.parseUserJson(JSON(userDict)) as User
            usersDict.setObject(curUser, forKey: curUser.iUserId)
        }
        
        self.delegate?.didUpdateUsersList(usersDict)
    }
}

private let singletonInstance = LocationsHandler()
class SharedLocationsHandler: LocationsHandler{
    class var sharedInstace: LocationsHandler{
        return singletonInstance
    }
}

//
//  MainPage.swift
//  Shanti
//
//  Created by hodaya ohana on 12/29/14.
//  Copyright (c) 2014 webit. All rights reserved.
//

import UIKit
//import GoogleMaps


class MainPage: GlobalViewController,CLLocationManagerDelegate,GMSMapViewDelegate,ActiveUserDelegate,MainInfoViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var underLineView: UIView!
    @IBOutlet weak var imgTraingle: UIImageView!
    @IBOutlet weak var lblUnderLine: UILabel!
    
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var everyOneBtn: UIButton!
    @IBOutlet weak var groupsBtn: UIButton!
    
    var userInfoView: MainInfoViewController!
    var meetingView :MeetingPointViewController!
    
    //    var barView: UIView!
    let locationManeger = CLLocationManager()
    var usersList: NSMutableDictionary = NSMutableDictionary()
    var usersDict: NSMutableDictionary = NSMutableDictionary()
    var usersMarkers: NSMutableDictionary = NSMutableDictionary()
    var meetingPointsDict: NSMutableDictionary = NSMutableDictionary()
    var meetingPointsMarkers: NSMutableDictionary = NSMutableDictionary()
    
    var plusBtn: UIButton!
    //    var groupsBtn: UIButton!
    //    var everyOneBtn: UIButton!
    var btnInformation: UIBarButtonItem!
    var btnMsg: UIBarButtonItem!
    var btnMenu: UIBarButtonItem!
    var btnGps: UIBarButtonItem!//UIButton!
    var gpsSettingsBtn = UIButton()
    let myLocationMarker: ShantiMarker = ShantiMarker(user: ActiveUser.sharedInstace)
    var mapViewCameraFlg = true
    var timeInterval: NSTimer!
    
    var flg = true
    var alertTxtField: UITextField = UITextField()
    var gpsOff = false
    
    var cameFromNotification: Bool = false
    var userInfo: [NSObject : AnyObject]?
    var notificationInterval: NSTimer!
    
    var generic = Generic()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        meetingView = self.storyboard?.instantiateViewControllerWithIdentifier("MeetingPointViewControllerId") as! MeetingPointViewController
        userInfoView = self.storyboard?.instantiateViewControllerWithIdentifier("MainInfoViewControllerId") as! MainInfoViewController
        
        locationManeger.delegate = self
        locationManeger.desiredAccuracy = kCLLocationAccuracyBest
        if (UIDevice.currentDevice().systemVersion as NSString).doubleValue >= 8{
            locationManeger.requestWhenInUseAuthorization()
            locationManeger.startUpdatingLocation()
        }else{
            locationManeger.startUpdatingLocation()
        }
        
        self.mapView.delegate = self
        
        userInfoView.delegate = self
        ActiveUser.sharedInstace.delegate = self
        userInfoView.view.frame = CGRectMake(0, UIScreen.mainScreen().bounds.height - 149 , UIScreen.mainScreen().bounds.width, 105)
        self.view.addSubview(userInfoView.view)
        userInfoView.user = ActiveUser.sharedInstace
        myLocationMarker.didTapMarker()
        
        mapView.settings.myLocationButton = true
        mapView.myLocationEnabled = true
        
        if self.cameFromNotification{
            self.notificationInterval = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "handleNotificationInBackgroundAndInactiveModes", userInfo: nil, repeats: true)
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.meetingView.view.removeFromSuperview()
    }
    
    override func viewWillLayoutSubviews(){
        //self.addSubviewsSettings()
        self.setSubviewsFrames()
        
    }
    override func viewWillAppear(animated: Bool) {
        
        self.addSubviewsSettings()
    }
    
    func addSubviewsSettings(){
        self.addNavigationSettings()
        self.addBarView()
        
        self.gpsSettingsBtn = UIButton()
        self.gpsSettingsBtn.setTitle("", forState: UIControlState.Normal)
        self.gpsSettingsBtn.setTitle("", forState: UIControlState.Highlighted)
        if CLLocationManager.locationServicesEnabled(){
            self.gpsSettingsBtn.setBackgroundImage(UIImage(named: "gps"), forState: UIControlState.Normal)
            self.gpsSettingsBtn.setBackgroundImage(UIImage(named: "gps-click"), forState: UIControlState.Highlighted)
            
        }else{
            self.gpsSettingsBtn.setBackgroundImage(UIImage(named: "gps_on"), forState: UIControlState.Normal)
            self.gpsSettingsBtn.setBackgroundImage(UIImage(named: "gps-on_click"), forState: UIControlState.Highlighted)
        }
        
        self.gpsSettingsBtn.addTarget(self, action: "changeGpsSettings:", forControlEvents: UIControlEvents.TouchUpInside)
        for view in self.view.subviews{
            if view.isKindOfClass(UIButton){
                view.removeFromSuperview()
                break
            }
        }
        self.view.addSubview(gpsSettingsBtn)
        self.view.bringSubviewToFront(gpsSettingsBtn)
    }
    
    func addNavigationSettings(){
        super.setNavigationBarSettings()
        self.title = ""
        
        var information = UIButton()
        information.setTitle(NSLocalizedString("Information", comment: "") as String, forState: UIControlState.Normal)//Information
        information.setTitle(NSLocalizedString("Information", comment: "") as String, forState: UIControlState.Highlighted)
        information.setTitleColor(UIColor.grayMedium(), forState: UIControlState.Normal)
        information.sizeToFit()
        information.frame = CGRectMake(10, (self.navigationController!.navigationBar.bounds.size.height - information.frame.size.height)/2, information.frame.size.width, information.frame.size.height)
        information.addTarget(self, action: "getInfoView:", forControlEvents: UIControlEvents.TouchUpInside)
        btnInformation = UIBarButtonItem(customView: information)
        
        var line = UIButton()
        line.setTitle("|", forState: UIControlState.Normal)
        line.setTitle("|", forState: UIControlState.Highlighted)
        line.setTitleColor(UIColor(red: 299/255, green: 299/255, blue: 299/255, alpha: 1), forState: UIControlState.Normal)
        //        line.titleLabel?.font = UIFont(name: "spacer", size: 17.5)
        line.frame = CGRectMake(line.frame.origin.x, line.frame.origin.y, 1 , 21.0)
        
        var btnLine = UIBarButtonItem(customView: line)
        
        var msg = UIButton()//Message
        msg.setTitle(NSLocalizedString("Information", comment: "") as String, forState: UIControlState.Normal)
        msg.setTitle(NSLocalizedString("Information", comment: "") as String, forState: UIControlState.Highlighted)
        msg.setTitleColor(UIColor.grayMedium(), forState: UIControlState.Normal)
        msg.titleLabel?.font = UIFont(name: "spacer", size: 17.5)
        msg.sizeToFit()
        btnMsg = UIBarButtonItem(customView: msg)
        
        if var btnBack = self.navigationItem.leftBarButtonItem{
            if var btn: UIButton = btnBack.customView as? UIButton{
                btn.setImage(UIImage(named: "purpleLeftBack"), forState: UIControlState.Normal)
                btn.setImage(UIImage(named: "purpleLeftBack"), forState: UIControlState.Highlighted)
            }
            
        }
        
           }
    
    override func popBack(sender: AnyObject){ // TODO: remove when anslash the 2 btns in the left navigation side
        if timeInterval != nil{
            timeInterval.invalidate()
        }
        
        if notificationInterval != nil{
            notificationInterval.invalidate()
        }
        locationManeger.stopUpdatingLocation()
        super.popBack(sender)
    }
    func setSubviewsFrames(){

        self.gpsSettingsBtn.frame = CGRectMake(50, 100, 70, 70)
        
        for view in self.mapView.subviews{
            var viewClassString: NSString = view.className
            if viewClassString.rangeOfString("GMSUISettingsView").location != NSNotFound {
                for view2 in view.subviews{
                    if view2.className == "GMSx_QTMButton"{//GMSx_QTMButton
                        
                        println("className:\(view2.className)")
                        var myLocationButton = view2 as! UIButton
                        self.gpsSettingsBtn.frame = CGRectMake(myLocationButton.frame.origin.x, myLocationButton.frame.origin.y - myLocationButton.frame.size.height + 30, myLocationButton.frame.size.width, myLocationButton.frame.size.height)
                        break
                    }
                }
            }
        }
    }
    
    func addBarView(){
        var barViewHeight: CGFloat = 44

        barView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).CGColor
        barView.layer.shadowRadius = 0
        barView.layer.shadowOffset = CGSizeMake(0, -1)
       
        groupsBtn.setTitle(NSLocalizedString("Groups", comment: "") as String, forState: UIControlState.Normal)
        everyOneBtn.setTitle(NSLocalizedString("General Notice", comment: "") as String, forState: UIControlState.Normal)
        
    }
    
    
    @IBAction func navigateToCreateGroup(sender: AnyObject) {
        let newGroupView: CreateGroupViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CreateGroupViewControllerId") as! CreateGroupViewController
        self.navigationController?.pushViewController(newGroupView, animated: true)
    }
    
    @IBAction func navigateToGroups(sender: AnyObject) {
        let groupsView: GroupsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("GroupsViewControllerId") as! GroupsViewController
        self.navigationController?.pushViewController(groupsView, animated: true)
    }
    
    @IBAction func sendGlobalMessage(sender: AnyObject) {

        var alert = UIAlertController(title: NSLocalizedString("General Notice", comment: "") as String, message: NSLocalizedString("Message to group", comment: "") as String, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler(addTextField)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancellation", comment: "") as String /*"ביטול"*/, style: UIAlertActionStyle.Cancel, handler: nil))//"Submit"
        alert.addAction(UIAlertAction(title:NSLocalizedString("Submit", comment: "") as String /*"שלח"*/, style: UIAlertActionStyle.Default, handler:{ action in action.style
            if self.alertTxtField.text != "" && self.alertTxtField.text != " "{
                var parametersList = NSMutableArray()
                
                var keyVals = KeyValue()
                keyVals.nvKey = "notificationType"
                keyVals.nvValue = String(NOTIFICATION_TYPE.NOTIFICATION_TYPE_GLOBAL_MESSAGE.rawValue)
                parametersList.addObject(KeyValue.getKeyValueDictionary(keyVals))
                
                keyVals.nvKey = "userIdSend"
                keyVals.nvValue = String(ActiveUser.sharedInstace.iUserId)
                parametersList.addObject(KeyValue.getKeyValueDictionary(keyVals))
                
                keyVals.nvKey = "nvSenderUserFullName"
                keyVals.nvValue = "\(ActiveUser.sharedInstace.nvShantiName)"
                parametersList.addObject(KeyValue.getKeyValueDictionary(keyVals))
                let message = ("\(ActiveUser.sharedInstace.nvShantiName): \(self.alertTxtField.text)")
                var users = self.usersMarkers.allKeys
                Connection.connectionToService("PushUpdates", params: ["sMessage":message,"ParamsList":parametersList,"lUsers":users], completion: {
                    data -> Void in
                    var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("PushUpdates global message:\(strData)")
                })
                
            }
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func addTextField(textField: UITextField!){
        // add the text field and make the result global
        textField.placeholder = NSLocalizedString("Email", comment: "") as String//"מייל"
        textField.textAlignment = NSTextAlignment.Center
        self.alertTxtField = textField
    }
    
    func getInfoView(sender: AnyObject){
        let informationView: InformationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("InformationViewControllerId") as! InformationViewController
        self.navigationController?.pushViewController(informationView, animated: true)
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse{
            locationManeger.startUpdatingLocation()
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation{
            if mapViewCameraFlg {
                mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
                myLocationMarker.map = self.mapView
                mapViewCameraFlg = false
                self.updateUserLocationInServer()
                self.timeInterval = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: "updateUserLocationInServer", userInfo: nil, repeats: true)
            }
            
            myLocationMarker.position = location.coordinate
            myLocationMarker.flat = false
            
            ActiveUser.sharedInstace.oLocation.dLatitude = location.coordinate.latitude
            ActiveUser.sharedInstace.oLocation.dLongitude = location.coordinate.longitude
            
            self.gpsSettingsBtn.setBackgroundImage(UIImage(named: "gps"), forState: UIControlState.Normal)
            self.gpsSettingsBtn.setBackgroundImage(UIImage(named: "gps-click"), forState: UIControlState.Highlighted)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        self.locationManeger.stopUpdatingLocation()
        self.gpsSettingsBtn.setBackgroundImage(UIImage(named: "gps_on"), forState: UIControlState.Normal)
        self.gpsSettingsBtn.setBackgroundImage(UIImage(named: "gps-on_click"), forState: UIControlState.Highlighted)
        println(error)
        if (UIDevice.currentDevice().systemVersion as NSString).doubleValue >= 8{
            var alert = UIAlertController(title: "Error", message: "An error accurate\nPlease check youre GPS connection", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { action in action.style
                manager.stopUpdatingLocation()
                if !self.gpsOff{
                    if self.timeInterval != nil{
                    }
                }
                
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        self.userInfoView.view.hidden = true
    }
    
    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
//          let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        appDelegate.didTap = true
        if self.userInfoView.user != nil{
            var idu = String("\(self.userInfoView.user!.iUserId)")
            println("lastMarker id:\(idu)")
            if let lastMarker = self.usersMarkers.objectForKey(String("\(self.userInfoView.user!.iUserId)")) as? ShantiMarker{
                lastMarker.didReleasMarker()
            }
        }
        
        if let currMarker = marker as? ShantiMarker {
            currMarker.didTapMarker()
            self.userInfoView.user = currMarker.user
            self.setLineViewHiddeSettings(false)
        }
        else if let currMarker = marker as? MeetingPointMarker
        {
            self.userInfoView.meetingPoint = currMarker.meetingPoint
        }
//        appDelegate.didTap = false
        return true
    }
    
    func mapView(mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView! {
        var infoView = UIView(frame: CGRectZero)
        if let currMarker = marker as? ShantiMarker {
            var btnIndicator = UIButton(frame: CGRectMake(0, 0, UIImage(named: "massage_icn_maps")!.size.width/2, UIImage(named: "massage_icn_maps")!.size.height/2))
            btnIndicator.setBackgroundImage(UIImage(named: "massage_icn_maps"), forState: UIControlState.Normal)
            btnIndicator.setBackgroundImage(UIImage(named: "massage_icn_maps"), forState: UIControlState.Highlighted)
            
            infoView.frame = btnIndicator.frame
            infoView.addSubview(btnIndicator)
            infoView.backgroundColor = UIColor.redColor()
            
        }
        return infoView
    }
    
    func mapView(mapView: GMSMapView!, didBeginDraggingMarker marker: GMSMarker!) {
        println("didBeginDraggingMarker")
        marker.icon = UIImage(named: "create_meeting_release")
       
    }
    
    func mapView(mapView: GMSMapView!, didEndDraggingMarker marker: GMSMarker!) {
        println("didEndDraggingMarker")
        marker.icon = UIImage(named: "create_meeting_long_press")
    }
    
    func updateUserLocationInServer(){
        if (self.flg == true){
            let date = NSDate()
            print("SetLocationGetFilterUsersList date:\(date)")//SetLocationGetUsersList SetLocationGetFilterUsersList
            let dict = ["d":Location.getLocationDictionary(ActiveUser.sharedInstace.oLocation)]
            self.flg = false
            Connection.locationToService("SetLocationGetUsersList", params: ["location":Location.getLocationDictionary(ActiveUser.sharedInstace.oLocation)], completion: { data -> Void in
                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                self.flg = true
                println("SetLocationGetUsersList:\(strData)")
                var err: NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
                
                if (json != nil) {
                    if let jsonDict = json{
                        let usersListDetails: UsersListDetails = UsersListDetails.parsUsersListDetailsDict(jsonDict)
                        self.updateUsersList(usersListDetails.users, meetingPointsList: usersListDetails.meetingPoints)
                        if self.userInfoView.user?.iUserId == ActiveUser.sharedInstace.iUserId{
                            dispatch_async(dispatch_get_main_queue(), {
                                self.userInfoView.changeText(self.userInfoView.lblNote, text: usersListDetails.usersDetails)
                            })
                        }
                    }
                }
            })
        }
    }
    
    func updateUsersList(usersList: [User], meetingPointsList: [MeetingPoint]){
        //hanle with users markers
        for curUser in usersList {
            usersDict.setObject(curUser, forKey: String(curUser.iUserId))
        }
        
        for userId in self.usersMarkers.allKeys {
            if usersDict.objectForKey(userId) == nil {
                if let marker = self.usersMarkers.objectForKey(userId) as? ShantiMarker{
                    marker.map = nil
                    self.usersMarkers.removeObjectForKey(userId)
                }
            }
        }
        
        for userId in self.usersDict.allKeys{
            if self.usersMarkers.objectForKey(userId) == nil {
                var marker: ShantiMarker = ShantiMarker(user: self.usersDict.objectForKey(userId) as! User!)
                self.usersMarkers.setObject(marker, forKey: String(marker.user.iUserId))
            }else{
                if let marker = self.usersMarkers.objectForKey(userId) as? ShantiMarker{
                    marker.user = self.usersDict.objectForKey(userId) as! User!
                }
                
            }
        }
        self.usersDict.removeAllObjects()
        
        self.setUsersMarkers()
        
        //hanle with users meetingPoints
        for currMeetingPoint in meetingPointsList{
            self.meetingPointsDict.setObject(currMeetingPoint, forKey: currMeetingPoint.iMeetingPointId)
        }
        
        for meetingPointId in self.meetingPointsMarkers.allKeys{
            if self.meetingPointsDict.objectForKey(meetingPointId) == nil {
                if let marker = self.meetingPointsMarkers.objectForKey(meetingPointId) as? ShantiMarker{
                    marker.map = nil
                    self.meetingPointsMarkers.removeObjectForKey(meetingPointId)
                }
            }
        }
        
        for meetingPointId in self.meetingPointsDict.allKeys{
            if self.meetingPointsMarkers.objectForKey(meetingPointId) == nil{
                var marker: MeetingPointMarker = MeetingPointMarker(meetingPoint: self.meetingPointsDict.objectForKey(meetingPointId) as! MeetingPoint)
                self.meetingPointsMarkers.setObject(marker, forKey: String(marker.meetingPoint.iMeetingPointId))
            }else{
                if let marker = self.meetingPointsMarkers.objectForKey(meetingPointId) as? MeetingPointMarker{
                    marker.meetingPoint = self.meetingPointsDict.objectForKey(meetingPointId) as! MeetingPoint!
                }
            }
        }
        self.meetingPointsDict.removeAllObjects()
        
        self.setMeetingPointsMarkers()
    }
    
    func setUsersMarkers(){
        for userId in self.usersMarkers.allKeys {
            if userId as! String != String(ActiveUser.sharedInstace.iUserId){
                if var marker = self.usersMarkers.objectForKey(userId) as? ShantiMarker{
                    dispatch_async(dispatch_get_main_queue(), {
                        UIView.beginAnimations(nil, context: nil)
                        UIView.setAnimationDuration(1)
                        marker.position = CLLocationCoordinate2D(latitude: marker.user.oLocation.dLatitude,longitude: marker.user.oLocation.dLongitude)
                        marker.map = self.mapView
                        UIView.commitAnimations()
                    })
                    
                }
            }
        }
    }
    
    func setMeetingPointsMarkers(){
        for meetingPointId in self.meetingPointsMarkers.allKeys {
            if var marker = self.meetingPointsMarkers.objectForKey(meetingPointId) as? MeetingPointMarker{
                dispatch_async(dispatch_get_main_queue(), {
                    UIView.beginAnimations(nil, context: nil)
                    UIView.setAnimationDuration(1)
                    marker.position = CLLocationCoordinate2D(latitude: marker.meetingPoint.oLocation.dLatitude,longitude: marker.meetingPoint.oLocation.dLongitude)
                    marker.map = self.mapView
                    UIView.commitAnimations()
                })
            }
        }
    }
    
    func getSizeFromePrecent(precent: CGFloat) -> CGFloat {
        var value: CGFloat = UIScreen.mainScreen().bounds.size.height
        return (value * precent)/100
    }
    
    //UserInfoViewDelegate
    func chatBtnDidClick(sender: AnyObject, user: User){
        if user == ActiveUser.sharedInstace{
            self.changeWaintingMessagesCounter(0)
            var mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let privateChat: AllPriveteChatViewController = mainStoryboard.instantiateViewControllerWithIdentifier("AllPriveteChatViewControllerId") as! AllPriveteChatViewController
            self.navigationController?.pushViewController(privateChat, animated: true)
        }else{
            self.generic.showNativeActivityIndicator(self)
            var chatDialog = QBChatDialog()
            chatDialog.occupantIDs = [user.oUserQuickBlox.ID]//[2338031]
            chatDialog.type = QBChatDialogTypePrivate
            QBChat.createDialog(chatDialog, delegate: self)
        }
    }
    
    func completedWithResult(result: Result) -> Void{
        self.generic.hideNativeActivityIndicator(self)
        if (result.success && result.isKindOfClass(QBChatDialogResult)){
            self.setLineViewHiddeSettings(true)
            
            var chatDialog = (result as! QBChatDialogResult).dialog!
            
            let chatView = self.storyboard!.instantiateViewControllerWithIdentifier("PrivateChatViewControllerId") as! PrivateChatViewController
            chatView.dialog = chatDialog
            chatView.user = self.userInfoView.user!
            self.navigationController?.pushViewController(chatView, animated: true)
        }
    }
    
    func setLineViewHiddeSettings(withHidden: Bool){
        if withHidden
        {
            self.userInfoView.view.hidden = true
            self.underLineView.hidden = true
            self.mapView.frame = CGRectMake(self.mapView.frame.origin.x, self.mapView.frame.origin.y, self.mapView.frame.size.width, self.barView.frame.origin.y - self.barView.frame.origin.y)
            self.mapView.sizeToFit()
        }
        else
        {
            self.userInfoView.view.hidden = false
            self.underLineView.hidden = false
            
            if self.userInfoView.user == ActiveUser.sharedInstace
            {
                self.lblUnderLine.backgroundColor = UIColor.purpleHome()
                self.imgTraingle.image = UIImage(named: "traingle-purple")
            }else
            {
                self.lblUnderLine.backgroundColor = UIColor.greenHome()
                self.imgTraingle.image = UIImage(named: "traingle-green")
            }
            
        }
    }
    
    func btnMettingPointDidClick(sender: AnyObject){
        self.meetingView.groupsList = []
        self.meetingView.meetingPoint = MeetingPoint()
        
        var generic = Generic()
        generic.showNativeActivityIndicator(self)
        if ActiveUser.sharedInstace.bIsMainUser == true
        {
        Connection.connectionToService("GetUserGroupsAsMain", params: ["id":ActiveUser.sharedInstace.iUserId], completion: {
            data -> Void in
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("GetUserGroupsAsMain:\(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSArray
            if json != nil{
                println("GetUserGroupsAsMain\(json)")
                for jsonDict in json!{
                    self.meetingView.groupsList.append(Group.parseGroupDictionary(jsonDict as! NSDictionary))
                }
            }
            
            if self.meetingView.groupsList.count > 0{
                let viewH = CGFloat(204)
                self.meetingView.view.frame = CGRectMake(0,self.view.frame.size.height - viewH,self.meetingView.view.frame.size.width,viewH)
                self.view.addSubview(self.meetingView.view)
                
                self.mapView.camera = nil
                self.mapView.camera = GMSCameraPosition(target: self.locationManeger.location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
                
                var marker = GMSMarker()
                marker.position = self.myLocationMarker.position
                marker.map = self.mapView
                marker.icon = UIImage(named: "create_meeting_long_press")
                marker.draggable = true
                
                self.meetingView.marker = marker
            }
            
        })
        }
        else
        {
            
//            
            var alert = UIAlertController(title: NSLocalizedString("Error", comment: "") as String/*"שגיאה"*/, message:NSLocalizedString("You do not have groups, presently.Begin creating groups", comment: "") as String/* "ארעה שגיאה, נקודת המפגש לא התווספה "*/, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Confirmation", comment: "") as String/*"אישור"*/, style: UIAlertActionStyle.Default, handler:{ action in action.style
                println("error!")
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        generic.hideNativeActivityIndicator(self)
    }
    
    func startChatWithGroup(iGroupId: Int){
        var generic = Generic()
        generic.showNativeActivityIndicator(self)
        Connection.connectionToService("GetGroup", params:["id":iGroupId], completion: {
            data -> Void in
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("GetGroup:\(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            if json != nil{
                if let parseJSON = json {
                    var group = Group.parseGroupDictionary(parseJSON)
                    let chatView: ChatGroupViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ChatGroupViewControllerId") as! ChatGroupViewController
                    
                    var currGroupDialog = QBChatDialog()
                    currGroupDialog.ID = group.nvQBDialogId
                    currGroupDialog.roomJID = group.nvQBRoomJid
                    
                    chatView.dialog = currGroupDialog // missing the dialog.recipientID,need to use creatDialog for that.
                    chatView.currGroup = group
                    
                    self.navigationController!.pushViewController(chatView, animated: true)
                    
                }
            }
            generic.hideNativeActivityIndicator(self)
        })
    }
    
    func btnMoreAboutFriend(user: User){
        let friendProfile: FriendProfileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FriendProfileViewControllerId") as! FriendProfileViewController
        friendProfile.user = user
        self.navigationController?.pushViewController(friendProfile, animated: true)
    }
    
    func mainInfoDidChangeFrame() {
        self.setLineViewHiddeSettings(false)
    }
    
    func navigateToMeetingPoint(iMeetingPointId: Int) {
        if let marker = self.meetingPointsMarkers.objectForKey(String("\(iMeetingPointId)")) as? MeetingPointMarker{
            self.addGoogleRout(marker.position)
        }
    }
    
    func addGoogleRout(pointLocation: CLLocationCoordinate2D){
        Connection.calculateRoutes(CLLocationCoordinate2D(latitude: ActiveUser.sharedInstace.oLocation.dLatitude, longitude: ActiveUser.sharedInstace.oLocation.dLongitude), t: pointLocation, completion: {
            data -> Void in
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("calculateRoutes:\(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            if json != nil{
                self.parsGoogleRoutSteps(json!)
            }
            
        })
        
    }
    
    func parsGoogleRoutSteps(googlDict: NSDictionary){
        println("googlDict:\(googlDict)")
        if let routs = googlDict["routes"] as? NSArray{
            for currRout in routs{
                if let overview_polyline: NSDictionary = currRout["overview_polyline"] as? NSDictionary{
                    if let points: String = overview_polyline["points"] as? String{
                        self.drawRoute(points)
                    }
                }
            }
            
        }
    }
    
    func drawRoute(points: String) {
                let path: GMSPath = GMSPath(fromEncodedPath: points)
                var routePolyline = GMSPolyline(path: path)
                routePolyline.map = self.mapView
                routePolyline.strokeColor = UIColor.greenHome()
    }
    
    func navigateToUser(userId: Int){
        if let marker = self.usersMarkers.objectForKey(String("\(userId)")) as? ShantiMarker{
            self.addGoogleRout(marker.position)
        }
    }
    
    func changeWaintingMessagesCounter(counter: Int) {
        self.userInfoView.setUserInfoViewNotificationIndicator(counter)
    }
    
    func changeGpsSettings(sender: AnyObject){
        UIApplication.sharedApplication().openURL(NSURL(string:UIApplicationOpenSettingsURLString)!)
        gpsOff = !gpsOff
        locationManeger.stopUpdatingLocation()
    }
    
    ////////////////////////////////// NOTIFICATION HANDLER //////////////////////////////////
    
    func handleNotificationInBackgroundAndInactiveModes(){
        self.notificationInterval.invalidate()
        
        if self.userInfo != nil{
            if let notificationType: AnyObject = self.userInfo!["notificationType"] {
                var notiType: AnyObject? = self.userInfo!["notificationType"]
                if (notificationType as! String) == String(NOTIFICATION_TYPE.NOTIFICATION_TYPE_NEW_MESSAGE_PRIVATE.rawValue){// privateChat
                    if let userSent = self.userInfo!["userIdSend"] as? String{
                        self.generic.showNativeActivityIndicator(self)
                        Connection.connectionToService("GetUser", params: ["id":userSent], completion: {
                            data -> Void in
                            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                            println("GetUser:\(strData)")
                            var err: NSError?
                            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
                            if let parseJSON = json {
                                var userDetails = User.parseUserJson(JSON(parseJSON))
                                //FIXME1.11
                                var userDics:NSMutableDictionary = ["newUser":User.getUserDictionary(userDetails)]
                                NSUserDefaults.standardUserDefaults().setValue(/*User.getUserDictionary(userDetails)*/userDics, forKey: "userIdSend")
                                NSUserDefaults.standardUserDefaults().synchronize()
                                self.createChatDialog(userDetails.oUserQuickBlox.ID)
                            }
                        })
                        
                    }
                }else if (notificationType as! String) == String(NOTIFICATION_TYPE.NOTIFICATION_TYPE_NEW_MESSAGE_GROUP.rawValue){// GroupChat
                    if let iGroupId = self.userInfo!["iGroupId"] as? String{
                        self.startChatWithGroup((iGroupId as NSString).integerValue)
                    }
                }else if (notificationType as! String) == String(NOTIFICATION_TYPE.NOTIFICATION_TYPE_APPROVAL_GROUP.rawValue){
                    var mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let pendingView: PendingGroupsViewController = mainStoryboard.instantiateViewControllerWithIdentifier("PendingGroupsViewControllerId") as! PendingGroupsViewController
                    var currView = (UIApplication.sharedApplication().windows[0] as! UIWindow).rootViewController! as! SWRevealViewController
                    let navCont = currView.frontViewController as! UINavigationController
                    let lastView: UIViewController = navCont.viewControllers[navCont.viewControllers.count - 1] as! UIViewController
                    lastView.navigationController?.pushViewController(pendingView, animated: true)
                }else if (notificationType as! String) == String(NOTIFICATION_TYPE.NOTIFICATION_TYPE_GLOBAL_MESSAGE.rawValue){
                    if let userName: AnyObject = self.userInfo!["nvSenderUserFullName"] {
                        if let userIdSend: AnyObject = self.userInfo!["userIdSend"] {
                            var mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            var currView = (UIApplication.sharedApplication().windows[0] as! UIWindow).rootViewController! as! SWRevealViewController
                            let navCont = currView.frontViewController as! UINavigationController
                            let lastView: UIViewController = navCont.viewControllers[navCont.viewControllers.count - 1] as! UIViewController
                            //General Notice//From//"\(multiplier) times 2.5 is \(Double(multiplier) * 2.5)"
                            var s:String=(NSLocalizedString("General Notice", comment: "") as String)+" "+(NSLocalizedString("From", comment: "") as String)+" "+"\(userName as! String)"
                            var title =  s// "הודעה כללית מאת \(userName as! String)"
                            if let appsDict: AnyObject = self.userInfo!["aps"]{
                                if let body = appsDict["alert"] as? String{
                                    println(body)
                                    var alert = UIAlertController(title: title, message: body, preferredStyle: UIAlertControllerStyle.Alert)
                                    alert.addAction(UIAlertAction(title: NSLocalizedString("Cancellation", comment: "") as String/*"בטל"*/, style: UIAlertActionStyle.Cancel, handler: nil))
                                    //FIXME:
                                    alert.addAction(UIAlertAction(title:NSLocalizedString("Cancellation", comment: "") as String/* "פתח צ׳אט"*/, style: UIAlertActionStyle.Default, handler:{ action in action.style
                                        Connection.connectionToService("GetUser", params: ["id":userIdSend], completion: {
                                            data -> Void in
                                            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                                            println("GetUser:\(strData)")
                                            var err: NSError?
                                            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
                                            if let parseJSON = json {
                                                var userDetails = User.parseUserJson(JSON(parseJSON))
                                                //FIXME1.11
                                                var userDics:NSMutableDictionary = ["newUser":User.getUserDictionary(userDetails)]
                                                NSUserDefaults.standardUserDefaults().setValue(/*User.getUserDictionary(userDetails)*/userDics, forKey: "userIdSend")
                                                NSUserDefaults.standardUserDefaults().synchronize()
                                                self.createChatDialog(userDetails.oUserQuickBlox.ID)
                                            }
                                        })
                                    }))
                                    
                                    lastView.presentViewController(alert, animated: true, completion:nil)
                                    
                                    
                                    
                                    
                                    // let delay = 5.0 * Double(NSEC_PER_SEC)
                                    //                                    var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                                    //                                    dispatch_after(time, dispatch_get_main_queue(), {
                                    //                                        alert.dismissViewControllerAnimated(true, completion: nil)
                                    //                                    })
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func createChatDialog(userQuickBloxID: Int){
        var dict = ["ProjectName":"Shanti","FunctionName":"start","ToUTL":"createChatDialog id:\(userQuickBloxID)"]
        Connection.writeToWebitLog(dict, completion: {
            data -> Void in
            println("finish writeToWebitLog")
        })
        var chatDialog = QBChatDialog()
        chatDialog.occupantIDs = [userQuickBloxID]
        chatDialog.type = QBChatDialogTypePrivate
        QBChat.createDialog(chatDialog, delegate: self)
    }
    
    func moveToGroupChatView(iGroupId: String){
        var mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        self.generic.showNativeActivityIndicator(self)
        Connection.connectionToService("GetGroup", params:["id":iGroupId], completion: {
            data -> Void in
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("GetGroup:\(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            if json != nil{
                if let parseJSON = json {
                    let chatView: ChatGroupViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ChatGroupViewControllerId") as! ChatGroupViewController
                    chatView.currGroup = Group.parseGroupDictionary(parseJSON)
                    
                    var currGroupDialog = QBChatDialog()
                    currGroupDialog.ID = chatView.currGroup.nvQBDialogId
                    currGroupDialog.roomJID = chatView.currGroup.nvQBRoomJid
                    
                    chatView.dialog = currGroupDialog // missing the dialog.recipientID,need to use creatDialog for that.
                    
                    var currView = (UIApplication.sharedApplication().windows[0] as! UIWindow).rootViewController! as! SWRevealViewController
                    if  let navCont = currView.frontViewController as? UINavigationController{
                        if let lastView: UIViewController = navCont.viewControllers[navCont.viewControllers.count - 1] as? UIViewController{
                            lastView.navigationController?.pushViewController(chatView, animated: true)
                        }
                    }
                }
            }
            self.generic.hideNativeActivityIndicator(self)
        })
    }
    
}


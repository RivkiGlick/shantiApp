//
//  UsersListViewController.swift
//  Shanti
//
//  Created by hodaya ohana on 10/11/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit
class UsersListViewController: GlobalViewController,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate,CLLocationManagerDelegate, UITextFieldDelegate
{
    
    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet weak var btnSortName: UIButton!
    @IBOutlet weak var btnSortDistance: UIButton!
    @IBOutlet  var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnFilter: UIButton!
    var usersListDistanceValue: NSMutableDictionary = NSMutableDictionary()//helper list to sort by distance/value
    var usersListDistance: NSMutableDictionary = NSMutableDictionary()//helper list to sort by distance/key
    var usersListOnline: NSMutableDictionary = NSMutableDictionary()//helper list to save online users
    
    var generic = Generic()
    var usersListArray: NSMutableArray = NSMutableArray()
    var usersList: NSMutableArray = NSMutableArray()
    var usersList1:[User] = []
    var filterUsers:[User] = []
    let locationManeger = CLLocationManager()
    var isUpdateLocation:Bool = Bool()
    var isOpen:Bool = Bool()
    var isOnline:Bool = Bool()
    var arrivalTime = String()
    var arrivalTimeValue = Int()
    var recipientId = Int()//"ETA from your location:"
    var diffWord3 = NSLocalizedString("ETA from your location:", comment: "") as String//"זמן הגעה ממיקומך: "
    var currUserChat:User=User()
    var didLogin:Bool=Bool()
    var index = Int()
    
    //MARK: ViewController Delegate
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.timer=NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "update", userInfo: nil, repeats: true)
        ActiveUser.loginToQuickBloxWithCurrentUser()
        
        tableView.hidden = true
        
        self.pageDesign()
        
        self.generic.showNativeActivityIndicator(self)
        self.SetDelegate()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.setNavigationBar()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Private Function
    
    func pageDesign(){
        self.btnFilter.setTitle(NSLocalizedString("Filter", comment: "") as String/*"סנן לפי"*/, forState: .Normal)
        self.btnFilter.setTitle(NSLocalizedString("Filter", comment: "") as String/*"סנן לפי"*/, forState: .Highlighted)
        
        self.btnSortName.setTitle(NSLocalizedString("Sorting by Name", comment: "") as String/*"לפי שם"*/, forState: .Normal)
        self.btnSortName.setTitle(NSLocalizedString("Sorting by Name", comment: "") as String/*"לפי שם"*/, forState: .Highlighted)
        
        self.btnSortDistance.setTitle(NSLocalizedString("Sorting by Distance", comment: "") as String/*"לפי מרחק"*/, forState: .Normal)
        self.btnSortDistance.setTitle(NSLocalizedString("Sorting by Distance", comment: "") as String/*"לפי מרחק"*/, forState: .Highlighted)
        
        //textAlignment
        var space: CGFloat = 25
        var textAlignment: NSTextAlignment = .Left
        let languageId = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) as! String
        if languageId == "he"{
            textAlignment = .Right
            space = -space
        }
        
        txtSearch.textAlignment = textAlignment
        
        //make cornerRadius and location placeHolder to the UITextField
        for view in self.view.subviews{
            if view.isKindOfClass(UIButton){
                view.layer.cornerRadius = 3
            }
            if view.isKindOfClass(UITextField){
                view.layer.cornerRadius = 3
                //                view.layer.sublayerTransform = CATransform3DMakeTranslation(space,0,0)
            }
        }
        self.view.bringSubviewToFront(self.imgSearch)
        
        self.txtSearch.backgroundColor = UIColor.whiteColor()
        self.txtSearch.textColor = UIColor.grayMedium()
        self.txtSearch.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).CGColor
        self.txtSearch.layer.borderWidth = 1.0
        
    }
    
    
    func SetDelegate()
    {
        txtSearch.delegate = self
        locationManeger.delegate = self
        locationManeger.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    func GetUserList()//function that init list with userlist in appDelegate
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if appDelegate.arrayUsers.count>0
        {
            self.usersListArray.removeAllObjects()
            
            self.usersList1=[]
            self.usersList.removeAllObjects()
            
            for i in 0...appDelegate.arrayUsers.count - 1{
                let currUser: User=appDelegate.arrayUsers[i] as! User
                self.usersListArray.addObject(currUser as User)
                self.usersList1.append(currUser)
                self.usersList.addObject(currUser as User)
                print(self.usersList1)
                
            }
            if self.usersListArray.count>0
            {
                if (UIDevice.currentDevice().systemVersion as NSString).doubleValue >= 8{
                    self.locationManeger.requestWhenInUseAuthorization()
                    self.locationManeger.startUpdatingLocation()
                }else{
                    self.locationManeger.startUpdatingLocation()
                }
            }
            
            self.tableView.reloadData()
            
            
        }
        else
        {
            
            var alert = UIAlertController(title: NSLocalizedString("Error", comment: "") as String/*"שגיאה"*/, message:NSLocalizedString("A temporary problem fetching data from the server, please try later" , comment: "") as String /*"בעיה זמנית בשליפת נתונים מהשרת,אנא נסו מאוחר יותר"*/, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Confirmation", comment: "") as String /*"אישור"*/, style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            self.generic.hideNativeActivityIndicator(self)
            
        }
    }
    
    
    func updateUsersDistance() {
        for i in 0...self.usersListArray.count - 1{
            let currUser: User=usersListArray[i] as! User
            println("-----------------currUser:\(String(currUser.iUserId))")
            
            Connection.getArrivalTime(CLLocationCoordinate2DMake(ActiveUser.sharedInstace.oLocation.dLatitude, ActiveUser.sharedInstace.oLocation.dLongitude), dest: CLLocationCoordinate2DMake(currUser.oLocation.dLatitude,currUser.oLocation.dLongitude), completion: {
                data -> Void in
                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("getArrivalTime:\(strData)")
                var err: NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
                let  status:NSString = ((json!["status"] as? NSString))!
                println("))))))))status:\(status)")
                //if status.isEqualToString("OK")
                //{
                
                if json != nil{
                    self.arrivalTime = self.parsGoogleArrivalTime(json!)
                    self.arrivalTimeValue = self.parsGoogleArrivalTimeValue(json!)
                    self.usersListDistance.setObject(self.arrivalTime, forKey: String(currUser.iUserId))
                    self.usersListDistanceValue.setObject(self.arrivalTimeValue, forKey: String(currUser.iUserId))
                    
                    
                }
            })
            
            
        }
        println("*******usersListDistance:\(usersListDistance)")
        
        self.tableView.reloadData()
    }
    
    func update() {
        var generic = Generic()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.timerCount++
        println(" appDelegate.timerCount++:\(appDelegate.timerCount)")
        
        if appDelegate.isLoginQb
        {
            // let mainPage: UsersListViewController = self.storyboard!.instantiateViewControllerWithIdentifier("UsersListViewControllerID") as! UsersListViewController
            //  frontNavigationController = UINavigationController(rootViewController: mainPage)
            dispatch_async(dispatch_get_main_queue(),{
                self.GetUserList()
                
                //MARK: ADD IN SYNCRONIZE
                if appDelegate.messages.count==0
                {
                    self.getMessagesFromQB()
                    
                }
                
            })
            
            generic.hideNativeActivityIndicator(self)
            appDelegate.timer.invalidate()
        }
        else
        {
            if   appDelegate.timerCount==40
            {
                var alert = UIAlertController(title: "error", message: "login in quickblox failed", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "אישור", style: UIAlertActionStyle.Cancel, handler: {
                    action -> Void in
                    
                    println()
                }))
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
        }
        // Something cool
    }
    
    
    //    override func viewWillAppear(animated: Bool) {
    //        self.setNavigationBar()
    //    }
    func setSubviewConfig(){
        self.setNavigationBar()
        self.setDeleagtes()
        self.setSubviewFrames()
    }
    
    func setNavigationBar(){
        self.setNavigationBarSettings()
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.purpleHome()
        self.navigationController?.navigationBar.setBackgroundImage(ImageProcessor.imageWithColor(UIColor.purpleHome()), forBarMetrics: UIBarMetrics.Default)
        self.title = NSLocalizedString("", comment: "") as String //"חיפוש"
    }
    func setDeleagtes(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //        self.tableView.registerNib(UINib(nibName: "UserLisrCell", bundle: nil), forCellReuseIdentifier: "UserLisrCellId")
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    func setSubviewFrames(){
        self.tableView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
    }
    
    //MARK: tableView Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return  usersList.count
        //return  10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        //        self.tableView.registerNib(UINib(nibName: "UserLisrCell", bundle: nil), forCellReuseIdentifier: "UserLisrCellId")
        var cell: UserLisrCell = tableView.dequeueReusableCellWithIdentifier("UserLisrCellId") as! UserLisrCell
        //        let cell: UserLisrCell = tableView.dequeueReusableCellWithIdentifier("UserLisrCellId", forIndexPath: indexPath) as! UserLisrCell
        let currUser:User
        var s:String
        currUser = usersList[indexPath.row] as! User
        
        cell.userImage.image = ImageHandler.getImageBase64FromUrl(currUser.nvImage)
        cell.userImage.layer.cornerRadius = 15
        
        var textAlignment: NSTextAlignment = .Left
        let languageId = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) as! String
        if languageId == "he"{
            textAlignment = .Right
        }
        cell.lblShantiName.textAlignment = textAlignment
        cell.lblLastBroadcastDate.textAlignment = textAlignment
        cell.lblUserName.textAlignment = textAlignment
        
        
        cell.lblShantiName.text = currUser.nvShantiName + "," + currUser.oCountry.nvValue
        cell.lblLastBroadcastDate.text = currUser.nvLastBroadcastDate
        cell.userImage.clipsToBounds = true
        println("ActiveUser.sharedInstace.oLocation:\(ActiveUser.sharedInstace.oLocation.dLatitude)\(ActiveUser.sharedInstace.oLocation.dLongitude)")
        println("currUser.oLocation:\(currUser.oLocation.dLatitude)\(currUser.oLocation.dLongitude)")
        if(isUpdateLocation)
        {
            
            cell.lblUserName.text=self.usersListDistance.objectForKey(String(currUser.iUserId)) as? String
            
            
        }
        else
        {
            // cell.lblUserName.text=self.usersListDistance.objectForKey(indexPath.row)
        }
        if(isOnline)
        {
            cell.userImage!.layer.borderWidth = 2
            var b:Bool=(self.usersListOnline.objectForKey(String(currUser.iUserId)) as? Bool)!
            if b
            {
                
                cell.userImage!.layer.borderColor = UIColor.greenHome().CGColor
            }
            else
            {
                cell.userImage!.layer.borderColor = UIColor.red().CGColor
                //cell.backgroundColor=UIColor.redColor()
            }
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //           if ActiveUser.sharedInstace.didLoginToQB == true&&self.didLogin == false
        //           {
        //FIXME:
        //        if appDelegate.messages.count==0
        //        {
        //            self.getMessagesFromQB()
        //
        //        }
        
        var currDialog: QBChatDialog=QBChatDialog()
        var b:Bool=false
        if appDelegate.messages.count>0
        {
            println(appDelegate.messages)
            for i in 0...appDelegate.messages.count - 1{
                var ChatDialog:QBChatDialog = appDelegate.messages.objectAtIndex(i) as! QBChatDialog
                var currUser:User = (usersList[indexPath.row] as? User)!
                
                for i in 0...ChatDialog.occupantIDs.count - 1{
                    if(currUser.oUserQuickBlox.ID != -1 && b == false)
                    {
                        if ChatDialog.occupantIDs[i] as! UInt==UInt(currUser.oUserQuickBlox.ID)
                        {
                            currDialog=ChatDialog
                            b=true
                        }
                    }
                }
                
            }
            if(b==false)
            {
                self.index=indexPath.row
                self.createDialog()
            }
            else
            {
                let chatView = self.storyboard!.instantiateViewControllerWithIdentifier("PrivateChatViewControllerId") as! PrivateChatViewController
                chatView.dialog = currDialog
                if let currUser = usersList[indexPath.row] as? User {
                    // var b:Bool=
                    chatView.isOnline=(self.usersListOnline.objectForKey(String(currUser.iUserId)) as? Bool)!
                    chatView.dialog = currDialog
                    chatView.user=currUser
                    self.navigationController?.pushViewController(chatView, animated: true)
                    
                }
            }
        }
            
            // if(b==false)
        else
        {
            self.index=indexPath.row
            self.createDialog()
            
        }
        //        else
        //        {
        //            var alert = UIAlertController(title: "שגיאה", message: "חיבורי הצ׳אט אינם זמינים, אנא נסה שוב מאוחר יותר", preferredStyle: UIAlertControllerStyle.Alert)
        //            alert.addAction(UIAlertAction(title: "אישור", style: UIAlertActionStyle.Default,handler: nil))
        //
        //            self.presentViewController(alert, animated: true, completion: nil)            //            alert.addAction(UIAlertAction(title: "אישור", style: UIAlertActionStyle.Cancel, handler: {
        //            //                action in action.style
        //            //             }))
        //
        //        }
        
        
        
        
        //        if appDelegate.messages.count>0
        //        {
        //            var currDialog: QBChatDialog=QBChatDialog()
        //            println(appDelegate.messages)
        //            for i in 0...appDelegate.messages.count - 1{
        //                var ChatDialog:QBChatDialog = appDelegate.messages.objectAtIndex(i) as! QBChatDialog
        //                var currUser:User = (usersList[indexPath.row] as? User)!
        //                for i in 0...ChatDialog.occupantIDs.count - 1{
        //                    if ChatDialog.occupantIDs[i] as! UInt==UInt(currUser.oUserQuickBlox.ID)
        //                    {
        //                        currDialog=ChatDialog
        //                    }
        //                }
        //
        //
        //            }
        //
        //            let chatView = self.storyboard!.instantiateViewControllerWithIdentifier("PrivateChatViewControllerId") as! PrivateChatViewController
        //            chatView.dialog = currDialog
        //            if let currUser = usersList[indexPath.row] as? User {
        //
        //                // var b:Bool=
        //                chatView.isOnline=(self.usersListOnline.objectForKey(String(currUser.iUserId)) as? Bool)!
        //
        //
        //                chatView.dialog = currDialog
        //                chatView.user=currUser
        //                self.navigationController?.pushViewController(chatView, animated: true)
        //            }
        //        }
        //        else
        //        {
        //            var alert = UIAlertController(title:  NSLocalizedString("Error", comment: "") as String /*"שגיאה"*/,  message:NSLocalizedString("The chat connections are not available, please try again later", comment: "") as String/*"חיבורי הצ׳אט אינם זמינים, אנא נסה שוב מאוחר יותר"*/, preferredStyle: UIAlertControllerStyle.Alert)
        //            alert.addAction(UIAlertAction(title: NSLocalizedString("Confirmation", comment: "") as String /*"אישור"*/, style: UIAlertActionStyle.Default,handler: nil))
        //
        //            self.presentViewController(alert, animated: true, completion: nil)            //            alert.addAction(UIAlertAction(title: "אישור", style: UIAlertActionStyle.Cancel, handler: {
        //            //                action in action.style
        //            //             }))
        //
        //        }
        //
        
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 97.0
    }
    
    //MARK: chat Delegate
    func completedWithResult(result: Result) -> Void{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var dict = ["ProjectName":"Shanti","FunctionName":"completedWithResult","ToUTL":"appDelegate"]
        Connection.writeToWebitLog(dict, completion: {
            data -> Void in
            println("finish writeToWebitLog")
        })
        
        
        if (result.success && result.isKindOfClass(QBDialogsPagedResult)){
            var pagedResult = result as! QBDialogsPagedResult
            if pagedResult.dialogs != nil{
                //                if appDelegate.messages.count==0
                //                {
                appDelegate.messages.addObjectsFromArray(pagedResult.dialogs)
                // }
            }
            
            
        }
        if (result.success && result.isKindOfClass(QBChatDialogResult)){
            var chatDialog = (result as! QBChatDialogResult).dialog!
            if chatDialog.type.value == QBChatDialogTypePrivate.value{
                self.moveToChatViewController(chatDialog)
            }
        }
        
    }
    func createDialog()
    {
        var currUser:User = (usersList[self.index] as? User)!
        var chatDialog = QBChatDialog()
        chatDialog.occupantIDs = [currUser.oUserQuickBlox.ID]//[2338031]
        chatDialog.type = QBChatDialogTypePrivate
        QBChat.createDialog(chatDialog, delegate: self)
        self.getMessagesFromQB()
        
        //        var chatDialog = QBChatDialog()
        //        chatDialog.occupantIDs = [ActiveUser.sharedInstace.oUserQuickBlox.ID,currUser.oUserQuickBlox.ID]
        //
        //      // chatDialog.occupantIDs = [userQuickBloxID]
        //        chatDialog.type = QBChatDialogTypePrivate
        //        QBChat.createDialog(chatDialog, delegate: self)
    }
    
    func moveToChatViewController(chatDialog: QBChatDialog ){
        
        
        
        let chatView = self.storyboard!.instantiateViewControllerWithIdentifier("PrivateChatViewControllerId") as! PrivateChatViewController
        //        chatView.recipientID = self.recipientId
        //
        //
        //        chatView.dialog = chatDialog as QBChatDialog
        //
        //
        ////        currUserChat.isOnline=(self.usersListOnline.objectForKey(String(currUserChat.iUserId)) as? Bool)!
        //        chatView.user = self.currUserChat as User!
        //        self.navigationController?.pushViewController(chatView, animated: true)
        
        if let currUser = usersList[self.index] as? User {
            
            // var b:Bool=
            chatView.isOnline=(self.usersListOnline.objectForKey(String(currUser.iUserId)) as? Bool)!
            
            
            chatView.dialog = chatDialog
            chatView.user=currUser
            self.navigationController?.pushViewController(chatView, animated: true)
        }
        
    }
    
    
    //MARK: textField Delegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        
        var stringToSearch = textField.text + string
        if string == ""{
            stringToSearch = dropLast(textField.text)
            print("textField.text \(textField.text)")
            print("stringToSearch \(stringToSearch)")
        }
        
        usersList.removeAllObjects()
        //            tableList.removeAllObjects()
        if stringToSearch == "" || stringToSearch == "\n"{
            //            textField.text = stringToSearch
            //            textField.resignFirstResponder()
            usersList = self.usersListArray.mutableCopy() as! NSMutableArray
            //            self.imgSearch.hidden = false
        }else{
            self.imgSearch.hidden = true
            if self.usersListArray.count > 0{
                for i in 0...self.usersListArray.count - 1{
                    let currUser = self.usersListArray.objectAtIndex(i) as! User
                    var curString = currUser.nvShantiName
                    var substringRange: NSRange = (curString as NSString).rangeOfString(stringToSearch)
                    if (substringRange.location == 0) {
                        usersList.addObject(currUser)
                    }
                }
            }
        }
        self.tableView.reloadData()
        return true
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    //MARK: searchBar Delegate
    
    func searchBarResultsListButtonClicked(searchBar: UISearchBar){
        println("searchBarResultsListButtonClicked")
        
    }
    
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        println("textDidChange")
        
        
        usersList.removeAllObjects()
        //            tableList.removeAllObjects()
        if searchText == "" || searchText == "\n"{
            searchBar.resignFirstResponder()
            
            usersList = self.usersListArray.mutableCopy() as! NSMutableArray
        }else{
            if self.usersListArray.count > 0{
                for i in 0...self.usersListArray.count - 1{
                    let currUser = self.usersListArray.objectAtIndex(i) as! User
                    var curString = currUser.nvShantiName
                    var substringRange: NSRange = (curString as NSString).rangeOfString(searchText)
                    if (substringRange.location == 0) {
                        usersList.addObject(currUser)
                    }
                }
            }
        }
        
        
        // self.usersList.insertObject(chooseOption, atIndex: 0)
        self.tableView.reloadData()
        
        
        
    }
    
    
    
    func searchBarSearchButtonClicked( searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
    }
    
    
    //MARK:  LOCATION MANAGER DELEGATE
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse{
            self.locationManeger.startUpdatingLocation()
            
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation{
            
            
            
            ActiveUser.sharedInstace.oLocation.dLatitude = location.coordinate.latitude
            ActiveUser.sharedInstace.oLocation.dLongitude = location.coordinate.longitude
            if(!self.isUpdateLocation)
            {
                if self.usersListArray.count>0
                {
                    self.updateUsersDistance()
                    self.updateUsersOnline()
                }
                if(self.usersListDistance.count>0)
                {
                    isUpdateLocation=true
                    self.tableView.hidden=false
                    self.generic.hideNativeActivityIndicator(self)
                    self.tableView.reloadData()
                }
                
                
            }
            
            
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        self.locationManeger.stopUpdatingLocation()
        self.locationOFF()
        
        
        println(error)
    }
    func locationOFF()
    {
        if(!self.isUpdateLocation)
        {
            if self.usersListArray.count>0
            {
                self.updateUsersDistance()
                self.updateUsersOnline()
                self.tableView.reloadData()
                self.generic.hideNativeActivityIndicator(self)
                self.tableView.hidden=false
            }
            if(self.usersListDistance.count>0)
            {
                isUpdateLocation=true
                self.tableView.hidden=false
                self.generic.hideNativeActivityIndicator(self)
                self.tableView.reloadData()
            }
            
            
        }
        
        
        
    }
    
    //sort
    //    @IBAction func btnSortDateClick(sender: AnyObject) {
    //
    //        let dateFormatter = NSDateFormatter()
    //        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
    //    //     self.usersList1.sort({(dateFormatter.dateFromString($0.nvLastBroadcastDate))>(dateFormatter.dateFromString($1.nvLastBroadcastDate))})
    //        for i in 0...self.usersList1.count - 1{
    //            let currUser: User=usersList1[i] as User
    //            currUser.dtLastBroadcastDate=self.getDateFromString(currUser.nvLastBroadcastDate)
    //
    //              self.usersList1[i]=currUser
    //        }
    //
    //         self.usersList1.sort({ $0.dtLastBroadcastDate.compare($1.dtLastBroadcastDate) == NSComparisonResult.OrderedDescending })
    //   //self.usersList1.sort({$0.nvLastBroadcastDate > $1.nvLastBroadcastDate })
    //        self.usersList.removeAllObjects()
    //
    //
    //           for i in 0...self.usersList1.count - 1{
    //             let currUser: User=usersList1[i] as User
    //            println("&&&&&&&&&:\(currUser.nvLastBroadcastDate)")
    //
    //            self.usersList.addObject(currUser as User)
    //        }
    //        self.tableView.reloadData()
    //    }
    
    //MARK: Sort Function
    func btnSortDate()
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        //     self.usersList1.sort({(dateFormatter.dateFromString($0.nvLastBroadcastDate))>(dateFormatter.dateFromString($1.nvLastBroadcastDate))})
        for i in 0...self.usersList1.count - 1{
            let currUser: User=usersList1[i] as User
            currUser.dtLastBroadcastDate=self.getDateFromString(currUser.nvLastBroadcastDate)
            
            self.usersList1[i]=currUser
        }
        self.usersList1.sort({ $0.dtLastBroadcastDate.compare($1.dtLastBroadcastDate) == NSComparisonResult.OrderedDescending })
        
    }
    
    func backwards(s1: String, s2: String) -> Bool {
        return s1 > s2
    }
    
    @IBAction func sortByName(sender: AnyObject) {
        
        self.btnSortName.backgroundColor = UIColor.lightGrayColor()
        self.usersList1.sort({$0.nvShantiName.lowercaseString < $1.nvShantiName.lowercaseString })
        self.usersList.removeAllObjects()
        
        
        for i in 0...self.usersList1.count - 1{
            let currUser: User=usersList1[i] as User
            println("&&&&&&&&&:\(currUser.nvShantiName)")
            
            self.usersList.addObject(currUser as User)
        }
        self.tableView.reloadData()
        self.btnSortName.hidden = !self.btnSortName.hidden
        self.btnSortDistance.hidden = !self.btnSortDistance.hidden
        
    }
    
    @IBAction func sortByDistanceClick(sender: AnyObject) {
        
        self.btnSortDistance.backgroundColor = UIColor.lightGrayColor()
        self.btnSortDate()
        for i in 0...self.usersList1.count - 1{
            let currUser: User=usersList1[i] as User
            currUser.iDistance = self.usersListDistanceValue.objectForKey(String(currUser.iUserId))  as! Int
            self.usersList1[i]=currUser
            
        }
        
        self.usersList1.sort({$0.iDistance < $1.iDistance })
        //self.usersList1.sort({$0.nvLastBroadcastDate > $1.nvLastBroadcastDate })
        self.usersList.removeAllObjects()
        
        
        for i in 0...self.usersList1.count - 1{
            let currUser: User=usersList1[i] as User
            
            
            self.usersList.addObject(currUser as User)
        }
        self.tableView.reloadData()
        self.btnSortName.hidden = !self.btnSortName.hidden
        self.btnSortDistance.hidden = !self.btnSortDistance.hidden
        
        
    }
    
    @IBAction func btnFilterClick(sender: AnyObject) {
        self.btnSortName.hidden = !self.btnSortName.hidden
        self.btnSortDistance.hidden = !self.btnSortDistance.hidden
        view.bringSubviewToFront(btnSortName)
        view.bringSubviewToFront(btnSortDistance)
        //        if(!self.isOpen)
        //        {
        //            self.btnSortName.hidden=false
        //            self.btnSortDistance.hidden=false
        //
        //
        //            self.isOpen=true
        //        }
        //        else
        //        {
        //            self.btnSortName.hidden=true
        //            self.btnSortDistance.hidden=true
        //
        //
        //
        //            self.isOpen=false
        //        }
    }
    
    @IBAction func btnSortByDistanceRealesed(sender: AnyObject) {
        self.btnSortDistance.backgroundColor = UIColor.darkGrayColor()
    }
    @IBAction func btnSortByNameRealesed(sender: AnyObject) {
        self.btnSortName.backgroundColor = UIColor.darkGrayColor()
    }
    
    
    //MARK: helper Function
    
    func getDateFromString(string: String) -> NSDate{
        let dateFormatter = NSDateFormatter()//"yyyy-MM-dd'T'HH:mm:ssZZZZ"
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        
        if(string.isEmpty)
        {
            var s:NSString="01/01/2000 01:01:01"
            return dateFormatter.dateFromString(s as String)!
        }
        let d:NSDate=dateFormatter.dateFromString(string)!
        println("^^^^^^^^^^^^^:\(string)")
        
        return dateFormatter.dateFromString(string)!
    }
    
    func parsGoogleArrivalTime(googlDict: NSDictionary) -> String{
        println("googlDict:\(googlDict)")
        var arrivalTime = String()
        let  status:NSString = ((googlDict["status"] as? NSString))!
        if status.isEqualToString("ZERO_RESULTS")||status.isEqualToString("OVER_QUERY_LIMIT")
        {
            return ""
        }
        else
        {
            if status.isEqualToString("OK")
            {
                if let routs = googlDict["routes"] as? NSArray{
                    if let firstRout = routs.objectAtIndex(0) as? NSDictionary{
                        if let legs = firstRout.valueForKey("legs") as? NSArray{
                            if let firstLeg = legs.objectAtIndex(0) as? NSDictionary{
                                if let duration = firstLeg.valueForKey("distance") as? NSDictionary{
                                    if let text = duration.valueForKey("text") as? String{
                                        arrivalTime = text
                                    }
                                }
                            }
                        }
                    }
                }
                return arrivalTime
            }
            else
            {
                return ""
            }
        }
    }
    func parsGoogleArrivalTimeValue(googlDict: NSDictionary) -> Int{
        println("googlDict:\(googlDict)")
        var arrivalTime = String()
        let  status:NSString = ((googlDict["status"] as? NSString))!
        if status.isEqualToString("ZERO_RESULTS")||status.isEqualToString("OVER_QUERY_LIMIT")
        {
            return 0
        }
        else
        {
            if status.isEqualToString("OK")
            {
                if let routs = googlDict["routes"] as? NSArray{
                    if let firstRout = routs.objectAtIndex(0) as? NSDictionary{
                        if let legs = firstRout.valueForKey("legs") as? NSArray{
                            if let firstLeg = legs.objectAtIndex(0) as? NSDictionary{
                                if let duration = firstLeg.valueForKey("distance") as? NSDictionary{
                                    if let text = duration.valueForKey("value") as? Int{
                                        arrivalTimeValue = text
                                    }
                                }
                            }
                        }
                    }
                }
                return arrivalTimeValue
            }
            else
            {
                return 0
            }
        }
    }
    
    
    
    func updateUsersOnline()
    {
        var currUser: User
        for i in 0...self.usersList1.count - 1{
            currUser=usersList1[i] as User
            currUser.dtLastBroadcastDate=self.getDateFromString(currUser.nvLastBroadcastDate)
            if(self.isOnlineDate(currUser.dtLastBroadcastDate))
            {
                self.usersListOnline.setObject(true, forKey: String(currUser.iUserId))
                
            }
            else
            {
                self.usersListOnline.setObject(false, forKey: String(currUser.iUserId))
            }
            
        }
        
        isOnline=true
        
        
        self.tableView.reloadData()
    }
    func isOnlineDate(date:NSDate)->Bool
    {
        //        let date = NSDate()
        //        let calendar = NSCalendar.currentCalendar()
        //        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: date)
        //        let hour = components.hour
        //        let minutes = components.minute
        //        let seconds = components.second
        
        let now = NSDate()
        // "Sep 23, 2015, 10:26 AM"
        let olderDate = NSDate(timeIntervalSinceNow: -10000)
        // "Sep 23, 2015, 7:40 AM"
        var order = NSCalendar.currentCalendar().compareDate(now, toDate: date, toUnitGranularity: NSCalendarUnit.DayCalendarUnit)
        //        var order = NSCalendar.currentCalendar().compareDate(now, toDate: olderDate,toUnitGranularity: .Hour)
        
        
        // Compare to hour: SAME
        
        order = NSCalendar.currentCalendar().compareDate(date, toDate: olderDate,
            toUnitGranularity:NSCalendarUnit.HourCalendarUnit)
        
        switch order {
        case .OrderedDescending:
            print("DESCENDING")
        case .OrderedAscending:
            print("ASCENDING")
        case .OrderedSame:
            print("SAME")
        }
        
        switch order {
        case .OrderedDescending:
            return true
        case .OrderedAscending:
            return false
        case .OrderedSame:
            return false
        }
        
        
        return false
    }
    func getMessagesFromQB(){
        
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if  appDelegate.isLoginQb==true{
            //self.generic.showNativeActivityIndicator(self)
            var extendedRequest: NSMutableDictionary = ["type":3]
            QBChat.dialogsWithExtendedRequest(extendedRequest, delegate: self)
            self.didLogin==true
        }else{
            
            var alert = UIAlertController(title:NSLocalizedString("Error", comment: "") as String/*"שגיאה"*/, message:NSLocalizedString("The chat connections are not available, please try again later" , comment: "") as String /* "חיבורי הצ׳אט אינם זמינים, אנא נסה שוב מאוחר יותר"*/, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Confirmation", comment: "") as String /*"אישור"*/, style: UIAlertActionStyle.Cancel, handler: {
                action in action.style
                // self.navigationController?.popViewControllerAnimated(true)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
    }
    override func popBack(sender: AnyObject){
        
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    
}

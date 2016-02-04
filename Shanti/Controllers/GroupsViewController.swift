//
//  GroupsViewController.swift
//  Shanti
//
//  Created by hodaya ohana on 2/22/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

class GroupsViewController: GlobalViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var btnNewGroup: UIBarButtonItem!
    var btnPendingGroups: UIBarButtonItem!
    var btnMap: UIBarButtonItem!
    var groupsList: NSMutableArray = NSMutableArray()
    var groupsDialog : NSMutableDictionary = NSMutableDictionary()
    var imgsDict = NSMutableDictionary()
    var generic = Generic()
    var viewNoGroups = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavigationSettings()
        self.getGroupsFromServer()
        //FIXME: in order to not show empty table until the groupslist did fill 10.11
        self.tableView.hidden=true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //        self.tableView.reloadData()
        if self.groupsList.count > 0{
            //FIXME: in order to not show empty table until the groupslist did fill 10.11
            //            var generic = Generic()
            self.generic.showNativeActivityIndicator(self)
            //
            viewNoGroups.removeFromSuperview()
            self.downloadImageFromServer()
        }
    }
    
    override func viewWillLayoutSubviews() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    func rotated()
    {
        self.tableView.reloadData()
        
    }

    
    func getGroupsFromServer(){
        self.tableView.backgroundColor = UIColor.offwhiteDark()
        //        var generic = Generic()
        self.generic.showNativeActivityIndicator(self)
        
        Connection.connectionToService("GetUserGroups", params: ["id":ActiveUser.sharedInstace.iUserId], completion: {
            data -> Void in
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("GetUserGroups:\(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSArray
            if json != nil
            {
                println("GetUserGroups\(json)")
                if  json!.count > 0
                {
                    for jsonDict in json!
                    {
                        self.groupsList.addObject(Group.parseGroupDictionary(jsonDict as! NSDictionary))
                    }
                    //                    self.generic.hideNativeActivityIndicator(self)
                }
                else
                {
                    self.addInfoViews()
                    self.generic.hideNativeActivityIndicator(self)
                }
            }
            else
            {
                self.addInfoViews()
                self.generic.hideNativeActivityIndicator(self)
            }
            
            self.setSubviewsConfig()
            self.downloadImageFromServer()
            
            // self.tableView.reloadData()
        })
    }
    
    func setSubviewsConfig(){
        self.setDelegates()
        self.setSubviewsGraphics()
        self.setSubviewsFrames()
    }
    
    func setSubviewsGraphics(){
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.separatorColor = UIColor.grayMedium()
        
        if self.tableView.respondsToSelector("setSeparatorInset::"){
            self.tableView.separatorInset = UIEdgeInsetsZero
        }
        
        if self.tableView.respondsToSelector("setLayoutMargins:"){
            self.tableView.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    func addNavigationSettings(){
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.purpleHome()
        self.navigationController?.navigationBar.setBackgroundImage(ImageProcessor.imageWithColor(UIColor.purpleHome()), forBarMetrics: UIBarMetrics.Default)
        self.title = NSLocalizedString("Groups", comment: "") as String /*"קבוצות"*/
        
        var newGroup = UIButton()
        newGroup.setTitle("", forState: UIControlState.Normal)
        newGroup.setTitle("", forState: UIControlState.Highlighted)
        newGroup.setBackgroundImage(UIImage(named: "btnNewGroup"), forState: UIControlState.Normal)
        newGroup.setBackgroundImage(UIImage(named: "btnNewGroup"), forState: UIControlState.Highlighted)
        newGroup.titleLabel?.font = UIFont(name: "spacer", size: 17.5)
        newGroup.sizeToFit()
        newGroup.frame = CGRectMake(8, (self.navigationController!.navigationBar.bounds.size.height - UIImage(named: "btnNewGroup")!.size.height/2)/2, UIImage(named: "btnNewGroup")!.size.width/2, UIImage(named: "btnNewGroup")!.size.height/2)
        newGroup.addTarget(self, action: "addNewGroup:", forControlEvents: UIControlEvents.TouchUpInside)
        btnNewGroup = UIBarButtonItem(customView: newGroup)
        
        var pendingGroups = UIButton()
        pendingGroups.setTitle("", forState: UIControlState.Normal)
        pendingGroups.setTitle("", forState: UIControlState.Highlighted)
        pendingGroups.setBackgroundImage(UIImage(named: "join_btn"), forState: UIControlState.Normal)
        pendingGroups.setBackgroundImage(UIImage(named: "join_btn"), forState: UIControlState.Highlighted)
        pendingGroups.titleLabel?.font = UIFont(name: "spacer", size: 17.5)
        pendingGroups.sizeToFit()
        pendingGroups.frame = CGRectMake(newGroup.frame.origin.x + newGroup.frame.size.width, newGroup.frame.origin.y, UIImage(named: "join_btn")!.size.width/2, UIImage(named: "join_btn")!.size.height/2)
        pendingGroups.addTarget(self, action: "getPendingGroups:", forControlEvents: UIControlEvents.TouchUpInside)
        btnPendingGroups = UIBarButtonItem(customView: pendingGroups)
        
        self.navigationItem.setLeftBarButtonItems([btnNewGroup,btnPendingGroups], animated: true)
        
        var map = UIButton()
        map.setTitle((NSLocalizedString("Map", comment: "") as String) + ">" , forState: UIControlState.Normal)///*"מפה >"*/
        map.setTitle((NSLocalizedString("Map", comment: "") as String) + ">", forState: UIControlState.Highlighted) /*"מפה >"*/
        map.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        map.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        map.titleLabel?.font = UIFont(name: "spacer", size: 17.5)
        map.sizeToFit()
        map.frame = CGRectMake((self.navigationController!.navigationBar.bounds.size.width - map.frame.size.width)/2 - 10, (self.navigationController!.navigationBar.bounds.size.height - map.frame.size.height)/2, map.frame.size.width, map.frame.size.height)
        map.addTarget(self, action: "getToMainMap:", forControlEvents: UIControlEvents.TouchUpInside)
        btnMap = UIBarButtonItem(customView: map)
        
        self.navigationItem.setRightBarButtonItem(btnMap, animated: true)
    }
    
    func setDelegates(){
        self.tableView.registerNib(UINib(nibName: "GroupsListCell", bundle: nil), forCellReuseIdentifier: "GroupsListCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func setSubviewsFrames(){
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height - (self.navigationController!.navigationBar.frame.origin.y + self.navigationController!.navigationBar.frame.size.height))
    }
    
    func addNewGroup(sender: AnyObject){
        let newGroupView: CreateGroupViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CreateGroupViewControllerId") as! CreateGroupViewController
        self.navigationController?.pushViewController(newGroupView, animated: true)
    }
    
    func getPendingGroups(sender: AnyObject){
        let pendingGroupsView: PendingGroupsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PendingGroupsViewControllerId") as! PendingGroupsViewController
        self.navigationController?.pushViewController(pendingGroupsView, animated: true)
    }
    
    func getToMainMap(sender: AnyObject){
        var controllers = self.navigationController?.viewControllers as [AnyObject]!
        
        let mainPage: MainPage = self.storyboard!.instantiateViewControllerWithIdentifier("MainPageId") as! MainPage
        self.navigationController!.pushViewController(mainPage, animated: true)
    }
     func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath){
        if cell.respondsToSelector("setSeparatorInset::"){
            cell.separatorInset = UIEdgeInsetsZero
        }
        
        if cell.respondsToSelector("setLayoutMargins:"){
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 138
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.groupsList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell: GroupsListCell = tableView.dequeueReusableCellWithIdentifier("GroupsListCell", forIndexPath: indexPath) as! GroupsListCell
        
        let currGroup: Group = self.groupsList.objectAtIndex(indexPath.row) as! Group
        cell.setSubviewsSettings() // has to b before touching the cell properies
        cell.lblGroupName.text = currGroup.nvGroupName
        cell.lblGroupName.sizeToFit()
        cell.btnFriendsNumber.setTitle("\(currGroup.iNumOfMembers)", forState: UIControlState.Normal)
        cell.btnFriendsNumber.setTitle("\(currGroup.iNumOfMembers)", forState: UIControlState.Highlighted)
        cell.btnFriendsNumber.titleLabel?.textAlignment = NSTextAlignment.Center
        cell.setSubviewsFrames() // has to b after touching the cell properies
        cell.imgBg.image = self.imgsDict[currGroup.iGroupId] as? UIImage
        return cell
    }
    

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if ActiveUser.sharedInstace.didLoginToQB == true{
            let currGroup: Group = self.groupsList.objectAtIndex(indexPath.row) as! Group
            
            var currGroupDialog = QBChatDialog()
            currGroupDialog.ID = currGroup.nvQBDialogId//"55054cec535c12182b00e67f"
            currGroupDialog.roomJID = currGroup.nvQBRoomJid//"19515_55054cec535c12182b00e67f@muc.chat.quickblox.com"
            
            let chatView: ChatGroupViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ChatGroupViewControllerId") as! ChatGroupViewController
            chatView.dialog = currGroupDialog // missing the dialog.recipientID,need to use creatDialog for that.
            chatView.currGroup = currGroup
            
            self.navigationController!.pushViewController(chatView, animated: true)
        }else{
            var alert = UIAlertController(title: NSLocalizedString("Error", comment: "") as String/*"שגיאה"*/, message: (NSLocalizedString("Message history failed to load", comment: "") as String) + " " +  (NSLocalizedString("Try again", comment: "") as String)/* "חיבורי הצ׳אט אינם זמינים, אנא נסה שוב מאוחר יותר"*/, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Confirmation", comment: "") as String/*"אישור"*/, style: UIAlertActionStyle.Cancel, handler: {
                action in action.style
                self.navigationController?.popViewControllerAnimated(true)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
        
    func downloadImageFromServer(){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            for currGroup in self.groupsList{
                if (self.imgsDict.objectForKey((currGroup as! Group).iGroupId)) == nil{
                    self.imgsDict.setObject(ImageHandler.getImageBase64FromUrl((currGroup as! Group).nvImage), forKey: (currGroup as! Group).iGroupId)
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                //FIXME: in order to not show empty table until the groupslist did fill 10.11
                self.generic.hideNativeActivityIndicator(self)
                self.tableView.hidden=false
                self.tableView.reloadData()
                //                self.generic.hideNativeActivityIndicator(self)
                //
            }
        })
        
    }
    
    
    func addInfoViews(){
        viewNoGroups.backgroundColor = UIColor.clearColor()
        
        var imgView = UIImageView(image: UIImage(named: "baloon"))
        var size = CGSizeMake(imgView.image!.size.width/2, imgView.image!.size.height/2)
        
        
        var lblInfo = UILabel()
        lblInfo.text = (NSLocalizedString("You do not have groups, presently.Begin creating groups", comment: "") as String)/*"אין לך קבוצות כעת.\nהתחל ביצירת קבוצות"*/
        lblInfo.font = UIFont(name: "spacer", size: 15)
        lblInfo.textColor = UIColor.grayLight()
        lblInfo.lineBreakMode = NSLineBreakMode.ByCharWrapping
        lblInfo.numberOfLines = 0
        lblInfo.sizeToFit()
        
        let spaceBetweenImgToTxt = CGFloat(10)
        let viewH = CGFloat(lblInfo.frame.size.height + size.height + spaceBetweenImgToTxt)
        let ViewW = lblInfo.frame.size.width > size.width ? lblInfo.frame.size.width : size.width
        
        viewNoGroups.frame = CGRectMake((UIScreen.mainScreen().bounds.size.width - lblInfo.frame.size.width)/2, (UIScreen.mainScreen().bounds.size.height - viewH)/2, ViewW, viewH)
        
        imgView.frame = CGRectMake((viewNoGroups.frame.size.width - size.width)/2, 0, size.width, size.height)
        lblInfo.frame = CGRectMake((viewNoGroups.frame.size.width - lblInfo.frame.size.width)/2, imgView.frame.origin.y + imgView.frame.size.height + spaceBetweenImgToTxt, lblInfo.frame.size.width, lblInfo.frame.size.height)
        
        viewNoGroups.addSubview(imgView)
        viewNoGroups.addSubview(lblInfo)
        
        self.view.addSubview(viewNoGroups)
    }
}

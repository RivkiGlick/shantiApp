//
//  PendingGroupsViewController.swift
//  Shanti
//
//  Created by hodaya ohana on 3/12/15.
//  Copyright (c) 2015 webit. All rights reserved.
//NSLocalizedString("Meeting points", comment: "") as String

import UIKit

class PendingGroupsViewController: GlobalViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var pendingGroups = NSMutableArray()
    var generic = Generic()
    var approvedGroups = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setSubviewsConfig()
        self.getPendingGroupsInfoFromServer()
    }
    
    override func viewWillLayoutSubviews() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    func rotated()
    {
        self.removeSubviews()
        self.setSubviewsConfig()
        self.getPendingGroupsInfoFromServer()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setSubviewsConfig(){
        self.setNavigationSettings()
        self.setSubviewsDelegate()
        self.setSubviewsGraphics()
        self.setSubviewsFrames()
    }
    func setNavigationSettings(){
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.purpleHome()
        self.navigationController?.navigationBar.setBackgroundImage(ImageProcessor.imageWithColor(UIColor.purpleHome()), forBarMetrics: UIBarMetrics.Default)
        self.navigationItem.rightBarButtonItem = nil
        self.title = NSLocalizedString("Joining requests", comment: "") as String/*"בקשות הצטרפות"*/
        
        self.navigationItem.rightBarButtonItem =  nil
    }
    
    func setSubviewsDelegate(){
        if self.tableView != nil
        {
        self.tableView.registerNib(UINib(nibName: "PendingGroupsTableViewCell", bundle: nil), forCellReuseIdentifier: "PendingGroupsTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        }
    }
    
    func setSubviewsGraphics(){
        if self.tableView != nil
        {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.separatorColor = UIColor.whiteColor()
        }
    }
    
    func getPendingGroupsInfoFromServer(){
        self.generic.showNativeActivityIndicator(self)
        Connection.connectionToService("GetUserPendingGroups", params: ["id":ActiveUser.sharedInstace.iUserId], completion: {
            data -> Void in
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("GetUserPendingGroups:\(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSArray
            if json != nil
            {
                if let parseJSON = json
                {
                    if parseJSON.count > 0
                    {
                        for groupDict in parseJSON{
                            self.pendingGroups.addObject(Group.parseGroupDictionary(groupDict as! NSDictionary))
                        }
                    }
                    else
                    {
                        self.addInfoViews()
                    }
                    
                }
                else
                {
                   self.tableView.reloadData()
                }
                
            }
            else
            {
                self.addInfoViews()
            }
            self.generic.hideNativeActivityIndicator(self)
        })
    }
    
    func setSubviewsFrames(){
        if self.tableView != nil
        {
        self.tableView.frame = CGRectMake(0,0,UIScreen.mainScreen().bounds.size.width,UIScreen.mainScreen().bounds.size.height)
    }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.pendingGroups.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell: PendingGroupsTableViewCell = tableView.dequeueReusableCellWithIdentifier("PendingGroupsTableViewCell", forIndexPath: indexPath) as! PendingGroupsTableViewCell
        
        let currGroup = self.pendingGroups.objectAtIndex(indexPath.row) as! Group
        cell.imgGroupProfile.image = ImageHandler.getImageBase64FromUrl(currGroup.nvImage)
        var a=NSLocalizedString("Group", comment: "") as String
        cell.lblGroupName.text = "\(a)\(currGroup.nvGroupName)"
        cell.lblGroupName.sizeToFit()
        cell.lblRequestDate.text = currGroup.dtCreateDate//"יום א׳ 12 במרץ 12:24"//TODO: add in server request date
        cell.lblRequestDate.sizeToFit()
        cell.backgroundColor = UIColor.offwhiteBasic()
        cell.setSubviewsFrames()
        
        cell.btnRejectGroup.tag = currGroup.iGroupId
        cell.btnApproveGroup.tag = currGroup.iGroupId
        cell.btnRejectGroup.addTarget(self, action: "rejectGroup:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.btnRejectGroup.addTarget(self, action: "cellRejectBtnBgColorOnRelease:", forControlEvents: UIControlEvents.TouchDown)
        cell.btnApproveGroup.addTarget(self, action: "aprovalGroup:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.btnApproveGroup.addTarget(self, action: "cellApproveBtnBgColorOnRelease:", forControlEvents: UIControlEvents.TouchDown)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 110
    }
    
    func rejectGroup(sender: AnyObject){
        if let presedBtn = sender as? UIButton{
            presedBtn.backgroundColor = UIColor.clearColor()
            self.generic.showNativeActivityIndicator(self)
            Connection.connectionToService("RejectUserGroup", params: ["iUserId":ActiveUser.sharedInstace.iUserId,"iGroupId":presedBtn.tag], completion: {
                data -> Void in
                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("RejectUserGroupResult:\(strData)")
                var err: NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? String;
                if (strData!.boolValue == true){
                    for currGroup in self.pendingGroups{
                        if (currGroup as! Group).iGroupId == presedBtn.tag{
                            self.pendingGroups.removeObject(currGroup)
                            self.tableView.reloadData()
                        }
                    }
                }
                self.generic.hideNativeActivityIndicator(self)
            })
        }
    }
    
    func cellRejectBtnBgColorOnRelease(sender: AnyObject){ //Touch Down action
        if let presedBtn = sender as? UIButton{
                presedBtn.backgroundColor = UIColor.grayMedium()
                presedBtn.setTitleColor(UIColor.grayDark(), forState: UIControlState.Highlighted)
        }
    }
    
    func aprovalGroup(sender: AnyObject){
        if let presedBtn = sender as? UIButton{
            presedBtn.backgroundColor = UIColor.clearColor()
            self.generic.showNativeActivityIndicator(self)
            Connection.connectionToService("ApprovalUserGroup", params: ["iUserId":ActiveUser.sharedInstace.iUserId,"iGroupId":presedBtn.tag], completion: {
                data -> Void in
                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("ApprovalUserGroupResult:\(strData)")
                var err: NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? String;
                if (strData!.boolValue == true){
                    for currGroup in self.pendingGroups{
                        if (currGroup as! Group).iGroupId == presedBtn.tag{
                            self.approvedGroups.addObject(currGroup)
                            self.pendingGroups.removeObject(currGroup)
                            self.tableView.reloadData()
                        }
                    }
                }
                self.generic.hideNativeActivityIndicator(self)
            })
        }

    }

    func cellApproveBtnBgColorOnRelease(sender: AnyObject){ //Touch Down action
        if let presedBtn = sender as? UIButton{
            presedBtn.backgroundColor = UIColor.purpleLight()
        }
    }
    
    
    override func popBack(sender: AnyObject){
        if let groupsView: GroupsViewController = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 2] as? GroupsViewController{
            groupsView.groupsList.addObjectsFromArray(self.approvedGroups as [AnyObject])
            self.navigationController?.popViewControllerAnimated(true)
        }else{
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }

    func addInfoViews(){
        var view = UIView()
        view.backgroundColor = UIColor.clearColor()
        
        var imgView = UIImageView(image: UIImage(named: "empty_notfications"))
        var size = CGSizeMake(imgView.image!.size.width/2, imgView.image!.size.height/2)
        
        
        var lblInfo = UILabel()
        lblInfo.text = NSLocalizedString("Presently, you have no join request", comment: "") as String/*"אין לך בקשות הצטרפות כעת."*/
        lblInfo.font = UIFont(name: "spacer", size: 15)
        lblInfo.textColor = UIColor.grayLight()
        lblInfo.sizeToFit()
        
        let spaceBetweenImgToTxt = CGFloat(10)
        let viewH = CGFloat(lblInfo.frame.size.height + size.height + spaceBetweenImgToTxt)
        let ViewW = lblInfo.frame.size.width > size.width ? lblInfo.frame.size.width : size.width
        
        view.frame = CGRectMake((UIScreen.mainScreen().bounds.size.width - lblInfo.frame.size.width)/2, (UIScreen.mainScreen().bounds.size.height - viewH)/2, ViewW, viewH)
        
        imgView.frame = CGRectMake((view.frame.size.width - size.width)/2, 0, size.width, size.height)
        lblInfo.frame = CGRectMake((view.frame.size.width - lblInfo.frame.size.width)/2, imgView.frame.origin.y + imgView.frame.size.height + spaceBetweenImgToTxt, lblInfo.frame.size.width, lblInfo.frame.size.height)
        
        view.addSubview(imgView)
        view.addSubview(lblInfo)
        
        self.view.addSubview(view)
    }
    
    func removeSubviews()
    {
        let subviews = self.view.subviews as! [UIView]
        for v in subviews {
            if v.isKindOfClass(UIView)
            {
                    v.removeFromSuperview()
                
                }
                
            }
            
        }
}

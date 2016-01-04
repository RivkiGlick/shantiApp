//
//  GroupProfileViewController.swift
//  Shanti
//
//  Created by hodaya ohana on 5/6/15.
//  Copyright (c) 2015 webit. All rights reserved.
//NSLocalizedString("", comment: "") as String

import UIKit

class GroupProfileViewController: GlobalViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    @IBOutlet weak var scrollViewGroupDetails: UIScrollView!
    @IBOutlet weak var viewBgToImgProfile: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblGroupName: UILabel!
    @IBOutlet weak var lblGroupType: UILabel!
    @IBOutlet weak var lblFriendsNum: UILabel!
    @IBOutlet weak var lblAboutTitile: UILabel!
    @IBOutlet weak var lblAboutText: UILabel!
    @IBOutlet weak var scrollViewFriends: UIScrollView!
    @IBOutlet weak var lblFriendsTitle: UILabel!
    @IBOutlet weak var tableViewFriends: UITableView!
    
    var group: Group = Group()
    var imgsDict = NSMutableDictionary()
    var btnSaveChanges: UIBarButtonItem!
    var deleteUsersArry: [Int] = []
    var addUsersDict = NSMutableDictionary()
    var userInGroup = NSMutableArray()
    var addUsersArr: [Int] = []
    
    var btnAddFriends = UIButton()
    var lblFriendsAdded = UILabel()
    var txtSearchUser = UITextField()
    var btnSearchUser = UIButton()
    var tableViewAddFriends = UITableView()
    var btnX = UIButton()
    let cellH = CGFloat(50.0)
    let spaceBetweenTxts = CGFloat(10.0)
    let txtsW = CGFloat(291.5)
    var groupImgLink: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupImgLink = self.group.nvImage
        for user in self.group.UsersList
        {
            if (user as! User).bIsActive
            {
                self.userInGroup.addObject(user)
                println("userInGroup:\(user)")
            }
        }
        println(self.userInGroup)
        
        
        self.setDesign()
        self.setNavigationController()
        self.downloadImageFromServer()
        self.setConfig()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setConfig(){
        self.setSubviewsConfig()
        //        self.setSubviewsFrames()
        self.tableViewFriends.reloadData()
        self.tableViewFriends.tableFooterView = UIView(frame: CGRectZero)
    }
    
    func setDesign(){
        //textAlignment
        var textAlignment: NSTextAlignment = .Left
        let languageId = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) as! String
        if languageId == "he"{
            textAlignment = .Right
        }
        
        lblGroupName.textAlignment = textAlignment
        lblAboutTitile.textAlignment = textAlignment
        lblAboutText.textAlignment = textAlignment
        lblFriendsTitle.textAlignment = textAlignment
        
        lblFriendsNum.textAlignment = .Center
        lblGroupType.textAlignment = .Center
        
        
        for view in self.view.subviews{
            if view.isKindOfClass(UIView) {
                view.layer.shadowColor = UIColor.grayMedium().CGColor
                view.layer.shadowOpacity = 1
                view.layer.shadowOffset = CGSizeMake(0, 0.5)
                view.layer.shadowRadius = 0.2
            }
        }
    }
    
    func setNavigationController(){
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.purpleHome()
        self.navigationController?.navigationBar.setBackgroundImage(ImageProcessor.imageWithColor(UIColor.purpleHome()), forBarMetrics: UIBarMetrics.Default)
        self.navigationItem.rightBarButtonItem = nil
        self.title = NSLocalizedString("Group profile", comment: "") as String/*"פרופיל קבוצה"*/
        
        //        if self.group.iMainUserId == ActiveUser.sharedInstace.iUserId{
        var saveChanges = UIButton()
        saveChanges.setTitle(NSLocalizedString("Edit", comment: "") as String/*"ערוך"*/, forState: UIControlState.Normal)
        saveChanges.setTitle(NSLocalizedString("Edit", comment: "") as String/*"ערוך"*/, forState: UIControlState.Highlighted)
        saveChanges.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        saveChanges.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        //            saveChanges.titleLabel?.font = UIFont(name: "spacer", size: 17.5)
        saveChanges.backgroundColor = UIColor.clearColor()
        saveChanges.sizeToFit()
        saveChanges.frame = CGRectMake((self.navigationController!.navigationBar.bounds.size.width - saveChanges.frame.size.width)/2 - 10, (self.navigationController!.navigationBar.bounds.size.height - saveChanges.frame.size.height)/2, saveChanges.frame.size.width, saveChanges.frame.size.height)
        saveChanges.addTarget(self, action: "createEditableProfile:", forControlEvents: UIControlEvents.TouchUpInside)
        self.btnSaveChanges = UIBarButtonItem(customView: saveChanges)
        self.navigationItem.setRightBarButtonItem(self.btnSaveChanges, animated: true)
        //        }
    }
    
    func setSubviewsConfig(){
        self.view.backgroundColor = UIColor.offwhiteDark()
        
        //scrollViewGroupDetails
        self.scrollViewGroupDetails.backgroundColor = UIColor.offwhiteBasic()
        var a = NSLocalizedString("", comment: "") as String
        self.lblGroupName.text = "(\(a)\(self.group.nvGroupName))"
        self.lblGroupName.textColor = UIColor.grayDark()
        self.lblGroupName.backgroundColor = UIColor.clearColor()
        //        self.lblGroupName.font = UIFont(name: "spacer", size: 15)
        //        self.lblGroupName.sizeToFit()
        
        var codeValue: CodeValue?
        for i in 0...ApplicationData.sharedApplicationDataInstance.groupsArry.count - 1{
            var currVal = ApplicationData.sharedApplicationDataInstance.groupsArry[i]
            if currVal.iKeyId == self.group.iGroupType{
                codeValue = currVal
                break
            }
        }
        
        if codeValue != nil{
            self.lblGroupType.text = "\(codeValue!.nvValue)"
        }else{
            self.lblGroupType.hidden = true
        }
        
        self.lblGroupType.textColor = UIColor.grayMedium()
        self.lblGroupType.backgroundColor = UIColor.clearColor()
        //        self.lblGroupType.font = UIFont(name: "spacer", size: 12)
        //        self.lblGroupType.sizeToFit()
        var b = NSLocalizedString("Friends", comment: "") as String
        self.lblFriendsNum.text = "\(self.group.UsersList.count) \(b)"/*משתמשים*/
        self.lblFriendsNum.textColor = UIColor.grayMedium()
        self.lblFriendsNum.backgroundColor = UIColor.clearColor()
        //        self.lblFriendsNum.font = UIFont(name: "spacer", size: 12)
        //        self.lblFriendsNum.sizeToFit()
        
        self.lblAboutTitile.text = NSLocalizedString("More about the group", comment: "") as String /*"עוד משהו על הקבוצה"*/
        self.lblAboutTitile.textColor = UIColor.grayDark()
        self.lblAboutTitile.backgroundColor = UIColor.clearColor()
        //        self.lblAboutTitile.font = UIFont(name: "spacer", size: 15)
        //        self.lblAboutTitile.sizeToFit()
        
        self.lblAboutText.text = "\(self.group.nvComment)"
        self.lblAboutText.textColor = UIColor.grayMedium()
        self.lblAboutText.backgroundColor = UIColor.clearColor()
        //        self.lblAboutText.font = UIFont(name: "spacer", size: 12)
        //        self.lblAboutText.sizeToFit()
        self.lblAboutText.numberOfLines = 0
        self.lblAboutText.lineBreakMode = NSLineBreakMode.ByWordWrapping
        //        self.lblAboutText.textAlignment = NSTextAlignment.Right
        
        self.viewBgToImgProfile.backgroundColor = UIColor.grayMedium()
        self.imgProfile.contentMode = UIViewContentMode.ScaleAspectFill
        self.imgProfile.clipsToBounds = true
        self.imgProfile.image = ImageHandler.getImageBase64FromUrl(groupImgLink)
        self.imgProfile.layer.cornerRadius = 15
        
        //scrollViewFriendsself
        self.scrollViewFriends.backgroundColor = UIColor.offwhiteBasic()
        
        self.lblFriendsTitle.text = NSLocalizedString("Friends", comment: "") as String/*"החברים"*/
        self.lblFriendsTitle.textColor = UIColor.grayDark()
        self.lblFriendsTitle.backgroundColor = UIColor.clearColor()
        //        self.lblFriendsTitle.font = UIFont(name: "spacer", size: 15)
        //        self.lblFriendsTitle.sizeToFit()
        
        self.tableViewFriends.backgroundColor = UIColor.offwhiteBasic()
        self.tableViewFriends.delegate = self
        self.tableViewFriends.dataSource = self
        self.tableViewFriends.separatorColor = UIColor.clearColor()
        self.tableViewFriends.estimatedRowHeight = 46.5
        self.tableViewFriends.tableFooterView = UIView(frame: CGRectZero)
        self.tableViewFriends.registerNib(UINib(nibName: "GroupFriendCell", bundle: nil), forCellReuseIdentifier: "GroupFriendCell")
    }
    
    func setSubviewsFrames(){
        let spaeBetweenLblGroupNameToUnderLbls = CGFloat(10)
        let spaceBetweenLblsInScrollViewGroupDetails = CGFloat(15)
        let spaceBetweenLblGroupNameToNextLbl = CGFloat(12)
        let spaceBetweenSubTitlesLblToTitles = CGFloat(5)
        let spaceBetweenSubtitlesToLblAboutTitle = CGFloat(23)
        let spaceBetweenScrolls = CGFloat(5)
        let spaceFromLeft = CGFloat(5)
        let spaceBetweenScrollViewGroupDetailsToTop = CGFloat(17.5)
        let spaceBetweenScrollViewGroupDetailsToRight = CGFloat(10)
        
        let imageProfileS = CGFloat(105)
        let viewBgS = CGFloat(112)
        let scrollDetailsW = CGFloat(400)
        let scrollDetailsH = CGFloat(150)
        let scrollFriendsH = CGFloat(179.5)
        let tableViewFriendsH = CGFloat(128.5)
        let tableViewSpaceFromSides = CGFloat(10)
        
        //scrollViewGroupDetails
        self.scrollViewGroupDetails.frame = CGRectMake(2, 5, UIScreen.mainScreen().bounds.size.width - 4, scrollDetailsH)
        self.scrollViewGroupDetails.contentSize = CGSizeMake(scrollDetailsW, scrollDetailsH)
        
        self.viewBgToImgProfile.frame = CGRectMake(self.scrollViewGroupDetails.contentSize.width - viewBgS - spaceBetweenScrollViewGroupDetailsToRight, spaceBetweenScrollViewGroupDetailsToTop, viewBgS, viewBgS)
        self.imgProfile.frame = CGRectMake((self.viewBgToImgProfile.frame.size.width - imageProfileS)/2, (self.viewBgToImgProfile.frame.size.height - imageProfileS)/2, imageProfileS, imageProfileS)
        self.lblGroupName.frame = CGRectMake(self.viewBgToImgProfile.frame.origin.x - self.lblGroupName.frame.size.width - spaceBetweenLblGroupNameToNextLbl, self.viewBgToImgProfile.frame.origin.y, self.lblGroupName.frame.size.width, self.lblGroupName.frame.size.height)
        self.lblGroupType.frame = CGRectMake(self.viewBgToImgProfile.frame.origin.x - self.lblGroupType.frame.size.width - spaceBetweenLblGroupNameToNextLbl - spaceBetweenSubTitlesLblToTitles, self.lblGroupName.frame.origin.y + self.lblGroupName.frame.size.height + spaeBetweenLblGroupNameToUnderLbls, self.lblGroupType.frame.size.width, self.lblGroupType.frame.size.height)
        self.lblFriendsNum.frame = CGRectMake(self.lblGroupType.frame.origin.x - self.lblFriendsNum.frame.size.width - spaceBetweenLblsInScrollViewGroupDetails, self.lblGroupType.frame.origin.y, self.lblFriendsNum.frame.size.width, self.lblFriendsNum.frame.size.height)
        self.lblAboutTitile.frame = CGRectMake(self.viewBgToImgProfile.frame.origin.x - self.lblAboutTitile.frame.size.width - spaceBetweenLblGroupNameToNextLbl, self.lblGroupType.frame.origin.y + self.lblGroupType.frame.size.height + spaceBetweenSubtitlesToLblAboutTitle, self.lblAboutTitile.frame.size.width, self.lblAboutTitile.frame.size.height)
        self.lblAboutText.frame = CGRectMake(spaceFromLeft, self.lblAboutTitile.frame.origin.y + self.lblAboutTitile.frame.size.height + spaeBetweenLblGroupNameToUnderLbls, self.viewBgToImgProfile.frame.origin.x - spaceFromLeft - spaceBetweenLblGroupNameToNextLbl - spaceBetweenSubTitlesLblToTitles, self.viewBgToImgProfile.frame.origin.y + self.viewBgToImgProfile.frame.size.height - (self.lblAboutTitile.frame.origin.y + self.lblAboutTitile.frame.size.height + spaeBetweenLblGroupNameToUnderLbls))
        
        self.scrollViewFriends.frame = CGRectMake(self.scrollViewGroupDetails.frame.origin.x, self.scrollViewGroupDetails.frame.origin.y + self.scrollViewGroupDetails.frame.size.height + self.scrollViewGroupDetails.frame.origin.y, self.scrollViewGroupDetails.frame.size.width, scrollFriendsH)
        self.lblFriendsTitle.frame = CGRectMake(self.scrollViewFriends.frame.size.width - spaceBetweenLblGroupNameToNextLbl - self.lblFriendsTitle.frame.size.width, spaceBetweenLblGroupNameToNextLbl,  self.lblFriendsTitle.frame.size.width,  self.lblFriendsTitle.frame.size.height)
        self.tableViewFriends.frame = CGRectMake(tableViewSpaceFromSides, self.lblFriendsTitle.frame.origin.y + self.lblFriendsTitle.frame.size.height + 8, self.scrollViewFriends.frame.size.width - tableViewSpaceFromSides * 2, tableViewFriendsH)
        
        self.btnAddFriends.frame = CGRectMake(self.scrollViewFriends.frame.size.width - spaceBetweenLblGroupNameToNextLbl - self.btnAddFriends.frame.size.width, self.tableViewFriends.frame.origin.y + self.tableViewFriends.frame.size.height, self.btnAddFriends.frame.size.width, self.btnAddFriends.frame.size.height)
        self.lblFriendsAdded.frame = CGRectMake(self.btnAddFriends.frame.origin.x - self.lblFriendsAdded.frame.size.width - 15, self.btnAddFriends.frame.origin.y, self.lblFriendsAdded.frame.size.width, self.btnAddFriends.frame.size.height)
        self.txtSearchUser.frame = CGRectMake(self.tableViewFriends.frame.size.width - spaceBetweenLblGroupNameToNextLbl - 290, self.btnAddFriends.frame.origin.y + self.btnAddFriends.frame.size.height + 5, 290, 50)
        self.scrollViewFriends.frame = CGRectMake(self.scrollViewGroupDetails.frame.origin.x, self.scrollViewGroupDetails.frame.origin.y + self.scrollViewGroupDetails.frame.size.height + self.scrollViewGroupDetails.frame.origin.y, self.scrollViewGroupDetails.frame.size.width, self.txtSearchUser.frame.origin.y + self.txtSearchUser.frame.size.height + 10)
    }
    
    func downloadImageFromServer(){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            for currUser in self.group.UsersList{
                self.imgsDict.setObject(ImageHandler.getImageBase64FromUrl((currUser as! User).nvImage), forKey: "\((currUser as! User).iUserId)")
            }
            self.tableViewFriends.reloadData()
            
            for currUser in self.addUsersDict.allValues{
                (currUser as! User).image = (ImageHandler.getImageBase64FromUrl((currUser as! User).nvImage))
            }
            self.tableViewAddFriends.reloadData()
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView == tableViewFriends{
            return self.userInGroup.count
        }else{
            return self.addUsersDict.allKeys.count
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if tableView == tableViewFriends{
            let tableViewCellH = CGFloat(46.5)
            return tableViewCellH
        }else{
            return self.cellH
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell: GroupFriendCell = tableView.dequeueReusableCellWithIdentifier("GroupFriendCell") as! GroupFriendCell
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, tableView.frame.size.width, cell.frame.size.height)
        println("self.userInGroup.objectAtIndex:\(self.userInGroup.objectAtIndex(indexPath.row) as! User)")
        let currUser = self.userInGroup.objectAtIndex(indexPath.row) as! User
        //        if currUser.bIsActive
        //        {
        
        cell.lblUserName.text = "\(currUser.nvShantiName)"//\(currUser.nvFirstName) \(currUser.nvLastName) "
        cell.lblSeparator.text = ""
        cell.lblUserAddress.text = "\(currUser.oCountry.nvValue)"
        if(cell.lblUserName.text != ""  && cell.lblUserAddress.text != ""){
            cell.lblSeparator.text = "-"
        }
        if currUser.iUserId == self.group.iMainUserId{
            cell.lblUserInfo.text = NSLocalizedString("Group administrator", comment: "") as String /*"מנהל קבוצה"*/
        }else{
            cell.lblUserInfo.hidden = true
        }
        cell.btnDeletefriend.hidden = true
        
        cell.btnDeletefriend.tag = currUser.iUserId
        cell.btnDeletefriend.addTarget(self, action: "deleteFriendByTag:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.imgProfile.image = self.imgsDict.valueForKey("\((currUser as User).iUserId)") as? UIImage
        cell.setSubviewsFrame()
        return cell
        //        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if let srchBtn = self.scrollViewFriends.viewWithTag(self.tableViewAddFriends.tag) as? UIButtonSearch{
            self.addUserDetailsView(srchBtn, userDetails: (self.addUsersDict.allValues[indexPath.row] as! User))
        }
        self.txtSearchUser.text = ""
        self.closeTableView(tableViewAddFriends)
    }
    
    func closeTableView(sender: AnyObject){
        tableViewAddFriends.removeFromSuperview()
        //        self.scrollViewFriends.scrollEnabled = true
    }
    
    func addUserDetailsView(forSrchBtn: UIButtonSearch, userDetails: User){
        var userView = UIView(frame: CGRectMake(forSrchBtn.frame.origin.x, forSrchBtn.frame.origin.y + forSrchBtn.frame.size.height + spaceBetweenTxts, (forSrchBtn.textField.frame.origin.x + forSrchBtn.textField.frame.size.width) - forSrchBtn.frame.origin.x,forSrchBtn.frame.size.height ))
        userView.tag = userDetails.iUserId
        
        let requestW = CGFloat(94.0)
        let requestH = CGFloat(29.0)
        
        var btnRequest = UIButton(frame: CGRectMake(0, (userView.frame.size.height - requestH)/2, requestW, requestH))
        btnRequest.setTitle(NSLocalizedString("Send a request", comment: "") as String/*"שלח בקשה"*/, forState: UIControlState.Normal)
        btnRequest.setTitle(NSLocalizedString("Send a request", comment: "") as String/*"שלח בקשה"*/, forState: UIControlState.Highlighted)
        btnRequest.setTitleColor(UIColor.grayDark(), forState: UIControlState.Normal)
        btnRequest.setTitleColor(UIColor.grayDark(), forState: UIControlState.Highlighted)
        btnRequest.setBackgroundImage(ImageProcessor.imageWithColor(UIColor.offwhiteBasic()), forState: UIControlState.Normal)
        btnRequest.setBackgroundImage(ImageProcessor.imageWithColor(UIColor(red: 233/255, green: 229/255, blue: 220/255, alpha: 1)), forState: UIControlState.Highlighted)
        btnRequest.addTarget(self, action: "sendUserRequest:", forControlEvents: UIControlEvents.TouchUpInside)
        btnRequest.titleLabel?.font = UIFont(name: "spacer", size: 15.0)
        btnRequest.layer.cornerRadius = 3
        btnRequest.layer.borderWidth = 0.5
        btnRequest.layer.borderColor = UIColor(red: 128/255, green: 137/255, blue: 148/255, alpha:1).CGColor
        btnRequest.tag = userDetails.iUserId
        
        let imgUserSize = CGFloat(37.5)
        var imgUser = UIImageView(frame: CGRectMake(userView.frame.size.width - imgUserSize, (userView.frame.size.height - imgUserSize)/2, imgUserSize, imgUserSize))
        imgUser.image = User.getUserImageBase64(userDetails.nvImage)
        imgUser.layer.cornerRadius = 14
        imgUser.layer.borderWidth = 2
        imgUser.layer.borderColor = UIColor.greenHome().CGColor
        imgUser.contentMode = UIViewContentMode.ScaleAspectFill
        imgUser.clipsToBounds = true
        
        let spaceBtweenImgToLable = CGFloat(12.5)
        var lblUserInfo = UILabel()
        lblUserInfo.numberOfLines = 0
        lblUserInfo.lineBreakMode = NSLineBreakMode.ByCharWrapping
        //        lblUserInfo.font = UIFont(name: "spacer", size: 15)
        lblUserInfo.text = userDetails.nvShantiName + "\n" + userDetails.oCountry.nvValue//userDetails.nvFirstName + " " + userDetails.nvLastName + "\n" + userDetails.oCountry.nvValue
        //        lblUserInfo.textAlignment = NSTextAlignment.Right
        lblUserInfo.sizeToFit()
        lblUserInfo.backgroundColor = UIColor.clearColor()
        lblUserInfo.textColor = UIColor.grayDark()
        lblUserInfo.frame = CGRectMake(imgUser.frame.origin.x - lblUserInfo.frame.size.width - spaceBtweenImgToLable, (userView.frame.size.height - lblUserInfo.frame.size.height)/2, lblUserInfo.frame.size.width, lblUserInfo.frame.size.height)
        
        userView.addSubview(btnRequest)
        userView.addSubview(imgUser)
        userView.addSubview(lblUserInfo)
        
        if (self.navigationController!.navigationBar.frame.size.height + self.scrollViewFriends.frame.origin.y + self.scrollViewFriends.frame.size.height + userView.frame.size.height + spaceBetweenTxts /*+ self.navigationController!.navigationBar.frame.origin.y + self.navigationController!.navigationBar.frame.size.height*/) > (UIScreen.mainScreen().bounds.size.height - 10 ){
            self.scrollViewFriends.contentSize = CGSizeMake(self.scrollViewFriends.contentSize.width, self.scrollViewFriends.contentSize.height + userView.frame.size.height + spaceBetweenTxts)
        }else{
            self.scrollViewFriends.frame = CGRectMake(self.scrollViewFriends.frame.origin.x, self.scrollViewFriends.frame.origin.y, self.scrollViewFriends.frame.size.width, self.scrollViewFriends.frame.size.height + userView.frame.size.height + spaceBetweenTxts)
            self.scrollViewFriends.contentSize = self.scrollViewFriends.frame.size
        }
        
        //        moving the rest textFields frame after userView frame
        self.moveScrollViewSubviewsAfter(userView)
        self.scrollViewFriends.addSubview(userView)
        self.scrollViewFriends.scrollRectToVisible(userView.frame, animated: true)
    }
    
    func moveScrollViewSubviewsAfter(inputView: UIView){
        for view in self.scrollViewFriends.subviews{
            if view.frame.origin.y >= inputView.frame.origin.y{
                (view as! UIView).frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + inputView.frame.size.height + spaceBetweenTxts, view.frame.size.width, view.frame.size.height)
            }
        }
    }
    
    func sendUserRequest(sender: AnyObject){
        if let senderBtn = sender as? UIButton{
            var newUser = User()
            
            if let requestedUser = self.addUsersDict["\(senderBtn.tag)"] as? User{
                self.addUsersArr.append(requestedUser.iUserId)
                var c=NSLocalizedString("Adding", comment: "") as String
                var d=NSLocalizedString("Friends", comment: "") as String
                self.lblFriendsAdded.text = "\(c)\(self.addUsersArr.count)\(d) "
                self.lblFriendsNum.sizeToFit()///*הוספת *//*משתמשים*/
            }
            
            senderBtn.removeFromSuperview()
        }
    }
    
    func createEditableProfile(sender: AnyObject){
        let editProfile = self.storyboard?.instantiateViewControllerWithIdentifier("GroupEditableProfileViewControllerId") as! GroupEditableProfileViewController
        editProfile.group = self.group
        self.navigationController?.pushViewController(editProfile, animated: true)
    }
    
}


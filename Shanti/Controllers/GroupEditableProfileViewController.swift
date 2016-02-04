//
//  GroupEditableProfileViewController.swift
//  Shanti
//
//  Created by hodaya ohana on 5/19/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

class GroupEditableProfileViewController: GlobalViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {
    
    
    
    @IBOutlet weak var viewGroupDetails: UIView!
    @IBOutlet weak var viewUsers: UIView!
    @IBOutlet weak var scrollViewPrivateDetiles: UIScrollView!
    @IBOutlet weak var viewImgProfileBg: UIView!
    @IBOutlet weak var ImgProfile: UIImageView!
    @IBOutlet weak var txtGroupName: UITextField!
    @IBOutlet weak var btnDeleteGroup: UIButton!
    @IBOutlet weak var btnGeneralGroup: UIButton!
    @IBOutlet weak var btnPrivateGroup: UIButton!
    @IBOutlet weak var lblGeneralGroup: UILabel!
    @IBOutlet weak var lblPrivateGroup: UILabel!
    @IBOutlet weak var lblMoreAboutGroup: UILabel!
    @IBOutlet weak var btnDeleteImg: UIButton!
    @IBOutlet weak var btnChangeImg: UIButton!
    @IBOutlet weak var btnTakePhoto: UIButton!
    @IBOutlet weak var viewSeperator1: UIView!
    @IBOutlet weak var viewSeperator2: UIView!
    @IBOutlet weak var txtMoreAboutGroup: UITextView!
    @IBOutlet weak var lblImgTitle: UILabel!
    
    @IBOutlet weak var bigScrollView: UIScrollView!
    @IBOutlet weak var scrollViewGeneralDetails: UIScrollView!
    @IBOutlet weak var viewGeneralDetails: UIView!
    @IBOutlet weak var lblFriendsTitle: UILabel!
    @IBOutlet weak var tableViewFriends: UITableView!
    @IBOutlet weak var btnAddMoreFriends: UIButton!
    @IBOutlet weak var lblFriendsAddedNum: UILabel!
    
//    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var friensTabelViewConstraint: NSLayoutConstraint!
//    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    var group: Group = Group()
    var imgsDict = NSMutableDictionary()
    var btnSaveChanges: UIBarButtonItem!
    var editableProfile: Bool = false
    var flage: Bool = false
    var deleteUsersArry: [Int] = []
    var addUsersDict = NSMutableDictionary()
    //FIXME8.11.15
    var usersInScroll = NSMutableArray()
    var addUsersArr: [Int] = []
    var userInGroup = NSMutableArray()
    var txtSearchUser = UITextField()
    var tableViewAddFriends = UITableView()
    var btnX = UIButton()
    let cellH = CGFloat(50.0)
    var friensTabelViewConstraintH = CGFloat(0.0)
    let spaceBetweenTxts = CGFloat(10.0)
    let txtsW = CGFloat(291.5)
    var groupImgLink: String!
    var addFriensTaped = false
    var didAddSubViews = false
    var searchBtn = UIButtonSearch()
    override func viewDidLoad() {
        super.viewDidLoad()
//       self.friensTabelViewConstraintH = self.friensTabelViewConstraint.constant
        groupImgLink = self.group.nvImage
        for user in self.group.UsersList
        {
            if (user as! User).bIsActive
            {
                self.userInGroup.addObject(user)
            }
        }
        var array: NSMutableArray = self.group.UsersList
        self.usersInScroll.addObjectsFromArray(array as [AnyObject])
        self.didAddSubViews = false
        self.rotated()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
        self.scrollViewGeneralDetails.frame = CGRectMake(self.scrollViewGeneralDetails.frame.origin.x, self.scrollViewGeneralDetails.frame.origin.y, self.scrollViewGeneralDetails.frame.size.width, self.scrollViewGeneralDetails.frame.size.height)
        if !self.didAddSubViews
        {
        self.changeScrollViewContentSize( self.btnAddMoreFriends.frame.origin.y + self.btnAddMoreFriends.frame.size.height + 20)
            self.rotated()
        }
        
    }
    func rotated()
    {
        self.group.nvImage = ""
        self.setNavigationController()
        self.downloadImageFromServer()
        self.setConfig()
       
    }
    
    func setConfig(){
        self.setSubviewsConfig()
        self.setSubviewsFrames()
        self.tableViewFriends.reloadData()
        self.tableViewFriends.tableFooterView = UIView(frame: CGRectZero)
        if self.addFriensTaped
        {
            self.addMoreFriends(btnAddMoreFriends as UIButton)
        }
    }
    
    func setNavigationController(){
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.purpleHome()
        self.navigationController?.navigationBar.setBackgroundImage(ImageProcessor.imageWithColor(UIColor.purpleHome()), forBarMetrics: UIBarMetrics.Default)
        self.navigationItem.rightBarButtonItem = nil
        self.title = NSLocalizedString("", comment: "") as String /*"פרופיל קבוצה"*/
        
        //        if self.group.iMainUserId == ActiveUser.sharedInstace.iUserId{
        var saveChanges = UIButton()
        saveChanges.setTitle(NSLocalizedString("Save changes", comment: "") as String/*"שמור שינויים"*/, forState: UIControlState.Normal)
        saveChanges.setTitle(NSLocalizedString("Save changes", comment: "") as String/*"שמור שינויים"*/, forState: UIControlState.Highlighted)
        saveChanges.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        saveChanges.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        saveChanges.backgroundColor = UIColor.clearColor()
        saveChanges.sizeToFit()
        saveChanges.frame = CGRectMake((self.navigationController!.navigationBar.bounds.size.width - saveChanges.frame.size.width)/2 - 10, (self.navigationController!.navigationBar.bounds.size.height - saveChanges.frame.size.height)/2, saveChanges.frame.size.width, saveChanges.frame.size.height)
        saveChanges.addTarget(self, action: "updateGroup:", forControlEvents: UIControlEvents.TouchUpInside)
        self.btnSaveChanges = UIBarButtonItem(customView: saveChanges)
        self.navigationItem.setRightBarButtonItem(self.btnSaveChanges, animated: true)
        //        }
    }
    
    func setSubviewsConfig(){
        let titlesFont = UIFont(name: "spacer", size: 15)
        
        self.view.backgroundColor = UIColor.offwhiteDark()
        var tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard:")
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        //scrollViewPrivateDetiles
        self.scrollViewPrivateDetiles.backgroundColor =  UIColor.offwhiteBasic()
        
        self.viewImgProfileBg.backgroundColor = UIColor.grayMedium()
        self.ImgProfile.contentMode = UIViewContentMode.ScaleAspectFill
        self.ImgProfile.clipsToBounds = true
        self.ImgProfile.image = ImageHandler.getImageBase64FromUrl(groupImgLink)
        self.ImgProfile.layer.cornerRadius = 15
        
        self.btnGeneralGroup.setTitle("", forState: UIControlState.Normal)
        self.btnGeneralGroup.setTitle("", forState: UIControlState.Highlighted)
        self.btnGeneralGroup.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).CGColor
        self.btnGeneralGroup.layer.borderWidth = 1.0
        self.btnGeneralGroup.backgroundColor = UIColor.whiteColor()
        self.btnGeneralGroup.addTarget(self, action: "radioBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.txtGroupName.text = self.group.nvGroupName
        self.txtGroupName.textColor = UIColor.grayDark()
        self.txtGroupName.backgroundColor = UIColor.clearColor()
        self.txtGroupName.layer.cornerRadius = 1.5
        self.btnDeleteGroup.addTarget(self, action: "deleteGroup:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.btnGeneralGroup.setTitle("", forState: UIControlState.Normal)
        self.btnGeneralGroup.setTitle("", forState: UIControlState.Highlighted)
        self.btnGeneralGroup.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).CGColor
        self.btnGeneralGroup.layer.borderWidth = 1.0
        self.btnGeneralGroup.backgroundColor = UIColor.whiteColor()
        self.btnGeneralGroup.addTarget(self, action: "radioBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.btnPrivateGroup.setTitle("", forState: UIControlState.Normal)
        self.btnPrivateGroup.setTitle("", forState: UIControlState.Highlighted)
        self.btnPrivateGroup.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).CGColor
        self.btnPrivateGroup.layer.borderWidth = 1.0
        self.btnPrivateGroup.backgroundColor = UIColor.whiteColor()
        self.btnPrivateGroup.addTarget(self, action: "radioBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        
        if self.group.iGroupType == ApplicationData.sharedApplicationDataInstance.groupsArry[0].iKeyId{
            self.btnGeneralGroup.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
        }else if self.group.iGroupType == ApplicationData.sharedApplicationDataInstance.groupsArry[1].iKeyId{
            self.btnPrivateGroup.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
        }
        
        self.lblGeneralGroup.backgroundColor = UIColor.clearColor()
        self.lblGeneralGroup.textColor = UIColor.grayMedium()
        self.lblGeneralGroup.text = ApplicationData.sharedApplicationDataInstance.groupsArry[0].nvValue
        
        self.lblPrivateGroup.backgroundColor = UIColor.clearColor()
        self.lblPrivateGroup.textColor = UIColor.grayMedium()
        self.lblPrivateGroup.text = ApplicationData.sharedApplicationDataInstance.groupsArry[1].nvValue
        
        self.lblImgTitle.text = NSLocalizedString("Image group:", comment: "") as String/*"תמונה לקבוצה:"*/
        self.lblImgTitle.textColor = UIColor.grayDark()
        self.lblImgTitle.backgroundColor = UIColor.clearColor()
        
        self.btnDeleteImg.setTitle(NSLocalizedString("Delete", comment: "") as String/*"מחק"*/, forState: UIControlState.Normal)
        self.btnDeleteImg.setTitle(NSLocalizedString("Delete", comment: "") as String/*"מחק"*/, forState: UIControlState.Highlighted)
        self.btnDeleteImg.setTitleColor(UIColor.grayMedium(), forState: UIControlState.Normal)
        self.btnDeleteImg.setTitleColor(UIColor.grayMedium(), forState: UIControlState.Highlighted)
        self.btnDeleteImg.addTarget(self, action: "deleteImg:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.btnChangeImg.setTitle(NSLocalizedString("Replace", comment: "") as String/*"החלף"*/, forState: UIControlState.Normal)
        self.btnChangeImg.setTitle(NSLocalizedString("Replace", comment: "") as String/*"החלף"*/, forState: UIControlState.Highlighted)
        self.btnChangeImg.setTitleColor(UIColor.grayMedium(), forState: UIControlState.Normal)
        self.btnChangeImg.setTitleColor(UIColor.grayMedium(), forState: UIControlState.Highlighted)
        self.btnChangeImg.addTarget(self, action: "getAlbum:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.btnTakePhoto.setTitle(NSLocalizedString("Take another picture", comment: "") as String/*"צלם שוב"*/, forState: UIControlState.Normal)
        self.btnTakePhoto.setTitle(NSLocalizedString("Take another picture", comment: "") as String/*"צלם שוב"*/, forState: UIControlState.Highlighted)
        self.btnTakePhoto.setTitleColor(UIColor.grayMedium(), forState: UIControlState.Normal)
        self.btnTakePhoto.setTitleColor(UIColor.grayMedium(), forState: UIControlState.Highlighted)
        self.btnTakePhoto.addTarget(self, action: "getCamera:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.viewSeperator1.backgroundColor = UIColor.grayMedium()
        self.viewSeperator2.backgroundColor = UIColor.grayMedium()
        
        self.lblMoreAboutGroup.text = NSLocalizedString("More about the group", comment: "") as String/*"עוד משהו על הקבוצה:"*/
        self.lblMoreAboutGroup.textColor = UIColor.grayDark()
        self.lblMoreAboutGroup.backgroundColor = UIColor.clearColor()
        
        self.txtMoreAboutGroup.text = "\(self.group.nvComment)"
        self.txtMoreAboutGroup.textColor = UIColor.grayMedium()
        self.txtMoreAboutGroup.backgroundColor = UIColor.clearColor()
        self.txtMoreAboutGroup.layer.borderColor = UIColor.grayMedium().CGColor
        self.txtMoreAboutGroup.layer.borderWidth = 1
        self.txtMoreAboutGroup.layer.cornerRadius = 1.5
        
        //scrollViewGeneralDetails
        self.scrollViewGeneralDetails.backgroundColor =  UIColor.offwhiteBasic()
        self.scrollViewGeneralDetails.userInteractionEnabled = true
        self.scrollViewGeneralDetails.exclusiveTouch = true
        self.scrollViewGeneralDetails.canCancelContentTouches = true
        self.scrollViewGeneralDetails.delaysContentTouches = true
        
        var a = NSLocalizedString("The", comment: "") as String
        var b = NSLocalizedString("Friends", comment: "") as String
        self.lblFriendsTitle.text = "\(a)\(b)"/*"החברים"*/
        self.lblFriendsTitle.textColor = UIColor.grayDark()
        self.lblFriendsTitle.backgroundColor = UIColor.clearColor()
        
        self.tableViewFriends.backgroundColor = UIColor.offwhiteBasic()
        self.tableViewFriends.delegate = self
        self.tableViewFriends.dataSource = self
        self.tableViewFriends.separatorColor = UIColor.clearColor()
        self.tableViewFriends.estimatedRowHeight = 46.5
        self.tableViewFriends.tableFooterView = UIView(frame: CGRectZero)
        self.tableViewFriends.registerNib(UINib(nibName: "GroupFriendCell", bundle: nil), forCellReuseIdentifier: "GroupFriendCell")
        
        self.btnAddMoreFriends.setTitle(NSLocalizedString("Join more members", comment: "") as String/*"הוסף משתמשים"*/, forState: UIControlState.Normal)
        self.btnAddMoreFriends.setTitle(NSLocalizedString("Join more members", comment: "") as String/*"הוסף משתמשים"*/, forState: UIControlState.Highlighted)
        self.btnAddMoreFriends.setTitleColor(UIColor.grayMedium(), forState: UIControlState.Normal)
        self.btnAddMoreFriends.setTitleColor(UIColor.grayMedium(), forState: UIControlState.Highlighted)
        self.btnAddMoreFriends.addTarget(self, action: "addMoreFriends:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.lblFriendsAddedNum.text = ""
        self.lblFriendsAddedNum.textColor = UIColor.grayDark()
        self.lblFriendsAddedNum.backgroundColor = UIColor.clearColor()
        self.lblFriendsAddedNum.hidden = true
        
        self.scrollViewGeneralDetails.addSubview(txtSearchUser)
        self.txtSearchUser.backgroundColor = UIColor.whiteColor()
        self.txtSearchUser.textColor = UIColor.grayMedium()
        self.txtSearchUser.delegate = self
        self.txtSearchUser.placeholder = NSLocalizedString("Search by name or Shanty name", comment: "") as String/*"חפש לפי שם או שם שאנטי"*/
        self.txtSearchUser.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).CGColor
        self.txtSearchUser.tag = 1
        self.txtSearchUser.hidden = true
        
        var bgImage = UIImage(named: "close_icn-groups")!
        self.btnX.setBackgroundImage(bgImage, forState: UIControlState.Normal)
        self.btnX.setBackgroundImage(bgImage, forState: UIControlState.Highlighted)
        self.btnX.setTitle("", forState: UIControlState.Normal)
        self.btnX.setTitle("", forState: UIControlState.Highlighted)
        self.btnX.addTarget(self, action: "closeTableView:", forControlEvents: UIControlEvents.TouchUpInside)
        self.btnX.layer.borderColor = UIColor.offwhiteDark().CGColor
        self.btnX.layer.borderWidth = 1.5
        self.btnX.layer.cornerRadius = 3
        
        var headerView = UIView(frame: CGRectMake(0, 0, self.tableViewAddFriends.frame.size.width, self.btnX.frame.size.height + 10))
        headerView.backgroundColor = UIColor.offwhiteBasic()
        headerView.addSubview(self.btnX)
        
        self.tableViewAddFriends.tableHeaderView = headerView
        self.tableViewAddFriends.dataSource = self
        self.tableViewAddFriends.delegate = self
        self.tableViewAddFriends.allowsSelection = true
        
        //textAlignment
        
        var textAlignment: NSTextAlignment = .Left
        let languageId = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) as! String
        if languageId == "he"{
            textAlignment = .Right
            
        }
        
        txtGroupName.textAlignment = textAlignment
        txtMoreAboutGroup.textAlignment = textAlignment
        txtSearchUser.textAlignment = textAlignment
        
        for view in self.view.subviews{
            if view.isKindOfClass(UIView) {
                view.layer.shadowColor = UIColor.grayMedium().CGColor
                view.layer.shadowOpacity = 1
                view.layer.shadowOffset = CGSizeMake(0, 0.5)
                view.layer.shadowRadius = 0.2
            }
        }
        self.btnPrivateGroup.layer.cornerRadius = 6.5
        self.btnGeneralGroup.layer.cornerRadius = 6.5
    }
    
    func setSubviewsFrames(){
        let spaeBetweenLblGroupNameToUnderLbls = CGFloat(10)
        let spaceBetweenLblGroupNameToNextLbl = CGFloat(12)
        let spaceBetweenSubtitlesToLblAboutTitle = CGFloat(23)
        let spaceBetweenScrolls = CGFloat(5)
        let spaceFromLeft = CGFloat(5)
        let spaceBetweenScrollViewGroupDetailsToTop = CGFloat(17.5)
        let spaceBetweenScrollViewGroupDetailsToRight = CGFloat(10)
        
        let imageProfileS = CGFloat(105)
        let viewBgS = CGFloat(112)
        let scrollPrivateH = CGFloat(227.5)
        let scrollGeneralH = CGFloat(210)
        
        let spaceBetweenRadioBtnToLbl = CGFloat(2)
        let spaceBetweenLblToRadioBtn = CGFloat(5)
        let radiosBtnsSize = CGFloat(13.0)
        let btnsPedding = CGFloat(13)
        let txtGroupNameW = CGFloat(150)
        let txtGroupNameH = CGFloat(27)
        let txtMoreAboutH = CGFloat(45)
        let tableViewFriendsH = CGFloat(128.5)
        let tableViewSpaceFromSides = CGFloat(10)
        
        let mailTxtsW = CGFloat(240.5)
        let txtsH = CGFloat(46.0)
        let txtsW = CGFloat(291.5)
        
        self.tableViewFriends.frame = CGRectMake(self.tableViewFriends.frame.origin.x, self.tableViewFriends.frame.origin.y, self.tableViewFriends.frame.size.width, CGFloat(self.userInGroup.count)*cellH)
        self.txtSearchUser.frame = CGRectMake((UIScreen.mainScreen().bounds.size.width - mailTxtsW)/2 ,self.btnAddMoreFriends.frame.origin.y + self.btnAddMoreFriends.frame.size.height , mailTxtsW, txtsH)
  
    }
    
    func changeScrollViewContentSize(contentSizeHeight:CGFloat)
   {
             self.scrollViewGeneralDetails.contentSize = CGSizeMake(self.scrollViewGeneralDetails.frame.size.width,contentSizeHeight)
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
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableViewAddFriends.reloadData()
            }
            
        })
    }
    
    
    func updateGroup(sender: AnyObject){
        self.group.nvGroupName = self.txtGroupName.text
        self.group.nvComment = self.txtMoreAboutGroup.text
        var selectedUsersIDs = NSMutableArray()
        var generic = Generic()
        generic.showNativeActivityIndicator(self)
        Connection.connectionToService("UpdateGroup", params: ["oGroup":Group.getGroupDictionary(self.group),"AddingUsers":addUsersArr,"DeletingUsers":self.deleteUsersArry], completion: {
            data -> Void in
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("UpdateGroup:\(strData)")
            generic.hideNativeActivityIndicator(self)
            
            for currUser in self.group.UsersList
            {
                if (currUser as! User).oUserQuickBlox.ID != -1
                {
                    if contains(self.deleteUsersArry, (currUser as! User).iUserId)
                    {
                        selectedUsersIDs.addObject((currUser as! User).oUserQuickBlox.ID)
                    }
                }
            }
            var deleteUsers :Array<User> = []
            var controllers = self.navigationController?.viewControllers as [AnyObject]!
            for view in controllers{
                //FIXME7.11
                if view.isKindOfClass(UsersListViewController/*MainPage*/){
                    self.navigationController?.popToViewController(view as! UIViewController, animated: true)
                    break
                }
            }
        })
    }
    
    func radioBtnClicked(sender: AnyObject){
        if let clickedBtn = sender as? UIButton{
            if clickedBtn == self.btnGeneralGroup{
                self.btnGeneralGroup.layer.borderWidth = 3
                self.btnGeneralGroup.layer.borderColor = UIColor.whiteColor().CGColor
                self.btnGeneralGroup.backgroundColor = UIColor.grayDark()
                
                self.btnPrivateGroup.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).CGColor
                self.btnPrivateGroup.layer.borderWidth = 1.0
                self.btnPrivateGroup.backgroundColor = UIColor.whiteColor()
                
                for codeVal in ApplicationData.sharedApplicationDataInstance.groupsArry{
                    if (codeVal as CodeValue).nvValue == self.lblGeneralGroup.text{
                        self.group.iGroupType = (codeVal as CodeValue).iKeyId
                        break;
                    }
                }
                
            }else if clickedBtn == self.btnPrivateGroup{
                self.btnPrivateGroup.layer.borderWidth = 3
                self.btnPrivateGroup.layer.borderColor = UIColor.whiteColor().CGColor
                self.btnPrivateGroup.backgroundColor = UIColor.grayDark()
                
                self.btnGeneralGroup.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).CGColor
                self.btnGeneralGroup.layer.borderWidth = 1.0
                self.btnGeneralGroup.backgroundColor = UIColor.whiteColor()
                
                for codeVal in ApplicationData.sharedApplicationDataInstance.groupsArry{
                    if (codeVal as CodeValue).nvValue == self.lblPrivateGroup.text{
                        self.group.iGroupType = (codeVal as CodeValue).iKeyId
                        break;
                    }
                }
            }
        }
    }
    
    func deleteGroup(sender: AnyObject){
        var alert = UIAlertController(title:"", message: NSLocalizedString("Do you want to delete the group?", comment: "") as String /*"למחוק קבוצה?"*/, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title:NSLocalizedString("Cancel", comment: "") as String /*"ביטול"*/, style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title:NSLocalizedString("Confirmation", comment: "") as String /*"אישור"*/, style: UIAlertActionStyle.Default, handler:{ action in action.style
            Connection.connectionToService("DeleteGroup", params: ["iGroupId":self.group.iGroupId], completion: {
                data -> Void in
                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("DeleteGroup\(strData)")
                var controllers = self.navigationController?.viewControllers as [AnyObject]!
                for view in controllers{
                    if view.isKindOfClass(UsersListViewController){
                        self.navigationController?.popToViewController(view as! UIViewController, animated: true)
                        break
                    }
                }
            })
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func getCamera(sender: AnyObject){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            var imag = UIImagePickerController()
            imag.delegate = self
            imag.sourceType = UIImagePickerControllerSourceType.Camera;
            imag.allowsEditing = false
            
            self.presentViewController(imag, animated: true, completion: nil)
        }
    }
    
    func deleteImg(sender: AnyObject){
        self.group.nvImage = ""
    }
    
    func getAlbum(sender: AnyObject){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            var imag = UIImagePickerController()
            imag.delegate = self
            imag.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imag.allowsEditing = false
            
            self.presentViewController(imag, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!){
        self.dismissViewControllerAnimated(true, completion: nil)
        self.ImgProfile.image = image
        self.group.nvImage =  ImageHandler.convertImageToString(ImageHandler.scaledImage(self.ImgProfile.image, newSize: CGSizeMake(115, 115)))
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool{
        if textField == txtSearchUser{
            self.view.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y - 240, self.view.frame.size.width, self.view.frame.size.height)
            
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField){
        textField.resignFirstResponder()
        if textField == txtSearchUser{
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 240, self.view.frame.size.width, self.view.frame.size.height)
        }
    }
    
    func addMoreFriends(sender: AnyObject){
        
        let subviews = self.scrollViewGeneralDetails.subviews as! [UIView]
        for v in subviews {
            if v.isKindOfClass(UIButtonSearch){
                v.removeFromSuperview()
            }
//            if v.isKindOfClass(UIView){
//                v.removeFromSuperview()
//            }
//            if v.isKindOfClass(UITextField){
//                v.removeFromSuperview()
//            }
        }
        
        self.addFriensTaped = true
        
        (sender as! UIButton).setTitleColor(UIColor.purpleHome(), forState: UIControlState.Normal)
        (sender as! UIButton).setTitleColor(UIColor.purpleHome(), forState: UIControlState.Highlighted)
        
        if self.txtSearchUser.hidden{
            txtSearchUser.hidden = false
            self.lblFriendsAddedNum.hidden = false
            self.addSearchBtn(txtSearchUser)
             self.viewGeneralDetails.frame = CGRectMake(self.viewGeneralDetails.frame.origin.x, self.viewGeneralDetails.frame.origin.y, self.viewGeneralDetails.frame.size.width, self.txtSearchUser.frame.origin.y + self.txtSearchUser.frame.size.height + 30)
        }
        
    }
    
    func addSearchBtn(forTextField: UITextField){
        let spaceBetweenTxtToBtn = CGFloat(5.0)
        let searchBtnSize =  CGFloat(46.0)
        
        var frame = CGRectMake(forTextField.frame.origin.x - spaceBetweenTxtToBtn - searchBtnSize, forTextField.frame.origin.y, searchBtnSize, searchBtnSize)
        searchBtn.frame = frame
        searchBtn.textField = forTextField
        searchBtn.tag = forTextField.tag
        forTextField.tag = 0 // for not gett 2 view's with the same tag when using viewWithTag in didSelectRow - tableView
        searchBtn.addTarget(self, action: "searhBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.scrollViewGeneralDetails.addSubview(searchBtn)
        self.didAddSubViews = true
         self.changeScrollViewContentSize(frame.size.height + frame.origin.y + 20)
    }
    
    func searhBtnClicked(sender: AnyObject){
        if let srchBtn = sender as? UIButtonSearch{
            srchBtn.textField.resignFirstResponder()
            if srchBtn.textField.text != ""{
                self.getUserDetailsByEmailFromServer(srchBtn)
            }else{
                srchBtn.textField.layer.borderColor = UIColor.redColor().CGColor
            }
        }
    }
    
    func getUserDetailsByEmailFromServer(sender: AnyObject){
        if let srchBtn = sender as? UIButtonSearch{
            self.addUsersDict.removeAllObjects()
            Connection.connectionToService("GetUsersBySearchText", params: ["SearchText":srchBtn.textField.text], completion: {
                data -> Void in
                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("GetUsersBySearchText:\(strData)")
                var err: NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSArray
                
                if (json != nil) {
                    for userDict in json! {
                        var curUser: User = User.parseUserJson(JSON(userDict)) as User
                        if curUser.iUserId != ActiveUser.sharedInstace.iUserId
                        {
                            
                            //                            //FIXME8.11.15
                            var b:Bool=Bool(false)
                            //
                            //                            //FIXME 8.11.15
                            for user in self.usersInScroll
                            {
                                if curUser.iUserId == (user as! User).iUserId
                                {
                                    b = true
                                }
                            }
                            if !b
                            {
                                self.addUsersDict.setObject(curUser, forKey: String(curUser.iUserId))
                            }
                        }
                    }
                    self.downloadImageFromServer()
                    self.fiilUsersTable(srchBtn)
                }
            })
        }
    }
    
    func fiilUsersTable(forSrchBtn: UIButtonSearch){
        var hightForTabelView = CGFloat(self.addUsersDict.allKeys.count * 50/*cellH*/)
        if hightForTabelView > self.viewUsers.frame.size.height
        {
            hightForTabelView = self.view.frame.size.height - self.viewGroupDetails.frame.size.height
        }
        self.tableViewAddFriends.frame = CGRectMake(self.searchBtn.frame.origin.x ,self.txtSearchUser.frame.origin.y - hightForTabelView, self.txtSearchUser.frame.size.width + self.searchBtn.frame.size.width + 1 , hightForTabelView )


        self.tableViewAddFriends.tag = forSrchBtn.tag
        self.scrollViewGeneralDetails.addSubview(tableViewAddFriends)
//        self.viewGeneralDetails.bringSubviewToFront(tableViewAddFriends)
//        self.scrollViewGeneralDetails.bringSubviewToFront(tableViewAddFriends)
        self.tableViewAddFriends.reloadData()
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
        if tableView == tableViewFriends{
            var cell: GroupFriendCell = tableView.dequeueReusableCellWithIdentifier("GroupFriendCell") as! GroupFriendCell
            let currUser = self.userInGroup.objectAtIndex(indexPath.row) as! User
            cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, tableView.frame.size.width, cell.frame.size.height)
            cell.lblSeparator.text = ""
            cell.lblUserName.text = "\(currUser.nvShantiName)"
            cell.lblUserAddress.text = "\(currUser.oCountry.nvValue)"
            if(cell.lblUserName.text != ""  && cell.lblUserAddress.text != ""){
                cell.lblSeparator.text = "-"
                
            }
            cell.lblUserInfo.text = ""
            
            if self.group.iMainUserId == ActiveUser.sharedInstace.iUserId
            {
                if currUser.iUserId == self.group.iMainUserId
                {
                    cell.lblUserInfo.text = NSLocalizedString("Group administrator", comment: "") as String /*"מנהל קבוצה"*/
                    cell.btnDeletefriend.hidden = true
                    cell.lblUserInfo.hidden = false
                }
                else
                {
                    
                    cell.lblUserInfo.hidden = true
                    cell.btnDeletefriend.hidden = false
                }
                
            }
            else
            {
                
                if currUser.iUserId == ActiveUser.sharedInstace.iUserId
                {
                    cell.btnDeletefriend.hidden = false
                }
                else
                {
                    cell.btnDeletefriend.hidden = true
                }
            }
            
            
            cell.btnDeletefriend.tag = currUser.iUserId
            if contains(self.deleteUsersArry, cell.btnDeletefriend.tag){
                cell.btnDeletefriend.hidden = true
            }
            
            cell.btnDeletefriend.addTarget(self, action: "deleteFriendByTag:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.imgProfile.image = self.imgsDict.valueForKey("\((currUser as User).iUserId)") as? UIImage
            cell.setSubviewsFrame()
            return cell
        }else{
            var cell = tableView.dequeueReusableCellWithIdentifier("CELL") as? UITableViewCell
            
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL")
            }
            
            cell!.frame = CGRectMake(cell!.frame.origin.x, cell!.frame.origin.y, tableView.frame.size.width, cell!.frame.size.height)
            cell!.backgroundColor = UIColor.offwhiteBasic()
            for view in cell!.subviews{
                view.removeFromSuperview()
            }
            
            println("indexPath.row:\(indexPath.row)")
            var currUser: User = self.addUsersDict.allValues[indexPath.row] as! User
            
            let imgUserSize = CGFloat(37.5)
            var imgUser = UIImageView(frame: CGRectMake(cell!.frame.origin.x + cell!.frame.size.width - imgUserSize - 3, (cell!.frame.size.height - imgUserSize)/2, imgUserSize, imgUserSize))
            imgUser.image = currUser.image
            imgUser.layer.cornerRadius = 14
            imgUser.layer.borderWidth = 2
            imgUser.layer.borderColor = UIColor.greenHome().CGColor
            imgUser.contentMode = UIViewContentMode.ScaleAspectFill
            imgUser.clipsToBounds = true
            
            let spaceBtweenImgToLable = CGFloat(12.5)
            var lblUserInfo = UILabel()
            lblUserInfo.numberOfLines = 0
            lblUserInfo.lineBreakMode = NSLineBreakMode.ByCharWrapping
            lblUserInfo.text = currUser.nvShantiName + "\n" + currUser.oCountry.nvValue
            
            lblUserInfo.textAlignment = NSTextAlignment.Right
            lblUserInfo.sizeToFit()
            lblUserInfo.backgroundColor = UIColor.clearColor()
            lblUserInfo.textColor = UIColor.grayDark()
            lblUserInfo.frame = CGRectMake(imgUser.frame.origin.x - lblUserInfo.frame.size.width - spaceBtweenImgToLable, (cell!.frame.size.height - lblUserInfo.frame.size.height)/2, lblUserInfo.frame.size.width, lblUserInfo.frame.size.height)
            
                        cell!.addSubview(imgUser)
                        cell!.addSubview(lblUserInfo)
            
            return cell!
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if let srchBtn = self.scrollViewGeneralDetails.viewWithTag(self.tableViewAddFriends.tag) as? UIButtonSearch
        {
            //FIXME8.11.15
            var b:Bool=Bool(false)
            
            //FIXME 8.11.15
            for user in self.usersInScroll
            {
                let requestedUser1 = self.addUsersDict[srchBtn.tag] as? User
                if requestedUser1?.iUserId == (user as! User).iUserId
                {
                    b = true
                }
            }
            if !b
            {
                self.usersInScroll.addObject(self.addUsersDict.allValues[indexPath.row] as! User)
                self.addUserDetailsView(srchBtn, userDetails: (self.addUsersDict.allValues[indexPath.row] as! User))
            }
            
        }
        self.txtSearchUser.text = ""
        self.closeTableView(tableViewAddFriends)
        
    }
    
    func closeTableView(sender: AnyObject){
        tableViewAddFriends.removeFromSuperview()
    }
    
    func addUserDetailsView(forSrchBtn: UIButtonSearch, userDetails: User){
        var userView = UIView(frame: CGRectMake(forSrchBtn.frame.origin.x, forSrchBtn.frame.origin.y + forSrchBtn.frame.size.height + spaceBetweenTxts, (forSrchBtn.textField.frame.origin.x + forSrchBtn.textField.frame.size.width) - forSrchBtn.frame.origin.x,forSrchBtn.frame.size.height ))
        userView.tag = userDetails.iUserId
        
        let requestW = CGFloat(94.0)
        let requestH = CGFloat(29.0)
        
        var btnRequest = UIButton()
        btnRequest.setTitle(NSLocalizedString("Send a request", comment: "") as String/*"שלח בקשה"*/, forState: UIControlState.Normal)
        btnRequest.setTitle(NSLocalizedString("Send a request", comment: "") as String/*"שלח בקשה"*/, forState: UIControlState.Highlighted)
        btnRequest.setTitleColor(UIColor.grayDark(), forState: UIControlState.Normal)
        btnRequest.setTitleColor(UIColor.grayDark(), forState: UIControlState.Highlighted)
        btnRequest.setBackgroundImage(ImageProcessor.imageWithColor(UIColor.offwhiteBasic()), forState: UIControlState.Normal)
        btnRequest.setBackgroundImage(ImageProcessor.imageWithColor(UIColor(red: 233/255, green: 229/255, blue: 220/255, alpha: 1)), forState: UIControlState.Highlighted)
        btnRequest.addTarget(self, action: "sendUserRequest:", forControlEvents: UIControlEvents.TouchUpInside)
        btnRequest.layer.cornerRadius = 3
        btnRequest.layer.borderWidth = 0.5
        btnRequest.layer.borderColor = UIColor(red: 128/255, green: 137/255, blue: 148/255, alpha:1).CGColor
        btnRequest.tag = userDetails.iUserId
        btnRequest.sizeToFit()
        btnRequest.frame = CGRectMake(0, (userView.frame.size.height - requestH)/2, btnRequest.frame.size.width, requestH)
        
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
        lblUserInfo.text = userDetails.nvShantiName + "\n" + userDetails.oCountry.nvValue
        lblUserInfo.textAlignment = NSTextAlignment.Right
        lblUserInfo.sizeToFit()
        lblUserInfo.backgroundColor = UIColor.clearColor()
        lblUserInfo.textColor = UIColor.grayDark()
        lblUserInfo.frame = CGRectMake(imgUser.frame.origin.x - lblUserInfo.frame.size.width - spaceBtweenImgToLable, (userView.frame.size.height - lblUserInfo.frame.size.height)/2, lblUserInfo.frame.size.width, lblUserInfo.frame.size.height)
        
        
        userView.addSubview(btnRequest)
        userView.addSubview(imgUser)
        userView.addSubview(lblUserInfo)
        
        if (self.viewUsers.frame.origin.y + self.scrollViewGeneralDetails.frame.size.height + userView.frame.size.height + spaceBetweenTxts) > (UIScreen.mainScreen().bounds.size.height - 10 )
        {
            self.didAddSubViews = true
             self.changeScrollViewContentSize(self.scrollViewGeneralDetails.contentSize.height + userView.frame.size.height + spaceBetweenTxts)
        }
        else
        {
            self.scrollViewGeneralDetails.frame = CGRectMake(self.scrollViewGeneralDetails.frame.origin.x, self.scrollViewGeneralDetails.frame.origin.y, self.scrollViewGeneralDetails.contentSize.width, self.scrollViewGeneralDetails.contentSize.height + userView.frame.size.height + spaceBetweenTxts)
            self.didAddSubViews = true
             self.changeScrollViewContentSize(self.scrollViewGeneralDetails.contentSize.height + userView.frame.size.height + spaceBetweenTxts)
        }
        self.moveScrollViewSubviewsAfter(userView)
        self.scrollViewGeneralDetails.addSubview(userView)
        self.scrollViewGeneralDetails.scrollRectToVisible(userView.frame, animated: true)
    }
    
    func moveScrollViewSubviewsAfter(inputView: UIView){
        for view in self.scrollViewGeneralDetails.subviews{
            if view.frame.origin.y >= inputView.frame.origin.y{
                (view as! UIView).frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + inputView.frame.size.height + spaceBetweenTxts, view.frame.size.width, view.frame.size.height)
            }
        }
    }
    
    func sendUserRequest(sender: AnyObject){
        if let senderBtn = sender as? UIButton{
            var newUser = User()
            
            if let requestedUser = self.addUsersDict["\(senderBtn.tag)"] as? User{
                
                //FIXME:15.11
                Connection.connectionToService("AddUserToGroup", params: ["iUserId":requestedUser.iUserId,"iGroupId":self.group.iGroupId,"bIsMainUser":false], completion: {
                    
                    data -> Void in
                    var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("GetUsersBySearchText:\(strData)")
                    var err: NSError?
                    var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSArray
                    
                    if (json != nil) {
                        for userDict in json! {
                        }
                    }
                })
                self.addUsersArr.append(requestedUser.iUserId)
                
                var a=NSLocalizedString("Adding", comment: "") as String
                var b=NSLocalizedString("Friends", comment: "") as String
                self.lblFriendsAddedNum.text = "\(a) \(self.addUsersArr.count) \(b)"
                self.lblFriendsAddedNum.sizeToFit()//הוספת//משתמשים
                self.lblFriendsAddedNum.frame = CGRectMake(self.btnAddMoreFriends.frame.origin.x - self.lblFriendsAddedNum.frame.size.width - 15, self.btnAddMoreFriends.frame.origin.y, self.lblFriendsAddedNum.frame.size.width, self.btnAddMoreFriends.frame.size.height)
                
            }
            
            senderBtn.removeFromSuperview()
        }
    }
    
    func deleteFriendByTag(sender: AnyObject){
        (sender as! UIButton).hidden = true
        self.deleteUsersArry.append((sender as! UIButton).tag)
    }
    func dismissKeyboard(sender: AnyObject){
        self.txtGroupName.resignFirstResponder()
        self.txtMoreAboutGroup.resignFirstResponder()
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool{
        if touch.view.isKindOfClass(UITableViewCell) || touch.view.isKindOfClass(UITableView){
            return false
        }
        return true
    }
}

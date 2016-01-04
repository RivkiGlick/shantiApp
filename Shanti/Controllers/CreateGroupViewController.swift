//
//  CreateGroupViewController.swift
//  Shanti
//
//  Created by hodaya ohana on 2/24/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

class CreateGroupViewController: GlobalViewController,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource/*UIGestureRecognizerDelegate*/{
    
    @IBOutlet var btnSearch1: UIButtonSearch!
    @IBOutlet weak var lblGroupDetails: UILabel!
    @IBOutlet weak var txtGroupName: UITextField!
    @IBOutlet weak var txtComment: UITextField!
    @IBOutlet weak var btnGeneralGroup: UIButton!
    @IBOutlet weak var lblGeneralGroup: UILabel!
    @IBOutlet weak var btnPrivateGroup: UIButton!
    @IBOutlet weak var lblPrivateGroup: UILabel!
    @IBOutlet weak var btnSetGroupImage: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblAddFriends: UILabel!
    @IBOutlet weak var lblFriendsNubmer: UILabel!
    @IBOutlet weak var txtMail1: UITextField!
    @IBOutlet weak var btnCreateGroup: UIButton!
    @IBOutlet weak var imgGroup: UIImageView!
    
    var newGroup: Group = Group()
    
    let spaceFromNavigationToTxt = CGFloat(48.0)
    let spaceBetweenTxts = CGFloat(10.0)
    let spaceBetweenTxtToBtn = CGFloat(5.0)
    let spaceBetweenRadios = CGFloat(29.5)
    let rightBtnX = CGFloat(47.5)
    let radiosBtnsSize = CGFloat(13.0)
    let txtsW = CGFloat(291.5)
    let mailTxtsW = CGFloat(240.5)
    let txtsH = CGFloat(46.0)
    let imgBgH = CGFloat(225.0)
    let searchBtnSize =  CGFloat(46.0)
    let cellH = CGFloat(50.0)
    
    var generic = Generic()
    var usersDict = NSMutableDictionary()
    var tableView = UITableView()
    var btnX = UIButton()
    //FIXME8.11.15
    var usersInScroll = NSMutableArray()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setSubviewsConfig()
        
        //        var tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard:")
        //        tap.delegate = self
        //        self.view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setSubviewsConfig(){
        self.addNavigationSettings()
        self.setDelegateAndTags()
        self.setSubviewsSettings()
        self.setSubviewsFrames()
        //  self.addSearchBtn(self.txtMail1)
    }
    
    func addNavigationSettings(){
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.purpleHome()
        self.navigationController?.navigationBar.setBackgroundImage(ImageProcessor.imageWithColor(UIColor.purpleHome()), forBarMetrics: UIBarMetrics.Default)
        self.title =  NSLocalizedString("New group", comment: "") as String/*"קבוצה חדשה"*/
        self.navigationItem.rightBarButtonItem = nil
    }
    
    
    func setSubviewsSettings(){
        
        //textAlignment
        var space: CGFloat = 10
        var textAlignment: NSTextAlignment = .Left
        let languageId = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) as! String
        if languageId == "he"{
            textAlignment = .Right
            space = -space
        }
        
        txtComment.textAlignment = textAlignment
        txtGroupName.textAlignment = textAlignment
        
        lblGeneralGroup.textAlignment = textAlignment
        lblPrivateGroup.textAlignment = textAlignment
        lblGroupDetails.textAlignment = textAlignment
        
        //make cornerRadius and location placeHolder to the UITextField
        for view in self.view.subviews{
            if view.isKindOfClass(UITextField){
                view.layer.cornerRadius = 3
                view.layer.sublayerTransform = CATransform3DMakeTranslation(space,0,0)
            }
        }
        //make cornerRadius to Radio Buttons
        self.btnGeneralGroup.layer.cornerRadius = 6.5
        self.btnPrivateGroup.layer.cornerRadius = 6.5
        
        let titlesColor = UIColor.grayMedium()
        //        let titlesFont = UIFont(name: "spacer", size: 15)
        
        self.lblGroupDetails.backgroundColor = UIColor.clearColor()
        self.lblGroupDetails.textColor = titlesColor
        //        self.lblGroupDetails.font = titlesFont
        self.lblGroupDetails.text = NSLocalizedString("Group info", comment: "") as String /*"פרטי קבוצה:"*/
        //        self.lblGroupDetails.sizeToFit()
        
        self.txtGroupName.backgroundColor = UIColor.whiteColor()
        self.txtGroupName.textColor = titlesColor
        //        self.txtGroupName.font = titlesFont
        self.txtGroupName.placeholder = NSLocalizedString("Group name", comment: "") as String/*"שם קבוצה"*/
        //        self.txtGroupName.textAlignment = NSTextAlignment.Right
        self.txtGroupName.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).CGColor
        self.txtGroupName.layer.borderWidth = 1.0
        
        self.txtComment.backgroundColor = UIColor.whiteColor()
        self.txtComment.textColor = titlesColor
        //        self.txtComment.font = titlesFont
        self.txtComment.placeholder = NSLocalizedString("Something more", comment: "") as String /*"משהו נוסף..."*/
        //        self.txtComment.textAlignment = NSTextAlignment.Right
        self.txtComment.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).CGColor
        self.txtComment.layer.borderWidth = 1.0
        
        self.btnGeneralGroup.setTitle("", forState: UIControlState.Normal)
        self.btnGeneralGroup.setTitle("", forState: UIControlState.Highlighted)
        self.btnGeneralGroup.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).CGColor
        self.btnGeneralGroup.layer.borderWidth = 1.0
        self.btnGeneralGroup.backgroundColor = UIColor.whiteColor()
        self.btnGeneralGroup.addTarget(self, action: "radioBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.btnGeneralGroup.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
        
        self.btnPrivateGroup.setTitle("", forState: UIControlState.Normal)
        self.btnPrivateGroup.setTitle("", forState: UIControlState.Highlighted)
        self.btnPrivateGroup.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).CGColor
        self.btnPrivateGroup.layer.borderWidth = 1.0
        self.btnPrivateGroup.backgroundColor = UIColor.whiteColor()
        self.btnPrivateGroup.addTarget(self, action: "radioBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.lblGeneralGroup.backgroundColor = UIColor.clearColor()
        self.lblGeneralGroup.textColor = UIColor.grayMedium()
        //        self.lblGeneralGroup.font = titlesFont
        self.lblGeneralGroup.text = ApplicationData.sharedApplicationDataInstance.groupsArry[0].nvValue//((ApplicationData.sharedApplicationDataInstance.groupsArry.objectAtIndex(0) as CodeValue).nvValue)// "קבוצה כללית"
        //        self.lblGeneralGroup.sizeToFit()
        
        self.lblPrivateGroup.backgroundColor = UIColor.clearColor()
        self.lblPrivateGroup.textColor = UIColor.grayMedium()
        //        self.lblPrivateGroup.font = titlesFont
        self.lblPrivateGroup.text = ApplicationData.sharedApplicationDataInstance.groupsArry[1].nvValue//(ApplicationData.sharedApplicationDataInstance.groupsArry.objectAtIndex(1) as CodeValue).nvValue//"קבוצה פרטית"
        //        self.lblPrivateGroup.sizeToFit()
        
        self.imgGroup.contentMode = UIViewContentMode.ScaleAspectFill
        self.imgGroup.clipsToBounds = true
        self.imgGroup.layer.opacity = 0.5
        let url = NSURL(string: "http://qa.webit-track.com/ShantiFiles/Files/Groups/marker_defualt.png")
        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        imgGroup.image = UIImage(data: data!)
        
        
        self.btnSetGroupImage.backgroundColor = UIColor.purpleMedium()
        self.btnSetGroupImage.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.btnSetGroupImage.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        self.btnSetGroupImage.setTitle(NSLocalizedString("Select a different picture", comment: "") as String/*"בחר תמונה לקבוצה"*/, forState: UIControlState.Normal)
        self.btnSetGroupImage.setTitle(NSLocalizedString("Select a different picture", comment: "") as String/*"בחר תמונה לקבוצה"*/, forState: UIControlState.Highlighted)
        self.btnSetGroupImage.addTarget(self, action: "getGroupImg:", forControlEvents: UIControlEvents.TouchUpInside)
        self.btnSetGroupImage.layer.cornerRadius = 3
        self.btnSetGroupImage.layer.borderWidth = 1.0
        self.btnSetGroupImage.layer.borderColor = UIColor.purpleMedium().CGColor
        //  self.btnSetGroupImage.layer.shadowRadius = 1.0
        self.btnSetGroupImage.layer.shadowOffset = CGSizeMake(0, -1.0)
        self.btnSetGroupImage.layer.shadowColor = UIColor(red: 30/255.0, green: 10/255.0, blue: 40/255.0, alpha: 0.75).CGColor
        
        //        self.lblAddFriends.backgroundColor = UIColor.clearColor()
        //        self.lblAddFriends.textColor = titlesColor
        //        self.lblAddFriends.font = titlesFont
        //        self.lblAddFriends.text = NSLocalizedString("Join members", comment: "") as String/*"צרף משתמשים:"*/
        //        self.lblAddFriends.sizeToFit()
        //
        //        self.lblFriendsNubmer.backgroundColor = UIColor.clearColor()
        //        self.lblFriendsNubmer.textColor = titlesColor
        //        self.lblFriendsNubmer.font = titlesFont
        //        self.lblFriendsNubmer.text = ""
        //        self.lblFriendsNubmer.sizeToFit()
        //        self.lblFriendsNubmer.hidden = true
        
        //        self.txtMail1.backgroundColor = UIColor.whiteColor()
        //        self.txtMail1.textColor = titlesColor
        //        self.txtMail1.font = titlesFont
        //        self.txtMail1.placeholder = NSLocalizedString("Search by name or  Shanti name", comment: "") as String /*"חפש לפי שם או שם שאנטי"*/
        //        self.txtMail1.textAlignment = NSTextAlignment.Right
        //        self.txtMail1.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).CGColor
        
        self.btnCreateGroup.backgroundColor = UIColor.purpleMedium()
        self.btnCreateGroup.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.btnCreateGroup.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        self.btnCreateGroup.setTitle(NSLocalizedString("Create new group", comment: "") as String/*"צור את הקבוצה"*/, forState: UIControlState.Normal)
        self.btnCreateGroup.setTitle(NSLocalizedString("Create new group", comment: "") as String/*"צור את הקבוצה"*/, forState: UIControlState.Highlighted)
        self.btnCreateGroup.addTarget(self, action: "createGroup:", forControlEvents: UIControlEvents.TouchUpInside)
        self.btnCreateGroup.layer.cornerRadius = 3
        self.btnCreateGroup.layer.borderWidth = 1.0
        self.btnCreateGroup.layer.borderColor = UIColor.purpleMedium().CGColor
        self.btnCreateGroup.layer.shadowRadius = 1.0
        self.btnCreateGroup.layer.shadowOffset = CGSizeMake(0, -1.0)
        self.btnCreateGroup.layer.shadowColor = UIColor(red: 30/255.0, green: 10/255.0, blue: 40/255.0, alpha: 0.75).CGColor
        //    self.scrollView.backgroundColor = UIColor.clearColor()
        
        self.view.sendSubviewToBack(self.imgGroup)
    }
    
    func setSubviewsFrames(){
        //        self.txtGroupName.frame = CGRectMake((self.view.frame.size.width - txtsW)/2, spaceFromNavigationToTxt, txtsW, txtsH)
        //        self.lblGroupDetails.frame = CGRectMake(self.txtGroupName.frame.origin.x + self.txtGroupName.frame.size.width - self.lblGroupDetails.frame.size.width, spaceFromNavigationToTxt/2, self.lblGroupDetails.frame.size.width, self.lblGroupDetails.frame.size.height)
        //        self.txtComment.frame = CGRectMake(self.txtGroupName.frame.origin.x, self.txtGroupName.frame.origin.y + self.txtGroupName.frame.size.height + spaceBetweenTxts, txtsW, txtsH)
        //        self.btnGeneralGroup.frame = CGRectMake(self.txtGroupName.frame.origin.x + self.txtGroupName.frame.size.width - rightBtnX, self.txtComment.frame.origin.y + self.txtComment.frame.size.height + spaceBetweenTxts * 2, radiosBtnsSize, radiosBtnsSize)
        //        self.btnGeneralGroup.layer.cornerRadius = radiosBtnsSize/2 // to make it rectangle
        //        self.lblGeneralGroup.frame = CGRectMake(self.btnGeneralGroup.frame.origin.x - self.lblGeneralGroup.frame.size.width - 3, (self.btnGeneralGroup.frame.origin.y + (self.btnGeneralGroup.frame.size.height - self.lblGeneralGroup.frame.size.height)/2), self.lblGeneralGroup.frame.size.width, self.lblGeneralGroup.frame.size.height)
        //        self.btnPrivateGroup.frame = CGRectMake(self.lblGeneralGroup.frame.origin.x - spaceBetweenRadios, self.btnGeneralGroup.frame.origin.y, radiosBtnsSize, radiosBtnsSize)
        //        self.btnPrivateGroup.layer.cornerRadius = radiosBtnsSize/2 // to make it rectangle
        //        self.lblPrivateGroup.frame = CGRectMake(self.btnPrivateGroup.frame.origin.x - self.lblPrivateGroup.frame.size.width - 3, (self.btnPrivateGroup.frame.origin.y + (self.btnPrivateGroup.frame.size.height - self.lblPrivateGroup.frame.size.height)/2), self.lblPrivateGroup.frame.size.width, self.lblPrivateGroup.frame.size.height)
        //        self.btnSetGroupImage.frame = CGRectMake(self.txtGroupName.frame.origin.x, self.btnPrivateGroup.frame.origin.y + self.btnPrivateGroup.frame.size.height + spaceBetweenTxts * 2, txtsW, txtsH)
        //        self.imgGroup.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, self.btnSetGroupImage.frame.origin.y + self.btnSetGroupImage.frame.size.height/2)
        //        self.scrollView.frame = CGRectMake(0, self.btnSetGroupImage.frame.origin.y + self.btnSetGroupImage.frame.size.height, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height - (self.btnSetGroupImage.frame.origin.y + self.btnSetGroupImage.frame.size.height))
        //        self.txtMail1.frame = CGRectMake(self.txtGroupName.frame.origin.x + self.txtGroupName.frame.size.width - mailTxtsW, 50, mailTxtsW, txtsH)
        //        self.lblAddFriends.frame = CGRectMake(self.txtMail1.frame.origin.x + self.txtMail1.frame.size.width - self.lblAddFriends.frame.size.width, (self.txtMail1.frame.origin.y - self.lblAddFriends.frame.size.height)/2, self.lblAddFriends.frame.size.width, self.lblAddFriends.frame.size.height)
        //        self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.txtMail1.frame.origin.y + self.txtMail1.frame.size.height)
        //        self.btnCreateGroup.frame = CGRectMake(self.txtGroupName.frame.origin.x, self.scrollView.frame.origin.y + self.scrollView.frame.size.height + spaceBetweenTxts, txtsW, txtsH)
        //        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height)
    }
    
    func addSearchBtn(forTextField: UITextField){
        //        var searchBtn = UIButtonSearch()
        var searchBtn = btnSearch1
        var frame = CGRectMake(forTextField.frame.origin.x - spaceBetweenTxtToBtn - searchBtnSize, forTextField.frame.origin.y, searchBtnSize, searchBtnSize)
        searchBtn.frame = frame
        searchBtn.textField = forTextField
        searchBtn.tag = forTextField.tag
        forTextField.tag = 0 // for not gett 2 view's with the same tag when using viewWithTag in didSelectRow - tableView
        searchBtn.addTarget(self, action: "searhBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.scrollView.addSubview(searchBtn)
    }
    
    func setDelegateAndTags(){
        //        self.tableView.allowsSelection = true
        //        self.tableView.delegate = self
        //        self.tableView.dataSource = self
        self.txtGroupName.delegate = self
        self.txtComment.delegate = self
        //        self.txtMail1.delegate = self
        //        self.txtMail1.tag = 1
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
                        self.newGroup.iGroupType = (codeVal as CodeValue).iKeyId
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
                        self.newGroup.iGroupType = (codeVal as CodeValue).iKeyId as Int
                        break;
                    }
                }
            }
        }
    }
    
    func getGroupImg(sender: AnyObject){
        var actionSheet = UIActionSheet(title: NSLocalizedString("Select a source image", comment: "") as String/*"בחר מקור תמונה"*/, delegate: self, cancelButtonTitle:NSLocalizedString("Cancellation", comment: "") as String /*"ביטול"*/, destructiveButtonTitle: nil, otherButtonTitles:NSLocalizedString("Camera", comment: "") as String,NSLocalizedString("Gallery", comment: "") as String /*"מצלמה"/*, */"אלבום תמונות"*/)
        //        var actionSheet = UIActionSheet(title: /* "בחר מקור תמונה"*/, delegate: self, cancelButtonTitle: /*"ביטול"*/, destructiveButtonTitle: nil, otherButtonTitles: "מצלמה", "אלבום תמונות")
        actionSheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int){
        switch buttonIndex{
        case 1:
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
                var imag = UIImagePickerController()
                imag.delegate = self
                imag.sourceType = UIImagePickerControllerSourceType.Camera;
                imag.allowsEditing = false
                
                self.presentViewController(imag, animated: true, completion: nil)
            }
            break
        case 2:
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
                var imag = UIImagePickerController()
                imag.delegate = self
                imag.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                imag.allowsEditing = false
                
                self.presentViewController(imag, animated: true, completion: nil)
            }
            break
        default:
            break
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!){
        self.dismissViewControllerAnimated(true, completion: nil)
        self.imgGroup.image = image
        self.btnSetGroupImage.setTitle(NSLocalizedString("Select a different picture", comment: "") as String /*"בחר תמונה אחרת"*/, forState: UIControlState.Normal)
        self.btnSetGroupImage.setTitle(NSLocalizedString("Select a different picture", comment: "") as String /*"בחר תמונה אחרת"*/, forState: UIControlState.Highlighted)
    }
    
    func textFieldDidBeginEditing(textField: UITextField){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1)
        
        textField.backgroundColor = UIColor.offwhiteBasic()
        textField.textColor = UIColor.grayDark()
        textField.layer.borderColor = UIColor.grayColor().CGColor
        
        if textField != self.txtGroupName && textField != self.txtComment{
            self.view.frame = CGRectMake(self.view.frame.origin.x, -180, self.view.frame.size.width, self.view.frame.size.height)
        }
        
        UIView.commitAnimations()
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool{
        //        if textField == txtMail1{
        //            self.view.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y - 240, self.view.frame.size.width, self.view.frame.size.height)
        //
        //        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField){
        textField.resignFirstResponder()
        textField.backgroundColor = UIColor.whiteColor()
        textField.textColor = UIColor.grayMedium()
        textField.layer.borderColor = UIColor.grayPastel().CGColor
        //        if textField == txtMail1{
        //            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 240, self.view.frame.size.width, self.view.frame.size.height)
        //        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        //  self.dismissKeyboard(textField)
        return true
    }
    
    func searhBtnClicked(sender: AnyObject){
        if let srchBtn = sender as? UIButtonSearch{
            //     self.dismissKeyboard(sender)
            if srchBtn.textField.text != ""{
                self.getUserDetailsByEmailFromServer(srchBtn)
            }else{
                srchBtn.textField.layer.borderColor = UIColor.redColor().CGColor
            }
        }
    }
    //FIXME9.11.15
    func getUserDetailsByEmailFromServer(sender: AnyObject){
        if let srchBtn = sender as? UIButtonSearch{
            self.usersDict.removeAllObjects()
            Connection.connectionToService("GetUsersBySearchText", params: ["SearchText":srchBtn.textField.text], completion: {
                data -> Void in
                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("GetUsersBySearchText:\(strData)")
                var err: NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSArray
                
                if (json != nil) {
                    for userDict in json! {
                        var curUser: User = User.parseUserJson(JSON(userDict)) as User
                        if curUser.iUserId != ActiveUser.sharedInstace.iUserId{
                            
                            //                            //FIXME8.11.15
                            var b:Bool=Bool(false)
                            //
                            //                            //FIXME 8.11.15
                            for user in self.usersInScroll{
                                if curUser.iUserId == (user as! User).iUserId  {
                                    b = true
                                    
                                }
                            }
                            if !b
                            {
                                self.usersDict.setObject(curUser, forKey: String(curUser.iUserId))
                            }
                            
                            
                        }
                        
                        
                        
                        
                        
                        
                        
                    }
                    
                    self.downloadImagesFromServer()
                    self.fiilUsersTable(srchBtn)
                }
            })
        }
    }
    
    //    func getUserDetailsByEmailFromServer(sender: AnyObject){
    //        if let srchBtn = sender as? UIButtonSearch{
    //            self.usersDict.removeAllObjects()
    //            Connection.connectionToService("GetUsersBySearchText", params: ["SearchText":srchBtn.textField.text], completion: {
    //                data -> Void in
    //                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
    //                println("GetUsersBySearchText:\(strData)")
    //                var err: NSError?
    //                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSArray
    //
    //                if (json != nil) {
    //                    for userDict in json! {
    //                        var curUser: User = User.parseUserJson(JSON(userDict)) as User
    //                        if curUser.iUserId != ActiveUser.sharedInstace.iUserId{
    //                            self.usersDict.setObject(curUser, forKey: String(curUser.iUserId))
    //                        }
    //                    }
    //                    self.downloadImagesFromServer()
    //                    self.fiilUsersTable(srchBtn)
    //                }
    //            })
    //        }
    //    }
    
    func downloadImagesFromServer(){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            for currUser in self.usersDict.allValues{
                (currUser as! User).image = (ImageHandler.getImageBase64FromUrl((currUser as! User).nvImage))
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        })
    }
    
    func fiilUsersTable(forSrchBtn: UIButtonSearch){
        var offsetY = self.scrollView.frame.origin.y + forSrchBtn.frame.origin.y
        var tvH = CGFloat(self.cellH * CGFloat(self.usersDict.allKeys.count))
        
        if tvH > (offsetY - self.txtGroupName.frame.origin.y){
            tvH = (offsetY - self.txtGroupName.frame.origin.y)
        }
        
        self.tableView.frame = CGRectMake(forSrchBtn.frame.origin.x, offsetY - tvH - spaceBetweenTxts, self.txtsW, tvH)
        self.tableView.tag = forSrchBtn.tag
        self.view.addSubview(tableView)
        self.view.bringSubviewToFront(tableView)
        
        self.scrollView.scrollEnabled = false
        self.tableView.reloadData()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.usersDict.allKeys.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
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
        var currUser: User = self.usersDict.allValues[indexPath.row] as! User
        
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
        //        lblUserInfo.font = UIFont(name: "spacer", size: 15)
        lblUserInfo.text = /*currUser.nvFirstName + " " + currUser.nvLastName*/currUser.nvShantiName + "\n" + currUser.oCountry.nvValue
        let languageId = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) as! String
        if languageId == "he"{
            lblUserInfo.textAlignment = NSTextAlignment.Right
        }else{
            lblUserInfo.textAlignment = NSTextAlignment.Left
        }
        
        
        lblUserInfo.textAlignment = NSTextAlignment.Right
        lblUserInfo.sizeToFit()
        lblUserInfo.backgroundColor = UIColor.clearColor()
        lblUserInfo.textColor = UIColor.grayDark()
        lblUserInfo.frame = CGRectMake(imgUser.frame.origin.x - lblUserInfo.frame.size.width - spaceBtweenImgToLable, (cell!.frame.size.height - lblUserInfo.frame.size.height)/2, lblUserInfo.frame.size.width, lblUserInfo.frame.size.height)
        
        cell!.addSubview(imgUser)
        cell!.addSubview(lblUserInfo)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return self.cellH
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if let srchBtn = self.scrollView.viewWithTag(self.tableView.tag) as? UIButtonSearch{
            //FIXME8.11.15
            var b:Bool=Bool(false)
            
            //FIXME 8.11.15
            for user in self.usersInScroll{
                let requestedUser1 = self.usersDict[srchBtn.tag] as? User
                if requestedUser1?.iUserId == (user as! User).iUserId  {
                    b = true
                }
            }
            if !b
            {
                self.usersInScroll.addObject(self.usersDict.allValues[indexPath.row] as! User)
                self.addUserDetailsView(srchBtn, userDetails: (self.usersDict.allValues[indexPath.row] as! User))
            }
            
        }
        self.txtMail1.text = ""
        self.closeTableView(tableView)
    }
    
    func closeTableView(sender: AnyObject){
        tableView.removeFromSuperview()
        self.scrollView.scrollEnabled = true
    }
    
    func addUserDetailsView(forSrchBtn: UIButtonSearch, userDetails: User){
        var userView = UIView(frame: CGRectMake(forSrchBtn.frame.origin.x, forSrchBtn.frame.origin.y + forSrchBtn.frame.size.height + spaceBetweenTxts, (forSrchBtn.textField.frame.origin.x + forSrchBtn.textField.frame.size.width) - forSrchBtn.frame.origin.x,forSrchBtn.frame.size.height ))
        userView.tag = userDetails.iUserId
        
        let requestW = CGFloat(94.0)
        let requestH = CGFloat(29.0)
        
        var btnRequest = UIButton(frame: CGRectMake(0, (userView.frame.size.height - requestH)/2, requestW, requestH))
        btnRequest.setTitle(NSLocalizedString("Send a request", comment: "") as String /*"שלח בקשה"*/, forState: UIControlState.Normal)
        btnRequest.setTitle(NSLocalizedString("Send a request", comment: "") as String /*"שלח בקשה"*/, forState: UIControlState.Highlighted)
        btnRequest.setTitleColor(UIColor.grayDark(), forState: UIControlState.Normal)
        btnRequest.setTitleColor(UIColor.grayDark(), forState: UIControlState.Highlighted)
        btnRequest.setBackgroundImage(ImageProcessor.imageWithColor(UIColor.offwhiteBasic()), forState: UIControlState.Normal)
        btnRequest.setBackgroundImage(ImageProcessor.imageWithColor(UIColor(red: 233/255, green: 229/255, blue: 220/255, alpha: 1)), forState: UIControlState.Highlighted)
        btnRequest.addTarget(self, action: "sendUserRequest:", forControlEvents: UIControlEvents.TouchUpInside)
        //        btnRequest.titleLabel?.font = UIFont(name: "spacer", size: 15.0)
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
        lblUserInfo.text = /*userDetails.nvFirstName + " " + userDetails.nvLastName*/userDetails.nvShantiName + "\n" + userDetails.oCountry.nvValue
        //       lblUserInfo.textAlignment = NSTextAlignment.Right
        lblUserInfo.sizeToFit()
        lblUserInfo.backgroundColor = UIColor.clearColor()
        lblUserInfo.textColor = UIColor.grayDark()
        lblUserInfo.frame = CGRectMake(imgUser.frame.origin.x - lblUserInfo.frame.size.width - spaceBtweenImgToLable, (userView.frame.size.height - lblUserInfo.frame.size.height)/2, lblUserInfo.frame.size.width, lblUserInfo.frame.size.height)
        
        userView.addSubview(btnRequest)
        userView.addSubview(imgUser)
        userView.addSubview(lblUserInfo)
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height + userView.frame.size.height + spaceBetweenTxts)
        
        //        moving the rest textFields frame after userView frame
        self.moveScrollViewSubviewsAfter(userView)
        self.scrollView.addSubview(userView)
        self.scrollView.scrollRectToVisible(userView.frame, animated: true)
    }
    
    func moveScrollViewSubviewsAfter(inputView: UIView){
        for view in self.scrollView.subviews{
            if view.frame.origin.y >= inputView.frame.origin.y{
                (view as! UIView).frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + inputView.frame.size.height + spaceBetweenTxts, view.frame.size.width, view.frame.size.height)
            }
        }
    }
    
    func moveScrollViewSubviewsBefore(inputView: UIView){
        for view in self.scrollView.subviews{
            if view.frame.origin.y > inputView.frame.origin.y{
                (view as! UIView).frame = CGRectMake(view.frame.origin.x, view.frame.origin.y - inputView.frame.size.height - spaceBetweenTxts, view.frame.size.width, view.frame.size.height)
            }
        }
    }
    
    func sendUserRequest(sender: AnyObject){
        if let senderBtn = sender as? UIButton{
            var newUser = User()
            
            if let requestedUser = self.usersDict["\(senderBtn.tag)"] as? User{
                newUser.iUserId = requestedUser.iUserId
                newUser.oUserQuickBlox.ID = requestedUser.oUserQuickBlox.ID
                self.newGroup.UsersList.addObject(newUser)
                var a = NSLocalizedString("You added", comment: "") as String
                var b = NSLocalizedString("Friends", comment: "") as String
                self.lblFriendsNubmer.text = "\(a) \(self.newGroup.UsersList.count) \(b)"
                
                //                self.lblFriendsNubmer.text = "צרפת \(self.newGroup.UsersList.count) משתמשים"
                self.lblFriendsNubmer.hidden = false
            }
            
            senderBtn.removeFromSuperview()
        }
    }
    
    func createGroup(sender: AnyObject){
        self.generic.showNativeActivityIndicator(self)
        fillGroupDetails()
    }
    
    func fillGroupDetails(){
        self.newGroup.iMainUserId = ActiveUser.sharedInstace.iUserId
        self.newGroup.nvGroupName = self.txtGroupName.text
        self.newGroup.nvComment = self.txtComment.text
        self.newGroup.nvImage = ImageHandler.convertImageToString(ImageHandler.scaledImage(self.imgGroup.image, newSize: CGSizeMake(115, 115)))//ImageHandler.convertImageToString(ImageHandler.compressUserImage(self.imgGroup.image?))
        
        self.createGroupDialog(self.newGroup)
    }
    
    func createGroupDialog(createdGroup: Group){
        
        var chatDialog = QBChatDialog()
        var selectedUsersIDs = NSMutableArray()
        
        selectedUsersIDs.addObject(ActiveUser.sharedInstace.oUserQuickBlox.ID)
        for currUser in createdGroup.UsersList{
            if (currUser as! User).oUserQuickBlox.ID != -1{
                selectedUsersIDs.addObject((currUser as! User).oUserQuickBlox.ID)
            }
        }
        
        chatDialog.occupantIDs = [selectedUsersIDs]
        chatDialog.type = QBChatDialogTypeGroup
        chatDialog.name = createdGroup.nvGroupName != "" ? createdGroup.nvGroupName :NSLocalizedString("New group", comment: "") as String  /*"קבוצה חדשה"*/
        
        QBChat.createDialog(chatDialog, delegate: self)
    }
    
    
    func completedWithResult(result: Result) -> Void{
        if (result.success && result.isKindOfClass(QBChatDialogResult)){
            var chatDialog = (result as! QBChatDialogResult).dialog!
            self.newGroup.nvQBDialogId = chatDialog.ID
            self.newGroup.nvQBRoomJid = chatDialog.roomJID
            
            var generic = Generic()
            generic.showNativeActivityIndicator(self)
            
            Connection.connectionToService("CreateNewGroup", params: ["oGroup":Group.getGroupDictionary(self.newGroup)], completion: {
                data -> Void in
                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("CreateNewGroupResult \(strData)")
                generic.hideNativeActivityIndicator(self)
                var err: NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
                if json != nil{
                    if let parseJSON = json {
                        var group: Group = Group.parseGroupDictionary(parseJSON)
                        self.generic.hideNativeActivityIndicator(self)
                        if group.iGroupId != -1{
                            ActiveUser.sharedInstace.bIsMainUser = true
                            var alert = UIAlertController(title: "", message:NSLocalizedString("The group has been added successfully", comment: "") as String  /* "הקבוצה התווספה בהצלחה"*/, preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("Confirmation", comment: "") as String /*"אישור"*/, style: UIAlertActionStyle.Default, handler:{ action in action.style
                                if let groupsView: GroupsViewController = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 2] as? GroupsViewController{
                                    //                                    self.newGroup.UsersList.removeAllObjects()
                                    groupsView.groupsList.addObject(group)
                                    self.navigationController?.popViewControllerAnimated(true)
                                }else{
                                    self.navigationController?.popViewControllerAnimated(true)
                                }
                            }))
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    }
                }
                //                self.generic.hideNativeActivityIndicator(self)
            })
        }
    }
    
    @IBAction func createGroupClick(sender: AnyObject) {
        self.generic.showNativeActivityIndicator(self)
        fillGroupDetails()
    }
}

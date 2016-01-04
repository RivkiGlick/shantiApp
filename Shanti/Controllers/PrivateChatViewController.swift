//
//  PrivateChatViewController.swift
//  Shanti
//
//  Created by hodaya ohana on 5/19/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit
let kNotificationDidReceiveNewMessage = "kNotificationDidReceiveNewMessage"
let kNotificationDidReceiveNewMessageFromRoom = "kNotificationDidReceiveNewMessageFromRoom"

class PrivateChatViewController: GlobalViewController,UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,ImageProcessorDelegate,chatDelegatee , AttachmentTableViewCellDelegate{
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var lblUserLocation: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var btnMoreInfo: UIButton!
    
    @IBOutlet weak var buttomView: UIView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var btnAddAttachment: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    let UIScreenW = UIScreen.mainScreen().bounds.size.width
    var btnInformation: UIButton = UIButton()
    var buttomViewNormalY: CGFloat!
    var user: User = User()
    var isOnline: Bool = false
    var dialog: QBChatDialog = QBChatDialog()
    var req: QBRequest = QBRequest()
    var chatRoom: QBChatRoom? = QBChatRoom()
    var messages: NSMutableArray = NSMutableArray()
    var attachments = NSMutableDictionary()
    var largeAttachments = NSMutableDictionary()
    var library: ALAssetsLibrary = ALAssetsLibrary()
    var downloadedAttchs = NSMutableDictionary()
    var recipientID: Int = Int()
    var generic = Generic()
    var flg: Bool = false
    var urlString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setSubviewsConfig()
        self.getDownloadedAttachmentDict()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
        flg = false
    }
    
    override func viewWillAppear(animated: Bool) {
        self.setChatSettings()
    }
    
    func setSubviewsConfig(){
        var tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard:")
        self.view.addGestureRecognizer(tap)
        self.setChatSettings()
        self.generic.showNativeActivityIndicator(self)
        var params: NSMutableDictionary = ["limit":100,"sort_desc":"date_sent"]
        
        QBChat.messagesWithDialogID(self.dialog.ID, extendedRequest: params, delegate: self)
        self.user.image = ImageHandler.getImageBase64FromUrl(self.user.nvImage)
        self.addNavigationSettings()
        self.setDelegates()
        self.setSubviewsGraphics()
        self.setSubviewsFrames()
    }
    
    func setChatSettings(){
        if !flg{
            flg = true
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "chatDidReceiveMessageNotification:", name: kNotificationDidReceiveNewMessage, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        }
    }
    
    func addNavigationSettings(){
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.purpleHome()
        self.navigationController?.navigationBar.setBackgroundImage(ImageProcessor.imageWithColor(UIColor.whiteColor()), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.purpleHome()]
        self.title = user.nvShantiName
        
        let btnInfoSize: CGFloat = 37.5
        btnInformation.setTitle("", forState: UIControlState.Normal)
        btnInformation.setTitle("", forState: UIControlState.Highlighted)
        btnInformation.setTitleColor(UIColor.purpleHome(), forState: UIControlState.Normal)
        btnInformation.frame = CGRectMake(12, (self.navigationController!.navigationBar.frame.size.height - btnInfoSize)/2, btnInfoSize, btnInfoSize)
        
        
        btnInformation.layer.cornerRadius = 5
        if(self.isOnline)
        {
            btnInformation.layer.borderColor = UIColor.greenColor().CGColor
        }
        else
        {
            btnInformation.layer.borderColor = UIColor.redColor().CGColor
        }
        
        btnInformation.layer.borderWidth = 1
        btnInformation.setBackgroundImage(self.user.image, forState: UIControlState.Normal)
        btnInformation.setBackgroundImage(self.user.image, forState: UIControlState.Highlighted)
        btnInformation.clipsToBounds = true
        
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(customView: btnInformation), animated: true)
        
        if var btnBack = self.navigationItem.leftBarButtonItem{
            if var btn: UIButton = btnBack.customView as? UIButton{
                btn.setImage(UIImage(named: "purpleLeftBack.png"), forState: UIControlState.Normal)
                btn.setImage(UIImage(named: "purpleLeftBack.png"), forState: UIControlState.Highlighted)
            }
            
        }
    }
    
    func setDelegates(){
        self.tableView.registerNib(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTableViewCell")
        self.tableView.registerNib(UINib(nibName: "AttachmentTableViewCell", bundle: nil), forCellReuseIdentifier: "AttachmentTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func setSubviewsGraphics(){
        self.topView.backgroundColor = UIColor.whiteColor()
        
        self.lblUserLocation.text = "text from google"
        self.lblUserLocation.font = UIFont(name: "spacer", size: 15.0)
        self.lblUserLocation.textColor = UIColor.grayMedium()
        self.lblUserLocation.sizeToFit()
        self.lblUserLocation.hidden = true
        var a = (NSLocalizedString("Member in", comment: "") as String)
        var b = (self.user.iNumGroupAsMemberUser)
        var c = (NSLocalizedString("Groups", comment: "") as String)
        var d = (self.user.iNumGroupAsMainUser)
        var e = (NSLocalizedString("and administrator", comment: "") as String)
        self.lblInfo.text = "\(a) \(b) \(e) \(d) \(b)"
        self.lblInfo.font = UIFont(name: "spacer", size: 15.0)
        self.lblInfo.textColor = UIColor.grayMedium()
        self.lblInfo.sizeToFit()
        
        var f = NSLocalizedString("More about", comment: "") as String///*עוד על*/
        self.btnMoreInfo.setTitle("\(f)\(user.nvShantiName)", forState: UIControlState.Normal)
        self.btnMoreInfo.setTitle("\(f) \(user.nvShantiName)", forState: UIControlState.Highlighted)
        self.btnMoreInfo.titleLabel?.font = UIFont(name: "spacer", size: 15.0)
        self.btnMoreInfo.setTitleColor(UIColor.greenHome(), forState: UIControlState.Normal)
        self.btnMoreInfo.setTitleColor(UIColor.greenHome(), forState: UIControlState.Highlighted)
        self.btnMoreInfo.addTarget(self, action: "getUserProfile:", forControlEvents: UIControlEvents.TouchUpInside)
        self.btnMoreInfo.sizeToFit()
        
        self.btnSend.backgroundColor = UIColor.clearColor()
        self.btnSend.setTitle("", forState: UIControlState.Normal)
        self.btnSend.setTitle("", forState: UIControlState.Highlighted)
        self.btnSend.titleLabel!.font = UIFont(name: "spacer", size: 17)
        self.btnSend.setBackgroundImage(UIImage(named: "send_btn"), forState: UIControlState.Normal)
        self.btnSend.setBackgroundImage(UIImage(named: "send_btn_clicked.png"), forState: UIControlState.Highlighted)
        
        self.btnAddAttachment.backgroundColor = UIColor.clearColor()
        self.btnAddAttachment.setTitle("+", forState: UIControlState.Normal)
        self.btnAddAttachment.setTitle("+", forState: UIControlState.Highlighted)
        self.btnAddAttachment.setTitleColor(UIColor.purpleHome(), forState: UIControlState.Normal)
        self.btnAddAttachment.setTitleColor(UIColor.purpleHome(), forState: UIControlState.Highlighted)
        self.btnAddAttachment.addTarget(self, action: "getFile:", forControlEvents: UIControlEvents.TouchUpInside)
        self.btnAddAttachment.titleLabel!.font = UIFont(name: "spacer", size: 40)
        self.btnAddAttachment.layer.borderColor = UIColor.purpleShines().CGColor
        self.btnAddAttachment.layer.borderWidth = 1.5
        self.btnAddAttachment.layer.cornerRadius = 1.5
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.backgroundColor = UIColor.offwhiteDark()//UIColor.clearColor()
        
        self.buttomView.backgroundColor = UIColor.whiteColor()
    }
    
    func setSubviewsFrames(){
        buttomViewNormalY = CGFloat(UIScreen.mainScreen().bounds.height - 50 - (self.navigationController!.navigationBar.frame.origin.y + self.navigationController!.navigationBar.frame.size.height))
        self.topView.frame = CGRectMake(0,0, UIScreen.mainScreen().bounds.width, 67.0)
        self.buttomView.frame = CGRectMake(0, self.buttomViewNormalY, UIScreen.mainScreen().bounds.width, 50)
        
        //inside topView
        self.lblUserLocation.frame = CGRectMake(15, 10, self.lblUserLocation.frame.size.width, self.lblUserLocation.frame.size.height)
        self.lblInfo.frame = CGRectMake(self.topView.frame.size.width -  self.lblInfo.frame.size.width - 15, self.topView.frame.size.height - self.lblInfo.frame.size.height - 10, self.lblInfo.frame.size.width, self.lblInfo.frame.size.height)
        
        
        self.btnMoreInfo.frame = CGRectMake(15, self.lblInfo.frame.origin.y, self.btnMoreInfo.frame.size.width, self.lblInfo.frame.size.height)
        
        //inside buttomView
        self.btnAddAttachment.frame = CGRectMake(15, (self.buttomView.frame.size.height - 30)/2, 30, 30)
        self.btnSend.frame = CGRectMake(self.buttomView.frame.size.width - self.btnSend.backgroundImageForState(UIControlState.Normal)!.size.width/2, (self.buttomView.frame.size.height - self.btnSend.backgroundImageForState(UIControlState.Normal)!.size.height/2)/2, self.btnSend.backgroundImageForState(UIControlState.Normal)!.size.width/2, self.btnSend.backgroundImageForState(UIControlState.Normal)!.size.height/2)
        self.txtMessage.frame = CGRectMake(self.btnAddAttachment.frame.origin.x + self.btnAddAttachment.frame.size.width + 5, (self.buttomView.frame.size.height - self.txtMessage.frame.size.height)/2, self.btnSend.frame.origin.x - (self.btnAddAttachment.frame.origin.x + self.btnAddAttachment.frame.size.width + 5) - 5, self.txtMessage.frame.size.height)
        
        
        self.tableView.frame = CGRectMake(0, self.topView.frame.origin.y + self.topView.frame.size.height, UIScreen.mainScreen().bounds.size.width, self.buttomView.frame.origin.y - (self.topView.frame.origin.y + self.topView.frame.size.height))
    }
    
    func dismissKeyboard(sender: AnyObject){
        self.txtMessage.resignFirstResponder()
    }
    
    //pragma mark QBActionStatusDelegate
    func completedWithResult(result: Result){
        println("result:\(result)")
        if result.success && result.isKindOfClass(QBChatHistoryMessageResult) {
            self.generic.hideNativeActivityIndicator(self)
            var res = result as! QBChatHistoryMessageResult
            var historyMessages = res.messages
            if historyMessages != nil{
                //                self.messages.addObjectsFromArray(historyMessages)
                for i in 0...historyMessages.count - 1{ // sort asc
                    self.messages.addObject(historyMessages.objectAtIndex(historyMessages.count - 1 - i))
                }
                
                for msg in historyMessages{
                    if msg.attachments != nil && msg.attachments.count > 0{
                        self.downloadAttachment(msg as! QBChatAbstractMessage)
                    }
                }
                self.tableView.reloadData()
            }
            
            if(self.messages.count > 0){
                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.messages.count-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
            }
        }else{
            println("result.success = false")
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var currCell: UITableViewCell!
        var currMsg: QBChatAbstractMessage = self.messages.objectAtIndex(indexPath.row) as! QBChatAbstractMessage
        if currMsg.attachments != nil && currMsg.attachments.count > 0{
            currCell = tableView.dequeueReusableCellWithIdentifier("AttachmentTableViewCell", forIndexPath: indexPath) as! AttachmentTableViewCell
            currCell.backgroundColor = UIColor.yellowColor()
            
            var cell = currCell as! AttachmentTableViewCell
            
            cell.tableViewWidth = self.tableView.bounds.size.width
            cell.progressView.hidden = true
            cell.del = self
            
            if ActiveUser.sharedInstace.oUserQuickBlox.ID == Int(currMsg.senderID){
                cell.imgUserProfile.image = ActiveUser.sharedInstace.image
            }
            else
            {
                cell.imgUserProfile.image = self.user.image
            }
            
            cell.imgUserProfile.layer.cornerRadius = 9.0
            cell.imgUserProfile.layer.borderWidth = 1.0
            cell.imgUserProfile.layer.borderColor = UIColor.grayMedium().CGColor
            cell.imgUserProfile.clipsToBounds = true
            var senderName = self.user.nvShantiName//self.user.nvFirstName + " " + self.user.nvLastName
            
            cell.configureCellWithMessage(currMsg,senderName: senderName)
            
            if currMsg.attachments != nil && currMsg.attachments.count > 0{
                for attachment in currMsg.attachments{
                    if let dict = self.attachments.valueForKey(currMsg.ID) as? NSDictionary{
                        var blobIdString = NSString(string: attachment.ID)
                        var imgData: NSData? = dict.valueForKey(blobIdString as String) as? NSData
                        if imgData != nil{
                            cell.btnDownload.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
                            cell.imgContent.image = UIImage(data: imgData!)
                            cell.btnDownload.tag = indexPath.row
                            cell.btnDownload.addTarget(self, action: "downloadLargeImg:", forControlEvents: UIControlEvents.TouchUpInside)
                        }
                        
                        if self.downloadedAttchs.valueForKey(blobIdString as String) != nil{
                            //                            cell.btnDownload.hidden = true
                            cell.btnDownload.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
                            cell.btnDownload.addTarget(self, action: "presentImg:", forControlEvents: UIControlEvents.TouchUpInside)
                            cell.btnDownload.setBackgroundImage(nil, forState: UIControlState.Normal)
                            cell.btnDownload.setBackgroundImage(nil, forState: UIControlState.Highlighted)
                            cell.btnDownload.tag = indexPath.row
                        }
                    }
                }
            }
        }else{
            currCell = tableView.dequeueReusableCellWithIdentifier("ChatTableViewCell", forIndexPath: indexPath) as! ChatTableViewCell
            currCell.backgroundColor = UIColor.redColor()
            
            var cell = currCell as! ChatTableViewCell
            
            cell.tableViewWidth = self.tableView.bounds.size.width
            
            if ActiveUser.sharedInstace.oUserQuickBlox.ID == Int(currMsg.senderID)
            {
                cell.imgUserProfile.image = ActiveUser.sharedInstace.image
            }else
            {
                cell.imgUserProfile.image = self.user.image
            }
            cell.del = self
            cell.imgUserProfile.layer.cornerRadius = 9.0
            cell.imgUserProfile.layer.borderWidth = 1.0
            cell.imgUserProfile.layer.borderColor = UIColor.grayMedium().CGColor
            cell.imgUserProfile.clipsToBounds = true
            var senderName = self.user.nvShantiName//self.user.nvFirstName + " " + self.user.nvLastName
            
            cell.configureCellWithMessage(currMsg,senderName: senderName)
            
        }
        
        currCell.backgroundColor = UIColor.clearColor()
        currCell.selectionStyle = UITableViewCellSelectionStyle.None
        return currCell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let currMsg: QBChatAbstractMessage = self.messages.objectAtIndex(indexPath.row) as! QBChatAbstractMessage
        let cellHeight: CGFloat = ChatTableViewCell.heightForCellWithMessage(currMsg)
        return cellHeight
    }
    
    func chatDidReceiveMessageNotification(notification: NSNotification){// chat received when chat page is open (after history)
        var currMessage: QBChatMessage? = notification.userInfo?["kMessage"] as? QBChatMessage
        if Int(currMessage!.senderID) != self.dialog.recipientID{
            return
        }
        
        self.messages.addObject(currMessage!)
        
        if currMessage?.attachments != nil && currMessage?.attachments.count > 0{
            if (currMessage?.text == nil) || (currMessage?.text != nil && currMessage?.text == ""){
                self.downloadAttachment(currMessage!)
                self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.messages.count - 1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
            }else{
                self.messages.removeObject(currMessage!)
                largeAttachments.setObject(currMessage!, forKey: currMessage!.text)
            }
        }else{
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.messages.count - 1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
        }
        
        //        self.tableView.reloadData()
        
        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.messages.count-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
    }
    
    func keyboardWillShow(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey]
            as? NSValue)?.CGRectValue() {
                UIView.animateWithDuration(0.3, animations: {
                    self.view.frame = CGRectMake(self.buttomView.frame.origin.x,self.view.frame.origin.y - keyboardSize.size.height, self.view.frame.size.width, self.view.frame.size.height)
                    println("self.buttomView frame:\(self.buttomView)")
                })
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if self.buttomView.frame.origin.y != buttomViewNormalY{
                UIView.animateWithDuration(0.3, animations: {
                    self.view.frame = CGRectMake(self.buttomView.frame.origin.x, self.navigationController!.navigationBar.frame.size.height + self.navigationController!.navigationBar.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)
                })
            }
        }
    }
    
    @IBAction func sendMessage(sender: AnyObject) {// only for text msg
        self.dismissKeyboard(sender)
        var currMessage = QBChatMessage()
        currMessage.text = self.txtMessage.text
        
        if currMessage.text != "" && currMessage.text != " "{
            var params: NSMutableDictionary = NSMutableDictionary()
            params["save_to_history"] = true
            currMessage.customParameters = params
            
            // 1-1 Chat
            currMessage.recipientID = UInt(self.dialog.recipientID)
            currMessage.senderID = UInt(ActiveUser.sharedInstace.oUserQuickBlox.ID)
            
            ChatService.instance().sendMessage(currMessage)
            
            self.sendUserDialogNotification(self.txtMessage.text)
            self.messages.addObject(currMessage)
            self.txtMessage.text = nil
            
            //self.tableView.reloadData()
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.messages.count - 1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
            if(self.messages.count > 0){
                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.messages.count-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
            }
        }
    }
    
    func sendUserDialogNotification(withText: String){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            let message = ("\(ActiveUser.sharedInstace.nvShantiName) : \(withText)")
            
            var parametersList = NSMutableArray()
            
            var keyVals = KeyValue()
            keyVals.nvKey = "notificationType"
            keyVals.nvValue = String(NOTIFICATION_TYPE.NOTIFICATION_TYPE_NEW_MESSAGE_PRIVATE.rawValue)
            parametersList.addObject(KeyValue.getKeyValueDictionary(keyVals))
            
            keyVals.nvKey = "userIdSend"
            keyVals.nvValue = String(ActiveUser.sharedInstace.iUserId)
            parametersList.addObject(KeyValue.getKeyValueDictionary(keyVals))
            
            Connection.connectionToService("PushUpdates", params: ["sMessage":message,"ParamsList":parametersList,"lUsers":[self.user.iUserId]], completion: {
                data -> Void in
                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("PushUpdates privete chat:\(strData)")
            })
        })
    }
    
    func getUserProfile(sender: AnyObject){
        let friendProfile: FriendProfileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FriendProfileViewControllerId") as! FriendProfileViewController
        friendProfile.user = self.user
        self.navigationController?.pushViewController(friendProfile, animated: true)
    }
    
    func getFile(sender: AnyObject){
        var actionSheet = UIActionSheet(title: NSLocalizedString("Select a source image", comment: "") as String/*"בחר מקור תמונה"*/, delegate: self, cancelButtonTitle:NSLocalizedString("Cancellation", comment: "") as String /*"ביטול"*/, destructiveButtonTitle: nil, otherButtonTitles:NSLocalizedString("Camera", comment: "") as String,NSLocalizedString("Gallery", comment: "") as String /*"מצלמה"/*, */"אלבום תמונות"*/)
        actionSheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int){
        println(buttonIndex)
        
        switch buttonIndex{
        case 1:
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
                var imag = UIImagePickerController()
                imag.delegate = self
                imag.sourceType = UIImagePickerControllerSourceType.Camera;
                imag.allowsEditing = false
                
                self.presentViewController(imag, animated: true, completion: nil)
            }
            
        case 2:
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
                var imag = UIImagePickerController()
                imag.delegate = self
                imag.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                imag.allowsEditing = false
                
                self.presentViewController(imag, animated: true, completion: nil)
            }
            
        default:
            break
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!)
    {
        var file = image
        self.setChatSettings()
        self.sendMessageWithFile(file)
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    //        let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
    //        self.urlString = "\(imageURL)"
    //        let imageName = imageURL.path!.lastPathComponent
    //        let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as! String
    //        let localPath = documentDirectory.stringByAppendingPathComponent(imageName)
    //
    //        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
    //        let data = UIImagePNGRepresentation(image)
    //        data.writeToFile(localPath, atomically: true)
    //
    //        let imageData = NSData(contentsOfFile: localPath)!
    //        let photoURL = NSURL(fileURLWithPath: localPath)
    //        let imageWithData = UIImage(data: imageData)!
    //
    //        var file = image
    //        self.setChatSettings()
    //        self.sendMessageWithFile(file)
    //
    //        picker.dismissViewControllerAnimated(true, completion: nil)
    //    }
    //
    
    func sendMessageWithFile(sender: AnyObject) {
        if let currFile = sender as? UIImage{
            var imageData = UIImagePNGRepresentation(ImageHandler.scaledImage(currFile, newSize: CGSizeMake(10, 10)))
            println("imageData: \(imageData.length)")
            var smallBlob: UInt = UInt(0)
            QBRequest.TUploadFile(imageData, fileName: "image.png", contentType: "image/png", isPublic: false, successBlock: {
                response, uploadedBlob -> Void in
                self.dismissKeyboard(sender)
                var currMessage = QBChatMessage()
                currMessage.text = ""
                var uploadedFileID = uploadedBlob.ID
                smallBlob = uploadedFileID
                var attachment = QBChatAttachment()
                attachment.type = "image"
                attachment.ID = "\(uploadedFileID)"
                currMessage.attachments = [attachment]
                var params: NSMutableDictionary = NSMutableDictionary()
                params["save_to_history"] = true
                currMessage.customParameters = params
                // 1-1 Chat
                currMessage.recipientID = UInt(self.dialog.recipientID)
                currMessage.senderID = UInt(ActiveUser.sharedInstace.oUserQuickBlox.ID)
                ChatService.instance().sendMessage(currMessage)
                self.sendUserDialogNotification("(תמונה)")
                var dict = NSMutableDictionary()
                dict.setObject(imageData, forKey: "\(uploadedBlob.ID)")
                self.attachments.setObject(dict, forKey: currMessage.ID)
                
                self.messages.addObject(currMessage)
                self.txtMessage.text = nil
                self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.messages.count - 1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
                
                if(self.messages.count > 0){
                    self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.messages.count-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
                }
                
                if smallBlob != 0{
                    var currCell: AttachmentTableViewCell?
                    if var cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: self.messages.count - 1, inSection: 0)) as? AttachmentTableViewCell{
                        currCell = cell
                    }
                    
                    currCell?.progressView.hidden = false
                    currCell?.progressView.progress = 0.0
                    
                    var imageFullData = UIImagePNGRepresentation(currFile)
                    println("imageFullData.length: \(imageFullData.length)")
                    QBRequest.TUploadFile(imageFullData, fileName: "image.png", contentType: "image/png", isPublic: false, successBlock: {
                        response, uploadedBlob -> Void in
                        currCell?.progressView.hidden = true
                        currCell?.progressView.progress = 0.0
                        
                        var currMessage = QBChatMessage()
                        currMessage.text = "\(smallBlob)"
                        var uploadedFileID = uploadedBlob.ID
                        var attachment = QBChatAttachment()
                        attachment.type = "image"
                        attachment.ID = "\(uploadedFileID)"
                        currMessage.attachments = [attachment]
                        var params: NSMutableDictionary = NSMutableDictionary()
                        params["save_to_history"] = true
                        currMessage.customParameters = params
                        // 1-1 Chat
                        currMessage.recipientID = UInt(self.dialog.recipientID)
                        currMessage.senderID = UInt(ActiveUser.sharedInstace.oUserQuickBlox.ID)
                        self.downloadAttachment(currMessage)
                        ChatService.instance().sendMessage(currMessage)
                        self.txtMessage.text = nil
                        }, statusBlock: {
                            request, status -> Void in
                            println("requestType:\(status.percentOfCompletion)")
                            currCell?.progressView.progress = CGFloat(status.percentOfCompletion)
                        }, errorBlock: {
                            response -> Void in
                            println("error:\(response.error)")
                    })
                }
                }, statusBlock: {
                    request, status -> Void in
                    println("requestType:\(status.requestType.rawValue)")
                }, errorBlock: {
                    response -> Void in
                    println("error:\(response.error)")
            })
        }
    }
    
    func downloadAttachment(currMessage: QBChatAbstractMessage){
        // download file by ID
        if (currMessage.text == nil) || (currMessage.text != nil && currMessage.text == ""){
            for attachment in currMessage.attachments{
                var blobIdString = NSString(string: attachment.ID)
                var blobId = UInt(blobIdString.integerValue)
                QBRequest.TDownloadFileWithBlobID(blobId, successBlock: {
                    response, fileData -> Void in
                    println("small fileData.length:\(fileData.length)")
                    var dict = NSMutableDictionary()
                    dict.setObject(fileData, forKey: blobIdString)
                    self.attachments.setObject(dict, forKey: currMessage.ID)
                    var indexPath = NSIndexPath(forRow: self.messages.indexOfObject(currMessage), inSection: 0)
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                    }, statusBlock: {
                        request, status -> Void in
                        println("requestType:\(status.percentOfCompletion)")
                    }, errorBlock: {
                        response -> Void in
                        println("response:\(response.error)")
                })
            }
        }else{
            self.messages.removeObject(currMessage)
            largeAttachments.setObject(currMessage, forKey: currMessage.text)
        }
    }
    
    func downloadLargeImg(sender: AnyObject){
        var btnDownload = sender as! UIButton
        btnDownload.setBackgroundImage(nil, forState: UIControlState.Normal)
        btnDownload.setBackgroundImage(nil, forState: UIControlState.Highlighted)
        btnDownload.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
        btnDownload.addTarget(self, action: "presentImg:", forControlEvents: UIControlEvents.TouchUpInside)
        
        var cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: (sender as! UIButton).tag, inSection: 0))
        println("cell = \(cell)")
        var attachmentCell = cell as! AttachmentTableViewCell
        
        if let curMsg = self.messages.objectAtIndex((sender as! UIButton).tag) as? QBChatAbstractMessage{
            if curMsg.attachments != nil && curMsg.attachments.count > 0{
                for attachment in curMsg.attachments{
                    var str = NSString(string: attachment.ID)
                    if let msg = self.largeAttachments.objectForKey(str) as? QBChatAbstractMessage{
                        if msg.attachments != nil && msg.attachments.count > 0{
                            for newAttachment in msg.attachments{
                                //                                if ActiveUser.sharedInstace.oUserQuickBlox.ID == Int(curMsg.senderID)
                                //                                {
                                attachmentCell.progressView.hidden = false
                                attachmentCell.progressView.indeterminate = false
                                attachmentCell.progressView.progress = 0.0
                                //                                }
                                
                                var blobIdString = NSString(string: newAttachment.ID)
                                var blob = UInt(blobIdString.integerValue)
                                println("blob:\(blob)")
                                
                                QBRequest.TDownloadFileWithBlobID(blob, successBlock: {
                                    response, fileData -> Void in
                                    println("large fileData.length:\(fileData.length)")
                                    var image = UIImage(data: fileData)
                                    self.library.saveImage(image, toAlbum: "Shanti", withCompletionBlock: {
                                        error, url -> Void in
                                        if error == nil{
                                            println("img saved: \(url)")
                                            attachmentCell.progressView.hidden = true
                                            self.downloadedAttchs = FileManager.sharedInstace.writeIntoFile(str as String, value: "\(url)")
                                            println("self.doenloadedAttchs:\(self.downloadedAttchs)")
                                        }else{
                                            println("img not saved")
                                        }
                                    })
                                    }, statusBlock: {
                                        request, status -> Void in
                                        println("percentOfCompletion:\(status.percentOfCompletion)")
                                        attachmentCell.progressView.progress = CGFloat(status.percentOfCompletion)
                                        println("requestType:\(status.requestType.rawValue)")
                                    }, errorBlock: {
                                        response -> Void in
                                })
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func getDownloadedAttachmentDict(){
        var dict = FileManager.sharedInstace.viewFileContent()
        if dict != nil{
            self.downloadedAttchs = NSMutableDictionary(dictionary: dict!)
            println("downloadedAttchs:\(downloadedAttchs)")
        }
    }
    func presentImg(sender: AnyObject)
    {
        if let btn = sender as? UIButton
        {
            if let  curMsg = self.messages.objectAtIndex((sender as! UIButton).tag) as? QBChatAbstractMessage
            {
                if curMsg.attachments != nil && curMsg.attachments.count > 0
                {
                    for attachment in curMsg.attachments
                    {
                        var blobIdString = NSString(string: attachment.ID)
                        if self.downloadedAttchs.valueForKey(blobIdString as String) != nil
                        {
                            var processor = ImageProcessor()
                            processor.delegate = self
                            processor.PresentImage(self.downloadedAttchs.valueForKey(blobIdString as String) as! NSString as String)
                        }
                        
                    }
                }
            }
        }
    }
    func imageFound(img: UIImage){
        var presentView = self.storyboard?.instantiateViewControllerWithIdentifier("PresentFileViewControllerId") as! PresentFileViewController
        presentView.img = img
        self.navigationController?.pushViewController(presentView, animated: true)
    }
    
    
    func deleteMsg(message:QBChatAbstractMessage!)
    {
        QBChat.deleteMessageWithID(message.ID, delegate: self)
        
        self.messages.removeObject(message as QBChatAbstractMessage)
        self.tableView.reloadData()
    }
    
    func deleteMsgAttachment(message:QBChatAbstractMessage!)
    {
        QBChat.deleteMessageWithID(message.ID, delegate: self)
        self.messages.removeObject(message as QBChatAbstractMessage)
        self.tableView.reloadData()
    }
}

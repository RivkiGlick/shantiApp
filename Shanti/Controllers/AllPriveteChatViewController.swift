//
//  AllPriveteChatViewController.swift
//  Shanti
//
//  Created by hodaya ohana on 3/18/15.
//  Copyright (c) 2015 webit. All rights reserved.
//NSLocalizedString("Meeting points", comment: "") as String

import UIKit

class AllPriveteChatViewController: GlobalViewController,UITableViewDelegate,UITableViewDataSource,chatDelegatee,PriveteChatCellDelegate {
   
    @IBOutlet weak var tableView: UITableView!
    
    var messages = NSMutableArray()
    var usersDict = NSMutableDictionary()
    var generic = Generic()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getMessagesFromQB()
        self.setSubviewConfig()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.setNavigationBar()
    }
    
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
        self.title = "הודעות"
    }
    
    func setDeleagtes(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(UINib(nibName: "PriveteChatCell", bundle: nil), forCellReuseIdentifier: "PriveteChatCell")
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    func setSubviewFrames(){
        self.tableView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
    }
    
    func getMessagesFromQB(){
        if ActiveUser.sharedInstace.didLoginToQB == true{
            self.generic.showNativeActivityIndicator(self)
            var extendedRequest: NSMutableDictionary = ["type":3]
            QBChat.dialogsWithExtendedRequest(extendedRequest, delegate: self)
        }else{
            var alert = UIAlertController(title: NSLocalizedString("Error", comment: "") as String/*"שגיאה"*/, message: NSLocalizedString("The chat connections are not available, please try again later", comment: "") as String/*"חיבורי הצ׳אט אינם זמינים, אנא נסה שוב מאוחר יותר"*/, preferredStyle: UIAlertControllerStyle.Alert)
            //
            alert.addAction(UIAlertAction(title:NSLocalizedString("Confirmation", comment: "") as String /*"אישור"*/, style: UIAlertActionStyle.Cancel, handler: {
                action in action.style
               self.navigationController?.popViewControllerAnimated(true)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func completedWithResult(result: Result) -> Void{
        if (result.success && result.isKindOfClass(QBDialogsPagedResult)){
            var pagedResult = result as! QBDialogsPagedResult
            if pagedResult.dialogs != nil{
                self.messages.addObjectsFromArray(pagedResult.dialogs)
                if self.messages.count < 0{
                    self.addInfoViews()
                }else{
                    self.getContactUsersDetailsFromServer()
                    self.tableView.reloadData()
                }
                
            }else{
                self.generic.hideNativeActivityIndicator(self)
                self.addInfoViews()
            }
            
        }
        else{
            self.generic.hideNativeActivityIndicator(self)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell: PriveteChatCell = tableView.dequeueReusableCellWithIdentifier("PriveteChatCell", forIndexPath: indexPath) as! PriveteChatCell
        
        let currDialog: QBChatDialog = self.messages.objectAtIndex(indexPath.row) as! QBChatDialog
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.backgroundColor = UIColor.offwhiteBasic()
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        cell.lblDate.text = currDialog.lastMessageDate != nil ? dateFormatter.stringFromDate(currDialog.lastMessageDate) : ""
        cell.lblDate.sizeToFit()
        cell.lblMsgText.text = currDialog.lastMessageText != nil ? currDialog.lastMessageText : ""
        cell.lblMsgText.sizeThatFits(CGSizeMake(cell.msgLblW, cell.msgLblH))
        cell.btnDelete.hidden=true
        if currDialog.lastMessageUserID != 0 {
            if let userDialog: User = self.usersDict.objectForKey(String(currDialog.recipientID)) as? User{
                cell.lblUserName.text = userDialog.nvShantiName// + " " + userDialog.nvLastName
                cell.lblUserName.sizeToFit()
                cell.imgUserProfile.image = userDialog.image
                
            }else{
                var dialogUser: String = String()
//                let ActiveUserId: String = String(ActiveUser.sharedInstace.oUserQuickBlox.ID)
//                var occupantIDs: NSArray = currDialog.occupantIDs
//                
//                for i in 0...occupantIDs.count-1{
//                    let occupantID: String = String("\(occupantIDs[i])")
//                    
//                     if occupantID != ActiveUserId{
//                        dialogUser = occupantID
//                        break
//                    }
//                }
                dialogUser = String(currDialog.recipientID)
                cell.lblUserName.text = dialogUser != "" ? dialogUser : "unknown user"
                cell.lblUserName.sizeToFit()
            }
            cell.setSubviewsFrame()
        }else{
            self.messages.removeObjectAtIndex(indexPath.row)
            self.tableView.reloadData()
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 107.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let currDialog: QBChatDialog = self.messages.objectAtIndex(indexPath.row) as! QBChatDialog
        let chatView = self.storyboard!.instantiateViewControllerWithIdentifier("PrivateChatViewControllerId") as! PrivateChatViewController
        chatView.dialog = currDialog
        if let currUser = self.usersDict.objectForKey(String(currDialog.recipientID)) as? User {
            chatView.dialog = currDialog
            chatView.user = currUser
            self.navigationController?.pushViewController(chatView, animated: true)
        }

    }
    
    func getContactUsersDetailsFromServer(){
            var params = NSMutableArray()

            for i in 0...self.messages.count-1{
                if let currDialog: QBChatDialog = self.messages.objectAtIndex(i) as? QBChatDialog{
                    params.addObject(String(currDialog.recipientID))
                }
            }
            
            Connection.connectionToService("GetUsersByQBIdList", params: ["ListQBIds":params], completion: {
                data -> Void in
                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("GetUsersByQBIdList:\(strData)")
                var err: NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSArray
                
                if (json != nil) {
                    for dict in json!{
                        let currUser: User = User.parseUserJson(JSON(dict))
                        currUser.image = ImageHandler.getImageBase64FromUrl(currUser.nvImage)
                        self.usersDict.setValue(currUser, forKey: String(currUser.oUserQuickBlox.ID))
                    }
                }
                self.tableView.reloadData()
                self.generic.hideNativeActivityIndicator(self)
            })
    }
    
    func addInfoViews(){
        var view = UIView()
        view.backgroundColor = UIColor.clearColor()
        
        var imgView = UIImageView(image: UIImage(named: "empty_inbox"))
        var size = CGSizeMake(imgView.image!.size.width/2, imgView.image!.size.height/2)
        

        var lblInfo = UILabel()
        lblInfo.text = NSLocalizedString("You have no new messages currently", comment: "") as String/*"אין לך הודעות כעת."*///"You have no new messages currently"
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
  func deleteMsg(message:QBChatAbstractMessage!)
    {
           QBChat.deleteMessageWithID(message.ID, delegate: self)
//        ChatService.deleteMessageWithID( message.ID, successBlock: {(response: QBResponse!) in
//            
//            }, errorBlock: {(response: QBResponse!) in
//                
//        })
//        QBChat.deleteMessageWithID(message.ID, delegate: self, successBlock: { (response: QBResponse!) -> Void in
//            
//            }) { (response: QBResponse!) -> Void in
//                
//        }
//     
        
//        QBRequest.deleteMessagesWithIDs(Set(arrayLiteral:"54fdbb69535c12c2e407c672","54fdbb69535c12c2e407c673"), forAllUsers: true, successBlock: { (response: QBResponse!) -> Void in
//            
//            }) { (response: QBResponse!) -> Void in
//                
//        }
        
            self.messages.removeObject(message as QBChatAbstractMessage)
        self.tableView.reloadData()

    }
}

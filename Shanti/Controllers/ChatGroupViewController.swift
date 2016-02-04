
//
//  ChatGroupViewController.swift
//  Shanti
//
//  Created by hodaya ohana on 3/2/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

class ChatGroupViewController: GlobalViewController,UITableViewDataSource,UITableViewDelegate,QBChatDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,ImageProcessorDelegate,chatDelegatee,AttachmentTableViewCellDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate/*,UIGestureRecognizerDelegate */{
    //FIXME:12.11.15
    //    @IBOutlet var btnSearch2: UIButtonSearch!
    //    @IBOutlet var scrollView2: UIScrollView!
    //    @IBOutlet weak var lblAddFriends: UILabel!
    //    @IBOutlet var txtMail1: UITextField!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblGroupLocation: UILabel!
    @IBOutlet weak var btnMoreInfo: UIButton!
    @IBOutlet weak var btnAddFriendsToGroup: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var buttomView: UIView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var btnAddAttachment: UIButton!
    
    @IBOutlet weak var viewCreateMeetingPoint: UIView!
    @IBOutlet weak var btnCreateMeetingPoint: UIButton!
    @IBOutlet weak var imgCreateMeetingPoint: UIImageView!
    //    @IBOutlet var viewAddFriends: UIView!
    
    var currGroup: Group = Group()
    var dialog: QBChatDialog = QBChatDialog()
    var chatRoom: QBChatRoom? = QBChatRoom()
    var messages: NSMutableArray = NSMutableArray()
    var imgsDict: NSMutableDictionary = NSMutableDictionary()
    var buttomViewNormalY = CGFloat()//(UIScreen.mainScreen().bounds.height - 50)
    var attachments = NSMutableDictionary()
    var largeAttachments = NSMutableDictionary()
    var library: ALAssetsLibrary = ALAssetsLibrary()
    var downloadedAttchs = NSMutableDictionary()
    var usersDict = NSMutableDictionary()
    //FIXME8.11.15
    var usersInScroll = NSMutableArray()
    
    
    var scrollView2: UIScrollView = UIScrollView()
    var lblAddFriends: UILabel = UILabel()
    var txtMail1: UITextField = UITextField()
    var lblFriendsNubmer: UILabel = UILabel()
    var lblNoFriends: UILabel = UILabel()
    var btnAddFriends: UIButton = UIButton()
    
    var btnX = UIButton()
    var viewSeparation: UIView!
    var addFriendsTableView: UITableView = UITableView()
    let connectionQueue = dispatch_queue_create("com.test.LockQueue", nil)
    var generic = Generic()
    
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
    var viewNormal = CGFloat()
    
    var flg: Bool = false
    var addFriensTaped = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewNormal = view.frame.size.height
        buttomViewNormalY = CGFloat(UIScreen.mainScreen().bounds.height - 50)
        self.txtMessage.delegate = self
        if self.currGroup.UsersList.count == 0{
            self.getGroupById()
        }else{
            self.updateDialog()
            self.downloadImageFromServer()
            self.addGroupUsersImagesToScroll()
        }
        //    }
        self.setSubviewsConfig()
        self.getDownloadedAttachmentDict()
    }
     override func viewDidAppear(animated: Bool) {
       //super.viewDidAppear(true)
    }
    
    override func viewWillLayoutSubviews()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    
    func rotated()
    {
        viewNormal = view.frame.size.height
        buttomViewNormalY = CGFloat(UIScreen.mainScreen().bounds.height - 50)
        self.txtMessage.delegate = self
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
        self.chatRoom?.leaveRoom()
        self.chatRoom = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        self.setChatSettings()
    }
    
    func setSubviewsConfig(){
                var tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard:")
                tap.delegate = self
                self.view.addGestureRecognizer(tap)
    
        self.setChatSettings()
        generic.showNativeActivityIndicator(self)
        var params: NSMutableDictionary = ["limit":100,"sort_desc":"date_sent"]
        QBChat.messagesWithDialogID(self.dialog.ID, extendedRequest: params, delegate: self)
        self.addNavigationSettings()
        self.setSubViewHidden()
        self.setSubviewsGraphics()
        self.setSubviewsFrames()
        self.setDelegates()
        if addFriensTaped == true
        {
            self.addFriends(nil)
        }
        
    }
    
    func setChatSettings(){
        if !flg{
            flg = true
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "chatRoomDidReceiveMessageNotification:", name: kNotificationDidReceiveNewMessageFromRoom, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
            
            if(self.dialog.type.value != QBChatDialogTypePrivate.value){
                self.chatRoom = self.dialog.chatRoom
                ChatService.instance().joinRoom(self.chatRoom, completionBlock: {
                    joinedChatRoom -> Void in
                    println("joined")
                })
            }
        }
    }
    
    func addNavigationSettings(){
        self.title = self.currGroup.nvGroupName
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.purpleHome()
        self.navigationController?.navigationBar.setBackgroundImage(ImageProcessor.imageWithColor(UIColor.purpleHome()), forBarMetrics: UIBarMetrics.Default)
        self.navigationItem.rightBarButtonItem = nil
    }
    
    func setDelegates(){
        self.tableView.registerNib(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTableViewCell")
        self.tableView.registerNib(UINib(nibName: "AttachmentTableViewCell", bundle: nil), forCellReuseIdentifier: "AttachmentTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.addFriendsTableView.allowsSelection = true
        self.addFriendsTableView.delegate = self
        self.addFriendsTableView.dataSource = self
        self.txtMail1.delegate = self
        self.txtMail1.tag = 1
        
    }
    
    func setSubviewsGraphics(){
        
        let titlesColor = UIColor.grayMedium()
        let titlesFont = UIFont(name: "spacer", size: 15)
        
        self.detailsView.backgroundColor = UIColor.clearColor()
        self.imgProfile.image = ImageHandler.getImageBase64FromUrl(self.currGroup.nvImage)
        self.imgProfile.contentMode = UIViewContentMode.ScaleAspectFill
        self.imgProfile.clipsToBounds = true
        
        //top view
        self.topView.backgroundColor = UIColor.clearColor()
        
        self.scrollView.backgroundColor = UIColor.clearColor()
        
        self.lblGroupLocation.font = UIFont(name: "spacer", size: 15.0)
        self.lblGroupLocation.textColor = UIColor.grayMedium()
        self.lblGroupLocation.textAlignment = NSTextAlignment.Left
        self.lblGroupLocation.text = "text from google"
        self.lblGroupLocation.sizeToFit()
        
        self.btnMoreInfo.setTitle( NSLocalizedString("More about", comment: "") as String/*"עוד על "*/ + self.currGroup.nvGroupName, forState: UIControlState.Normal)
        self.btnMoreInfo.setTitle(NSLocalizedString("More about", comment: "") as String/*"עוד על "*/ + self.currGroup.nvGroupName, forState: UIControlState.Highlighted)
        self.btnMoreInfo.titleLabel!.font = UIFont(name: "spacer", size: 15.0)
        self.btnMoreInfo.setTitleColor(UIColor.greenHome(), forState: UIControlState.Normal)
        self.btnMoreInfo.setTitleColor(UIColor.greenHome(), forState: UIControlState.Highlighted)
        self.btnMoreInfo.sizeToFit()
        self.btnMoreInfo.backgroundColor = UIColor.clearColor()
        self.btnMoreInfo.addTarget(self, action: "navigateToGroupProfile:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.btnAddFriendsToGroup.setTitle(NSLocalizedString("Join more members", comment: "") as String/*"צרף עוד משתמשים"*/, forState: UIControlState.Normal)
        self.btnAddFriendsToGroup.setTitle(NSLocalizedString("Join more members", comment: "") as String/*"צרף עוד משתמשים"*/, forState: UIControlState.Highlighted)
        self.btnAddFriendsToGroup.titleLabel!.font = UIFont(name: "spacer", size: 15.0)
        self.btnAddFriendsToGroup.setTitleColor(UIColor.grayMedium(), forState: UIControlState.Normal)
        self.btnAddFriendsToGroup.setTitleColor(UIColor.grayMedium(), forState: UIControlState.Highlighted)
        self.btnAddFriendsToGroup.sizeToFit()
        if self.currGroup.iMainUserId == ActiveUser.sharedInstace.iUserId{
            self.btnAddFriendsToGroup.hidden = false
        }else{
            self.btnAddFriendsToGroup.hidden = true
        }
        self.btnAddFriendsToGroup.hidden = true
        
        
        self.btnProfile.setTitle("...", forState: UIControlState.Normal)
        self.btnProfile.setTitle("...", forState: UIControlState.Highlighted)
        self.btnProfile.titleLabel!.font = UIFont(name: "spacer", size: 30.0)
        self.btnProfile.setTitleColor(UIColor.greenHome(), forState: UIControlState.Normal)
        self.btnProfile.setTitleColor(UIColor.greenHome(), forState: UIControlState.Highlighted)
        self.btnProfile.sizeToFit()
        self.btnProfile.backgroundColor = UIColor.clearColor()
        
        viewSeparation = UIView()
        viewSeparation.backgroundColor = UIColor.purpleHome()
        self.topView.bringSubviewToFront(self.btnProfile)
        
        //buttom view
        self.buttomView.backgroundColor = UIColor.clearColor()
        
        self.btnSend.backgroundColor = UIColor.clearColor()
        self.btnSend.setTitle("", forState: UIControlState.Normal)
        self.btnSend.setTitle("", forState: UIControlState.Highlighted)
        self.btnSend.titleLabel!.font = UIFont(name: "spacer", size: 17)
        self.btnSend.setBackgroundImage(UIImage(named: "send_btn"), forState: UIControlState.Normal)
        self.btnSend.setBackgroundImage(UIImage(named: "send_btn_clicked.png"), forState: UIControlState.Highlighted)
        self.btnSend.addTarget(self, action: "sendMessage:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.btnAddAttachment.backgroundColor = UIColor.clearColor()
        self.btnAddAttachment.setTitle("+", forState: UIControlState.Normal)
        self.btnAddAttachment.setTitle("+", forState: UIControlState.Highlighted)
        self.btnAddAttachment.titleLabel!.font = UIFont(name: "spacer", size: 30)
        self.btnAddAttachment.setTitleColor(UIColor.purpleHome(), forState: UIControlState.Normal)
        self.btnAddAttachment.setTitleColor(UIColor.purpleHome(), forState: UIControlState.Highlighted)
        self.btnAddAttachment.addTarget(self, action: "getFile:", forControlEvents: UIControlEvents.TouchUpInside)
        self.btnAddAttachment.layer.borderColor = UIColor.purpleShines().CGColor
        self.btnAddAttachment.layer.borderWidth = 1.5
        self.btnAddAttachment.layer.cornerRadius = 1.5
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.backgroundColor = UIColor.offwhiteBasic()
        
        
        
        self.viewCreateMeetingPoint.backgroundColor = UIColor.clearColor()
        
        self.btnCreateMeetingPoint.backgroundColor = UIColor.clearColor()
        self.btnCreateMeetingPoint.setTitle(NSLocalizedString("Meeting points", comment: "") as String/*"נקודת מפגש"*/, forState: UIControlState.Normal)
        self.btnCreateMeetingPoint.setTitle(NSLocalizedString("Meeting points", comment: "") as String/*"נקודת מפגש"*/, forState: UIControlState.Highlighted)
        self.btnCreateMeetingPoint.setTitleColor(UIColor.grayMedium(), forState: UIControlState.Normal)
        self.btnCreateMeetingPoint.setTitleColor(UIColor.purpleHome(), forState: UIControlState.Highlighted)
        self.btnCreateMeetingPoint.titleLabel!.font = UIFont(name: "spacer", size: 17)
        self.btnCreateMeetingPoint.addTarget(self, action: "createMeetingPoint:", forControlEvents: UIControlEvents.TouchUpInside)
        self.btnCreateMeetingPoint.sizeToFit()
        
        
        self.lblNoFriends.backgroundColor = UIColor.clearColor()
        self.lblNoFriends.textColor = titlesColor
        self.lblNoFriends.font = titlesFont
       // self.lblNoFriends.text = NSLocalizedString("B" , comment: "")
        self.lblNoFriends.text = NSLocalizedString("no friend",comment: "") as String
        self.lblNoFriends.sizeToFit()
//        self.lblNoFriends.hidden = true
        self.view.addSubview(lblNoFriends)
        
        self.btnAddFriends.backgroundColor = UIColor.purpleMedium()
        self.btnAddFriends.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.btnAddFriends.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        self.btnAddFriends.setTitle(NSLocalizedString("Join members", comment: "") as String/*"צרף חברים"*/, forState: UIControlState.Normal)
        self.btnAddFriends.setTitle(NSLocalizedString("Join members", comment: "") as String/*"צרף חברים"*/, forState: UIControlState.Highlighted)
        self.btnAddFriends.addTarget(self, action: "addFriends:", forControlEvents: UIControlEvents.TouchUpInside)
        self.btnAddFriends.layer.cornerRadius = 3
        self.btnAddFriends.layer.borderWidth = 1.0
        self.btnAddFriends.layer.borderColor = UIColor.purpleMedium().CGColor
        self.btnAddFriends.layer.shadowRadius = 1.0
        self.btnAddFriends.layer.shadowOffset = CGSizeMake(0, -1.0)
        self.btnAddFriends.layer.shadowColor = UIColor(red: 30/255.0, green: 10/255.0, blue: 40/255.0, alpha: 0.75).CGColor
        self.view.addSubview(self.btnAddFriends)
        
        self.lblAddFriends.backgroundColor = UIColor.clearColor()
        self.lblAddFriends.textColor = titlesColor
        self.lblAddFriends.font = titlesFont
        self.lblAddFriends.text = NSLocalizedString("Join members", comment: "")
        
        self.lblAddFriends.sizeToFit()
        self.lblAddFriends.hidden = true
        self.scrollView2.addSubview(lblAddFriends)
        
        self.lblFriendsNubmer.backgroundColor = UIColor.clearColor()
        self.lblFriendsNubmer.textColor = titlesColor
        self.lblFriendsNubmer.font = titlesFont
        self.lblFriendsNubmer.text = ""
        self.lblFriendsNubmer.sizeToFit()
        self.lblFriendsNubmer.hidden = true
        self.scrollView2.addSubview(lblFriendsNubmer)
        
        self.txtMail1.backgroundColor = UIColor.whiteColor()
        self.txtMail1.textColor = titlesColor
        self.txtMail1.font = titlesFont
        self.txtMail1.placeholder = NSLocalizedString("Search by name or Shanti name", comment: "")
        self.txtMail1.textAlignment = NSTextAlignment.Right
        self.txtMail1.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).CGColor
        self.txtMail1.layer.borderWidth = 1.5
        self.txtMail1.layer.cornerRadius = 3
        self.txtMail1.hidden = true
        self.scrollView2.addSubview(txtMail1)
        
        self.scrollView2.backgroundColor = UIColor.clearColor()
        self.view.addSubview(scrollView2)
        
        var bgImage = UIImage(named: "close_icn-groups")!
        self.btnX.setBackgroundImage(bgImage, forState: UIControlState.Normal)
        self.btnX.setBackgroundImage(bgImage, forState: UIControlState.Highlighted)
        self.btnX.setTitle("", forState: UIControlState.Normal)
        self.btnX.setTitle("", forState: UIControlState.Highlighted)
        self.btnX.addTarget(self, action: "closeTableView:", forControlEvents: UIControlEvents.TouchUpInside)
        self.btnX.frame = CGRectMake(5, 10, bgImage.size.width/2, bgImage.size.height/2)
        self.btnX.layer.borderColor = UIColor.offwhiteDark().CGColor
        self.btnX.layer.borderWidth = 1.5
        self.btnX.layer.cornerRadius = 3
        
        var headerView = UIView(frame: CGRectMake(0, 0, self.addFriendsTableView.frame.size.width, self.btnX.frame.size.height + 10))
        headerView.backgroundColor = UIColor.offwhiteBasic()
        headerView.addSubview(self.btnX)
        self.addFriendsTableView.tableHeaderView = headerView
        
        self.imgCreateMeetingPoint.image = UIImage(named: "meeting_point_groups")
        
        if self.currGroup.iMainUserId == ActiveUser.sharedInstace.iUserId{
            viewCreateMeetingPoint.hidden = false
        }else{
            viewCreateMeetingPoint.hidden = true
        }
    }
    
    func setSubviewsFrames(){
        let viewMeetingPointW = CGFloat(98)
        let viewMeetingPointH = CGFloat(18)
        let spaceFromeRight = CGFloat(18)
        let imgW = CGFloat(self.imgCreateMeetingPoint.image!.size.width/2)
        let imgH = CGFloat(self.imgCreateMeetingPoint.image!.size.height/2)
        
        self.detailsView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 150)
        self.imgProfile.frame = CGRectMake(0, 0, self.detailsView.frame.size.width, self.detailsView.frame.size.height)
        
        //inside topView
        self.topView.frame = CGRectMake(0, self.detailsView.frame.origin.y + self.detailsView.frame.size.height, UIScreen.mainScreen().bounds.size.width, self.detailsView.frame.size.height)
        self.scrollView.frame = CGRectMake(0, 0, self.topView.frame.size.width, self.topView.frame.size.height/2)
        self.lblGroupLocation.frame = CGRectMake(15, self.scrollView.frame.origin.y + self.scrollView.frame.size.height, self.lblGroupLocation.frame.size.width, self.lblGroupLocation.frame.size.height)
        self.btnMoreInfo.frame = CGRectMake(15, self.topView.frame.size.height - self.btnMoreInfo.frame.size.height - 10, self.btnMoreInfo.frame.size.width, self.btnMoreInfo.frame.size.height)
        self.btnAddFriendsToGroup.frame = CGRectMake(self.topView.frame.size.width -  self.btnAddFriendsToGroup.frame.size.width - 15, self.btnMoreInfo.frame.origin.y, self.btnAddFriendsToGroup.frame.size.width, self.btnAddFriendsToGroup.frame.size.height)
        self.btnProfile.frame = CGRectMake((self.topView.frame.size.width - self.btnProfile.frame.size.width)/2, self.topView.frame.size.height - self.btnProfile.frame.size.height,/* self.btnProfile.frame.size.width, self.btnProfile.frame.size.height*/50,50)
        viewSeparation.frame = CGRectMake(0, self.topView.frame.size.height - 5, self.topView.frame.size.width, 5)
        
        //inside buttomView
        if (self.navigationController != nil)
        {
        self.buttomView.frame = CGRectMake(0,buttomViewNormalY - self.navigationController!.navigationBar.bounds.height - self.navigationController!.navigationBar.frame.origin.y, UIScreen.mainScreen().bounds.width, 50)
        self.btnAddAttachment.frame = CGRectMake(15, (self.buttomView.frame.size.height - 30)/2, 30, 30)
        self.btnSend.frame = CGRectMake(self.buttomView.frame.size.width - self.btnSend.backgroundImageForState(UIControlState.Normal)!.size.width/2, (self.buttomView.frame.size.height - self.btnSend.backgroundImageForState(UIControlState.Normal)!.size.height/2)/2, self.btnSend.backgroundImageForState(UIControlState.Normal)!.size.width/2, self.btnSend.backgroundImageForState(UIControlState.Normal)!.size.height/2)
        self.txtMessage.frame = CGRectMake(self.btnAddAttachment.frame.origin.x + self.btnAddAttachment.frame.size.width + 5, (self.buttomView.frame.size.height - self.txtMessage.frame.size.height)/2, self.btnSend.frame.origin.x - (self.btnAddAttachment.frame.origin.x + self.btnAddAttachment.frame.size.width + 5) - 5, self.txtMessage.frame.size.height)
        }
        
        if self.currGroup.iNumOfMembers==1
        {

            self.tableView.hidden = true
            self.scrollView2.hidden  = false
            
        }
        else
        {
            self.tableView.frame = CGRectMake(0, self.topView.frame.origin.y + self.topView.frame.size.height, UIScreen.mainScreen().bounds.size.width, self.buttomView.frame.origin.y - (self.topView.frame.origin.y + self.topView.frame.size.height))
            self.tableView.hidden = false
            self.scrollView2.hidden  = true
        }
        
        self.btnCreateMeetingPoint.frame = CGRectMake(0, 0, self.btnCreateMeetingPoint.frame.size.width, self.btnCreateMeetingPoint.frame.size.height)
        self.imgCreateMeetingPoint.frame = CGRectMake(self.btnCreateMeetingPoint.frame.origin.x + self.btnCreateMeetingPoint.frame.size.width + 5, self.btnCreateMeetingPoint.frame.origin.y, imgW, imgH)
        self.btnCreateMeetingPoint.frame = CGRectMake(self.btnCreateMeetingPoint.frame.origin.x, (self.imgCreateMeetingPoint.frame.origin.y + self.imgCreateMeetingPoint.frame.size.height - self.btnCreateMeetingPoint.frame.size.height)/2, self.btnCreateMeetingPoint.frame.size.width, self.btnCreateMeetingPoint.frame.size.height)
        self.viewCreateMeetingPoint.frame = CGRectMake(self.topView.frame.size.width - spaceFromeRight - (imgCreateMeetingPoint.frame.origin.x + self.imgCreateMeetingPoint.frame.size.width), self.lblGroupLocation.frame.origin.y, self.imgCreateMeetingPoint.frame.origin.x + self.imgCreateMeetingPoint.frame.size.width, imgCreateMeetingPoint.frame.origin.y + self.imgCreateMeetingPoint.frame.size.height)


        
        self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.txtMail1.frame.origin.y + self.txtMail1.frame.size.height)
        
        self.lblNoFriends.frame = CGRectMake((self.view.frame.size.width - self.lblNoFriends.frame.size.width)/2, self.detailsView.frame.origin.y + self.detailsView.frame.size.height + 5, self.lblNoFriends.frame.size.width, self.lblNoFriends.frame.size.height)
        var w = (self.view.frame.size.width - txtsW)/2
        self.btnAddFriends.frame = CGRectMake(w, self.lblNoFriends.frame.origin.y + self.lblNoFriends.frame.size.height+5, txtsW, txtsH)
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height)
    }
    
    func setSubViewHidden()
    {
        if self.currGroup.iNumOfMembers == 1
        {
            self.lblGroupLocation.hidden = true
            self.btnAddFriends.hidden = false
            self.lblNoFriends.hidden = false
            self.viewCreateMeetingPoint.hidden = true
            self.btnMoreInfo.hidden  = true
            self.btnProfile.hidden = true
            self.btnCreateMeetingPoint.hidden = true
            self.imgCreateMeetingPoint.hidden = true
            self.buttomView.hidden = true
        }
        else
        {
            self.lblGroupLocation.hidden = false
            self.btnAddFriends.hidden = true
            self.lblNoFriends.hidden = true
            self.viewCreateMeetingPoint.hidden = false
            self.btnMoreInfo.hidden  = false
            self.btnProfile.hidden = false
            self.btnCreateMeetingPoint.hidden = false
            self.imgCreateMeetingPoint.hidden = false
            self.buttomView.hidden = false
        }
    }
    
    func addFriends(sender: AnyObject?)
    {
            let subviews = self.scrollView2.subviews as! [UIView]
            for v in subviews {
                if v.isKindOfClass(UIButtonSearch){
                    v.removeFromSuperview()
                }
            }
        
        self.addFriensTaped = true
            self.scrollView2.frame = CGRectMake(0, self.btnAddFriends.frame.origin.y + self.btnAddFriends.frame.size.height + 10,UIScreen.mainScreen().bounds.size.width,(self.topView.frame.origin.y + self.topView.frame.size.height))
        self.txtMail1.frame = CGRectMake((UIScreen.mainScreen().bounds.size.width - txtsW)/2+spaceBetweenTxtToBtn + searchBtnSize, 50, mailTxtsW, txtsH)
        self.lblAddFriends.frame = CGRectMake(self.txtMail1.frame.origin.x + self.txtMail1.frame.size.width - self.lblAddFriends.frame.size.width, (self.txtMail1.frame.origin.y - self.lblAddFriends.frame.size.height)/2, self.lblAddFriends.frame.size.width, self.lblAddFriends.frame.size.height)
                self.scrollView2.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height)
        

        self.tableView.hidden = true
        self.scrollView2.hidden  = false
        self.lblAddFriends.hidden = false
        self.txtMail1.hidden = false
        self.addSearchBtn(self.txtMail1)
    

    }
    
    func addSearchBtn(forTextField: UITextField){
        var searchBtn = UIButtonSearch()
        
        var frame = CGRectMake(forTextField.frame.origin.x - spaceBetweenTxtToBtn - searchBtnSize, forTextField.frame.origin.y, searchBtnSize, searchBtnSize)
        searchBtn.frame = frame
        searchBtn.textField = forTextField
        searchBtn.tag = forTextField.tag
        forTextField.tag = 0 // for not gett 2 view's with the same tag when using viewWithTag in didSelectRow - tableView
        searchBtn.addTarget(self, action: "searhBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.scrollView2.addSubview(searchBtn)
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1)
        
        textField.backgroundColor = UIColor.offwhiteBasic()
        textField.textColor = UIColor.grayDark()
        textField.layer.borderColor = UIColor.grayColor().CGColor
        
        //        if textField != self.txtGroupName && textField != self.txtComment{
        //            self.view.frame = CGRectMake(self.view.frame.origin.x, -180, self.view.frame.size.width, self.view.frame.size.height)
        //        }
        
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
//        if textField == txtMail1{
//            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 240, self.view.frame.size.width, self.view.frame.size.height)
//        }
    }
    
//    func textFieldShouldReturn(textField: UITextField) -> Bool{
//        self.dismissKeyboard(textField)
//        return true
//    }
    
    func searhBtnClicked(sender: AnyObject){
        if let srchBtn = sender as? UIButtonSearch{
            self.dismissKeyboard(sender)
            if srchBtn.textField.text != ""{
                self.getUserDetailsByEmailFromServer(srchBtn)
            }else{
                srchBtn.textField.layer.borderColor = UIColor.redColor().CGColor
            }
        }
    }
    
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
    
    func downloadImagesFromServer(){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            for currUser in self.usersDict.allValues{
                (currUser as! User).image = (ImageHandler.getImageBase64FromUrl((currUser as! User).nvImage))
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.addFriendsTableView.reloadData()
            }
        })
    }
    
    func fiilUsersTable(forSrchBtn: UIButtonSearch){
        var offsetY = self.scrollView2.frame.origin.y + forSrchBtn.frame.origin.y
        var tvH = CGFloat(self.cellH * CGFloat(self.usersDict.allKeys.count))
        
        if tvH > (offsetY - spaceFromNavigationToTxt){
            tvH = (offsetY - spaceFromNavigationToTxt)
        }
        
        self.addFriendsTableView.frame = CGRectMake(forSrchBtn.frame.origin.x, offsetY - tvH - spaceBetweenTxts, self.txtsW, tvH)
        self.addFriendsTableView.tag = forSrchBtn.tag
        self.view.addSubview(addFriendsTableView)
        self.view.bringSubviewToFront(addFriendsTableView)
        
        self.scrollView2.scrollEnabled = false
        self.addFriendsTableView.reloadData()
    }
    
    
    func addGroupUsersImagesToScroll(){
        let spaceFromTheViewFrame = CGFloat(15.0)
        let spaceBetweenBtns = CGFloat(7.0)
        var nextX = spaceFromTheViewFrame
        let btnsSize = CGFloat(37.5)
        let btnsY = (self.scrollView.frame.size.height - btnsSize)/2
        for currUser in self.currGroup.UsersList{
            if (currUser as! User).bIsActive  == true
            {
            var btnUser = UIButton(frame: CGRectMake(nextX, btnsY, btnsSize, btnsSize))
            btnUser.setBackgroundImage(ImageHandler.getImageBase64FromUrl((currUser as! User).nvImage), forState: UIControlState.Normal)
            btnUser.setBackgroundImage(ImageHandler.getImageBase64FromUrl((currUser as! User).nvImage), forState: UIControlState.Highlighted)
            btnUser.layer.cornerRadius = 14
            btnUser.layer.borderWidth = 1.5
            btnUser.layer.borderColor = UIColor.greenHome().CGColor
            btnUser.contentMode = UIViewContentMode.ScaleAspectFill
            btnUser.clipsToBounds = true
            
            nextX = nextX + btnsSize + spaceBetweenBtns
            
            self.scrollView.contentSize = CGSizeMake(btnUser.frame.origin.x + btnsSize + spaceFromTheViewFrame, self.scrollView.frame.size.height)
            self.scrollView.addSubview(btnUser)
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView.tag == 5
        {
            return self.messages.count
        }
        else
        {
            return self.usersDict.allKeys.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if tableView.tag == 5
        {
            var currCell: UITableViewCell!
            var currMsg: QBChatAbstractMessage = self.messages.objectAtIndex(indexPath.row) as! QBChatAbstractMessage
            var senderName = String()
            if currMsg.attachments != nil && currMsg.attachments.count > 0{
                currCell = tableView.dequeueReusableCellWithIdentifier("AttachmentTableViewCell", forIndexPath: indexPath) as! AttachmentTableViewCell
                currCell.backgroundColor = UIColor.whiteColor()
                
                var cell = currCell as! AttachmentTableViewCell
                cell.del=self
                cell.currentMessage=currMsg
                cell.tableViewWidth = self.tableView.bounds.size.width
                cell.progressView.hidden = true
                
                if ActiveUser.sharedInstace.oUserQuickBlox.ID == Int(currMsg.senderID){
                    cell.imgUserProfile.image = ActiveUser.sharedInstace.image
                }else{
                    for currUser in self.currGroup.UsersList{
                        if (currUser as! User).oUserQuickBlox.ID == Int(currMsg.senderID){
                            cell.imgUserProfile.image = self.imgsDict["\((currUser as! User).iUserId)"] as? UIImage
                            senderName = (currUser as! User).nvShantiName//(currUser as! User).nvFirstName
                            break
                        }
                    }
                }
                
                cell.imgUserProfile.layer.cornerRadius = 9.0
                cell.imgUserProfile.layer.borderWidth = 1.0
                cell.imgUserProfile.layer.borderColor = UIColor.grayMedium().CGColor
                cell.imgUserProfile.clipsToBounds = true
                
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
                cell.del=self
                cell.currentMessage=currMsg
                cell.tableViewWidth = self.tableView.bounds.size.width
                
                if ActiveUser.sharedInstace.oUserQuickBlox.ID == Int(currMsg.senderID){
                    cell.imgUserProfile.image = ActiveUser.sharedInstace.image
                }else{
                    for currUser in self.currGroup.UsersList{
                        if (currUser as! User).oUserQuickBlox.ID == Int(currMsg.senderID){
                            cell.imgUserProfile.image = self.imgsDict["\((currUser as! User).iUserId)"] as? UIImage
                            senderName = (currUser as! User).nvShantiName//(currUser as! User).nvFirstName
                            break
                        }
                    }
                }
                
                cell.imgUserProfile.layer.cornerRadius = 9.0
                cell.imgUserProfile.layer.borderWidth = 1.0
                cell.imgUserProfile.layer.borderColor = UIColor.grayMedium().CGColor
                cell.imgUserProfile.clipsToBounds = true
                
                cell.configureCellWithMessage(currMsg,senderName: senderName)
                
            }
            
            currCell.backgroundColor = UIColor.clearColor()
            currCell.selectionStyle = UITableViewCellSelectionStyle.None
            return currCell
        }
        else
        {
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
            lblUserInfo.font = UIFont(name: "spacer", size: 15)
            lblUserInfo.text = /*currUser.nvFirstName + " " + currUser.nvLastName*/currUser.nvShantiName + "\n" + currUser.oCountry.nvValue
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if tableView.tag == 5
        {
            let currMsg: QBChatAbstractMessage = self.messages.objectAtIndex(indexPath.row) as! QBChatAbstractMessage
            let cellHeight: CGFloat = ChatTableViewCell.heightForCellWithMessage(currMsg)
            return cellHeight
            
        }
        else
        {
            return self.cellH
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        if tableView.tag != 5
        {
            if let srchBtn = self.scrollView2.viewWithTag(self.addFriendsTableView.tag) as? UIButtonSearch{
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
        
    }
    
    func closeTableView(sender: AnyObject){
        addFriendsTableView.removeFromSuperview()
        self.scrollView2.scrollEnabled = true
    }
    
    func addUserDetailsView(forSrchBtn: UIButtonSearch, userDetails: User){
        var userView = UIView(frame: CGRectMake(forSrchBtn.frame.origin.x, forSrchBtn.frame.origin.y + forSrchBtn.frame.size.height + spaceBetweenTxts, (forSrchBtn.textField.frame.origin.x + forSrchBtn.textField.frame.size.width) - forSrchBtn.frame.origin.x,forSrchBtn.frame.size.height ))
        userView.tag = userDetails.iUserId
        
        let requestW = CGFloat(94.0)
        let requestH = CGFloat(29.0)
        
        var btnRequest = UIButton(frame: CGRectMake(0, (userView.frame.size.height - requestH)/2, requestW, requestH))
        btnRequest.setTitle("שלח בקשה", forState: UIControlState.Normal)
        btnRequest.setTitle("שלח בקשה", forState: UIControlState.Highlighted)
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
        lblUserInfo.font = UIFont(name: "spacer", size: 15)
        lblUserInfo.text = /*userDetails.nvFirstName + " " + userDetails.nvLastName*/userDetails.nvShantiName + "\n" + userDetails.oCountry.nvValue
        lblUserInfo.textAlignment = NSTextAlignment.Right
        lblUserInfo.sizeToFit()
        lblUserInfo.backgroundColor = UIColor.clearColor()
        lblUserInfo.textColor = UIColor.grayDark()
        lblUserInfo.frame = CGRectMake(imgUser.frame.origin.x - lblUserInfo.frame.size.width - spaceBtweenImgToLable, (userView.frame.size.height - lblUserInfo.frame.size.height)/2, lblUserInfo.frame.size.width, lblUserInfo.frame.size.height)
        
        userView.addSubview(btnRequest)
        userView.addSubview(imgUser)
        userView.addSubview(lblUserInfo)
        
        self.scrollView2.contentSize = CGSizeMake(self.scrollView2.contentSize.width, self.scrollView2.contentSize.height + userView.frame.size.height + spaceBetweenTxts)
        
        //        moving the rest textFields frame after userView frame
        self.moveScrollViewSubviewsAfter(userView)
        self.scrollView2.addSubview(userView)
        self.scrollView2.scrollRectToVisible(userView.frame, animated: true)
    }
    
    func moveScrollViewSubviewsAfter(inputView: UIView){
        for view in self.scrollView2.subviews{
            if view.frame.origin.y >= inputView.frame.origin.y{
                (view as! UIView).frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + inputView.frame.size.height + spaceBetweenTxts, view.frame.size.width, view.frame.size.height)
            }
        }
    }
    
    func moveScrollViewSubviewsBefore(inputView: UIView){
        for view in self.scrollView2.subviews{
            if view.frame.origin.y > inputView.frame.origin.y{
                (view as! UIView).frame = CGRectMake(view.frame.origin.x, view.frame.origin.y - inputView.frame.size.height - spaceBetweenTxts, view.frame.size.width, view.frame.size.height)
            }
        }
    }
    
    func sendUserRequest(sender: AnyObject){
        var b:Bool=Bool(false)
        if let senderBtn = sender as? UIButton{
            var newUser = User()
            if let requestedUser = self.usersDict["\(senderBtn.tag)"] as? User{
                
                newUser.iUserId = requestedUser.iUserId
                newUser.oUserQuickBlox.ID = requestedUser.oUserQuickBlox.ID
                self.currGroup.UsersList.addObject(newUser)
                self.lblFriendsNubmer.text = "צרפת \(self.currGroup.UsersList.count) משתמשים"
                self.lblFriendsNubmer.hidden = false
                self.lblFriendsNubmer.sizeToFit()
                self.lblFriendsNubmer.frame = CGRectMake(20, (self.txtMail1.frame.origin.y - self.lblAddFriends.frame.size.height)/2, self.lblFriendsNubmer.frame.size.width, lblFriendsNubmer.frame.size.height)
            }
            //             }
            
            senderBtn.removeFromSuperview()
        }
    }
    
    func getGroupById(){
        let generic = Generic()
        generic.showNativeActivityIndicator(self)
        
        dispatch_sync(connectionQueue, {
            Connection.connectionToService("GetGroup", params:["id":self.currGroup.iGroupId], completion: {
                data -> Void in
                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("GetGroup:\(strData)")
                var err: NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
                if json != nil{
                    if let parseJSON = json {
                        self.currGroup = Group.parseGroupDictionary(parseJSON)
                        self.updateDialog()
                        self.downloadImageFromServer()
                        self.addGroupUsersImagesToScroll()
                    }
                }
            })
            generic.hideNativeActivityIndicator(self)
        })
        
    }
    
    func updateDialog(){
        var usersIdArr = NSMutableArray()
        for currUser in self.currGroup.UsersList{
            usersIdArr.addObject(Int((currUser as! User).oUserQuickBlox.ID))
        }
        
        self.dialog.occupantIDs = [usersIdArr]
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool{
        if touch.view.isKindOfClass(UITableViewCell) || touch.view.isKindOfClass(UITableView){
            return false
        }
        return true
    }
    
    func dismissKeyboard(sender: AnyObject){
        self.txtMessage.resignFirstResponder()
        self.txtMail1.resignFirstResponder()
    }
    
    //pragma mark QBActionStatusDelegate
    func completedWithResult(result: Result){
        if result.success && result.isKindOfClass(QBChatHistoryMessageResult) {
            var res = result as! QBChatHistoryMessageResult
            var historyMessages = res.messages
            if historyMessages != nil
            {
                //                self.messages.addObjectsFromArray(historyMessages)
                for i in 0...historyMessages.count - 1
                { // sort asc
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
        }else if result.success && result.isKindOfClass(QBChatDialogResult){
            self.dialog = (result as! QBChatDialogResult).dialog!
            println("result updated dialog")
        }else{
            println("result.success = false")
        }
        generic.hideNativeActivityIndicator(self)
    }
    
    func chatRoomDidReceiveMessageNotification(notification: NSNotification){
        var currMessage: QBChatMessage? = notification.userInfo?[kMessage] as? QBChatMessage
        var roomJID: String? = notification.userInfo?[kRoomJID] as? String
        
        if self.chatRoom!.JID != roomJID {
            return
        }
        
        self.messages.addObject(currMessage!)
        
        if currMessage?.attachments != nil && currMessage?.attachments.count > 0{
            if (currMessage?.text == nil) || (currMessage?.text != nil && currMessage?.text == ""){
                self.downloadAttachment(currMessage!)
            }else{
                self.messages.removeObject(currMessage!)
                largeAttachments.setObject(currMessage!, forKey: currMessage!.text)
            }
        }
        
        self.tableView.reloadData()
        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.messages.count - 1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        self.dismissKeyboard(textField)
        return false
    }
    
    func keyboardWillShow(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey]
            as? NSValue)?.CGRectValue() {
                UIView.animateWithDuration(0.3, animations: {
                    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - keyboardSize.height, self.view.frame.size.width, self.view.frame.size.height)
                })
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
             self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + keyboardSize.height, self.view.frame.size.width, self.view.frame.height)
        }
        
    }
    
    
    @IBAction func sendMessage(sender: AnyObject) {
        self.dismissKeyboard(sender)
        var currMessage = QBChatMessage()
        currMessage.text = self.txtMessage.text
        if currMessage.text != "" && currMessage.text != " "{
            var params: NSMutableDictionary = NSMutableDictionary()
            params["save_to_history"] = true
            currMessage.customParameters = params
            currMessage.senderID = UInt(ActiveUser.sharedInstace.oUserQuickBlox.ID)
            
            ChatService.instance().sendMessage(currMessage, toRoom: self.chatRoom)
            self.sendUserDialogNotification(self.txtMessage.text)
            
        //self.tableView.hidden = false
       // self.tableView.reloadData()
            self.messages.addObject(currMessage)
            self.txtMessage.text = nil
            self.tableView.reloadData()
            if(self.messages.count > 0){
                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.messages.count-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
            }

        }
    }
    
    func btnProfilePanGesture(sender: UIGestureRecognizer){
        println("pan")
        self.topView.frame = CGRectZero
        if self.currGroup.iNumOfMembers==1
        {
//            self.scrollView2.frame = CGRectMake(0, self.detailsView.frame.origin.y + self.detailsView.frame.size.height, self.tableView.frame.size.width, self.tableView.frame.size.height)
            
        }
        else
        {
            self.tableView.frame = CGRectMake(0, self.detailsView.frame.origin.y + self.detailsView.frame.size.height, self.tableView.frame.size.width, self.tableView.frame.size.height)
        }
        //        self.tableView.frame = CGRectMake(0, self.detailsView.frame.origin.y + self.detailsView.frame.size.height, self.tableView.frame.size.width, self.tableView.frame.size.height)
    }
    
    func downloadImageFromServer(){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            for currUser in self.currGroup.UsersList{
                self.imgsDict.setObject(ImageHandler.getImageBase64FromUrl((currUser as! User).nvImage), forKey:"\((currUser as! User).iUserId)")
            }
            self.tableView.reloadData()
        })
    }
    
    func sendUserDialogNotification(withText: String){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            //            let message = ("\(ActiveUser.sharedInstace.nvFirstName) \(ActiveUser.sharedInstace.nvLastName): \(withText)")
            let message = ("\(ActiveUser.sharedInstace.nvShantiName) : \(withText)")
            
            var parametersList = NSMutableArray()
            
            var keyVals = KeyValue()
            keyVals.nvKey = "notificationType"
            keyVals.nvValue = String(NOTIFICATION_TYPE.NOTIFICATION_TYPE_NEW_MESSAGE_GROUP.rawValue)
            parametersList.addObject(KeyValue.getKeyValueDictionary(keyVals))
            
            keyVals.nvKey = "userIdSend"
            keyVals.nvValue = String(ActiveUser.sharedInstace.iUserId)
            parametersList.addObject(KeyValue.getKeyValueDictionary(keyVals))
            
            keyVals.nvKey = "iGroupId"
            keyVals.nvValue = String(self.currGroup.iGroupId)
            parametersList.addObject(KeyValue.getKeyValueDictionary(keyVals))
            
            var usersIds = NSMutableArray()
            for currUser in self.currGroup.UsersList{
                usersIds.addObject((currUser as! User).iUserId)
            }
            
            Connection.connectionToService("PushUpdates", params: ["sMessage":message,"ParamsList":parametersList,"lUsers":usersIds], completion: {
                data -> Void in
                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("PushUpdates group chat:\(strData)")
            })
            
        })
    }
    
    @IBAction func navigateToGroupProfile(sender: AnyObject) {
        let groupProfileView: GroupProfileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("GroupProfileViewControllerId") as! GroupProfileViewController
        groupProfileView.group = self.currGroup
        self.navigationController?.pushViewController(groupProfileView, animated: true)
    }
    
    func createMeetingPoint(sender: AnyObject){
        let meetingPointView = self.storyboard?.instantiateViewControllerWithIdentifier("CreateMeetingPointWithGroupViewControllerId") as! CreateMeetingPointWithGroupViewController
        meetingPointView.group = self.currGroup
        self.navigationController?.pushViewController(meetingPointView, animated: true)
    }
    
    func getFile(sender: AnyObject){
        var actionSheet = UIActionSheet(title: NSLocalizedString("Select a source image", comment: "") as String/*"בחר מקור תמונה"*/, delegate: self, cancelButtonTitle:NSLocalizedString("Cancellation", comment: "") as String /*"ביטול"*/, destructiveButtonTitle: nil, otherButtonTitles:NSLocalizedString("Camera", comment: "") as String,NSLocalizedString("Gallery", comment: "") as String /*"מצלמה"/*, */"אלבום תמונות"*/)
        //        var actionSheet = UIActionSheet(title: "בחר מקור תמונה", delegate: self, cancelButtonTitle: "ביטול", destructiveButtonTitle: nil, otherButtonTitles: "מצלמה", "אלבום תמונות")
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        var file = image
        print("chatRoom:\(self.chatRoom)")
        self.setChatSettings()
        self.sendMessageWithFile(file)
    }
    
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
                
                currMessage.senderID = UInt(ActiveUser.sharedInstace.oUserQuickBlox.ID)
                ChatService.instance().sendMessage(currMessage, toRoom: self.chatRoom)
                self.sendUserDialogNotification( NSLocalizedString("Image", comment: "") as String)//Image
                var dict = NSMutableDictionary()
                dict.setObject(imageData, forKey: "\(uploadedBlob.ID)")
                self.attachments.setObject(dict, forKey: currMessage.ID)
                
                self.messages.addObject(currMessage)
                self.txtMessage.text = nil
                self.tableView.reloadData()
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
                        self.downloadAttachment(currMessage)
                        currMessage.senderID = UInt(ActiveUser.sharedInstace.oUserQuickBlox.ID)
                        
                        ChatService.instance().sendMessage(currMessage, toRoom: self.chatRoom)
                        self.txtMessage.text = nil
                        }, statusBlock: {
                            request, status -> Void in
                            println("requestType:\(status.requestType.rawValue)")
                            currCell?.progressView.progress = CGFloat(status.percentOfCompletion)
                        }, errorBlock: {
                            response -> Void in
                            println("error:\(response.error)")
                    })
                }
                }, statusBlock: {
                    request, status -> Void in
                    println("requestType:\(status.requestType.rawValue)")
                    var a: QBRequestStatus
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
                    self.tableView.reloadData()
                    }, statusBlock: {
                        request, status -> Void in
                        println("requestType:\(status.requestType.rawValue)")
                    }, errorBlock: {
                        response -> Void in
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
        
        if let  curMsg = self.messages.objectAtIndex((sender as! UIButton).tag) as? QBChatAbstractMessage{
            if curMsg.attachments != nil && curMsg.attachments.count > 0{
                for attachment in curMsg.attachments{
                    var str = NSString(string: attachment.ID)
                    if let msg = self.largeAttachments.objectForKey(str) as? QBChatAbstractMessage{
                        if msg.attachments != nil && msg.attachments.count > 0{
                            for newAttachment in msg.attachments{
                                attachmentCell.progressView.hidden = false
                                attachmentCell.progressView.indeterminate = false
                                attachmentCell.progressView.progress = 0.0
                                
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
                                        }else
                                        {
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
    
    func presentImg(sender: AnyObject){
        if let btn = sender as? UIButton{
            if let  curMsg = self.messages.objectAtIndex((sender as! UIButton).tag) as? QBChatAbstractMessage{
                if curMsg.attachments != nil && curMsg.attachments.count > 0{
                    for attachment in curMsg.attachments{
                        var blobIdString = NSString(string: attachment.ID)
                        if self.downloadedAttchs.valueForKey(blobIdString as String) != nil{
                            var processor = ImageProcessor()
                            processor.delegate = self
                            processor.PresentImage(self.downloadedAttchs.valueForKey(blobIdString as String)as! String)
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
        //        ChatService.deleteMessageWithID( message.ID, successBlock: {(response: QBResponse!) in
        //
        //            }, errorBlock: {(response: QBResponse!) in
        //
        //        })
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

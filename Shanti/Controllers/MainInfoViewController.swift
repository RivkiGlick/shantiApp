//
//  MainInfoViewController.swift
//  Shanti
//
//  Created by hodaya ohana on 5/10/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

protocol MainInfoViewDelegate{
    func chatBtnDidClick(sender: AnyObject, user: User)
    func btnMettingPointDidClick(sender: AnyObject)
    func navigateToUser(userId: Int)
    func navigateToMeetingPoint(iMeetingPointId: Int)
    func startChatWithGroup(iGroupId: Int)
    func mainInfoDidChangeFrame()
    func btnMoreAboutFriend(user: User)
}

class MainInfoViewController: UIViewController {
    
    @IBOutlet weak var viewP: UIView!
    @IBOutlet weak var lblIndicatorLS: UILabel!
    @IBOutlet weak var imgIndicatorLS: UIImageView!
    @IBOutlet weak var lblAboutLS: UILabel!
    @IBOutlet weak var btnMoreInfoLS: UIButton!
    @IBOutlet weak var lblSubtitleLS: UILabel!
    @IBOutlet weak var lblTitleLS: UILabel!
    @IBOutlet weak var btnMeetingPointLS: UIButton!
    @IBOutlet weak var lblTimeLS: UILabel!
    @IBOutlet weak var btnChatLS: UIButton!
    @IBOutlet weak var viewLS: UIView!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var lblNoteLS: UILabel!
    @IBOutlet weak var btnMoreInfo: UIButton!
    @IBOutlet weak var btnMeetingPoint: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var lblAbout: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgIndicator: UIImageView!
    @IBOutlet weak var lblIndicator: UILabel!
    var textAlignment: NSTextAlignment = .Left
    var mainPage:MainPage = MainPage()
    
    var delegate: MainInfoViewDelegate?
    
    var user: User?{
        didSet{
            if self.user != nil{
                self.meetingPoint = nil
                self.viewConfig()
            }
            
        }
    }
    
    var meetingPoint: MeetingPoint?{
        didSet{
            if self.meetingPoint != nil{
                self.user = nil
                self.viewConfig()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainPage.userInfoView = self
        mainPage.userInfoViewLS = self

        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    
    override func viewWillLayoutSubviews(){
        //self.addSubviewsSettings()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
        
    }

    
    func rotated()
    {
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
        {
//            viewP.hidden = true
//            viewLS.hidden = true
            //viewLS.frame = CGRectMake(0, 0, 330, 240)
            
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
        {
//            viewP.hidden = false
//            viewLS.hidden = true
//            
        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewConfig(){
        self.setSubviewsSettings()
    }
    
    func setSubviewsSettings(){
        self.navigationController?.navigationBarHidden = true
        if self.user != nil{
            self.configByUser()
            self.setFramesByUser()
        }else if self.meetingPoint != nil{
            self.setFramesByMeetingPoint()
            self.configByMeetingPoint()
            self.setFramesByMeetingPoint()
        }
    }
    
    func configByUser(){
        
        var space: CGFloat = 10
        
        let languageId = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) as! String
        if languageId == "he"
        {
            textAlignment = .Right
            space = -space
        }
     self.lblAbout.textAlignment = textAlignment
        
        self.lblAbout.hidden = true
        self.lblTime.hidden = true
        
        self.lblAboutLS.textAlignment = textAlignment
        
        self.lblAboutLS.hidden = true
        self.lblTimeLS.hidden = true
        
        if self.user!.oUserQuickBlox.ID == -1{
            btnChat.hidden = true
            btnChatLS.hidden = true
        }else
        {
            btnChat.hidden = false
            btnChatLS.hidden = false

        }
        
        self.lblSubtitle.text = user!.nvShantiName
        self.lblSubtitleLS.text = user!.nvShantiName
        if self.user! == ActiveUser.sharedInstace
        {
            self.btnMoreInfo.hidden = true
            
            self.lblTitle.text = NSLocalizedString("You are here", comment: "") as String /*"אתה נמצא כאן"*/
            self.lblTitle.textColor = UIColor(red: 124/255, green: 7/255, blue: 157/255, alpha: 1)
            
            self.lblNote.text = ""
            var res = NSMutableAttributedString(attributedString: self.lblNote.attributedText)
            res.beginEditing()
            res.removeAttribute(NSFontAttributeName, range: NSRangeFromString("\(self.lblNote.attributedText)"))
            res.endEditing()
            self.lblNote.attributedText = res
            
            self.btnMoreInfo.hidden = true
            
            self.lblTitle.text = NSLocalizedString("You are here", comment: "") as String /*"אתה נמצא כאן"*/
            self.lblTitle.textColor = UIColor(red: 124/255, green: 7/255, blue: 157/255, alpha: 1)
            
            self.lblNoteLS.text = ""
//            var res = NSMutableAttributedString(attributedString: self.lblNoteLS.attributedText)
            res.beginEditing()
            res.removeAttribute(NSFontAttributeName, range: NSRangeFromString("\(self.lblNoteLS.attributedText)"))
            res.endEditing()
            self.lblNoteLS.attributedText = res
            
            self.btnMoreInfoLS.hidden = true
            
            self.lblTitleLS.text = NSLocalizedString("You are here", comment: "") as String /*"אתה נמצא כאן"*/
            self.lblTitleLS.textColor = UIColor(red: 124/255, green: 7/255, blue: 157/255, alpha: 1)

            
            
            
//            if self.user!.bIsMainUser == true
//            {
                self.btnMeetingPoint.hidden = false
                self.btnMeetingPointLS.hidden = false

//            }else
//            {
//                self.btnMeetingPoint.hidden = true
//            }
        }
        else
        {
            self.btnMoreInfo.hidden = false
            self.btnMeetingPoint.hidden = false
            
            self.lblTitle.textColor = UIColor.greenHome()
            self.lblTitle.text = user!.oAddress.nvFullAddress
            
            self.btnMoreInfoLS.hidden = false
            self.btnMeetingPointLS.hidden = false
            
            self.lblTitleLS.textColor = UIColor.greenHome()
            self.lblTitleLS.text = user!.oAddress.nvFullAddress
            
            var a = NSLocalizedString("More about", comment: "") as String//עוד על
            self.btnMoreInfo.setTitle("\(a) \(user!.nvShantiName)", forState: UIControlState.Normal)
            self.btnMoreInfo.setTitle("\(a) \(user!.nvShantiName)", forState: UIControlState.Highlighted)
            self.btnMoreInfo.addTarget(self, action: "moreAboutUser:", forControlEvents: UIControlEvents.TouchUpInside)
            
            self.btnMoreInfoLS.setTitle("\(a) \(user!.nvShantiName)", forState: UIControlState.Normal)
            self.btnMoreInfoLS.setTitle("\(a) \(user!.nvShantiName)", forState: UIControlState.Highlighted)
            self.btnMoreInfoLS.addTarget(self, action: "moreAboutUser:", forControlEvents: UIControlEvents.TouchUpInside)
        }
        self.btnMeetingPoint.setTitle("", forState: UIControlState.Normal)
        self.btnMeetingPoint.setTitle("", forState: UIControlState.Highlighted)
        self.btnMeetingPoint.addTarget(self, action: "createMeetingPoint:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.btnChat.setTitle("", forState: UIControlState.Normal)
        self.btnChat.setTitle("", forState: UIControlState.Highlighted)
        self.btnChat.addTarget(self, action: "startChat:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.btnMeetingPointLS.setTitle("", forState: UIControlState.Normal)
        self.btnMeetingPointLS.setTitle("", forState: UIControlState.Highlighted)
        self.btnMeetingPointLS.addTarget(self, action: "createMeetingPoint:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.btnChatLS.setTitle("", forState: UIControlState.Normal)
        self.btnChatLS.setTitle("", forState: UIControlState.Highlighted)
        self.btnChatLS.addTarget(self, action: "startChat:", forControlEvents: UIControlEvents.TouchUpInside)

        
        if self.user!  == ActiveUser.sharedInstace
        {
            self.btnChat.setBackgroundImage(UIImage(named: "chat_btn_me"), forState: UIControlState.Normal)
            self.btnChat.setBackgroundImage(UIImage(named: "chat_btn_me_clicked"), forState: UIControlState.Highlighted)
            
            self.btnChatLS.setBackgroundImage(UIImage(named: "chat_btn_me"), forState: UIControlState.Normal)
            self.btnChatLS.setBackgroundImage(UIImage(named: "chat_btn_me_clicked"), forState: UIControlState.Highlighted)
            
            self.btnMeetingPoint.setBackgroundImage(UIImage(named: "meeting_point_btn"), forState: UIControlState.Normal)
            self.btnMeetingPoint.setBackgroundImage(UIImage(named: "meeting_point_btn_clicked"), forState: UIControlState.Normal)
            self.imgIndicator.hidden = true
            self.lblIndicator.hidden = true
            self.lblNote.hidden = false
            
            self.btnMeetingPointLS.setBackgroundImage(UIImage(named: "meeting_point_btn"), forState: UIControlState.Normal)
            self.btnMeetingPointLS.setBackgroundImage(UIImage(named: "meeting_point_btn_clicked"), forState: UIControlState.Normal)
            self.imgIndicatorLS.hidden = true
            self.lblIndicatorLS.hidden = true
            self.lblNoteLS.hidden = false
        }
        else
        {
           
            
            self.btnChat.setBackgroundImage(UIImage(named: "chat_btn.png"), forState: UIControlState.Normal)
            self.btnChat.setBackgroundImage(UIImage(named: "chat_btn_clicked.png"), forState: UIControlState.Highlighted)
        
            self.btnMeetingPoint.setBackgroundImage(UIImage(named: "nevigation_btn"), forState: UIControlState.Normal)
            self.btnMeetingPoint.setBackgroundImage(UIImage(named: "nevigation_btn_clicked"), forState: UIControlState.Normal)
            
            self.btnChatLS.setBackgroundImage(UIImage(named: "chat_btn.png"), forState: UIControlState.Normal)
            self.btnChatLS.setBackgroundImage(UIImage(named: "chat_btn_clicked.png"), forState: UIControlState.Highlighted)
            
            self.btnMeetingPointLS.setBackgroundImage(UIImage(named: "nevigation_btn"), forState: UIControlState.Normal)
            self.btnMeetingPointLS.setBackgroundImage(UIImage(named: "nevigation_btn_clicked"), forState: UIControlState.Normal)
            if self.user?.waintingMessages > 0
            {
                self.imgIndicator.hidden = false
                self.lblIndicator.hidden = false
                
                self.imgIndicatorLS.hidden = false
                self.lblIndicatorLS.hidden = false
            }
            else
            {
                self.imgIndicator.hidden = true
                self.lblIndicator.hidden = true
                
                self.imgIndicatorLS.hidden = true
                self.lblIndicatorLS.hidden = true
            }
            
            self.lblNote.hidden = true
            self.lblNoteLS.hidden = true
        }
        
        //        self.lblIndicator.font = UIFont(name: "spacer", size: 14)
        self.lblIndicator.text = "\(ActiveUser.sharedInstace.waintingMessages)"
        self.lblIndicator.textColor = UIColor.whiteColor()
        self.lblIndicator.backgroundColor = UIColor.clearColor()
        self.lblIndicator.sizeToFit()
        
        self.lblIndicatorLS.text = "\(ActiveUser.sharedInstace.waintingMessages)"
        self.lblIndicatorLS.textColor = UIColor.whiteColor()
        self.lblIndicatorLS.backgroundColor = UIColor.clearColor()
        self.lblIndicatorLS.sizeToFit()

    }
    
    func setFramesByUser(){
        let spaceFromLeft = CGFloat(10)
        let indicatoreImgXFromChatBtnEnd = CGFloat(12)
        let barViewOfSuperView = CGFloat(44)

        
        if self.user!.iUserId == ActiveUser.sharedInstace.iUserId{
        }else{
        }
        self.CalculateLblIndicatoreFrame()
        if self.delegate != nil{
            self.delegate?.mainInfoDidChangeFrame()
        }
        
    }
    
    func CalculateLblIndicatoreFrame(){
        let indicatorImgRightSideH = CGFloat(12.5)
    }
    
    func startChat(sender: AnyObject) {
        if self.delegate != nil{
            if self.user != nil{
                self.delegate?.chatBtnDidClick(sender, user: self.user!)
            }else if self.meetingPoint != nil{
                self.delegate?.startChatWithGroup(self.meetingPoint!.iGroupId)
            }
            
        }
    }
    
    @IBAction func createMeetingPoint(sender: AnyObject) {
        if self.delegate != nil
        {
            if self.user != nil
            {
                if self.user == ActiveUser.sharedInstace
                {
                    self.delegate?.btnMettingPointDidClick(sender)
                }
                else
                {
                    self.delegate?.navigateToUser(self.user!.iUserId)
                }
            }
            else if self.meetingPoint != nil
            {
                self.delegate?.navigateToMeetingPoint(self.meetingPoint!.iMeetingPointId)
            }
        }
    }
    
    func moreAboutUser(sender: AnyObject){
        if self.delegate != nil{
            self.delegate?.btnMoreAboutFriend(self.user!)
        }
    }
    
    func setUserInfoViewNotificationIndicator(count: Int){
        if self.user == ActiveUser.sharedInstace{
            if count > 0{
                self.lblIndicator.text = "\(count)"
                self.lblIndicator.sizeToFit()
                self.lblIndicator.hidden = false
                self.imgIndicator.hidden = false
                
                self.lblIndicatorLS.text = "\(count)"
                self.lblIndicatorLS.sizeToFit()
                self.lblIndicatorLS.hidden = false
                self.imgIndicatorLS.hidden = false
                self.CalculateLblIndicatoreFrame()
            }else{
                self.lblIndicator.hidden = true
                self.imgIndicator.hidden = true
                
                self.lblIndicatorLS.hidden = true
                self.imgIndicatorLS.hidden = true
            }
        }else{
            self.lblIndicator.hidden = true
            self.imgIndicator.hidden = true
            
            self.lblIndicatorLS.hidden = true
            self.imgIndicatorLS.hidden = true

        }
        
    }
    
    func changeText(lbl: UILabel , text: String){
//        let spaceFromRight = CGFloat(10)
        switch lbl{
        case self.lblNote:
            self.lblNote.text = ""
            self.lblNote.text = text
//            self.lblNote.sizeToFit()
            self.lblNote.textAlignment = textAlignment
            
            if self.user == ActiveUser.sharedInstace{
                
            }else{
              
            }
            break
        default:
            break
        }
        
        switch lbl{
        case self.lblNoteLS:
            self.lblNoteLS.text = ""
            self.lblNoteLS.text = text
            //            self.lblNote.sizeToFit()
            self.lblNoteLS.textAlignment = textAlignment
            
            if self.user == ActiveUser.sharedInstace{
                
            }else{
                
            }
            break
        default:
            break
        }

    }
    
    func configByMeetingPoint(){
        
        if  self.meetingPoint?.iGroupId == -1{
            btnChat.hidden = true
            btnChatLS.hidden = true
        }else
        {
            btnChat.hidden = false
            btnChatLS.hidden = false

        }
        
        self.lblTitle.text = NSLocalizedString("Meeting of group", comment: "") as String/* "מפגש קבוצת"*/
        self.lblTitle.textColor = UIColor.greenHome()
        
        self.lblTime.hidden = false
        
        self.lblTitleLS.text = NSLocalizedString("Meeting of group", comment: "") as String/* "מפגש קבוצת"*/
        self.lblTitleLS.textColor = UIColor.greenHome()
        
        self.lblTimeLS.hidden = false

        var meetingHour = self.meetingPoint!.dtMeetingTime.substringWithRange(Range<String.Index>(start: advance(self.meetingPoint!.dtMeetingTime.endIndex, -8), end: advance(self.meetingPoint!.dtMeetingTime.endIndex,0)))
        meetingHour = meetingHour.substringWithRange(Range<String.Index>(start: advance(meetingHour.startIndex, 0), end: advance(meetingHour.endIndex,-3)))
        self.lblTime.text = meetingHour
        self.lblTime.textColor = UIColor.greenHome()
        
        self.lblTimeLS.text = meetingHour
        self.lblTimeLS.textColor = UIColor.greenHome()

        
        var diffWord1 = NSLocalizedString("Definition", comment: "") as String/*"הגדרה: "*/
        var text1 = NSMutableAttributedString(string: "\(diffWord1)\(self.meetingPoint!.nvTitle)")
        text1.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayDark(), range: NSMakeRange(0, count(diffWord1) - 1))
        text1.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayMedium(), range: NSMakeRange(count(diffWord1) ,count(self.meetingPoint!.nvTitle)))
        self.lblSubtitle.attributedText = text1
        self.lblSubtitle.numberOfLines = 0
        self.lblSubtitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        self.lblSubtitleLS.attributedText = text1
        self.lblSubtitleLS.numberOfLines = 0
        self.lblSubtitleLS.lineBreakMode = NSLineBreakMode.ByWordWrapping


        
        var diffWord2 = NSLocalizedString("Notes", comment: "") as String /*"הערות: "*/
        var text2 = NSMutableAttributedString(string: "\(diffWord2)\(self.meetingPoint!.nvComment)")
        text2.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayDark(), range: NSMakeRange(0, count(diffWord2) - 1))
        text2.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayMedium(), range: NSMakeRange(count(diffWord1) ,count(self.meetingPoint!.nvComment)))
        self.lblNote.attributedText = text2
        self.lblNote.hidden = false
        self.lblNote.numberOfLines = 0
        self.lblNote.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        self.lblNoteLS.attributedText = text2
        self.lblNoteLS.hidden = false
        self.lblNoteLS.numberOfLines = 0
        self.lblNoteLS.lineBreakMode = NSLineBreakMode.ByWordWrapping

        
        var arrivalTime = String()
        var diffWord3 = NSLocalizedString("ETA from your location:", comment: "") as String/* "זמן הגעה ממיקומך: "*/
        var text3 = NSMutableAttributedString(string: "\(diffWord3)\(arrivalTime)")
        text3.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayDark(), range: NSMakeRange(0, count(diffWord3) - 1))
        
        Connection.getArrivalTime(CLLocationCoordinate2DMake(ActiveUser.sharedInstace.oLocation.dLatitude, ActiveUser.sharedInstace.oLocation.dLongitude), dest: CLLocationCoordinate2DMake(self.meetingPoint!.oLocation.dLatitude,self.meetingPoint!.oLocation.dLongitude), completion: {
            data -> Void in
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("getArrivalTime:\(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            
            if json != nil{
                arrivalTime = self.parsGoogleArrivalTime(json!)
                diffWord3 = NSLocalizedString("ETA from your location:", comment: "") as String/* "זמן הגעה ממיקומך: "*/
                text3 = NSMutableAttributedString(string: "\(diffWord3)\(arrivalTime)")
                text3.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayDark(), range: NSMakeRange(0, count(diffWord3) - 1))
                
                text3.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayMedium(), range: NSMakeRange(count(diffWord3) ,count(arrivalTime)))
                self.lblAbout.attributedText = text3
                self.lblAbout.numberOfLines = 0
                self.lblAbout.lineBreakMode = NSLineBreakMode.ByWordWrapping
                self.lblAbout.hidden = false
                
                self.lblAboutLS.attributedText = text3
                self.lblAboutLS.numberOfLines = 0
                self.lblAboutLS.lineBreakMode = NSLineBreakMode.ByWordWrapping
                self.lblAboutLS.hidden = false
            }else{
                self.lblAbout.attributedText = text3
                self.lblAbout.numberOfLines = 0
                self.lblAbout.lineBreakMode = NSLineBreakMode.ByWordWrapping
                self.lblAbout.hidden = false
                
                self.lblAboutLS.attributedText = text3
                self.lblAboutLS.numberOfLines = 0
                self.lblAboutLS.lineBreakMode = NSLineBreakMode.ByWordWrapping
                self.lblAboutLS.hidden = false
            }
            self.setFramesByMeetingPoint()
        })
        
        self.lblAbout.attributedText = text3
        self.lblAbout.numberOfLines = 0
        self.lblAbout.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.lblAbout.hidden = false
        
        self.lblAboutLS.attributedText = text3
        self.lblAboutLS.numberOfLines = 0
        self.lblAboutLS.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.lblAboutLS.hidden = false

        
        self.btnChat.setBackgroundImage(UIImage(named: "chat_btn.png"), forState: UIControlState.Normal)
        self.btnChat.setBackgroundImage(UIImage(named: "chat_btn_clicked.png"), forState: UIControlState.Highlighted)
    
//        self.btnMeetingPoint.addTarget(MainPage(), action: "navigateToMeetingPoint:", forControlEvents: UIControlEvents.TouchUpInside)
        self.btnMeetingPoint.setBackgroundImage(UIImage(named: "nevigation_btn"), forState: UIControlState.Normal)
        self.btnMeetingPoint.setBackgroundImage(UIImage(named: "nevigation_btn_clicked"), forState: UIControlState.Highlighted)
        self.btnMoreInfo.hidden = true
        
        self.btnChatLS.setBackgroundImage(UIImage(named: "chat_btn.png"), forState: UIControlState.Normal)
        self.btnChatLS.setBackgroundImage(UIImage(named: "chat_btn_clicked.png"), forState: UIControlState.Highlighted)
        
        //        self.btnMeetingPointLS.addTarget(MainPage(), action: "navigateToMeetingPoint:", forControlEvents: UIControlEvents.TouchUpInside)
        self.btnMeetingPointLS.setBackgroundImage(UIImage(named: "nevigation_btn"), forState: UIControlState.Normal)
        self.btnMeetingPointLS.setBackgroundImage(UIImage(named: "nevigation_btn_clicked"), forState: UIControlState.Highlighted)
        self.btnMoreInfoLS.hidden = true
    }
    
    func setFramesByMeetingPoint(){
        let spaceFromLeft = CGFloat(10)
        let indicatoreImgXFromChatBtnEnd = CGFloat(12)
        let barViewOfSuperView = CGFloat(44)
        let spaceFromRight = CGFloat(17)
        let spaceBetweenBtnsToLbls = CGFloat(29)
        let spaceBetweenTitleToLbls = CGFloat(14)
        let spaceBetweenLbls = CGFloat(5)
     
        if self.delegate != nil{
            self.delegate?.mainInfoDidChangeFrame()
        }
    }
//    func navigateToMeetingPoint(iMeetingPointId: Int) {
//        if let marker = self.meetingPointsMarkers.objectForKey(String("\(iMeetingPointId)")) as? MeetingPointMarker{
//            self.addGoogleRout(marker.position)
//        }
//    }
//    
//    func addGoogleRout(pointLocation: CLLocationCoordinate2D){
//        Connection.calculateRoutes(CLLocationCoordinate2D(latitude: ActiveUser.sharedInstace.oLocation.dLatitude, longitude: ActiveUser.sharedInstace.oLocation.dLongitude), t: pointLocation, completion: {
//            data -> Void in
//            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
//            println("calculateRoutes:\(strData)")
//            var err: NSError?
//            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
//            if json != nil{
////                self.parsGoogleRoutSteps(json!)
//            }
//            
//        })
//        
//    }
    
    func parsGoogleArrivalTime(googlDict: NSDictionary) -> String{
        println("googlDict:\(googlDict)")
        var arrivalTime = String()
        if let routs = googlDict["routes"] as? NSArray{
            if routs.count != 0
            {
            if let firstRout = routs.objectAtIndex(0) as? NSDictionary
            {
                if let legs = firstRout.valueForKey("legs") as? NSArray
                {
                    if let firstLeg = legs.objectAtIndex(0) as? NSDictionary
                    {
                        if let duration = firstLeg.valueForKey("duration") as? NSDictionary
                        {
                            if let text = duration.valueForKey("text") as? String
                            {
                                arrivalTime = text
                            }
                        }
                    }
                }
            }
            }
        }
        
        return arrivalTime
    }
}

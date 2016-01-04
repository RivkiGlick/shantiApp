//
//  AttachmentTableViewCell.swift
//  Shanti
//
//  Created by hodaya ohana on 6/8/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit
protocol AttachmentTableViewCellDelegate
{
    func deleteMsgAttachment(message:QBChatAbstractMessage!)
}
class AttachmentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblMsgDetails: UILabel!
    @IBOutlet weak var viewMsg: UIView!
    @IBOutlet weak var imgMsgBg: UIImageView!
    @IBOutlet weak var imgContent: UIImageView!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var progressView: UCZProgressView!
    @IBOutlet var btnDeleteMessage: UIButton!
    
    var messageDateFormatter = NSDateFormatter()
    var activeUserBubble: UIImage!
    var otherUsersBubble: UIImage!
    var activeUser = false
    var tableViewWidth: CGFloat!
    let padding = CGFloat(20.0)
    let cellFont = UIFont(name: "spacer", size: 15)!
    var imageUserPath = NSString()
    
    //
    var del:AttachmentTableViewCellDelegate!
    var currentMessage:QBChatAbstractMessage!
    //
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setSubviewsConfig()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setSubviewsConfig(){
        messageDateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        messageDateFormatter.timeZone = NSTimeZone(name: "...")
        
        activeUserBubble = UIImage(named: "whiteBuble")?.stretchableImageWithLeftCapWidth(24, topCapHeight: 15)
        otherUsersBubble = UIImage(named: "pinkBuble")?.stretchableImageWithLeftCapWidth(24, topCapHeight: 15)
        
        self.viewMsg.backgroundColor = UIColor.clearColor()
        self.lblMsgDetails.font = cellFont
        
        self.viewMsg.backgroundColor = UIColor.clearColor()
        
        self.progressView.hidden = true
        self.progressView.progress = 0.0
        self.progressView.textLabel.backgroundColor = UIColor.clearColor()
        self.progressView.showsText = true
        //        self.progressView.blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        //        self.progressView.backgroundColor = UIColor.clearColor()
        self.progressView.backgroundView.backgroundColor = UIColor.clearColor()//nil
        self.progressView.tintColor = UIColor.blackColor()
    }
    
    func configureCellWithMessage(message: QBChatAbstractMessage, senderName: String) -> Void{
        self.currentMessage = message
        var textSize: CGSize = CGSizeMake(100, 100.0)
        var size: CGSize = ChatTableViewCell.frameForText("", sizeWithFont: cellFont, constrainedToSize: textSize, AndlineBreakMode: NSLineBreakMode.ByWordWrapping)
        size.width += 10
        
        var time: NSString = messageDateFormatter.stringFromDate(message.datetime)
        let userImageSize = CGFloat(50.0)
        // left bubble
        if ActiveUser.sharedInstace.oUserQuickBlox.ID == Int(message.senderID){
            self.lblMsgDetails.textAlignment = NSTextAlignment.Left
            self.lblMsgDetails.text = ActiveUser.sharedInstace.nvShantiName + "," + (time as String)//ActiveUser.sharedInstace.nvFirstName + " " + ActiveUser.sharedInstace.nvLastName + "," + time
            self.lblMsgDetails.sizeToFit()
            self.lblMsgDetails.frame = CGRectMake(15, 0, self.lblMsgDetails.frame.size.width, self.lblMsgDetails.frame.size.height)
            
            self.imgUserProfile.frame = CGRectMake(padding/2, self.lblMsgDetails.frame.origin.y + self.lblMsgDetails.frame.size.height + 5.0, userImageSize, userImageSize)
            
            self.viewMsg.frame = CGRectMake(self.imgUserProfile.frame.origin.x + self.imgUserProfile.frame.size.width + padding/2, self.imgUserProfile.frame.origin.y, textSize.width, textSize.height)
            self.btnDeleteMessage.frame = CGRectMake(self.viewMsg.frame.size.width + self.viewMsg.frame.origin.x + 10 , self.viewMsg.frame.origin.y , self.btnDeleteMessage.frame.size.width, self.btnDeleteMessage.frame.size.height)
            self.imgMsgBg.image = activeUserBubble
        }else{
            // right bubble
            self.lblMsgDetails.textAlignment = NSTextAlignment.Right
            self.lblMsgDetails.text = "\(senderName),\(time)"
            self.lblMsgDetails.sizeToFit()
            self.lblMsgDetails.frame = CGRectMake(tableViewWidth - self.lblMsgDetails.frame.size.width - 15, 0, self.lblMsgDetails.frame.size.width, self.lblMsgDetails.frame.size.height)
            
            self.imgUserProfile.frame = CGRectMake(tableViewWidth - padding/2 - userImageSize, self.lblMsgDetails.frame.origin.y + self.lblMsgDetails.frame.size.height + 5.0, userImageSize, userImageSize)
            
            self.viewMsg.frame = CGRectMake(self.imgUserProfile.frame.origin.x - padding/2 - (textSize.width), self.imgUserProfile.frame.origin.y, textSize.width, textSize.height)
            
            self.btnDeleteMessage.frame = CGRectMake(self.viewMsg.frame.origin.x - self.viewMsg.frame.size.width  , self.viewMsg.frame.origin.y , self.btnDeleteMessage.frame.size.width, self.btnDeleteMessage.frame.size.height)
            
            self.imgMsgBg.image = otherUsersBubble
        }
        
        self.imgMsgBg.frame = CGRectMake(0, 0, self.viewMsg.frame.size.width, self.viewMsg.frame.size.height)
        
        if ActiveUser.sharedInstace.oUserQuickBlox.ID == Int(message.senderID)
        {
            self.imgContent.frame = CGRectMake(self.imgMsgBg.frame.origin.x + 20, self.imgMsgBg.frame.origin.y + 10, self.imgMsgBg.frame.size.width - 30, self.imgMsgBg.frame.size.height - 20)
            self.btnDownload.center = self.imgContent.center
        }
        else
        {
            self.imgContent.frame = CGRectMake(self.imgMsgBg.frame.origin.x + 10, self.imgMsgBg.frame.origin.y + 10, self.imgMsgBg.frame.size.width - 20, self.imgMsgBg.frame.size.height - 20)
            self.btnDownload.hidden = false
            self.btnDownload.setTitle("", forState: UIControlState.Normal)
            self.btnDownload.setTitle("", forState: UIControlState.Highlighted)
            self.btnDownload.setBackgroundImage(UIImage(named: "download_btn"), forState: UIControlState.Normal)
            self.btnDownload.setBackgroundImage(UIImage(named: "download_btn_clicked"), forState: UIControlState.Highlighted)
            var imgSize = CGSizeMake(btnDownload.backgroundImageForState(UIControlState.Normal)!.size.width/2, btnDownload.backgroundImageForState(UIControlState.Normal)!.size.height/2)
            btnDownload.frame = CGRectMake((self.imgContent.frame.size.width - imgSize.width)/2, (self.imgContent.frame.size.height - imgSize.height)/2, imgSize.width, imgSize.height)
            self.btnDownload.center = self.imgContent.center
        }
        self.progressView.frame = self.btnDownload.frame
        self.progressView.center = self.imgContent.center
    }
    
    @IBAction func deleteMsgClick(sender: AnyObject)
    {
        if del != nil
        {
            del.deleteMsgAttachment(self.currentMessage)
        }
    }
    
    
}

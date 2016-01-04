//
//  ChatTableViewCell.swift
//  Shanti
//
//  Created by hodaya ohana on 3/10/15.
//  Copyright (c) 2015 webit. All rights reserved.
//
protocol chatDelegatee
{
    func deleteMsg(message:QBChatAbstractMessage!)
}
import UIKit


private let heCellFont = UIFont(name: "spacer", size: 15)!
private let cellFont = UIFont(name: "Roboto-Regular", size: 15)!


class ChatTableViewCell: UITableViewCell{
    
    @IBOutlet var btnDeleteMsg: UIButton!
    
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblMsgDetails: UILabel!
    @IBOutlet weak var viewMsg: UIView!
    @IBOutlet weak var imgMsgBg: UIImageView!
    
    @IBOutlet weak var txtMsg: UITextView!
    
    var messageDateFormatter = NSDateFormatter()
    var activeUserBubble: UIImage!
    var otherUsersBubble: UIImage!
    
    var tableViewWidth: CGFloat!
    let padding = CGFloat(20.0)
    var del:chatDelegatee!
    var currentMessage:QBChatAbstractMessage!
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
        self.lblMsgDetails.font = heCellFont
        self.txtMsg.font = heCellFont
        self.txtMsg.textAlignment = NSTextAlignment.Right
        self.txtMsg.backgroundColor = UIColor.clearColor()
        self.txtMsg.editable = false
        self.txtMsg.scrollEnabled = false
        self.txtMsg.sizeToFit()
        
        self.viewMsg.backgroundColor = UIColor.clearColor()
        
        
    }
    
    class func heightForCellWithMessage(message: QBChatAbstractMessage) -> CGFloat{
        if message.attachments != nil && message.attachments.count > 0{
            
            return 200
        }else{
            let text: String = message.text != nil ? message.text : ""
            var textSize: CGSize = CGSizeMake(200.0, 10000.0)
            var font = ChatTableViewCell.getFontForText(message.text)
            var size: CGSize = ChatTableViewCell.frameForText(text, sizeWithFont: /*ChatTableViewCell.getFontForText(text)*/heCellFont, constrainedToSize: textSize, AndlineBreakMode: NSLineBreakMode.ByWordWrapping)
            size.height += 70//45.0
            
            return size.height
        }
    }
    
    func configureCellWithMessage(message: QBChatAbstractMessage, senderName: String) -> Void{
        if message.attachments != nil && message.attachments.count > 0{
            self.currentMessage = message
            self.txtMsg.hidden = true
            
            self.txtMsg.text = message.text
            
            var textSize: CGSize = CGSizeMake(100, 100.0)
            
            var font = ChatTableViewCell.getFontForText(message.text)
            var size: CGSize = ChatTableViewCell.frameForText(self.txtMsg.text, sizeWithFont: /*ChatTableViewCell.getFontForText(self.txtMsg.text)*/heCellFont, constrainedToSize: textSize, AndlineBreakMode: NSLineBreakMode.ByWordWrapping)
            size.width += 10
            
            var time: NSString = messageDateFormatter.stringFromDate(message.datetime)
            let userImageSize = CGFloat(50.0)
            // left bubble
            if ActiveUser.sharedInstace.oUserQuickBlox.ID == Int(message.senderID){
                self.lblMsgDetails.textAlignment = NSTextAlignment.Left
                self.lblMsgDetails.text = ActiveUser.sharedInstace.nvShantiName + "," + (time as! String)//ActiveUser.sharedInstace.nvFirstName + " " + ActiveUser.sharedInstace.nvLastName + "," + time
                self.lblMsgDetails.sizeToFit()
                self.lblMsgDetails.frame = CGRectMake(15, 0, self.lblMsgDetails.frame.size.width, self.lblMsgDetails.frame.size.height)
                
                self.imgUserProfile.frame = CGRectMake(padding/2, self.lblMsgDetails.frame.origin.y + self.lblMsgDetails.frame.size.height + 5.0, userImageSize, userImageSize)
                
                self.viewMsg.frame = CGRectMake(self.imgUserProfile.frame.origin.x + self.imgUserProfile.frame.size.width + padding/2, self.imgUserProfile.frame.origin.y, textSize.width, textSize.height)
                self.imgMsgBg.image = activeUserBubble
            }else{
                // right bubble
                self.lblMsgDetails.textAlignment = NSTextAlignment.Right
                self.lblMsgDetails.text = "\(senderName),\(time)"
                self.lblMsgDetails.sizeToFit()
                self.lblMsgDetails.frame = CGRectMake(tableViewWidth - self.lblMsgDetails.frame.size.width - 15, 0, self.lblMsgDetails.frame.size.width, self.lblMsgDetails.frame.size.height)
                
                self.imgUserProfile.frame = CGRectMake(tableViewWidth - padding/2 - userImageSize, self.lblMsgDetails.frame.origin.y + self.lblMsgDetails.frame.size.height + 5.0, userImageSize, userImageSize)
                
                self.viewMsg.frame = CGRectMake(self.imgUserProfile.frame.origin.x - padding/2 - (textSize.width), self.imgUserProfile.frame.origin.y, textSize.width, textSize.height)
                self.imgMsgBg.image = otherUsersBubble
            }
            
            self.imgMsgBg.frame = CGRectMake(0, 0, self.viewMsg.frame.size.width, self.viewMsg.frame.size.height)
            
            self.txtMsg.frame = CGRectMake(self.imgMsgBg.frame.origin.x + padding/2, self.imgMsgBg.frame.origin.y, size.width, size.height)
            self.txtMsg.sizeToFit()
        }else{
            self.txtMsg.hidden = false
            self.txtMsg.text = message.text
            self.currentMessage = message
            var textSize: CGSize = CGSizeMake(200.0, 10000.0)
            var size: CGSize = ChatTableViewCell.frameForText(self.txtMsg.text, sizeWithFont: /*ChatTableViewCell.getFontForText(message.text)*/heCellFont, constrainedToSize: textSize, AndlineBreakMode: NSLineBreakMode.ByWordWrapping)
            size.width += 10
            
            var time: NSString = messageDateFormatter.stringFromDate(message.datetime)
            let userImageSize = CGFloat(50.0)
            // left bubble
            if ActiveUser.sharedInstace.oUserQuickBlox.ID == Int(message.senderID){
                self.lblMsgDetails.textAlignment = NSTextAlignment.Left
                self.lblMsgDetails.text = ActiveUser.sharedInstace.nvShantiName + "," + (time as! String)//ActiveUser.sharedInstace.nvFirstName + " " + ActiveUser.sharedInstace.nvLastName + "," + time
                self.lblMsgDetails.sizeToFit()
                self.lblMsgDetails.frame = CGRectMake(15, 0, self.lblMsgDetails.frame.size.width, self.lblMsgDetails.frame.size.height)
                
                self.imgUserProfile.frame = CGRectMake(padding/2, self.lblMsgDetails.frame.origin.y + self.lblMsgDetails.frame.size.height + 5.0, userImageSize, userImageSize)
                
                self.viewMsg.frame = CGRectMake(self.imgUserProfile.frame.origin.x + self.imgUserProfile.frame.size.width + padding/2, self.imgUserProfile.frame.origin.y, size.width + padding, size.height + padding)
                self.imgMsgBg.image = activeUserBubble
                
                self.btnDeleteMsg.frame = CGRectMake(self.viewMsg.frame.size.width + self.viewMsg.frame.origin.x + 10, self.imgMsgBg.frame.origin.y + self.lblMsgDetails.frame.size.height + 5  , self.btnDeleteMsg.frame.size.width, self.btnDeleteMsg.frame.size.height)
            }else{
                // right bubble
                self.lblMsgDetails.textAlignment = NSTextAlignment.Right
                self.lblMsgDetails.text = "\(senderName),\(time)"
                self.lblMsgDetails.sizeToFit()
                self.lblMsgDetails.frame = CGRectMake(tableViewWidth - self.lblMsgDetails.frame.size.width - 15, 0, self.lblMsgDetails.frame.size.width, self.lblMsgDetails.frame.size.height)
                
                self.imgUserProfile.frame = CGRectMake(tableViewWidth - padding/2 - userImageSize, self.lblMsgDetails.frame.origin.y + self.lblMsgDetails.frame.size.height + 5.0, userImageSize, userImageSize)
                
                self.viewMsg.frame = CGRectMake(self.imgUserProfile.frame.origin.x - padding/2 - (size.width + padding), self.imgUserProfile.frame.origin.y, size.width + padding, size.height + padding)
                self.imgMsgBg.image = otherUsersBubble
                
                self.btnDeleteMsg.frame = CGRectMake(self.imgUserProfile.frame.origin.x - padding/2 - (size.width + padding) - 30 , self.imgUserProfile.frame.origin.y  , self.btnDeleteMsg.frame.size.width, self.btnDeleteMsg.frame.size.height)
                
            }
            
            self.imgMsgBg.frame = CGRectMake(0, 0, self.viewMsg.frame.size.width, self.viewMsg.frame.size.height)
            
            self.txtMsg.frame = CGRectMake(self.imgMsgBg.frame.origin.x + padding/2, self.imgMsgBg.frame.origin.y, size.width, size.height)
            self.txtMsg.sizeToFit()
            
            
            
        }
        
        if self.txtMsg.text != nil && self.txtMsg.text != ""{
            self.txtMsg.font = heCellFont//ChatTableViewCell.getFontForText(self.txtMsg.text as! NSString)
        }
        
    }
    
    class func frameForText(text: String, sizeWithFont font: UIFont, constrainedToSize size: CGSize, AndlineBreakMode lineBreakMode: NSLineBreakMode) -> CGSize{
        var paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = lineBreakMode
        var attributes = [NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle]
        var options = unsafeBitCast(NSStringDrawingOptions.UsesLineFragmentOrigin.rawValue |
            NSStringDrawingOptions.UsesFontLeading.rawValue,
            NSStringDrawingOptions.self)
        var textRect = (text as NSString).boundingRectWithSize(size, options:options, attributes: attributes, context: nil)
        
        var newSize: CGSize
        if textRect.size.width > size.width{
            newSize = ChatTableViewCell.resize(size, fromSize: textRect.size, withFont: font)
        }else{
            newSize = CGSizeMake(textRect.width, textRect.height)
        }
        
        return newSize//textRect.size
    }
    
    class func resize(toSize: CGSize, fromSize: CGSize, withFont: UIFont) -> CGSize{
        var newSize = fromSize
        if fromSize.width > toSize.width{
            var difference = fromSize.width - toSize.width
            var linesToAdd = (difference/toSize.width) + 1
            var text = "LKZW"
            var size = (text as String).sizeWithAttributes([NSFontAttributeName: withFont])
            newSize = CGSizeMake(toSize.width, fromSize.height + (linesToAdd * size.height))
        }
        
        return newSize
    }
    
    class func getFontForText(text: String)-> UIFont
    {
        var language: String? = ChatMessageTableViewCell.getFontNameWithText((text as String))
        var fontName = UIFont()
        if language != nil{
            if language == "he"{
                fontName = heCellFont
            }else if language == "en"{
                fontName = cellFont
            }else{
                fontName = cellFont
            }
        }else{
            fontName = cellFont
        }
        
        
        return fontName
    }
    
    @IBAction func deleteMsgClick(sender: AnyObject)
    {
        if del != nil
        {
            print(self.currentMessage)
            del.deleteMsg(self.currentMessage)
        }
    }
}

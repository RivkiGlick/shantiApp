//
//  PriveteChatCell.swift
//  Shanti
//
//  Created by hodaya ohana on 3/18/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit
protocol PriveteChatCellDelegate
{
    func deleteMsg(message:QBChatAbstractMessage!)
}
class PriveteChatCell: UITableViewCell {
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblMsgText: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet var btnDelete: UIButton!
    let msgLblW = CGFloat(195.0)
    let msgLblH = CGFloat(43.0)
    
    
    //
    var del:PriveteChatCellDelegate!
    var currentMessage:QBChatAbstractMessage!
    //
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setSubviewsConfig()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setSubviewsConfig(){
        self.lblDate.text = ""
        self.lblDate.textColor = UIColor.grayMedium()
        self.lblDate.backgroundColor = UIColor.clearColor()
        self.lblDate.textAlignment = NSTextAlignment.Left
        self.lblDate.font = UIFont(name: "spacer", size: 15.0)
        
        self.lblMsgText.text = ""
        self.lblMsgText.textColor = UIColor.grayMedium()
        self.lblMsgText.backgroundColor = UIColor.clearColor()
        self.lblMsgText.textAlignment = NSTextAlignment.Right
        self.lblMsgText.font = UIFont(name: "spacer", size: 17.0)
        self.lblMsgText.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.lblMsgText.numberOfLines = 0
        
        self.lblUserName.text = ""
        self.lblUserName.textColor = UIColor.grayDark()
        self.lblUserName.backgroundColor = UIColor.clearColor()
        self.lblUserName.textAlignment = NSTextAlignment.Right
        self.lblUserName.font = UIFont(name: "spacer", size: 17.0)
        
        self.imgUserProfile.contentMode = UIViewContentMode.ScaleAspectFill
        self.imgUserProfile.clipsToBounds = true
        self.imgUserProfile.layer.cornerRadius = 9.0
        self.imgUserProfile.layer.borderWidth = 1.5
        self.imgUserProfile.layer.borderColor = UIColor.grayMedium().CGColor
    }
    
    func setSubviewsFrame(){
        let imgSize = CGFloat(55.0)
        let spaceFromLeftOfScreen = CGFloat(20.0)
        let spaceFromTopOfScreen = CGFloat(15.0)
        let spaceFromRightOfScreen = CGFloat(15.0)
        let spaceBetweenLbls = CGFloat(3.0)
        
        self.lblDate.frame = CGRectMake(spaceFromLeftOfScreen,spaceFromTopOfScreen,self.lblDate.frame.size.width,self.lblDate.frame.size.height)
        self.imgUserProfile.frame = CGRectMake(self.frame.size.width - imgSize - spaceFromRightOfScreen, self.lblDate.frame.origin.y + self.lblDate.frame.size.height, imgSize, imgSize)
        self.lblUserName.frame = CGRectMake(self.imgUserProfile.frame.origin.x - self.lblUserName.frame.size.width - spaceBetweenLbls, self.imgUserProfile.frame.origin.y, self.lblUserName.frame.size.width, self.lblUserName.frame.size.height)
        self.lblMsgText.frame = CGRectMake(self.imgUserProfile.frame.origin.x - msgLblW - spaceBetweenLbls, self.lblUserName.frame.origin.y + self.lblUserName.frame.size.height + spaceBetweenLbls, msgLblW, msgLblH)
    }
    
    @IBAction func deleteMsgClick(sender: AnyObject) {
     if self.currentMessage != nil
     {
        del.deleteMsg(self.currentMessage)
        }
    
    }
}

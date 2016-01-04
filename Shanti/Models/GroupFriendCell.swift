//
//  GroupFriendCell.swift
//  Shanti
//
//  Created by hodaya ohana on 6/21/15.
//  Copyright (c) 2015 webit. All rights reserved.
//NSLocalizedString("", comment: "") as String /*

import UIKit

class GroupFriendCell: UITableViewCell {
    
    @IBOutlet var lblSeparator: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserAddress: UILabel!
    @IBOutlet weak var lblUserInfo: UILabel!
    @IBOutlet weak var btnDeletefriend: UIButton!
    
    let imgR = CGFloat(14)
    let imgBorderW = CGFloat(1)
    let line1TitlesSize = CGFloat(16.5)
    let line2TitlesSize = CGFloat(12)
    let languageId = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) as! String
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setSubviewsConfig()
        //self.setDesign()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setSubviewsConfig(){
        
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        
        self.imgProfile.contentMode = UIViewContentMode.ScaleAspectFill
        self.imgProfile.clipsToBounds = true
        self.imgProfile.layer.borderColor = UIColor.greenHome().CGColor
        self.imgProfile.layer.borderWidth = imgBorderW
        self.imgProfile.layer.cornerRadius = imgR
        
        //        self.lblUserName.backgroundColor = UIColor.clearColor()
        self.lblUserName.textColor = UIColor.grayDark()
        //        self.lblUserName.font = UIFont(name: "spacer", size: line1TitlesSize)
        //        self.lblUserName.sizeToFit()
        
        //        self.lblUserAddress.backgroundColor = UIColor.clearColor()
        self.lblUserAddress.textColor = UIColor.grayMedium()
        //        self.lblUserAddress.font = UIFont(name: "spacer", size: line1TitlesSize)
        //        self.lblUserAddress.sizeToFit()
        
        //        self.lblUserInfo.backgroundColor = UIColor.clearColor()
        self.lblUserInfo.textColor = UIColor.grayMedium()
        //        self.lblUserInfo.font = UIFont(name: "spacer", size: line2TitlesSize)
        //        self.lblUserInfo.sizeToFit()
        
        self.btnDeletefriend.setTitle(NSLocalizedString("Delete", comment: "") as String /*"מחק"*/, forState: UIControlState.Normal)
        self.btnDeletefriend.setTitle(NSLocalizedString("Delete", comment: "") as String /*"מחק"*/, forState: UIControlState.Highlighted)
        self.btnDeletefriend.setTitleColor(UIColor.grayMedium(), forState: UIControlState.Normal)
        self.btnDeletefriend.setTitleColor(UIColor.grayMedium(), forState: UIControlState.Highlighted)
        self.btnDeletefriend.backgroundColor = UIColor.clearColor()
        //        self.btnDeletefriend.titleLabel?.font = UIFont(name: "spacer", size: line1TitlesSize)
        
        self.backgroundColor = UIColor.clearColor()
    }
    
    func setSubviewsFrame(){
        self.lblUserName.sizeToFit()
        self.lblUserInfo.sizeToFit()
        self.lblUserAddress.sizeToFit()
        self.btnDeletefriend.sizeToFit()
        self.lblSeparator.sizeToFit()
        
        let imgS = CGFloat(37.5)
        let lblUserNameY = CGFloat(12)
        let spaceFromeLeft = CGFloat(5)
        let spaceFromeRight = CGFloat(15)
        let spaceBetweenLblToImg = CGFloat(9)
        let spaceBetweenImgToRight = CGFloat(14)
        let spaceBetweenLblsLine = CGFloat(3)
        
        if languageId == "he"
        {
            imgProfile.frame = CGRectMake(self.frame.size.width - imgS - spaceBetweenImgToRight, 0, imgS, imgS)
            self.lblUserName.frame = CGRectMake(imgProfile.frame.origin.x - self.lblUserName.frame.size.width - spaceBetweenLblToImg, lblUserNameY, self.lblUserName.frame.size.width, self.lblUserName.frame.size.height)
            self.lblSeparator.frame = CGRectMake(lblUserName.frame.origin.x - self.lblSeparator.frame.size.width , lblUserNameY, self.lblSeparator.frame.size.width, self.lblSeparator.frame.size.height)
            self.lblUserAddress.frame = CGRectMake(self.lblSeparator.frame.origin.x - self.lblUserAddress.frame.size.width, self.lblUserName.frame.origin.y, self.lblUserAddress.frame.size.width, self.lblUserAddress.frame.size.height)
            self.btnDeletefriend.frame = CGRectMake(self.lblSeparator.frame.origin.x - self.lblUserAddress.frame.size.width - 3, self.lblUserAddress.frame.origin.y, self.btnDeletefriend.frame.size.width, self.btnDeletefriend.frame.size.height)
            self.lblUserInfo.frame = CGRectMake(imgProfile.frame.origin.x - self.lblUserInfo.frame.size.width - spaceBetweenLblToImg, self.lblUserName.frame.origin.y + self.lblUserName.frame.size.height + spaceBetweenLblsLine, self.lblUserInfo.frame.size.width, self.lblUserInfo.frame.size.height)
            
        }
        else{
            //  imgProfile.frame = CGRectMake(self.frame.size.width - imgS - spaceBetweenImgToRight, 0, imgS, imgS)
            self.lblUserName.frame = CGRectMake(imgProfile.frame.origin.x + imgProfile.frame.size.width + 3  , lblUserNameY, self.lblUserName.frame.size.width, self.lblUserName.frame.size.height)
            self.lblSeparator.frame = CGRectMake(self.lblUserName.frame.origin.x + self.lblUserName.frame.size.width , self.lblUserName.frame.origin.y, self.lblSeparator.frame.size.width, self.lblSeparator.frame.size.height)
            
            self.lblUserAddress.frame = CGRectMake(self.lblSeparator.frame.origin.x + self.lblSeparator.frame.size.width  , self.lblUserName.frame.origin.y, self.lblUserAddress.frame.size.width, self.lblUserAddress.frame.size.height)
            
            self.btnDeletefriend.frame = CGRectMake(self.lblSeparator.frame.origin.x + self.lblUserAddress.frame.size.width + 3, self.lblUserAddress.frame.origin.y, self.btnDeletefriend.frame.size.width, self.btnDeletefriend.frame.size.height)
            self.lblUserInfo.frame = CGRectMake(lblUserName.frame.origin.x
                , self.lblUserName.frame.origin.y + self.lblUserName.frame.size.height + spaceBetweenLblsLine, self.lblUserInfo.frame.size.width, self.lblUserInfo.frame.size.height)
        }
    }
    
    //    func setDesign(){
    //        //textAlignment
    //        var textAlignment: NSTextAlignment = .Left
    //
    //        if languageId == "he"{
    //            textAlignment = .Right
    //        }
    //
    //        lblUserAddress.textAlignment = textAlignment
    //        lblUserInfo.textAlignment = textAlignment
    //        lblUserName.textAlignment = textAlignment
    //        
    //    }
    
}

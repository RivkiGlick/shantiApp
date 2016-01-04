//
//  PendingGroupsTableViewCell.swift
//  Shanti
//
//  Created by hodaya ohana on 3/12/15.
//  Copyright (c) 2015 webit. All rights reserved.
// NSLocalizedString("", comment: "") as String /*

import UIKit

class PendingGroupsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgGroupProfile: UIImageView!
    @IBOutlet weak var lblGroupName: UILabel!
    @IBOutlet weak var lblRequestTitle: UILabel!
    @IBOutlet weak var lblRequestDate: UILabel!
    @IBOutlet weak var btnApproveGroup: UIButton!
    @IBOutlet weak var btnRejectGroup: UIButton!
    @IBOutlet weak var btnPanProfile: UIButton!
    @IBOutlet weak var lblSeperator: UILabel!
    @IBOutlet weak var lblDownSeperator: UILabel!
    
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
        self.imgGroupProfile.layer.cornerRadius = 14
        self.imgGroupProfile.layer.borderWidth = 1
        self.imgGroupProfile.layer.borderColor = UIColor.grayMedium().CGColor
        self.imgGroupProfile.contentMode = UIViewContentMode.ScaleAspectFill
        self.imgGroupProfile.clipsToBounds = true
        
        self.lblGroupName.text = ""
        self.lblGroupName.textAlignment = NSTextAlignment.Right
        self.lblGroupName.font = UIFont(name: "spacer", size: 15)
        self.lblGroupName.textColor = UIColor.grayDark()
        self.lblGroupName.sizeToFit()
        
        self.lblRequestTitle.text = NSLocalizedString("Asking you to join the group", comment: "") as String /*"מבקשת לצרף אותך לקבוצה"*/
        self.lblRequestTitle.textAlignment = NSTextAlignment.Right
        self.lblRequestTitle.font = UIFont(name: "spacer", size: 15)
        self.lblRequestTitle.textColor = UIColor.grayDark()
        self.lblRequestTitle.sizeToFit()
        
        self.lblRequestDate.text = ""
        self.lblRequestDate.textAlignment = NSTextAlignment.Right
        self.lblRequestDate.font = UIFont(name: "spacer", size: 10)
        self.lblRequestDate.textColor = UIColor.grayMedium()
        self.lblRequestDate.sizeToFit()
        
        self.btnRejectGroup.backgroundColor = UIColor.clearColor()
        self.btnRejectGroup.titleLabel?.font = UIFont(name: "spacer", size: 17)
        self.btnRejectGroup.setTitle(NSLocalizedString("Reject", comment: "") as String /*"דחה"*/, forState: UIControlState.Normal)
        self.btnRejectGroup.setTitle(NSLocalizedString("Reject", comment: "") as String /*"דחה"*/, forState: UIControlState.Highlighted)
        self.btnRejectGroup.setTitleColor(UIColor.grayMedium(), forState: UIControlState.Normal)
        self.btnRejectGroup.setTitleColor(UIColor.grayDark(), forState: UIControlState.Highlighted)
        self.btnRejectGroup.layer.cornerRadius = 1.5
        self.btnRejectGroup.sizeToFit()
        
        self.lblSeperator.text = "|"
        self.lblSeperator.textColor = UIColor.grayMedium()
        self.lblSeperator.backgroundColor = UIColor.grayMedium()
        self.lblSeperator.textAlignment = NSTextAlignment.Right
        self.lblSeperator.font = UIFont(name: "spacer", size: 22)
        self.lblSeperator.sizeToFit()
        
        self.btnApproveGroup.backgroundColor = UIColor.clearColor()
        self.btnApproveGroup.titleLabel?.font = UIFont(name: "spacer", size: 17)
        self.btnApproveGroup.setTitle(NSLocalizedString("Confirm", comment: "") as String /*"אשר"*/, forState: UIControlState.Normal)
        self.btnApproveGroup.setTitle(NSLocalizedString("Confirm", comment: "") as String /*"אשר"*/, forState: UIControlState.Highlighted)
        self.btnApproveGroup.setTitleColor(UIColor.purpleHome(), forState: UIControlState.Normal)
        self.btnApproveGroup.setTitleColor(UIColor.purpleHome(), forState: UIControlState.Highlighted)
        self.btnApproveGroup.layer.cornerRadius = 1.5
        self.btnApproveGroup.sizeToFit()
        
        self.btnPanProfile.backgroundColor = UIColor.clearColor()
        self.btnPanProfile.setTitleColor(UIColor.grayMedium(), forState: UIControlState.Normal)
        self.btnPanProfile.setTitleColor(UIColor.greenHome(), forState: UIControlState.Highlighted)
        self.btnPanProfile.setTitle("...", forState: UIControlState.Normal)
        self.btnPanProfile.setTitle("...", forState: UIControlState.Highlighted)
        self.btnPanProfile.sizeToFit()
        
        self.lblDownSeperator.text = ""
        self.lblDownSeperator.backgroundColor = UIColor.grayDark()
    }
    
    func setSubviewsFrames(){
        let spaceFromTopOfCell = CGFloat(15.0)
        let spaceFromRightOfCell = CGFloat(11.0)
        let spaceFromLeftOfCell = CGFloat(25.0)
        let spaceBetweenLbls = CGFloat(3.0)
        let spaceBetweenButtons = CGFloat(42.5)
        let btnsW = CGFloat(57.5)
        let btnsH = CGFloat(25)
        let imgSize = CGFloat(54.0)
        let seperatorH = CGFloat(22.0)
        let seperatorW = CGFloat(1.0)
        
        self.imgGroupProfile.frame = CGRectMake(self.frame.width - spaceFromRightOfCell - imgSize, self.frame.origin.x + spaceFromTopOfCell, imgSize, imgSize)
        self.lblGroupName.frame = CGRectMake(self.imgGroupProfile.frame.origin.x - spaceBetweenLbls - self.lblGroupName.frame.size.width, self.imgGroupProfile.frame.origin.y + 15.0, self.lblGroupName.frame.size.width, self.lblGroupName.frame.size.height)
        self.lblRequestTitle.frame = CGRectMake(self.imgGroupProfile.frame.origin.x - spaceBetweenLbls - self.lblRequestTitle.frame.size.width, self.lblGroupName.frame.origin.y + self.lblGroupName.frame.size.height + spaceBetweenLbls, self.lblRequestTitle.frame.size.width, self.lblRequestTitle.frame.size.height)
        self.lblRequestDate.frame = CGRectMake(self.imgGroupProfile.frame.origin.x - spaceBetweenLbls - self.lblRequestDate.frame.size.width, self.lblRequestTitle.frame.origin.y + self.lblRequestTitle.frame.size.height + spaceBetweenLbls, self.lblRequestDate.frame.size.width, self.lblRequestDate.frame.size.height)
        self.btnRejectGroup.frame = CGRectMake(spaceFromLeftOfCell, self.lblRequestDate.frame.origin.y + self.lblRequestDate.frame.size.height + spaceBetweenLbls * 2, btnsW, btnsH)
        self.btnApproveGroup.frame = CGRectMake(self.btnRejectGroup.frame.origin.x + self.btnRejectGroup.frame.size.width + spaceBetweenButtons, self.btnRejectGroup.frame.origin.y, btnsW, btnsH)
        self.lblSeperator.frame = CGRectMake((self.btnRejectGroup.frame.origin.x + self.btnRejectGroup.frame.size.width) + (self.btnApproveGroup.frame.origin.x - (self.btnRejectGroup.frame.origin.x + self.btnRejectGroup.frame.size.width) - seperatorW)/2, self.btnRejectGroup.frame.origin.y, seperatorW, seperatorH)
        self.btnPanProfile.frame = CGRectMake(self.imgGroupProfile.frame.origin.x + (self.imgGroupProfile.frame.width - self.btnPanProfile.frame.size.width)/2,(self.frame.size.height -  self.btnApproveGroup.frame.origin.y + self.btnApproveGroup.frame.size.height - self.btnPanProfile.frame.size.height)/2, self.btnPanProfile.frame.size.width, self.btnPanProfile.frame.size.height)
        self.lblDownSeperator.frame = CGRectMake(0, self.frame.size.height - 3, self.frame.size.width, 3)
    }
}

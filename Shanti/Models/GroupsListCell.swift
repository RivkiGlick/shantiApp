//
//  GroupsListCell.swift
//  Shanti
//
//  Created by hodaya ohana on 2/23/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

class GroupsListCell: UITableViewCell {

    @IBOutlet weak var imgBg: UIImageView!
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var btnFriendsNumber: UIButton!
    @IBOutlet weak var imgFriendsNumber: UIImageView!
    @IBOutlet weak var lblGroupName: UILabel!
    @IBOutlet weak var lblMask: UILabel!
    @IBOutlet weak var lblGroupInfo: UILabel!
    
    func setSubviewsSettings(){
        self.imgArrow.image = UIImage(named: "back")
      
        self.btnFriendsNumber.setBackgroundImage(UIImage(named: "members_num_circle"), forState: UIControlState.Normal)
        self.btnFriendsNumber.setBackgroundImage(UIImage(named: "members_num_circle"), forState: UIControlState.Highlighted)
        self.btnFriendsNumber.setTitle("", forState: UIControlState.Normal)
        self.btnFriendsNumber.setTitle("", forState: UIControlState.Highlighted)
        self.btnFriendsNumber.setTitleColor(UIColor.purpleHome(), forState: UIControlState.Normal)
        self.btnFriendsNumber.setTitleColor(UIColor.purpleHome(), forState: UIControlState.Highlighted)
        self.btnFriendsNumber.backgroundColor = UIColor.clearColor()
        self.btnFriendsNumber.titleLabel?.textAlignment = NSTextAlignment.Center
       self.btnFriendsNumber.titleLabel?.font = UIFont(name: "spacer", size: 20)
        self.imgFriendsNumber.image = UIImage(named: "members_num")
       
        self.lblGroupName.text = ""
        self.lblGroupName.backgroundColor = UIColor.clearColor()
        self.lblGroupName.textColor = UIColor.whiteColor()
        self.lblGroupName.font = UIFont(name: "spacer", size: 26.5)
      
        self.lblMask.text = ""
        self.lblMask.backgroundColor = UIColor.grayDark().colorWithAlphaComponent(0.7)
        
        self.lblGroupInfo.text = ""
        self.lblGroupInfo.backgroundColor = UIColor.clearColor()
        self.lblGroupInfo.textColor = UIColor.whiteColor()
        self.lblGroupInfo.font = UIFont(name: "spacer", size: 14)

        self.imgBg.contentMode = UIViewContentMode.ScaleAspectFill
        self.imgBg.clipsToBounds = true
    }
    
    func setSubviewsFrames(){
        let btnFriendsSize = UIImage(named: "members_num_circle")!.size
        self.imgBg.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
        self.imgArrow.frame = CGRectMake(15, (self.frame.height - self.imgArrow.image!.size.height/2)/2, self.imgArrow.image!.size.width/2, self.imgArrow.image!.size.height/2)
        self.lblGroupName.frame = CGRectMake((self.frame.size.width - self.lblGroupName.frame.size.width)/2, (self.frame.size.height - self.lblGroupName.frame.size.height)/2, self.lblGroupName.frame.size.width, self.lblGroupName.frame.size.height)
        self.imgFriendsNumber.frame = CGRectMake(self.frame.size.width - 85, 26, self.imgFriendsNumber.image!.size.width/2, self.imgFriendsNumber.image!.size.height/2)
        self.btnFriendsNumber.frame = CGRectMake(self.imgFriendsNumber.frame.origin.x, self.imgFriendsNumber.frame.origin.y,btnFriendsSize.width/2,btnFriendsSize.height/2)
        self.lblMask.frame = self.imgBg.frame
        self.lblGroupInfo.frame = CGRectMake((self.frame.size.width - self.lblGroupInfo.frame.size.width)/2, self.lblGroupName.frame.origin.y + self.lblGroupName.frame.size.height + 18, self.lblGroupInfo.frame.size.width, self.lblGroupInfo.frame.size.height)
    }
}

//
//  CategoryItemCell.swift
//  Shanti
//
//  Created by MyMac on 4/14/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

class CategoryItemCell: UITableViewCell {

    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblReview: UILabel!
    
    let spaceFromRight = CGFloat(19.0)
    
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
        self.lblUserName.text = ""
        self.lblUserName.textColor = UIColor.purpleHome()
        self.lblUserName.backgroundColor = UIColor.clearColor()
        self.lblUserName.textAlignment = NSTextAlignment.Right
        self.lblUserName.font = UIFont(name: "spacer", size: 17)
        
        self.lblReview.text = ""
        self.lblReview.textColor = UIColor.grayColor()
        self.lblReview.backgroundColor = UIColor.clearColor()
        self.lblReview.textAlignment = NSTextAlignment.Left
        self.lblReview.font = UIFont(name: "spacer", size: 15)
        self.lblReview.numberOfLines = 0
        self.lblReview.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.lblReview.frame = CGRectMake(0, 0, self.frame.size.width - spaceFromRight * 2, 0)
        
        self.backgroundColor = UIColor.clearColor()
    }
    
    func setSubviewsFrames(){
        let spaceFromTop = CGFloat(11.0)
        let spaceBetweenLbls = CGFloat(5)
        
        self.lblUserName.sizeToFit()
        self.lblReview.sizeToFit()
        
        self.lblUserName.frame = CGRectMake(spaceFromRight, spaceFromTop, self.lblUserName.frame.size.width, self.lblUserName.frame.size.height)
        self.lblReview.frame = CGRectMake(self.lblUserName.frame.origin.x, self.lblUserName.frame.origin.y + self.lblUserName.frame.size.height + spaceBetweenLbls, self.lblReview.frame.size.width, self.frame.size.height - (self.lblUserName.frame.origin.y + self.lblUserName.frame.size.height) - 5)
    }

}

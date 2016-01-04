//
//  PopUpTableViewCell.swift
//  Shanti
//
//  Created by hodaya ohana on 2/8/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

class PopUpTableViewCell: UITableViewCell {

    @IBOutlet weak var lblPrefix: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setTitleLableConfig()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setTitleLableConfig(){
        self.lblTitle.font = UIFont(name: "spacer", size: 25.0)
        self.lblTitle.backgroundColor = UIColor.clearColor()
        self.lblTitle.sizeToFit()
        
        self.img.image = UIImage(named: "switchOff.png")
        self.img.backgroundColor = UIColor.clearColor()
    }
    
    func setSubviewsframes(){
        let imgSize = CGFloat(24)
        self.img.frame = CGRectMake(self.frame.size.width - imgSize - 15, (self.frame.size.height - imgSize)/2, imgSize, imgSize)
        self.lblTitle.frame = CGRectMake(15, (self.frame.size.height - self.lblTitle.frame.size.height)/2, self.img.frame.origin.x - 15, self.lblTitle.frame.size.height)
    }
}

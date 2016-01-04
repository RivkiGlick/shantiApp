//
//  UserLisrCell.swift
//  Shanti
//
//  Created by hodaya ohana on 10/11/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

class UserLisrCell: UITableViewCell {
    
    @IBOutlet weak var lblShantiName: UILabel!
    @IBOutlet weak var lblLastBroadcastDate: UILabel!
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

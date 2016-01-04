//
//  UIPreferencesButton.swift
//  Shanti
//
//  Created by hodaya ohana on 2/2/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

class UIPreferencesButton: UIView {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSelectIndicator: UIButton!
    @IBOutlet weak var btnArrow: UIButton!
    
    override init(){
        super.init()
//        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.superview!.frame.size.width, 50)
        self.setViewConfig()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViewConfig()
        
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setViewConfig()
    }
    
    func setViewConfig(){
        self.setSubviewsSettings()
        self.setSubviewsFrames()
    }
    
    func setSubviewsSettings(){
        self.backgroundColor = UIColor.whiteColor()
        self.layer.borderColor = UIColor.grayColor().CGColor
        self.layer.borderWidth = 3.0
        
        self.lblTitle.textColor = UIColor(red: 167/255, green: 51/255 , blue: 255/255, alpha: 1)
        self.lblTitle.font = UIFont(name: "spacer", size: 15.0)
        self.lblTitle.sizeToFit()
        self.lblTitle.textAlignment = NSTextAlignment.Right
//        TODO: add the btnArrow background image
//        TODO: add the btnSelectIndicator background image
    }
    
    func setSubviewsFrames(){
        self.lblTitle.frame = CGRectMake(self.btnArrow.frame.origin.x + self.btnArrow.frame.size.width + 2, btnArrow.frame.origin.y, btnSelectIndicator.frame.origin.x - 3 - (self.btnArrow.frame.origin.x + self.btnArrow.frame.size.width + 2), self.lblTitle.frame.size.height)
    }
}

//
//  UIButtonSearch.swift
//  Shanti
//
//  Created by hodaya ohana on 3/24/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

class UIButtonSearch: UIButton {
    var image: UIImage = UIImage(named: "search_groups")!
    var textField: UITextField!
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        self.setBtnSettings()
    }
    
    func setBtnSettings(){
        let size = CGFloat(46.0)
        self.setImage(image, forState: UIControlState.Normal)
        self.setImage(image, forState: UIControlState.Highlighted)
        self.setTitle("", forState: UIControlState.Normal)
        self.setTitle("", forState: UIControlState.Highlighted)
        self.setBackgroundImage(ImageHandler.imageWithColor(UIColor.whiteColor()), forState: UIControlState.Normal)
        self.setBackgroundImage(ImageHandler.imageWithColor(UIColor.offwhiteBasic()), forState: UIControlState.Highlighted)
        self.layer.borderColor = UIColor.grayMedium().CGColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 3
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size, size)
    }
}

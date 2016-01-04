//
//  UIPreferencesCustomView.swift
//  Shanti
//
//  Created by hodaya ohana on 2/5/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

class UIPreferencesCustomView: UIView {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var selectionSwitch: UISwitch!
    
    override var frame: CGRect {
        didSet{
//            self.resizeSubviews()
        }
    }
    
//    override init(){
//        super.init()
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setLblTitleText(textLable: String){
        self.lblTitle.text = textLable
        self.viewConfig()
    }
    
    func viewConfig(){
        self.setSubviewsSettings()
        self.resizeSubviews()
    }

    func setSubviewsSettings(){
        self.backgroundColor = UIColor.clearColor()
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1).CGColor
        self.layer.cornerRadius = 3
        
        self.lblTitle.font = UIFont(name: "spacer", size: 17.0)
        self.lblTitle.textAlignment = NSTextAlignment.Center
        self.lblTitle.textColor = UIColor.grayMedium()
        self.lblTitle.sizeToFit()
        
        self.selectionSwitch.backgroundColor = UIColor.clearColor()
        self.selectionSwitch.onTintColor = UIColor.purpleHome()
        self.selectionSwitch.tintColor = UIColor.grayMedium()
//        TODO: add ofTintColor to (191,196,201)rgb
//      TODO: fix the switch thumbTintColor image!!!!
//        self.selectionSwitch.thumbTintColor = UIColor(patternImage: UIImage(named: "v_only")!)
        
    }
    
    func resizeSubviews(){
        self.lblTitle.frame = CGRectMake(self.frame.size.width - self.lblTitle.frame.size.width - 21.5, (self.frame.height - self.lblTitle.frame.size.height)/2, self.lblTitle.frame.size.width, self.lblTitle.frame.size.height)
        self.selectionSwitch.frame = CGRectMake(18, (self.frame.height - self.selectionSwitch.frame.size.height)/2, self.selectionSwitch.frame.size.width, self.selectionSwitch.frame.size.height)
    }
}

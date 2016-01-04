//
//  InformationViewController.swift
//  Shanti
//
//  Created by hodaya ohana on 3/16/15.
//  Copyright (c) 2015 webit. All rights reserved.
//NSLocalizedString("Meeting points", comment: "") as String

import UIKit


class InformationViewController: GlobalViewController {
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet weak var imgBg: UIImageView!
    
    var placesTypes: NSMutableArray = NSMutableArray()
    var lblTitle = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getTypeListFromServer()
        self.setSubviewsConfig()
        self.lblTitle.text =  NSLocalizedString("This option will be supported in future versions", comment: "")
        self.lblTitle.textColor = UIColor.whiteColor()
        self.lblTitle.font = UIFont(name:"spacer" ,size:17)
        self.lblTitle.sizeToFit()
        self.lblTitle.center = self.view.center
//      self.view.addSubview(self.lblTitle)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTypeListFromServer(){
        var generic = Generic()
        generic.showNativeActivityIndicator(self)
        Connection.connectionToService("GetGooglePlaces", params: ["nvLanguage":HEBROW_LANGUAGE], completion: {
            data -> Void in
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("GetGooglePlaces:\(strData)")
            
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSArray
            if json != nil{
                for itemDict in json! {
                    var currCategory: PlaceCategory = PlaceCategory.parsPlaceCategoryJson(itemDict as! NSDictionary)
                    self.placesTypes.addObject(currCategory)
                }
                self.setSubviews()
            }
            generic.hideNativeActivityIndicator(self)
        })
    }

    func setSubviewsConfig(){
        self.setNavigationSettings()
        self.setTopViewConfig()
        
        self.imgBg.image = UIImage(named: "infoBg")!
        if self.viewTop.hidden == false{
            self.imgBg.frame = CGRectMake(0, self.viewTop.frame.origin.y + self.viewTop.frame.size.height, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        }else{
            self.imgBg.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        }
        
    }
    
    func setNavigationSettings(){
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.purpleHome()
        self.navigationController?.navigationBar.setBackgroundImage(ImageProcessor.imageWithColor(UIColor.whiteColor()), forBarMetrics: UIBarMetrics.Default)
        self.title = ""
        
        if var btnBack = self.navigationItem.leftBarButtonItem{
            if var btn: UIButton = btnBack.customView as? UIButton{
                btn.setImage(UIImage(named: "purpleLeftBack"), forState: UIControlState.Normal)
                btn.setImage(UIImage(named: "purpleLeftBack"), forState: UIControlState.Highlighted)
            }
            
        }
    }
    
    func setTopViewConfig(){
        self.viewTop.backgroundColor = UIColor.offwhiteBasic()
        self.txtSearch.backgroundColor = UIColor.clearColor()
        self.txtSearch.layer.borderWidth = 1.5
        self.txtSearch.layer.borderColor = UIColor.purpleLight().CGColor
        self.imgSearch.hidden = false
        self.btnSearch.hidden = false
        
        let topViewH = CGFloat(43.0)
        let spaceFromLeft = CGFloat(17.5)
        let spaceFromButtom = CGFloat(9.0)
        let txtW = CGFloat(205.5)
        let txtH = CGFloat(topViewH * 3/4)
//        
        self.viewTop.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, topViewH)
        self.txtSearch.frame = CGRectMake(spaceFromLeft * 2, self.viewTop.frame.size.height - txtH - spaceFromButtom, txtW, txtH)
        
        self.viewTop.hidden = false
    }
    
    func setSubviews(){
        var nextY = CGFloat(self.viewTop.frame.origin.y + self.viewTop.frame.size.height + 43.0)
        let spaceFromeSides = CGFloat(14.0)
        let spaceBetweenItemsW = CGFloat(4.0)
        let spaceBetweenItemsH = CGFloat(5.0)
        let itemSize = CGFloat(93.5)
        var nextX = spaceFromeSides
        
        for currPlace in self.placesTypes{
            var placeBtn = UIButton(frame: CGRectMake(nextX, nextY, itemSize, itemSize))
            placeBtn.tag = self.placesTypes.indexOfObject(currPlace)
            placeBtn.layer.borderWidth = 1
            placeBtn.layer.borderColor = UIColor.purpleLight().CGColor
            placeBtn.layer.cornerRadius = 30.5
            placeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            placeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
            placeBtn.titleLabel?.textAlignment = NSTextAlignment.Center
            placeBtn.setTitle("", forState: UIControlState.Normal)
            placeBtn.setTitle("", forState: UIControlState.Highlighted)
            placeBtn.enabled = false
            
            
            if (currPlace as! PlaceCategory).nvFontName != "" && (currPlace as! PlaceCategory).nvFontCode != ""{
                var lblIcon = UILabel()
                
                var font = (currPlace as! PlaceCategory).nvFontName
                let myNSString = font as NSString
                var range = myNSString.rangeOfString(".")
                
                if range.length == 1{
                    let newFontName = myNSString.substringWithRange(NSRange(location: 0, length: range.location))
                    lblIcon.font = UIFont(name: newFontName, size: 25)
                }else{
                    lblIcon.font = UIFont(name: font, size: 25)
                }
                
//                lblIcon.font = UIFont(name: newFontName, size: 50)
//                lblIcon.text = (currPlace as! PlaceCategory).nvFontCode
                lblIcon.textColor = UIColor.whiteColor()
                lblIcon.textAlignment = NSTextAlignment.Center
                lblIcon.sizeToFit()
//                lblIcon.backgroundColor = UIColor.blueColor()
                
                var placeNameLbl = UILabel()
                placeNameLbl.text = (currPlace as! PlaceCategory).nvPlaceName
                placeNameLbl.textColor = UIColor.whiteColor()
                placeNameLbl.font = UIFont(name: "spacer", size: 12.5)
                placeNameLbl.textAlignment = NSTextAlignment.Center
                placeNameLbl.sizeToFit()
//                placeNameLbl.backgroundColor = UIColor.redColor()
                
                let spaceBetweenIconToTitle = CGFloat(3.0)
                let iconY = CGFloat((placeBtn.frame.size.height - (lblIcon.frame.size.height + spaceBetweenIconToTitle + placeNameLbl.frame.size.height))/2)
                lblIcon.frame = CGRectMake((placeBtn.frame.size.width - lblIcon.frame.size.width)/2, iconY, lblIcon.frame.size.width, lblIcon.frame.size.height)
                
                placeNameLbl.frame = CGRectMake((placeBtn.frame.size.width - placeNameLbl.frame.size.width)/2, lblIcon.frame.origin.y + lblIcon.frame.size.height + spaceBetweenIconToTitle, placeNameLbl.frame.size.width, placeNameLbl.frame.size.height)
                
                placeBtn.addSubview(lblIcon)
                placeBtn.addSubview(placeNameLbl)
                
            }else{
                placeBtn.titleLabel?.font = UIFont(name: "spacer", size: 12.5)
                placeBtn.setTitle((currPlace as! PlaceCategory).nvPlaceName, forState: UIControlState.Normal)
                placeBtn.setTitle((currPlace as! PlaceCategory).nvPlaceName, forState: UIControlState.Highlighted)
            }
            
            placeBtn.backgroundColor = UIColor.clearColor()
            placeBtn.addTarget(self, action: "getFullInfoOnCategory:", forControlEvents: UIControlEvents.TouchUpInside)
            nextX += spaceBetweenItemsW + itemSize
            if (UIScreen.mainScreen().bounds.size.width - nextX - itemSize < spaceFromeSides){
                nextX = spaceFromeSides
                nextY += itemSize + spaceBetweenItemsH
            }
            
            self.view.addSubview(placeBtn)
        }
    }
    
    
    
    
    func getFullInfoOnCategory(sender: AnyObject){
        if let currBtn = sender as? UIButton{
            var currPlaceCategory: AnyObject = self.placesTypes.objectAtIndex(currBtn.tag)
            let placeCategoryView = self.storyboard?.instantiateViewControllerWithIdentifier("PlaceCategoryInfoViewControllerId") as! PlaceCategoryInfoViewController
            placeCategoryView.placeCategory = currPlaceCategory as! PlaceCategory
            self.navigationController?.pushViewController(placeCategoryView, animated: true)
        }
    }
    
}

//
//  PlaceCategoryInfoViewController.swift
//  Shanti
//
//  Created by hodaya ohana on 3/29/15.
//  Copyright (c) 2015 webit. All rights reserved.
//NSLocalizedString("Meeting points", comment: "") as String

import UIKit

class PlaceCategoryInfoViewController: GlobalViewController {

    var placeCategory: PlaceCategory = PlaceCategory()
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var imgBg: UIImageView!
    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnSearch: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setSubviewsConfig()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setSubviewsConfig(){
        self.setNavigationSettings()
        self.setTopViewConfig()
        self.addSubviews()
        
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
                btn.setImage(UIImage(named: "purpleLeftBack.png"), forState: UIControlState.Normal)
                btn.setImage(UIImage(named: "purpleLeftBack.png"), forState: UIControlState.Highlighted)
            }
            
        }
    }
    
    func setTopViewConfig(){
        self.viewTop.backgroundColor = UIColor.offwhiteBasic()
        self.txtSearch.backgroundColor = UIColor.clearColor()
        self.txtSearch.layer.borderWidth = 1.5
        self.txtSearch.layer.borderColor = UIColor.purpleLight().CGColor
        self.imgSearch.hidden = true
        self.btnSearch.hidden = true
        
        let topViewH = CGFloat(43.0)
        let spaceFromLeft = CGFloat(17.5)
        let spaceFromButtom = CGFloat(9.0)
        let txtW = CGFloat(205.5)
        let txtH = CGFloat(topViewH * 3/4)
        
        self.viewTop.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, topViewH)
        self.txtSearch.frame = CGRectMake(spaceFromLeft * 2, self.viewTop.frame.size.height - txtH - spaceFromButtom, txtW, txtH)
        
        self.viewTop.hidden = true
    }
    
    func addSubviews(){
        var nextY = CGFloat(self.viewTop.frame.origin.y + self.viewTop.frame.size.height + 45.0)
        let spaceFromeSides = CGFloat(25.0)
        let spaceBetweenItemsW = CGFloat(7.0)
        let spaceBetweenItemsH = CGFloat(10.5)
        let spaceBetweenHeaderToItems = CGFloat(28.5)
        let headerBtnSize = CGFloat(93.5)
        let btnsH = CGFloat(30.0)
        let btnsAddW = CGFloat(38.0)
        var nextX = spaceFromeSides

        var headerBtn = UIButton()
        headerBtn.setTitle(self.placeCategory.nvPlaceName, forState: UIControlState.Normal)
        headerBtn.setTitle(self.placeCategory.nvPlaceName, forState: UIControlState.Highlighted)
        headerBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        headerBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        headerBtn.titleLabel?.font = UIFont(name: "spacer", size: 12.5)
        headerBtn.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        headerBtn.layer.borderColor = UIColor(red: 210/256, green: 210/256, blue: 210/256, alpha: 1).CGColor
        headerBtn.layer.borderWidth = 1
        headerBtn.layer.cornerRadius = 11
        headerBtn.frame = CGRectMake((UIScreen.mainScreen().bounds.size.width - headerBtnSize)/2, nextY, headerBtnSize, headerBtnSize)
        
        self.view.addSubview(headerBtn)
        
        nextY = headerBtn.frame.origin.y + headerBtn.frame.size.height + spaceBetweenHeaderToItems
        
        for currPlaceItem in self.placeCategory.lPlaceItems{
            var btnPlaceItem = UIButton()
            btnPlaceItem.setTitle(currPlaceItem.nvPlaceName, forState: UIControlState.Normal)
            btnPlaceItem.setTitle(currPlaceItem.nvPlaceName, forState: UIControlState.Highlighted)
            btnPlaceItem.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            btnPlaceItem.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
            btnPlaceItem.titleLabel?.font = UIFont(name: "spacer", size: 12.5)
            btnPlaceItem.backgroundColor = UIColor.clearColor()
            btnPlaceItem.layer.borderColor = UIColor.purpleLight().CGColor
            btnPlaceItem.layer.borderWidth = 1
            btnPlaceItem.layer.cornerRadius = 11
            btnPlaceItem.tag = find(self.placeCategory.lPlaceItems, currPlaceItem)!
            btnPlaceItem.sizeToFit()
            btnPlaceItem.titleLabel?.textAlignment = NSTextAlignment.Center
            btnPlaceItem.addTarget(self, action: "getFullInfoOnCategorItem:", forControlEvents: UIControlEvents.TouchUpInside)
            
            if (UIScreen.mainScreen().bounds.size.width - (nextX + btnPlaceItem.frame.size.width + btnsAddW)) < spaceFromeSides{
                nextX = spaceFromeSides
                self.placeLineSubviewsInTheMiddleOfScreen(nextY, firstElementX: nextX, spaceBetweenItems: spaceBetweenItemsW)
                nextY += btnsH + spaceBetweenItemsH
            }
            
            btnPlaceItem.frame = CGRectMake(nextX, nextY, btnPlaceItem.frame.size.width + btnsAddW, btnsH)
            nextX = spaceBetweenItemsW + btnPlaceItem.frame.origin.x + btnPlaceItem.frame.size.width
            
            self.view.addSubview(btnPlaceItem)
        }
        self.placeLineSubviewsInTheMiddleOfScreen(nextY, firstElementX: spaceFromeSides, spaceBetweenItems: spaceBetweenItemsW) // for the last line.
    }
    
    func placeLineSubviewsInTheMiddleOfScreen(lineY: CGFloat, firstElementX: CGFloat, spaceBetweenItems: CGFloat){
        var lineSubviews = [UIView]()
        var lastElementX = firstElementX
        var lastElementW = CGFloat()
        
        for view in self.view.subviews{ // get all the views in this line
            if view.frame.origin.y == lineY{
                lineSubviews += [view as! UIView]
                
                if view.frame.origin.x > lastElementX{
                    lastElementX = view.frame.origin.x
                    lastElementW = view.frame.size.width
                }
            }
        }
        
        var spaceFromeFrame = firstElementX + (UIScreen.mainScreen().bounds.size.width - (lastElementX + lastElementW))
        var newX = spaceFromeFrame/2
        
        for view in self.view.subviews{
            if view.frame.origin.y == lineY{
                (view as! UIView).frame = CGRectMake(newX, lineY, view.frame.size.width, view.frame.size.height)
                newX += view.frame.size.width + spaceBetweenItems
            }
        }
    }
    
    
    func getFullInfoOnCategorItem(sender: AnyObject){
        if let btn = sender as? UIButton{
            var currItem: PlaceItem = self.placeCategory.lPlaceItems[btn.tag]
            var coords: CLLocationCoordinate2D!
            for view in self.navigationController!.viewControllers{
                if view.isKindOfClass(MainPage){
                    coords = (view as! MainPage).myLocationMarker.position
                    break
                }
            }
            
            coords = CLLocationCoordinate2DMake(31.749860, 35.188710) // TODO: remove before submit
            if coords != nil{
                var generic = Generic()
                generic.showNativeActivityIndicator(self)

                Connection.getPlacesInformationFromGooglePlace(coords, radius: 5000, searchKeyWord: currItem.nvGoogleType, completion: {
                    data -> Void in
                    var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("getPlacesInformation:\(strData)")
                    var err: NSError?
                    var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary

                    let DetailedInfoView = self.storyboard?.instantiateViewControllerWithIdentifier("DetailedInfoViewControllerId") as! DetailedInfoViewController
                    if (json != nil) {
                        let js: NSDictionary = json!
                        if let placeArry = js["results"] as? NSArray{
                            for placeResult in placeArry{
                                var googlObjResult: GooglePlaceResultObject = GooglePlaceResultObject.parseGooglePlaceResultObjectDict(placeResult as! NSDictionary)
                                
                                Connection.featchPlaceDetailsFromGoogle(googlObjResult.place_id, language: "iw", completion: {
                                    data -> Void in
                                    var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                                    println("featchPlaceDetailsFromGoogle:\(strData)")
                                    var err: NSError?
                                    var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
                                    if json != nil{
                                        var gogglePlaceItemDetails = GogglePlaceItemDetails.parsGogglePlaceItemDetails(json!.valueForKey("result") as! NSDictionary)
                                        DetailedInfoView.placesArry += [gogglePlaceItemDetails]
                                    }
                                    
                                    if DetailedInfoView.placesArry.count == placeArry.count{
                                        generic.hideNativeActivityIndicator(self)
                                        self.navigationController?.pushViewController(DetailedInfoView, animated: true)
                                    }
                                })
                                
                            }
                        }
                    }

                })
           }
        }
    }
}

//
//  DetailedInfoViewController.swift
//  Shanti
//
//  Created by hodaya ohana on 3/16/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

class DetailedInfoViewController: GlobalViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var placesArry = [GogglePlaceItemDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setSubviewsConfig()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setSubviewsConfig(){
        self.navigationController?.navigationBar.hidden = false
        self.downloadImgsFromGoogle()
        self.addNavigationSettings()
        self.setDelegates()
        self.setSubviewsFrames()
        //        self.tableView.reloadData()
    }
    
    func addNavigationSettings(){
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
    func setDelegates(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func setSubviewsFrames(){
        self.tableView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
    }
    
    func downloadImgsFromGoogle(){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            for currPlaceItem in self.placesArry{
                println("\(find(self.placesArry, currPlaceItem)) 1. currPlaceItem.name: \(currPlaceItem.name)")
                if currPlaceItem.photos.count > 0 {
                    Connection.featchPlacePhotoFromGoogle(Int(self.view.bounds.size.width), photoReference: currPlaceItem.photos[0].photo_reference, completion: {
                        data -> Void in
                        println("\(find(self.placesArry, currPlaceItem)) 2. currPlaceItem.name: \(currPlaceItem.name)")
                        var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                        println("featchPlacePhotoFromGoogle:\(strData)")
                        currPlaceItem.photos[0].photoImg = UIImage(data: data)
                        
                        var result = find(self.placesArry, currPlaceItem)
                        if result != nil {
                            let index: Int = result!
                            let indexes = [NSIndexPath(forRow: index, inSection: 0)]
                            self.tableView.beginUpdates()
                            self.tableView.reloadRowsAtIndexPaths(indexes, withRowAnimation: UITableViewRowAnimation.Fade)
                            self.tableView.endUpdates()
                        }
                        
                    })
                }
            }
            self.tableView.reloadData()
        })
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 339
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.placesArry.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell: DetailedInfoCell = tableView.dequeueReusableCellWithIdentifier("DetailedInfoCell") as! DetailedInfoCell
        var currPlaceItem: GogglePlaceItemDetails = self.placesArry[indexPath.row]
        if currPlaceItem.photos.count > 0 {
            if currPlaceItem.photos[0].photoImg != nil{
                cell.imgPlace.image = currPlaceItem.photos[0].photoImg
                cell.imgPlace.backgroundColor = UIColor.whiteColor()
            }else{
                cell.imgPlace.image = UIImage(named: "no-image")
                cell.imgPlace.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
            }
        }else{
            cell.imgPlace.image = UIImage(named: "no-image")
            cell.imgPlace.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        }
        
        cell.lblTitle.text = currPlaceItem.name
        cell.lblInfo1.text = currPlaceItem.formatted_address
        cell.lblInfo2.text = currPlaceItem.international_phone_number != "" ? currPlaceItem.international_phone_number : currPlaceItem.formatted_phone_number
        cell.lblReviews.text = "\(currPlaceItem.reviews.count) תגובות"
        cell.setSubviewsFrames()
        
        let imgH = CGFloat(194.0)
        cell.imgPlace.frame = CGRectMake(0, 0, cell.frame.size.width, imgH)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let sfds = self.placesArry[indexPath.row]
        let catrgoryItemView = self.storyboard?.instantiateViewControllerWithIdentifier("CategoryItemDetaileViewControllerId") as! CategoryItemDetaileViewController
        catrgoryItemView.currGogglePlaceItem = self.placesArry[indexPath.row]
        self.navigationController?.pushViewController(catrgoryItemView, animated: true)
    }
    
}

class DetailedInfoCell: UITableViewCell{
    
    @IBOutlet weak var imgPlace: UIImageView!
    @IBOutlet weak var viewDetailes: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var lblInfo1: UILabel!
    @IBOutlet weak var lblIconInfo1: UILabel!
    @IBOutlet weak var lblIconInfo2: UILabel!
    @IBOutlet weak var lblInfo2: UILabel!
    @IBOutlet weak var lblReviews: UILabel!
    @IBOutlet weak var imgTraingle: UIImageView!
    
    let imgSource = UIImage(named: "traingle-white-info")
    
    let spaceFromRight = CGFloat(20.0)
    let spaceFromLeft = CGFloat(25.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setSubviewsConfig()
    }
    
    func setSubviewsConfig(){
        let lblsFontName = "spacer"
        
        self.imgPlace.contentMode = UIViewContentMode.ScaleAspectFill
        self.imgPlace.clipsToBounds = true
        
        self.imgTraingle.image = imgSource
        self.bringSubviewToFront(self.imgTraingle)
        
        
        var space: CGFloat = 10
        var textAlignment: NSTextAlignment = .Left
        let languageId = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) as! String
        if languageId == "he"{
            textAlignment = .Right
            space = -space
        }
        
        self.viewDetailes.backgroundColor = UIColor.whiteColor()
        
        self.lblTitle.backgroundColor = UIColor.clearColor()
        self.lblTitle.text = ""
        self.lblTitle.textColor = UIColor.purpleHome()
        self.lblTitle.font = UIFont(name: lblsFontName, size: 17.5)
        //        self.lblTitle.textAlignment = NSTextAlignment.Left
        self.lblTitle.textAlignment = textAlignment
        self.lblTitle.layer.sublayerTransform = CATransform3DMakeTranslation(space,0,0)
        
        self.lblSubtitle.backgroundColor = UIColor.clearColor()
        self.lblSubtitle.text = ""
        self.lblSubtitle.textColor = UIColor.grayMedium()
        self.lblSubtitle.font = UIFont(name: lblsFontName, size: 14)
        //        self.lblSubtitle.textAlignment = NSTextAlignment.Left
        self.lblSubtitle.textAlignment = textAlignment
        self.lblReviews.layer.sublayerTransform = CATransform3DMakeTranslation(space,0,0)
        
        
        self.lblInfo1.backgroundColor = UIColor.clearColor()
        self.lblInfo1.text = ""
        self.lblInfo1.textColor = UIColor.grayMedium()
        self.lblInfo1.font = UIFont(name: lblsFontName, size: 17.5)
        self.lblInfo1.textAlignment = NSTextAlignment.Left
        //        self.lblInfo1.textAlignment = textAlignment
        self.lblInfo1.layer.sublayerTransform = CATransform3DMakeTranslation(space,0,0)
        
        
        self.lblIconInfo1.backgroundColor = self.lblInfo1.backgroundColor
        self.lblIconInfo1.font = UIFont(name: "IcoMoon-Free", size: 17.5)
        self.lblIconInfo1.text = "map2"
        self.lblIconInfo1.textColor = self.lblInfo1.textColor
        self.lblIconInfo1.textAlignment = self.lblInfo1.textAlignment
        self.lblIconInfo1.sizeToFit()
        self.lblIconInfo1.hidden = false
        
        self.lblInfo2.backgroundColor = UIColor.clearColor()
        self.lblInfo2.text = ""
        self.lblInfo2.textColor = UIColor.grayMedium()
        self.lblInfo2.font = UIFont(name: lblsFontName, size: 17.5)
        self.lblInfo2.textAlignment = NSTextAlignment.Left
        self.lblInfo2.layer.sublayerTransform = CATransform3DMakeTranslation(space,0,0)
        //        self.lblInfo2.textAlignment = textAlignment
        
        self.lblIconInfo2.backgroundColor = UIColor.clearColor()
        self.lblIconInfo1.font = UIFont(name: "fontawesome-webfont", size: 17.5)
        self.lblIconInfo2.text = "fa-phone [&#xf095;]"
        self.lblIconInfo2.textColor = UIColor.grayMedium()
        self.lblIconInfo2.textAlignment = NSTextAlignment.Left
        
        //        self.lblIconInfo2.textAlignment = textAlignment
        self.lblIconInfo2.sizeToFit()
        self.lblIconInfo2.hidden = false
        
        self.lblReviews.backgroundColor = UIColor.clearColor()
        self.lblReviews.text = ""
        self.lblReviews.textColor = UIColor.grayMedium()
        self.lblReviews.font = UIFont(name: lblsFontName, size: 14)
        //        self.lblReviews.textAlignment = NSTextAlignment.Right
        self.lblReviews.textAlignment = textAlignment
        self.lblReviews.layer.sublayerTransform = CATransform3DMakeTranslation(space,0,0)
        
        //make cornerRadius and location placeHolder to the UITextField
        for view in self.viewDetailes.subviews{
            if view.isKindOfClass(UITextField){
                //                view.layer.cornerRadius = 8
                //                if (view as! UIView) != txtPrefix{
                view.layer.sublayerTransform = CATransform3DMakeTranslation(space,0,0)
                //                }
                
            }
        }
        
    }
    
    func setSubviewsFrames(){
        self.lblTitle.sizeToFit()
        self.lblSubtitle.sizeToFit()
        self.lblInfo1.sizeToFit()
        self.lblInfo2.sizeToFit()
        self.lblReviews.sizeToFit()
        
        let imgH = CGFloat(194.0)
        let viewDetailesH = CGFloat(14.0)
        let spaceBetweenImgToLbls = CGFloat(13.0)
        let spaceBetweenTitles = CGFloat(7.5)
        let spaceBetweenTitleToLblsInfo = CGFloat(11.0)
        let spaceBetweenLblsInfo = CGFloat(10.0)
        let spaceBetweenInfoLblsToReviewLbls = CGFloat(19.0)
        let spaceBetweenIconsLblToInfoLbls = CGFloat(19.0)
        
        self.imgPlace.frame = CGRectMake(0, 0, self.frame.size.width, imgH)
        self.imgTraingle.frame = CGRectMake((self.imgPlace.frame.size.width - imgSource!.size.width/2)/2, self.imgPlace.frame.size.height - imgSource!.size.height/2, imgSource!.size.width/2, imgSource!.size.height/2)
        self.viewDetailes.frame = CGRectMake(0, self.imgPlace.frame.origin.y + self.imgPlace.frame.size.height, self.frame.size.width, viewDetailesH)
        self.lblTitle.frame = CGRectMake(self.frame.size.width - spaceFromRight - self.lblTitle.frame.size.width, spaceBetweenImgToLbls, self.getWidthWithAlighment(self.lblTitle), self.lblTitle.frame.size.height)
        self.lblSubtitle.frame = CGRectMake(self.frame.size.width - spaceFromRight - self.lblSubtitle.frame.size.width, self.lblTitle.frame.origin.y + self.lblTitle.frame.size.height + spaceBetweenTitles, self.getWidthWithAlighment(self.lblSubtitle), self.lblSubtitle.frame.size.height)
        // self.lblIconInfo1.frame = CGRectMake(spaceFromLeft, self.lblSubtitle.frame.origin.y + self.lblSubtitle.frame.size.height + spaceBetweenTitleToLblsInfo, self.lblIconInfo1.frame.size.width, self.lblIconInfo1.frame.size.height)
        self.lblInfo1.frame = CGRectMake(/*self.lblIconInfo1.frame.origin.x + self.lblIconInfo1.frame.size.width + spaceBetweenIconsLblToInfoLbls*/spaceFromLeft, self.lblSubtitle.frame.origin.y + self.lblSubtitle.frame.size.height + spaceBetweenTitleToLblsInfo, self.getWidthWithAlighment(self.lblInfo1), self.lblInfo1.frame.size.height)
        //self.lblIconInfo2.frame = CGRectMake(spaceFromLeft,  self.lblInfo1.frame.origin.y + self.lblInfo1.frame.size.height + spaceBetweenLblsInfo, self.lblIconInfo2.frame.size.width, self.lblIconInfo2.frame.size.height)
        self.lblInfo2.frame = CGRectMake(/*self.lblIconInfo2.frame.origin.x + self.lblIconInfo2.frame.size.width + spaceBetweenIconsLblToInfoLbls*/spaceFromLeft, self.lblInfo1.frame.origin.y + self.lblInfo1.frame.size.height + spaceBetweenLblsInfo, self.getWidthWithAlighment(self.lblInfo2), self.lblInfo2.frame.size.height)
        self.lblReviews.frame = CGRectMake(self.frame.size.width - spaceFromRight - self.lblReviews.frame.size.width, self.lblInfo2.frame.origin.y + self.lblInfo2.frame.size.height + spaceBetweenInfoLblsToReviewLbls, self.getWidthWithAlighment(self.lblReviews), self.lblReviews.frame.size.height)
    }
    
    func getWidthWithAlighment(currLbl: UILabel) -> CGFloat{
        let maxLblWForRAlighment = CGFloat(self.frame.size.width - spaceFromRight)
        let maxLblWForLAlighment = CGFloat(self.frame.size.width - spaceFromLeft)
        
        var newWidth = CGFloat()
        var alighment = currLbl.textAlignment
        
        if alighment == NSTextAlignment.Right{
            if currLbl.frame.size.width > maxLblWForRAlighment{
                newWidth = maxLblWForRAlighment
            }else{
                newWidth = currLbl.frame.size.width
            }
        }else if alighment == NSTextAlignment.Left{
            if currLbl.frame.size.width > maxLblWForLAlighment{
                newWidth = maxLblWForLAlighment
            }else{
                newWidth = currLbl.frame.size.width
            }
        }
        
        return newWidth
    }
}
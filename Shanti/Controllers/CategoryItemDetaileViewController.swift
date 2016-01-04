//
//  CategoryItemDetaileViewController.swift
//  Shanti
//
//  Created by hodaya ohana on 4/13/15.
//  Copyright (c) 2015 webit. All rights reserved.
//NSLocalizedString("Meeting points", comment: "") as String

import UIKit

class CategoryItemDetaileViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var imgTraingle: UIImageView!
    @IBOutlet weak var placeImages: UIImageView!
    @IBOutlet weak var btnChangeImageLeft: UIButton!
    @IBOutlet weak var btnChangeImageRight: UIButton!
    
    @IBOutlet weak var viewTitles: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBAction func btnisplayMapClick(sender: AnyObject) {
        btnDisplayMap.setTitle(NSLocalizedString("CloseMap", comment: ""), forState: .Normal)
    }
    @IBOutlet var btnDisplayMap: UIButton!
    @IBOutlet var lblInfoHours: UILabel!
    @IBOutlet var lblInfoPhone: UILabel!
    @IBOutlet var lblInfoAddress: UILabel!
    @IBOutlet var txtvInfoSite: UITextView!
    
    @IBOutlet weak var viewBtns: UIView!
    @IBOutlet weak var btnInfo: UIButton!
    @IBOutlet weak var btnReviews: UIButton!
    @IBOutlet weak var lblSeperator: UILabel!
    @IBOutlet weak var lblInfoUnderLbl: UILabel!
    @IBOutlet weak var lblReviewsUnderLbl: UILabel!
    @IBOutlet weak var lblReviewsNumber: UIButton!
    
    @IBOutlet weak var viewReviews: UIView!
    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var currGogglePlaceItem: GogglePlaceItemDetails!
    let imgSource = UIImage(named: "traingle-info-inner")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewConfig()
        
        btnDisplayMap.setTitle(NSLocalizedString("DisplayMap", comment: ""), forState: .Normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setViewConfig(){
        self.addNavigationSettings()
        self.setSubviewsConfig()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.registerNib(UINib(nibName: "CategoryItemCell", bundle: nil), forCellReuseIdentifier: "CategoryItemCell")
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
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
    
    func setSubviewsConfig(){
        self.setSubviewsGraphics()
        self.fillInfoView()
        self.setSubviewsFrame()
        self.viewInfo.hidden = true
    }
    
    func setSubviewsGraphics(){
        self.viewTop.backgroundColor = UIColor.clearColor()
        
        self.imgTraingle.contentMode = UIViewContentMode.ScaleAspectFill
        self.imgTraingle.clipsToBounds = true
        self.imgTraingle.image = imgSource
        
        self.placeImages.contentMode = UIViewContentMode.ScaleAspectFill
        self.placeImages.clipsToBounds = true
        
        if self.currGogglePlaceItem.photos.count > 0{
            if self.currGogglePlaceItem.photos[0].photoImg != nil{
                self.placeImages.image = self.currGogglePlaceItem.photos[0].photoImg
                self.placeImages.backgroundColor = UIColor.whiteColor()
            }else{
                self.placeImages.image = UIImage(named: "no-image")
                self.placeImages.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
            }
        }else{
            self.placeImages.image = UIImage(named: "no-image")
            self.placeImages.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
            self.btnChangeImageLeft.enabled = false
            self.btnChangeImageRight.enabled = false
        }
        
        self.btnChangeImageLeft.titleLabel?.font = UIFont(name: "fontawesome-webfont", size: 12.0)
        self.btnChangeImageLeft.setTitle("F053", forState: .Normal)
        self.btnChangeImageLeft.setTitle("F053", forState: .Highlighted)
        self.btnChangeImageLeft.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.btnChangeImageLeft.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        self.btnChangeImageLeft.backgroundColor = UIColor.clearColor()
        self.btnChangeImageLeft.sizeToFit()
        
        self.btnChangeImageRight.titleLabel?.font = UIFont(name: "fontawesome-webfont", size: 12.0)
        self.btnChangeImageRight.setTitle("F054", forState: .Normal)
        self.btnChangeImageRight.setTitle("F054", forState: .Highlighted)
        self.btnChangeImageRight.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.btnChangeImageRight.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        self.btnChangeImageRight.backgroundColor = UIColor.clearColor()
        self.btnChangeImageRight.sizeToFit()
        
        self.viewTitles.backgroundColor = UIColor.grayDark().colorWithAlphaComponent(0.7)
        
        self.lblTitle.text = currGogglePlaceItem.name
        self.lblTitle.font = UIFont(name: "", size: 14.5)
        self.lblTitle.textColor = UIColor.whiteColor()
        self.lblTitle.backgroundColor = UIColor.clearColor()
        self.lblTitle.textAlignment = NSTextAlignment.Right
        self.lblTitle.sizeToFit()
        
        self.lblSubTitle.text = ""
        self.lblSubTitle.font = UIFont(name: "", size: 11.5)
        self.lblSubTitle.textColor = UIColor.whiteColor()
        self.lblSubTitle.backgroundColor = UIColor.clearColor()
        self.lblSubTitle.textAlignment = NSTextAlignment.Right
        self.lblSubTitle.sizeToFit()
        
        var dic:[String] = currGogglePlaceItem.opening_hours.weekday_text
        self.lblInfoPhone.text = currGogglePlaceItem.international_phone_number
        
        self.lblInfoPhone.sizeToFit()
        if dic.count != 0
        {
            let date = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            var d = dateFormatter.stringFromDate(date)
            let weekday = getDayOfWeek(d)
            self.lblInfoHours.text = (currGogglePlaceItem.opening_hours.weekday_text[weekday - 1] as String)
        }
        else
        {
            self.lblInfoHours.text = "no information"
        }
        self.lblInfoHours.sizeToFit()
        
        self.txtvInfoSite.text = currGogglePlaceItem.website
        //self.txtvInfoSite.sizeToFit()
        
        self.lblInfoAddress.text = currGogglePlaceItem.formatted_address
        self.lblInfoAddress.adjustsFontSizeToFitWidth = true
        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
        let underlineAttributedString = NSAttributedString(string: self.txtvInfoSite.text, attributes: underlineAttribute)
        txtvInfoSite.attributedText = underlineAttributedString
        
        
        self.lblDate.text = ""
        self.lblDate.font = UIFont(name: "", size: 9)
        self.lblDate.textColor = UIColor.whiteColor()
        self.lblDate.backgroundColor = UIColor.clearColor()
        self.lblDate.textAlignment = NSTextAlignment.Right
        self.lblDate.sizeToFit()
        
        self.viewBtns.backgroundColor = UIColor.clearColor()
        
        self.btnInfo.titleLabel?.font = UIFont(name: "spacer", size: 20.0)
        self.btnInfo.setTitle("מידע", forState: .Normal)
        self.btnInfo.setTitle("מידע", forState: .Highlighted)
        self.btnInfo.setTitleColor(UIColor.purpleHome(), forState: .Normal)
        self.btnInfo.setTitleColor(UIColor.purpleHome(), forState: .Highlighted)
        self.btnInfo.backgroundColor = UIColor.clearColor()
        self.btnInfo.addTarget(self, action: "changeToInfoView:", forControlEvents: UIControlEvents.TouchUpInside)
        self.btnInfo.sizeToFit()
        
        self.btnReviews.titleLabel?.font = UIFont(name: "spacer", size: 20.0)
        self.btnReviews.setTitle("תגובות", forState: .Normal)
        self.btnReviews.setTitle("תגובות", forState: .Highlighted)
        self.btnReviews.setTitleColor(UIColor.purpleHome(), forState: .Normal)
        self.btnReviews.setTitleColor(UIColor.purpleHome(), forState: .Highlighted)
        self.btnReviews.backgroundColor = UIColor.clearColor()
        self.btnReviews.addTarget(self, action: "changeToReviewsView:", forControlEvents: UIControlEvents.TouchUpInside)
        self.btnReviews.sizeToFit()
        
        self.lblSeperator.text = ""
        self.lblSeperator.textColor = UIColor.clearColor()
        self.lblSeperator.backgroundColor = UIColor.grayMedium()
        self.lblSeperator.sizeToFit()
        
        self.lblInfoUnderLbl.text = ""
        self.lblInfoUnderLbl.textColor = UIColor.clearColor()
        self.lblInfoUnderLbl.backgroundColor = UIColor.grayMedium()
        self.lblInfoUnderLbl.sizeToFit()
        
        self.lblReviewsUnderLbl.text = ""
        self.lblReviewsUnderLbl.textColor = UIColor.clearColor()
        self.lblReviewsUnderLbl.backgroundColor = UIColor.purpleMedium()
        self.lblReviewsUnderLbl.sizeToFit()
        
        self.lblReviewsNumber.setTitle(String(self.currGogglePlaceItem.reviews.count), forState: UIControlState.Normal)
        self.lblReviewsNumber.setTitle(String(self.currGogglePlaceItem.reviews.count), forState: UIControlState.Highlighted)
        self.lblReviewsNumber.titleLabel!.textAlignment = NSTextAlignment.Center
        self.lblReviewsNumber.titleLabel!.font = UIFont(name: "spacer", size: 20.0)
        self.lblReviewsNumber.backgroundColor = UIColor.purpleMedium().colorWithAlphaComponent(0.7)
        self.lblReviewsNumber.setTitleColor(UIColor.purpleMedium(), forState: UIControlState.Normal)
        self.lblReviewsNumber.setTitleColor(UIColor.purpleMedium(), forState: UIControlState.Highlighted)
        
        self.lblReviewsNumber.layer.borderColor = UIColor.purpleLight().CGColor
        self.lblReviewsNumber.layer.borderWidth = 0.5
        self.lblReviewsNumber.layer.cornerRadius = 5
        self.lblReviewsNumber.sizeToFit()
    }
    func getDayOfWeek(today:String)->Int {
        
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.dateFromString(today)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(NSCalendarUnit.WeekdayCalendarUnit, fromDate: todayDate)
        let weekDay = myComponents.weekday
        return weekDay
        
    }
    
    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews();
        self.scrollView.contentSize.height = 700
    }
    
    func setSubviewsFrame(){
        let topViewH = CGFloat(212.5)
        let viewTitlesH = CGFloat(60)
        let titlesSpaceFromTop = CGFloat(12.5)
        let titlesSpaceFromRight = CGFloat(28.75)
        let titlesSpaceFromLeft = CGFloat(12.5)
        let titlesSpaceFromButtom = CGFloat(11)
        let btnsSpaceFromSides = CGFloat(7.5)
        let viewBtnsH = CGFloat(43.5)
        let lblReviewsNumW = CGFloat(18.5)
        let lblReviewsNumH = CGFloat(12.5)
        let spaceBetweenlblReviewsNumToLeft = CGFloat(34.5)
        let navBarAndStatusBarH = CGFloat(self.navigationController!.navigationBar.frame.origin.y + self.navigationController!.navigationBar.frame.size.height)
        
        //        self.scrollView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        //        self.scrollView.contentSize = self.scrollView.frame.size
        
        self.viewTop.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, topViewH)
        self.imgTraingle.frame = CGRectMake((self.viewTop.frame.size.width - imgSource!.size.width/2)/2, 0, imgSource!.size.width/2, imgSource!.size.height/2)
        self.placeImages.frame = CGRectMake(0, 0, self.viewTop.frame.size.width, self.viewTop.frame.size.height)
        self.btnChangeImageLeft.frame = CGRectMake(btnsSpaceFromSides, (self.viewTop.frame.size.height - self.btnChangeImageLeft.frame.size.height)/2, self.btnChangeImageLeft.frame.size.width, self.btnChangeImageLeft.frame.size.height)
        self.btnChangeImageRight.frame = CGRectMake(self.viewTop.frame.size.width - btnsSpaceFromSides - self.btnChangeImageRight.frame.size.width, (self.viewTop.frame.size.height - self.btnChangeImageRight.frame.size.height)/2, self.btnChangeImageRight.frame.size.width, self.btnChangeImageRight.frame.size.height)
        
        self.viewTitles.frame = CGRectMake(0, topViewH - viewTitlesH - navBarAndStatusBarH, self.viewTop.frame.size.width, viewTitlesH)
        
        //        self.lblTitle.frame = CGRectMake(self.viewTitles.frame.size.width - self.lblTitle.frame.size.width - titlesSpaceFromRight, titlesSpaceFromTop, self.lblTitle.frame.size.width, self.lblTitle.frame.size.height)
        //
        //        self.lblSubTitle.frame = CGRectMake(self.viewTitles.frame.size.width - self.lblSubTitle.frame.size.width - titlesSpaceFromRight,self.lblTitle.frame.origin.y + self.lblTitle.frame.size.height + titlesSpaceFromTop, self.lblSubTitle.frame.size.width, self.lblSubTitle.frame.size.height)
        //
        //        self.lblDate.frame = CGRectMake(titlesSpaceFromLeft, self.lblSubTitle.frame.origin.y + self.lblSubTitle.frame.size.height - self.lblDate.frame.size.height, self.lblDate.frame.size.width, self.lblDate.frame.size.height)
        
        self.viewBtns.frame = CGRectMake(0, self.viewTop.frame.origin.y + self.viewTop.frame.size.height - navBarAndStatusBarH, self.viewTop.frame.size.width, viewBtnsH)
        self.btnInfo.frame = CGRectMake(self.viewBtns.frame.size.width - self.viewBtns.frame.size.width/2, 0, self.viewBtns.frame.size.width/2, self.viewBtns.frame.size.height)
        self.btnReviews.frame = CGRectMake(0, 0, self.viewBtns.frame.size.width/2, self.viewBtns.frame.size.height)
        self.lblReviewsNumber.frame = CGRectMake(self.btnReviews.titleLabel!.frame.origin.x - (self.lblReviewsNumber.frame.size.width + 1), (self.viewBtns.frame.size.height - (self.lblReviewsNumber.frame.size.height + 1))/2, self.lblReviewsNumber.frame.size.width + 1, self.lblReviewsNumber.frame.size.height + 1)
        self.lblSeperator.frame = CGRectMake((self.viewBtns.frame.size.width - 1)/2, 0, 1, self.viewBtns.frame.size.height)
        self.lblInfoUnderLbl.frame = CGRectMake(self.btnInfo.frame.origin.x, self.btnInfo.frame.origin.y + self.btnInfo.frame.size.height - 2, self.btnInfo.frame.size.width, 2)
        self.lblReviewsUnderLbl.frame = CGRectMake(self.btnReviews.frame.origin.x, self.btnReviews.frame.origin.y + self.btnReviews.frame.size.height - 2, self.btnReviews.frame.size.width, 2)
        
        self.viewReviews.frame = CGRectMake(0, self.viewBtns.frame.origin.y + self.viewBtns.frame.size.height, self.viewBtns.frame.size.width, UIScreen.mainScreen().bounds.size.height - navBarAndStatusBarH - (self.viewBtns.frame.origin.y + self.viewBtns.frame.size.height))
        self.tableView.frame = CGRectMake(0, 0, self.viewReviews.frame.size.width, self.viewReviews.frame.size.height)
        self.viewInfo.frame = self.viewReviews.frame
    }
    
    func changeToInfoView(sender: AnyObject){
        self.lblInfoUnderLbl.backgroundColor = UIColor.purpleMedium()
        self.lblReviewsUnderLbl.backgroundColor = UIColor.grayMedium()
        self.viewInfo.hidden = false
        self.viewReviews.hidden = true
    }
    
    func changeToReviewsView(sender: AnyObject){
        self.lblInfoUnderLbl.backgroundColor = UIColor.grayMedium()
        self.lblReviewsUnderLbl.backgroundColor = UIColor.purpleMedium()
        self.viewInfo.hidden = true
        self.viewReviews.hidden = false
    }
    
    func fillInfoView(){
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 100
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.currGogglePlaceItem.reviews.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell: CategoryItemCell = tableView.dequeueReusableCellWithIdentifier("CategoryItemCell") as! CategoryItemCell
        
        let currReview = currGogglePlaceItem.reviews[indexPath.row]
        cell.frame = CGRectMake(0,0,self.tableView.frame.size.width,100)
        cell.lblUserName.text = currReview.author_name
        cell.lblReview.text = currReview.text
        cell.setSubviewsFrames()
        return cell
    }
    
}

class ReviewCell: UITableViewCell{
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblReview: UILabel!
    
    let spaceFromRight = CGFloat(19.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setSubviewsConfig()
    }
    
    func setSubviewsConfig(){
        self.lblUserName.text = ""
        self.lblUserName.textColor = UIColor.purpleHome()
        self.lblUserName.backgroundColor = UIColor.clearColor()
        self.lblUserName.textAlignment = NSTextAlignment.Right
        self.lblUserName.font = UIFont(name: "spacer", size: 17)
        
        self.lblReview.text = ""
        self.lblReview.textColor = UIColor.purpleHome()
        self.lblReview.backgroundColor = UIColor.clearColor()
        self.lblReview.textAlignment = NSTextAlignment.Left
        self.lblReview.font = UIFont(name: "spacer", size: 15)
        self.lblReview.numberOfLines = 0
        self.lblReview.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.lblReview.frame = CGRectMake(0, 0, self.frame.size.width - spaceFromRight * 2, 0)
        
        self.backgroundColor = UIColor.clearColor()
    }
    
    func setSubviewsFrame(){
        
        let spaceFromTop = CGFloat(11.0)
        let spaceBetweenLbls = CGFloat(5)
        
        self.lblUserName.sizeToFit()
        self.lblReview.sizeToFit()//sizeThatFits(CGSizeMake(self.frame.width - spaceFromRight * 2, self.frame.size.height - self.lblUserName.frame.size.height - spaceBetweenLbls))
        
        self.lblUserName.frame = CGRectMake(5, /*spaceFromTop*/2, self.lblUserName.frame.size.width, self.lblUserName.frame.size.height)
        self.lblReview.frame = CGRectMake(5, 10, self.lblReview.frame.size.width, self.lblReview.frame.size.height)
        //        self.lblReview.frame = CGRectMake(5, 22,  self.frame.size.width - spaceFromRight * 2,self.lblReview.frame.size.height)
    }
}

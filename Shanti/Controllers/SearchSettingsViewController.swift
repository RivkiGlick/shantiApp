//
//  SearchSettingsViewController.swift
//  Shanti
//
//  Created by hodaya ohana on 2/5/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

class SearchSettingsViewController: GlobalViewController,PopupViewControllerDelegate {
    
    var lblTitle: UILabel = UILabel()
    var btnApply: UIButton = UIButton()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let countriesView: UIPreferencesCustomView = UIPreferencesCustomView.viewFromNibName("UIPreferencesCustomView") as! UIPreferencesCustomView
    let ageRangeView: UIPreferencesCustomView = UIPreferencesCustomView.viewFromNibName("UIPreferencesCustomView") as! UIPreferencesCustomView
    let religionView: UIPreferencesCustomView = UIPreferencesCustomView.viewFromNibName("UIPreferencesCustomView") as! UIPreferencesCustomView
    let radiusView: UIPreferencesCustomView = UIPreferencesCustomView.viewFromNibName("UIPreferencesCustomView") as! UIPreferencesCustomView
    var btnSkip: UIBarButtonItem!
    
    var scrollView: UIScrollView = UIScrollView()
    var userSearchSettings = UserSearchDef()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewConfig()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
//        if self.scrollView.frame.size.height > self.view.frame.size.height
//        {
            self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.origin.y
        + self.btnApply.frame.origin.y + self.btnApply.frame.size.height+10)
//        }
    }
    
    
    func rotated()
    {
        self.setViewConfig() 
    }

    
    func setViewConfig(){
        self.setNavigationConfig()
        self.setSubviewsGraphics()
        self.setSubviewsFrames()
        self.setCustomViewsTitles()
        self.setCustomViewsActions()
        self.addSubviews()
    }
    
    func setNavigationConfig(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "top_search.png"), forBarMetrics: UIBarMetrics.Default)
        self.title = NSLocalizedString("People Search settings", comment: "")  as String/*"הגדרות חיפוש משתמש"*/
        
        var skip = UIButton()
        skip.setTitle(NSLocalizedString("Skip", comment: "")  as String/*"דלג"*/, forState: UIControlState.Normal)
        skip.setTitle(NSLocalizedString("Skip", comment: "")  as String/*"דלג"*/, forState: UIControlState.Highlighted)
        skip.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        skip.titleLabel?.font = UIFont(name: "spacer", size: 15)
        skip.sizeToFit()
        skip.addTarget(self, action: "setUserPreferences:", forControlEvents: UIControlEvents.TouchUpInside)
        btnSkip = UIBarButtonItem(customView: skip)
        self.navigationItem.setRightBarButtonItem(self.btnSkip, animated: true)
        
        var controllers = self.navigationController?.viewControllers as [AnyObject]!
        
        for view in controllers{
            if view.isKindOfClass(UsersListViewController){
                self.navigationItem.rightBarButtonItem = nil // has to append after setNavigationConfig func
                break
            }
        }
    }
    
    func setSubviewsGraphics(){
        self.lblTitle.text = NSLocalizedString("Select the characteristics of the members you wish to meet", comment: "")  as String /*"בחר את מאפייני החברים שתרצה להכיר"*/
        self.lblTitle.textColor = UIColor.purpleHome()
        self.lblTitle.font = UIFont(name: "spacer", size: 15)
        self.lblTitle.sizeToFit()
        
        self.btnApply.setTitle(NSLocalizedString("Confirmation", comment: "")  as String/*"אישור"*/, forState: UIControlState.Normal)
        self.btnApply.setTitle(NSLocalizedString("Confirmation", comment: "")  as String/*"אישור"*/, forState: UIControlState.Highlighted)
        self.btnApply.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.btnApply.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        self.btnApply.titleLabel!.textAlignment = NSTextAlignment.Center
        self.btnApply.backgroundColor = UIColor(red: 176.0/255.0, green: 0.0/255.0, blue: 247.0/255.0, alpha: 0.8)
        self.btnApply.titleLabel!.font = UIFont(name: "spacer", size: 15.0)
        self.btnApply.sizeToFit()
        self.btnApply.layer.cornerRadius = 3.0;
        self.btnApply.layer.shadowRadius = 1.0
        self.btnApply.layer.shadowOffset = CGSizeMake(0, -1.0)
        self.btnApply.layer.shadowColor = UIColor(red: 30/255.0, green: 10/255.0, blue: 40/255.0, alpha: 0.75).CGColor
        
    }
    
    func setSubviewsFrames(){
        let subviewsW = CGFloat(290)
        let subviewsH = CGFloat(51.5)
        let subviewsX = CGFloat((UIScreen.mainScreen().bounds.size.width - subviewsW)/2 )
        let btnHight = CGFloat(46.0)
        
        self.scrollView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        self.lblTitle.frame = CGRectMake((UIScreen.mainScreen().bounds.size.width - self.lblTitle.frame.size.width)/2, 30, self.lblTitle.frame.size.width, self.lblTitle.frame.size.height)
        self.countriesView.frame = CGRectMake(subviewsX, self.lblTitle.frame.origin.y + self.lblTitle.frame.size.height + 17.5, subviewsW, subviewsH)
        self.ageRangeView.frame = CGRectMake(subviewsX, self.countriesView.frame.origin.y + self.countriesView.frame.size.height, subviewsW, subviewsH)
        self.religionView.frame = CGRectMake(subviewsX, self.ageRangeView.frame.origin.y + self.ageRangeView.frame.size.height, subviewsW, subviewsH)
        self.radiusView.frame = CGRectMake(subviewsX, self.religionView.frame.origin.y + self.religionView.frame.size.height, subviewsW, subviewsH)
        self.btnApply.frame = CGRectMake((UIScreen.mainScreen().bounds.size.width - subviewsW)/2, self.radiusView.frame.origin.y + self.radiusView.frame.size.height, subviewsW, btnHight)
//        self.scrollView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, self.btnApply.frame.size.height + self.btnApply.frame.origin.y)

       
    }
    
    func setCustomViewsTitles(){
        self.countriesView.setLblTitleText(NSLocalizedString("Country of residence", comment: "")  as String/*"ארץ מגורים"*/)
        self.ageRangeView.setLblTitleText(NSLocalizedString("Age Range", comment: "")  as String/*"גיל"*/)
        self.religionView.setLblTitleText(NSLocalizedString("Faith", comment: "")  as String/*"דת"*/)
        self.radiusView.setLblTitleText(NSLocalizedString("Radius", comment: "")  as String/*"רדיוס חיפוש"*/)
    }
    
    func setCustomViewsActions(){
        self.countriesView.selectionSwitch.addTarget(self, action: "selectionSwitchDidChange:", forControlEvents: UIControlEvents.TouchUpInside)
        self.ageRangeView.selectionSwitch.addTarget(self, action: "selectionSwitchDidChange:", forControlEvents: UIControlEvents.TouchUpInside)
        self.religionView.selectionSwitch.addTarget(self, action: "selectionSwitchDidChange:", forControlEvents: UIControlEvents.TouchUpInside)
        self.radiusView.selectionSwitch.addTarget(self, action: "selectionSwitchDidChange:", forControlEvents: UIControlEvents.TouchUpInside)
        self.radiusView.selectionSwitch.setOn(true, animated: true)
        self.radiusView.backgroundColor = UIColor.purpleLight()
        self.btnApply.addTarget(self, action: "setUserPreferences:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func addSubviews(){
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.lblTitle)
        self.scrollView.addSubview(self.countriesView)
        self.scrollView.addSubview(self.ageRangeView)
        self.scrollView.addSubview(self.religionView)
        self.scrollView.addSubview(self.radiusView)
        self.scrollView.addSubview(self.btnApply)
    }
    
    func selectionSwitchDidChange(sender: AnyObject){
        let seletionView = sender as! UISwitch
        let customView = seletionView.superview as! UIPreferencesCustomView
        let popupView: PopubViewController = PopubViewController(nibName: "PopubViewController", bundle: nil)
        popupView.parentView = self
        popupView.delegate = self
        if seletionView.on || customView == self.radiusView{
            switch customView {
            case self.countriesView:
                popupView.mode = "Countries"
                break
                
            case self.ageRangeView:
                popupView.mode = "AgeRange"
                break
            case self.religionView:
                popupView.mode = "Religion"
                break
            case self.radiusView:
                popupView.mode = "Radius"
                self.radiusView.selectionSwitch.setOn(true, animated: true)
                break
                
            default:
                break
            }
            
            if (popupView.mode != "") {
                self.presentPopupViewController(popupView, animationType: MJPopupViewAnimationFade)
            }
        }else{
            customView.backgroundColor = UIColor.whiteColor()
        }
        
    }
    
    func didEndSelection(arraySelections: [CodeValue], mode: String) {
        self.dismissPopupViewControllerWithanimationType(MJPopupViewAnimationFade)
        switch mode{
        case "Language":
            break
        case "Countries":
            self.userSearchSettings.Countries.removeAll(keepCapacity: false)
            for (index,element) in enumerate(arraySelections) {
                var val = element.iKeyId
                self.userSearchSettings.Countries.append(val)
            }
            break
        case "AgeRange":
            if let codeVal = (arraySelections as NSArray).objectAtIndex(0) as? CodeValue{
                userSearchSettings.iAgeRangeId = codeVal.iKeyId
            }
            break
        case "Religion":
            if let codeVal = (arraySelections as NSArray).objectAtIndex(0) as? CodeValue{
                userSearchSettings.iReligionId = codeVal.iKeyId
            }
            break
        case "ReligionLevel":
            if let codeVal = (arraySelections as NSArray).objectAtIndex(0) as? CodeValue{
                userSearchSettings.iReligionLevelId = codeVal.iKeyId
            }
            break
        case "Radius":
            if let codeVal = (arraySelections as NSArray).objectAtIndex(0) as? CodeValue{
                userSearchSettings.iRadiusId = codeVal.iKeyId
            }
            break
        default:
            break
        }
        
        self.checkSelectionCount(mode)
    }
    
    func checkSelectionCount(mode: String){
        switch mode{
        case "Countries":
            if userSearchSettings.Countries.count <= 0{
                self.countriesView.selectionSwitch.setOn(false, animated: true)
                self.countriesView.backgroundColor = UIColor.whiteColor()
            }else{
                self.countriesView.selectionSwitch.setOn(true, animated: true)
                self.countriesView.backgroundColor = UIColor.purpleLight()
                for (index, element) in enumerate(self.userSearchSettings.Countries) {
                    println("element= \(element)")
                    if element == -1{
                        self.countriesView.selectionSwitch.setOn(false, animated: true)
                        self.countriesView.backgroundColor = UIColor.whiteColor()
                        break
                    }
                }
            }
            break
        case "AgeRange":
            if userSearchSettings.iAgeRangeId == -1{
                self.ageRangeView.selectionSwitch.setOn(false, animated: true)
                self.ageRangeView.backgroundColor = UIColor.whiteColor()
            }else{
                self.ageRangeView.selectionSwitch.setOn(true, animated: true)
                self.ageRangeView.backgroundColor = UIColor.purpleLight()
            }
            break
        case "Religion":
            if userSearchSettings.iReligionId == -1{
                self.religionView.selectionSwitch.setOn(false, animated: true)
                self.religionView.backgroundColor = UIColor.whiteColor()
            }else{
                self.religionView.selectionSwitch.setOn(true, animated: true)
                self.religionView.backgroundColor = UIColor.purpleLight()
            }
            break
        case "ReligionLevel":
            if userSearchSettings.iReligionLevelId == -1{
            }else{
            }
            break
        case "Radius":
            if userSearchSettings.iRadiusId == -1{
                self.radiusView.selectionSwitch.setOn(false, animated: true)
                self.radiusView.backgroundColor = UIColor.whiteColor()
            }else{
                self.radiusView.selectionSwitch.setOn(true, animated: true)
                self.radiusView.backgroundColor = UIColor.purpleLight()
            }
            break
        default:
            break
        }
    }
    
    func setUserPreferences(sender: AnyObject)
    {
        if self.userSearchSettings.iUserId == 0
        {
            self.userSearchSettings.iUserId = 10
        }
        
        var userSettingsDict = ["newUserDef":UserSearchDef.getUserSearchDefDict(self.userSearchSettings)]
        var generic = Generic()
        generic.showNativeActivityIndicator(self)
        Connection.connectionToService("SetUserSearchDef", params: userSettingsDict, completion: {
            data -> Void in
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("SetUserSearchDef:\(strData)")
            generic.hideNativeActivityIndicator(self)
            var err: NSError?
            if strData == "1"
            {
                var controllers = self.navigationController?.viewControllers as [AnyObject]!
                var index = controllers.count
                let topView: AnyObject = controllers[index-2]
                
                
                
                if topView.isKindOfClass(FillingDetailsViewController)
                {
                    let loginView: LoginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewControllerId") as! LoginViewController
                    self.navigationController!.pushViewController(loginView, animated: true)
                }
                else
                {
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    
                }
            }
            else
            {
                var alert = UIAlertController(title: "", message: "Your group created successfuly", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:{ action in action.style
                    let loginView: LoginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewControllerId") as! LoginViewController
                    self.navigationController!.pushViewController(loginView, animated: true)
                }))
            }
        })
    }
    
    func update() {
        var generic = Generic()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.timerCount++
        println(" appDelegate.timerCount++:\(appDelegate.timerCount)")
        
        if appDelegate.isLoginQb
        {
            
            let mainPage: UsersListViewController = self.storyboard!.instantiateViewControllerWithIdentifier("UsersListViewControllerID") as! UsersListViewController
            self.navigationController!.pushViewController(mainPage, animated: true)
            generic.hideNativeActivityIndicator(self)
            appDelegate.timer.invalidate()
        }
        else
        {
            if   appDelegate.timerCount==1000
            {
                var alert = UIAlertController(title: "error", message: "login in quickblox failed", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "אישור", style: UIAlertActionStyle.Cancel, handler: {
                    action -> Void in
                    
                    println()
                }))
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
        }
        // Something cool
    }

    
    //FIXME:prefix
    func didEndSelectionKey(arraySelections: [KeyValue], mode: String)
        
    {
        
    }
}

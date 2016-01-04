//
//  FriendProfileViewController.swift
//  Shanti
//
//  Created by hodaya ohana on 5/14/15.
//  Copyright (c) 2015 webit. All rights reserved.
//NSLocalizedString("", comment: "") as String /*

import UIKit

class FriendProfileViewController: GlobalViewController {
    
    @IBOutlet weak var viewPrivetDetiles: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewGeneralDitales: UIView!
    @IBOutlet weak var scrollViewPrivateDetiles: UIScrollView!
    @IBOutlet weak var viewImgProfileBg: UIView!
    @IBOutlet weak var imgProfileBg: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserInfo: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblShantiName: UILabel!
    @IBOutlet weak var lblRestDetailes: UILabel!
    @IBOutlet weak var scrollViewGeneralDitales: UIScrollView!
    @IBOutlet weak var lblProfileTitle: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblLanguege: UILabel!
    @IBOutlet weak var lblReligion: UILabel!
    @IBOutlet weak var lblProfession: UILabel!
    @IBOutlet weak var lblReligionLevel: UILabel!
    @IBOutlet weak var lblHobby: UILabel!
    @IBOutlet weak var lblMoreAbout: UILabel!
    
    @IBOutlet weak var txtFieldMoreAbout: UITextView!
    @IBOutlet weak var lblHobby_user: UILabel!
    @IBOutlet weak var lblProfession_user: UILabel!
    @IBOutlet weak var lblReligionLevel_user: UILabel!
    @IBOutlet weak var lblReligion_user: UILabel!
    @IBOutlet weak var lblLanguege_user: UILabel!
    @IBOutlet weak var lblContry_user: UILabel!
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setConfig()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setConfig(){
        self.setNavigationController()
        self.setSubviewsConfig()
        self.setSubviewsFrames()
    }
    
    func setNavigationController(){
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.purpleHome()
        self.navigationController?.navigationBar.setBackgroundImage(ImageProcessor.imageWithColor(UIColor.purpleHome()), forBarMetrics: UIBarMetrics.Default)
        self.navigationItem.rightBarButtonItem = nil
        self.title = NSLocalizedString("Personal Profile", comment: "") as String /*"פרופיל משתמש"*/
    }
    
    func setSubviewsConfig(){
        self.scrollView.backgroundColor = UIColor.offwhiteDark()
        
                self.view.autoresizesSubviews = false
        
        viewGeneralDitales.layer.shadowColor = UIColor.grayMedium().CGColor
        viewGeneralDitales.layer.shadowOpacity = 1
        viewGeneralDitales.layer.shadowOffset = CGSizeMake(0, 1)
        viewGeneralDitales.layer.shadowRadius = 1.0
        
        viewPrivetDetiles.layer.shadowColor = UIColor.grayMedium().CGColor
        viewPrivetDetiles.layer.shadowOpacity = 1
        viewPrivetDetiles.layer.shadowOffset = CGSizeMake(0, 1)
        viewPrivetDetiles.layer.shadowRadius = 1.0
        
        
        
        
        
        //scrollViewGroupDetails
//        self.scrollViewPrivateDetiles.backgroundColor = UIColor.offwhiteBasic()
        
        self.lblUserName.text = "\(self.user.nvShantiName)"//"\(self.user.nvFirstName) \(self.user.nvLastName)"
        self.lblUserName.textColor = UIColor.grayDark()
        self.lblUserName.font = UIFont(name: "spacer", size: 19)
        self.lblUserName.backgroundColor = UIColor.clearColor()
        self.lblUserName.sizeToFit()
        var a = (NSLocalizedString("Member in", comment: "") as String)
        var b = (self.user.iNumGroupAsMemberUser)
        var c = (NSLocalizedString("Groups", comment: "") as String)
        var d = (self.user.iNumGroupAsMainUser)
        var e = (NSLocalizedString("and administrator", comment: "") as String)
        self.lblUserInfo.text = "\(a) \(b) \(e) \(d) \(b)"
        
        
        //        self.lblUserInfo.text = "חבר ב\(self.user.iNumGroupAsMemberUser) קבוצות ומנהל \(self.user.iNumGroupAsMainUser) קבוצות"
        self.lblUserInfo.textColor = UIColor.grayMedium()
        self.lblUserInfo.font = UIFont(name: "spacer", size: 15)
        self.lblUserInfo.backgroundColor = UIColor.clearColor()
        self.lblUserInfo.sizeToFit()
        var a1 = NSLocalizedString("Shanti Name", comment: "") as String//שם שאנטי
        self.lblShantiName.text = "\(a1): \(self.user.nvShantiName)"
        self.lblShantiName.textColor = UIColor.grayMedium()
        self.lblShantiName.font = UIFont(name: "spacer", size: 15)
        self.lblShantiName.backgroundColor = UIColor.clearColor()
        self.lblShantiName.sizeToFit()
        
//        var calendar : NSCalendar = NSCalendar.currentCalendar()
//        var now = NSDate()
//        let dateFormatter2 = NSDateFormatter()
//        dateFormatter2.dateFormat = "mm/dd/yyyy"
//        let date = dateFormatter2.dateFromString(user.dtBirthDate)
//        
////        var bbb = NSCalendar.currentCalendar().components(.CalendarUnitYear, fromDate: birthday!, toDate: NSDate(), options: nil).year
//        
////        let ageComponents = calendar.components(.CalendarUnitYear,
////            fromDate: birthday!,
////            toDate: now,
////            options: nil)
////        let age = ageComponents.year
//
//        self.lblAge.text = ("\(age)")
        self.lblAge.textColor = UIColor.grayMedium()
        self.lblAge.font = UIFont(name: "spacer", size: 15)
        self.lblAge.backgroundColor = UIColor.clearColor()
        self.lblAge.sizeToFit()
        
        var gendersArr: [CodeValue] = ApplicationData.sharedApplicationDataInstance.gendersArry as NSArray as! [CodeValue]
        var gender = gendersArr.filter{ $0.iKeyId == self.user.iGenderId }.first
        self.lblRestDetailes.text = gender?.nvValue
        self.lblRestDetailes.textColor = UIColor.grayMedium()
        self.lblRestDetailes.font = UIFont(name: "spacer", size: 15)
        self.lblRestDetailes.backgroundColor = UIColor.clearColor()
        self.lblRestDetailes.sizeToFit()
        
        self.viewImgProfileBg.backgroundColor = UIColor.grayLight()
        self.imgProfileBg.contentMode = UIViewContentMode.ScaleAspectFill
        self.imgProfileBg.clipsToBounds = true
        self.imgProfileBg.image = ImageHandler.getImageBase64FromUrl(self.user.nvImage)
        self.imgProfileBg.layer.cornerRadius = 21.5
        
//        self.scrollViewGeneralDitales.backgroundColor = UIColor.offwhiteBasic()
        
        self.lblProfileTitle.text = NSLocalizedString("Personal Profile", comment: "") as String
        /*"פרופיל אישי"*/
        self.lblProfileTitle.textColor = UIColor.grayDark()
        self.lblProfileTitle.font = UIFont(name: "spacer", size: 19)
        self.lblProfileTitle.backgroundColor = UIColor.clearColor()
        self.lblProfileTitle.sizeToFit()
        
        /*var diffWord1 = "הגדרה: "
        var text1 = NSMutableAttributedString(string: "\(diffWord1)\(self.meetingPoint!.nvTitle)")
        text1.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayDark(), range: NSMakeRange(0, countElements(diffWord1) - 1))
        text1.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayMedium(), range: NSMakeRange(countElements(diffWord1) ,countElements(self.meetingPoint!.nvTitle)))*/
        var diffWord1 = NSLocalizedString("Country of origin", comment: "") as String /*"ארץ מוצא: "*/
        var g = ":"
        var text1 = NSMutableAttributedString(string: "\(diffWord1)\(g)\(self.user.oCountry.nvValue)")
        text1.addAttribute(NSForegroundColorAttributeName, value: UIColor.yellowColor(), range: NSMakeRange(0,count(diffWord1) - 1))
        text1.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayMedium(), range: NSMakeRange(count(diffWord1) ,count(self.user.oCountry.nvValue)))
        self.lblCountry.text = NSLocalizedString("Country of origin", comment: "") as String /*"ארץ מוצא: "*/
        
        self.lblContry_user.text = "\(self.user.oCountry.nvValue)"
        self.lblContry_user.font = UIFont(name: "spacer", size: 15)
        self.lblCountry.textColor = UIColor.grayMedium()
        self.lblCountry.font = UIFont(name: "spacer", size: 15)
        self.lblCountry.backgroundColor = UIColor.clearColor()
        self.lblCountry.sizeToFit()
        
        var languages = NSLocalizedString("", comment: "") as String/*"דובר שפות: "*/
        if self.user.oLanguages.count > 0{
            for i in 0...self.user.oLanguages.count{
                if let language = self.user.oLanguages.objectAtIndex(i) as? String{
                    languages = "\(languages), \(language)"
                }
            }
        }
        
        self.lblLanguege.text = NSLocalizedString("Spoken languages", comment: "") as String/*"דובר שפות: "*/
        self.lblLanguege.textColor = UIColor.grayMedium()
        self.lblLanguege.font = UIFont(name: "spacer", size: 15)
        self.lblLanguege.backgroundColor = UIColor.clearColor()
        self.lblLanguege.sizeToFit()
        self.lblLanguege_user.text = languages
        self.lblLanguege_user.font = UIFont(name: "spacer", size: 15)
        
        var religionsArr: [CodeValue] = ApplicationData.sharedApplicationDataInstance.religionsArry as NSArray as! [CodeValue]
        var religion = religionsArr.filter{ $0.iKeyId == self.user.iReligionId }.first
        var b1 = NSLocalizedString("Faith", comment: "") as String
        self.lblReligion_user.text = (religion != nil) ? "\(religion!.nvValue)" : ""
        self.lblReligion_user.font = UIFont(name: "spacer", size: 15)
        self.lblReligion.text =  NSLocalizedString("Faith", comment: "") as String
        self.lblReligion.textColor = UIColor.grayMedium()
        self.lblReligion.font = UIFont(name: "spacer", size: 15)
        self.lblReligion.backgroundColor = UIColor.clearColor()
        self.lblReligion.sizeToFit()
        
        var religionsLevelArr: [CodeValue] = ApplicationData.sharedApplicationDataInstance.religionLevelArry as NSArray as! [CodeValue]
        var religionLevel = religionsLevelArr.filter{ $0.iKeyId == self.user.iReligiousLevelId }.first
        self.lblReligionLevel.text = NSLocalizedString("Faith affiliation", comment: "") as String/*"יחס לדת: "*/
        self.lblReligionLevel_user.text = (religionLevel != nil) ? "\(religionLevel!.nvValue)" : ""
        self.lblReligionLevel_user.font = UIFont(name: "spacer", size: 15)
        self.lblReligionLevel.textColor = UIColor.grayMedium()
        self.lblReligionLevel.font = UIFont(name: "spacer", size: 15)
        self.lblReligionLevel.backgroundColor = UIColor.clearColor()
        self.lblReligionLevel.sizeToFit()
        
        var c1 = NSLocalizedString("Occupation", comment: "") as String//מקצוע
        self.lblProfession.text = NSLocalizedString("Occupation", comment: "") as String//מקצוע
        self.lblProfession_user.text = ("\(self.user.nvProfession)")
        self.lblProfession_user.font = UIFont(name: "spacer", size: 15)
        self.lblProfession.textColor = UIColor.grayMedium()
        self.lblProfession.font = UIFont(name: "spacer", size: 15)
        self.lblProfession.backgroundColor = UIColor.clearColor()
        self.lblProfession.sizeToFit()
        
        var d1 = NSLocalizedString("Hobby", comment: "") as String//תחביב
        self.lblHobby.text = NSLocalizedString("Hobby", comment: "") as String//תחביב
        self.lblHobby_user.text = "\(self.user.nvProfession)"
        self.lblHobby_user.font = UIFont(name: "spacer", size: 15)
        self.lblHobby.textColor = UIColor.grayMedium()
        self.lblHobby.font = UIFont(name: "spacer", size: 15)
        self.lblHobby.backgroundColor = UIColor.clearColor()
        self.lblHobby.sizeToFit()
        
        self.lblMoreAbout.text =  NSLocalizedString("More about", comment: "") as String//עוד על
        self.txtFieldMoreAbout.text =  "\(self.user.nvShantiName):\n"
        self.txtFieldMoreAbout.font = UIFont(name: "spacer", size: 15)
        self.lblMoreAbout.textColor = UIColor.grayMedium()
        self.lblMoreAbout.font = UIFont(name: "spacer", size: 15)
        self.lblMoreAbout.backgroundColor = UIColor.clearColor()
        self.lblMoreAbout.frame = CGRectMake(self.lblMoreAbout.frame.origin.x, self.lblMoreAbout.frame.origin.y, 280, self.lblMoreAbout.frame.size.height)
        self.lblMoreAbout.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.lblMoreAbout.numberOfLines = 0
        self.lblMoreAbout.sizeToFit()
        //        self.lblMoreAbout.hidden = true
    }
    
    func setSubviewsFrames(){
        //        let scrollViewPrivate = CGFloat(120)
        //        let spaceFromRightPrivate = CGFloat(12)
        //      let spaceFromtop = spaceFromRightPrivate
        let viewImgS = CGFloat(100.5)
        let imgProfileS = CGFloat(96)
        let spaceBetweenViewImgToLbls = CGFloat(15)
        let spaceBetweenLbls = CGFloat(12)
        let spaceBetweenTitleLblToTopViewImg = CGFloat(3)
        let spaceBetweenScrolls = CGFloat(10)
        let scrollViewGeneral = CGFloat(367.5)
        let spaceFromRightGeneral = CGFloat(18)
        let spaceFromtopGeneral = spaceFromRightGeneral
        
        if self.view.frame.size.height < self.scrollViewGeneralDitales.frame.size.height + self.scrollViewGeneralDitales.frame.origin.y
        {
            self.scrollViewGeneralDitales.contentSize = CGSize(width: self.scrollViewGeneralDitales.frame.size.width,height: self.scrollViewGeneralDitales.frame.size.height)
        }
    }
}

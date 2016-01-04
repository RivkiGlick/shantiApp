//
//  UserProfileViewController.swift
//  Shanti
//
//  Created by hodaya ohana on 2/18/15.
//  Copyright (c) 2015 webit. All rights reserved.
//NSLocalizedString("", comment: "") as String

import UIKit

class UserProfileViewController: GlobalViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UITextViewDelegate,PopupViewControllerDelegate,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewImageProfile: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnChangePic: UIButton!
    @IBOutlet weak var btnTakePic: UIButton!
    @IBOutlet weak var btnDeletePic: UIButton!
    @IBOutlet weak var viewSeperator1: UIView!
    @IBOutlet weak var viewSeperator2: UIView!
    
    @IBOutlet weak var viewPersonalDetails: UIView!
    @IBOutlet weak var lblPersonalDetails: UILabel!
    @IBOutlet weak var btnPersonalDetails: UIButton!
    
    @IBOutlet weak var viewPersonalProfile: UIView!
    @IBOutlet weak var lblPersonalProfile: UILabel!
    @IBOutlet weak var btnPersonalProfile: UIButton!
    
    @IBOutlet weak var viewRestDetails: UIView!
    @IBOutlet weak var lblRestDetails: UILabel!
    @IBOutlet weak var btnRestDetails: UIButton!
    
    @IBOutlet weak var viewInScrollView: UIView!
    
    @IBOutlet weak var constraintButtom: NSLayoutConstraint!
    
    var txtEmail = UITextField()
    var txtPassword = UITextField()
    var txtFirstName = UITextField()
    var txtLastName = UITextField()
    var txtPhone = UITextField()
    
    var txtCountry = UITextField()
    var txtBirthday = UITextField()
    var txtGender = UITextField()
    var txtReligion = UITextField()
    //    var txtReligionLevel = UITextField()
    
    var txtProfession = UITextField()
    var txtHobby = UITextField()
    var txtLanguages = UITextField()
    var txtMoreDetails = UITextView()
    
    var btnSaveChanges: UIBarButtonItem!
    var datePicker: UIDatePicker = UIDatePicker()
    
    var currUser: User = ActiveUser.sharedInstace
    let spaceBetweenViews = CGFloat(8.0)
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constraintButtom.constant = -1500
        self.view.layoutIfNeeded()
        self.setSubviewsConfig()
        
    }
   
    
    func setSubviewsConfig(){
        self.currUser.nvImage = ""
        
        var toolBar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 44))
        var toolBarBtn = UIBarButtonItem(title: NSLocalizedString(NSLocalizedString("Select", comment: "") as String/*"בחר"*/, comment: ""), style: .Plain, target: self, action: "toolBarItemClicked:")
        toolBar.setItems([toolBarBtn], animated: true)
        toolBar.backgroundColor = datePicker.backgroundColor
        
        datePicker.datePickerMode = UIDatePickerMode.Date
        
        self.txtBirthday.inputView = datePicker
        self.txtBirthday.inputAccessoryView = toolBar
        
        self.setNavigationSettings()
        self.setSubvoewsGraphics()
        self.setSubviewsFrame()
        
        //        let tapGesture = UITapGestureRecognizer(target: self, action: "dismissControllers:")
        //        tapGesture.delegate = self
        //        self.view.addGestureRecognizer(tapGesture)
        //        self.scrollView.addGestureRecognizer(tapGesture)
        //        self.viewImageProfile.addGestureRecognizer(tapGesture)
        //        self.viewPersonalDetails.addGestureRecognizer(tapGesture)
        //        self.viewPersonalProfile.addGestureRecognizer(tapGesture)
    }
    
    //    func dismissControllers(sender: AnyObject){
    //        for view in self.scrollView.subviews{
    //            if view.isKindOfClass(UIView){
    //                let currView = view as UIView
    //                for txt in currView.subviews{
    //                    if txt.isKindOfClass(UITextField) || txt.isKindOfClass(UITextView){
    //                        txt.resignFirstResponder()
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    func setNavigationSettings(){
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.purpleHome()
        self.navigationController?.navigationBar.setBackgroundImage(ImageProcessor.imageWithColor(UIColor.purpleHome()), forBarMetrics: UIBarMetrics.Default)
        self.title = NSLocalizedString("My profile", comment: "") as String/*"הפרופיל שלי"*/
        
        var saveChanges = UIButton()
        saveChanges.setTitle(NSLocalizedString("Save changes", comment: "") as String/*"שמור שינויים"*/, forState: UIControlState.Normal)
        saveChanges.setTitle(NSLocalizedString("Save changes", comment: "") as String/*"שמור שינויים"*/, forState: UIControlState.Highlighted)
        saveChanges.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        saveChanges.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
//        saveChanges.titleLabel?.font = UIFont(name: "spacer", size: 17.5)
        saveChanges.backgroundColor = UIColor.clearColor()
//        saveChanges.sizeToFit()
        saveChanges.frame = CGRectMake((self.navigationController!.navigationBar.bounds.size.width - saveChanges.frame.size.width)/2 - 10, (self.navigationController!.navigationBar.bounds.size.height - saveChanges.frame.size.height)/2, saveChanges.frame.size.width, saveChanges.frame.size.height)
        saveChanges.addTarget(self, action: "saveUserUpdates:", forControlEvents: UIControlEvents.TouchUpInside)
        btnSaveChanges = UIBarButtonItem(customView: saveChanges)
        
    }
    
    func setSubvoewsGraphics(){
        self.view.autoresizesSubviews = false
        
        for view in self.view.subviews{
            if view.isKindOfClass(UIView){
                view.layer.shadowColor = UIColor.grayMedium().CGColor
                view.layer.shadowOpacity = 1
                view.layer.shadowOffset = CGSizeMake(0, 1)
                view.layer.shadowRadius = 1.0
            }
        }
       
        
        
//        var btnsFont = UIFont(name: "spacer", size: 17.0)
//        var lblsFont = UIFont(name: "spacer", size: 19.0)
        var viewsBgColor = UIColor.offwhiteBasic()
        
//        self.view.backgroundColor = UIColor.offwhiteDark()
//        self.scrollView.backgroundColor = UIColor.clearColor()
        
        //viewImageProfile
//        self.viewImageProfile.backgroundColor = viewsBgColor
        
        self.imgProfile.contentMode = UIViewContentMode.ScaleAspectFill
        self.imgProfile.clipsToBounds = true
        self.imgProfile.layer.cornerRadius = 20.0
       
//        self.imgProfile.layer.borderWidth = 8.0
//        self.imgProfile.layer.borderColor = UIColor.grayMedium().CGColor
        self.imgProfile.image = self.currUser.image
        
//        self.btnChangePic.titleLabel?.font = btnsFont
//        self.btnChangePic.setTitleColor(UIColor.grayMedium(), forState: UIControlState.Normal)
//        self.btnChangePic.setTitleColor(UIColor.grayMedium(), forState: UIControlState.Highlighted)
        self.btnChangePic.setTitle(NSLocalizedString("Replace", comment: "") as String/*"החלף"*/, forState: UIControlState.Normal)
        self.btnChangePic.setTitle(NSLocalizedString("Replace", comment: "") as String/*"החלף"*/, forState: UIControlState.Highlighted)
        self.btnChangePic.addTarget(self, action: "changeProfileImage:", forControlEvents:  UIControlEvents.TouchUpInside)
//        self.btnChangePic.sizeToFit()
        
//        self.btnTakePic.titleLabel?.font = btnsFont
//        self.btnTakePic.setTitleColor(UIColor.grayMedium(), forState: UIControlState.Normal)
//        self.btnTakePic.setTitleColor(UIColor.grayMedium(), forState: UIControlState.Highlighted)
        self.btnTakePic.setTitle(NSLocalizedString("Take another picture", comment: "") as String/*"צלם שוב"*/, forState: UIControlState.Normal)
        self.btnTakePic.setTitle(NSLocalizedString("Take another picture", comment: "") as String/*"צלם שוב"*/, forState: UIControlState.Highlighted)
        self.btnTakePic.addTarget(self, action: "takeNewProfileImagePic:", forControlEvents: UIControlEvents.TouchUpInside)
//        self.btnTakePic.sizeToFit()
        
//        self.btnDeletePic.titleLabel?.font = btnsFont
//        self.btnDeletePic.setTitleColor(UIColor.grayMedium(), forState: UIControlState.Normal)
//        self.btnDeletePic.setTitleColor(UIColor.grayMedium(), forState: UIControlState.Highlighted)
        self.btnDeletePic.setTitle(NSLocalizedString("Delete", comment: "") as String/*"מחק"*/, forState: UIControlState.Normal)
        self.btnDeletePic.setTitle(NSLocalizedString("Delete", comment: "") as String/*"מחק"*/, forState: UIControlState.Highlighted)
        self.btnDeletePic.addTarget(self, action: "deleteProfileImagePic:", forControlEvents: UIControlEvents.TouchUpInside)
//        self.btnDeletePic.sizeToFit()
        //        self.btnDeletePic.hidden = true
        
//        self.viewSeperator1.backgroundColor = UIColor.grayMedium()
//        self.viewSeperator2.backgroundColor = UIColor.grayMedium()
        
        //viewPersonalDetails
//        self.viewPersonalDetails.backgroundColor = viewsBgColor
        
        self.lblPersonalDetails.text = NSLocalizedString("Personal details", comment: "") as String /*"פרטים אישיים"*/
//        self.lblPersonalDetails.sizeToFit()
        
//        self.btnPersonalDetails.titleLabel?.font = btnsFont
//        self.btnPersonalDetails.setTitleColor(UIColor.grayMedium(), forState: UIControlState.Normal)
//        self.btnPersonalDetails.setTitleColor(UIColor.grayMedium(), forState: UIControlState.Highlighted)
        self.btnPersonalDetails.setTitle(NSLocalizedString("Edit", comment: "") as String/*"ערוך"*/, forState: UIControlState.Normal)
        self.btnPersonalDetails.setTitle(NSLocalizedString("Edit", comment: "") as String/*"ערוך"*/, forState: UIControlState.Highlighted)
//        self.btnPersonalDetails.sizeToFit()
        self.btnPersonalDetails.addTarget(self, action: "addViewSection:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //viewPersonalProfile
//        self.viewPersonalProfile.backgroundColor = viewsBgColor
        
        self.lblPersonalProfile.text = NSLocalizedString("Personal Profile", comment: "") as String/*"פרופיל אישי"*/
//        self.lblPersonalProfile.sizeToFit()
        
//        self.btnPersonalProfile.titleLabel?.font = btnsFont
//        self.btnPersonalProfile.setTitleColor(UIColor.grayMedium(), forState: UIControlState.Normal)
//        self.btnPersonalProfile.setTitleColor(UIColor.grayMedium(), forState: UIControlState.Highlighted)
        self.btnPersonalProfile.setTitle(NSLocalizedString("Edit", comment: "") as String/*"ערוך"*/, forState: UIControlState.Normal)
        self.btnPersonalProfile.setTitle(NSLocalizedString("Edit", comment: "") as String/*"ערוך"*/, forState: UIControlState.Highlighted)
        self.btnPersonalProfile.addTarget(self, action: "addViewSection:", forControlEvents: UIControlEvents.TouchUpInside)
//        self.btnPersonalProfile.sizeToFit()
        
        //viewRestDetails
//        self.viewRestDetails.backgroundColor = viewsBgColor
        
        self.lblRestDetails.text = NSLocalizedString("Supplemental details", comment: "") as String /*"פרטים משלימים"*/
//        self.lblRestDetails.sizeToFit()
        
//        self.btnRestDetails.titleLabel?.font = btnsFont
//        self.btnRestDetails.setTitleColor(UIColor.grayMedium(), forState: UIControlState.Normal)
//        self.btnRestDetails.setTitleColor(UIColor.grayMedium(), forState: UIControlState.Highlighted)
        self.btnRestDetails.setTitle(NSLocalizedString("Edit", comment: "") as String/*"ערוך"*/, forState: UIControlState.Normal)
        self.btnRestDetails.setTitle(NSLocalizedString("Edit", comment: "") as String/*"ערוך"*/, forState: UIControlState.Highlighted)
        self.btnRestDetails.addTarget(self, action: "addViewSection:", forControlEvents: UIControlEvents.TouchUpInside)
//        self.btnRestDetails.sizeToFit()
    }
    
    func setSubviewsFrame(){
        let viewImageH = CGFloat(120.0)
        let imgSpaceFromViewFrame = CGFloat(15.5)
        let imgSize = CGFloat(79.0)
        let viewsH = CGFloat(70.0)
        let spaceFromRight = CGFloat(17.5)
        let spaceFromleft = CGFloat(20.0)
        let spaceFromBottom = CGFloat(10.0)
        let spaceForSeperator = CGFloat(10.0)
        
//        self.scrollView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height - (self.navigationController!.navigationBar.frame.origin.y + self.navigationController!.navigationBar.frame.size.height))
        self.scrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
//
        //viewImageProfile
//        self.viewImageProfile.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, viewImageH)
//        self.imgProfile.frame = CGRectMake(self.viewImageProfile.frame.size.width - imgSpaceFromViewFrame - imgSize, imgSpaceFromViewFrame, imgSize, imgSize)
//        self.btnChangePic.frame = CGRectMake(spaceFromleft, self.viewImageProfile.frame.size.height - spaceFromBottom - self.btnChangePic.frame.size.height, self.btnChangePic.frame.size.width, self.btnChangePic.frame.size.height)
//        self.viewSeperator1.frame = CGRectMake(self.btnChangePic.frame.origin.x + self.btnChangePic.frame.size.width + spaceForSeperator, self.btnChangePic.frame.origin.y, 1, 22)
//        self.btnTakePic.frame = CGRectMake(self.viewSeperator1.frame.origin.x + self.viewSeperator1.frame.size.width + spaceForSeperator, self.btnChangePic.frame.origin.y, self.btnTakePic.frame.size.width, self.btnTakePic.frame.size.height)
//        self.viewSeperator2.frame = CGRectMake(self.btnTakePic.frame.origin.x + self.btnTakePic.frame.size.width + spaceForSeperator, self.btnTakePic.frame.origin.y, self.viewSeperator1.frame.size.width, self.viewSeperator1.frame.size.height)
//        self.btnDeletePic.frame = CGRectMake(self.viewSeperator2.frame.origin.x + self.viewSeperator2.frame.size.width + spaceForSeperator, self.btnTakePic.frame.origin.y, self.btnDeletePic.frame.size.width, self.btnDeletePic.frame.size.height)
//        
        //viewPersonalDetails
//        self.viewPersonalDetails.frame = CGRectMake(0, self.viewImageProfile.frame.origin.y + self.viewImageProfile.frame.size.height + spaceBetweenViews, UIScreen.mainScreen().bounds.size.width, viewsH)
//        self.lblPersonalDetails.frame = CGRectMake(self.viewPersonalDetails.frame.size.width - spaceFromRight - self.lblPersonalDetails.frame.size.width, (self.viewPersonalDetails.frame.size.height - self.lblPersonalDetails.frame.size.height)/2, self.lblPersonalDetails.frame.size.width, self.lblPersonalDetails.frame.size.height)
//        self.btnPersonalDetails.frame = CGRectMake(spaceFromleft, (self.viewPersonalDetails.frame.size.height - self.btnPersonalDetails.frame.size.height)/2, self.btnPersonalDetails.frame.size.width, self.btnPersonalDetails.frame.size.height)
//        
        //viewPersonalProfile
//        self.viewPersonalProfile.frame = CGRectMake(0, self.viewPersonalDetails.frame.origin.y + self.viewPersonalDetails.frame.size.height + spaceBetweenViews, UIScreen.mainScreen().bounds.size.width, viewsH)
//        self.lblPersonalProfile.frame = CGRectMake(self.viewPersonalProfile.frame.size.width - spaceFromRight - self.lblPersonalProfile.frame.size.width, (self.viewPersonalProfile.frame.size.height - self.lblPersonalProfile.frame.size.height)/2, self.lblPersonalProfile.frame.size.width, self.lblPersonalDetails.frame.size.height)
//        self.btnPersonalProfile.frame = CGRectMake(spaceFromleft, (self.viewPersonalProfile.frame.size.height - self.btnPersonalProfile.frame.size.height)/2, self.btnPersonalProfile.frame.size.width, self.btnPersonalProfile.frame.size.height)
//        
        //viewRestDetails
//        self.viewRestDetails.frame = CGRectMake(0, self.viewPersonalProfile.frame.origin.y + self.viewPersonalProfile.frame.size.height + spaceBetweenViews, UIScreen.mainScreen().bounds.size.width, viewsH)
//        self.lblRestDetails.frame = CGRectMake(self.viewRestDetails.frame.size.width - spaceFromRight - self.lblRestDetails.frame.size.width, (self.viewRestDetails.frame.size.height - self.lblRestDetails.frame.size.height)/2, self.lblRestDetails.frame.size.width, self.lblRestDetails.frame.size.height)
//        self.btnRestDetails.frame = CGRectMake(spaceFromleft, (self.viewRestDetails.frame.size.height - self.btnRestDetails.frame.size.height)/2, self.btnRestDetails.frame.size.width, self.btnRestDetails.frame.size.height)
//        
    }
    
    func changeProfileImage(sender: AnyObject){
        if self.navigationItem.rightBarButtonItem != self.btnSaveChanges{
            self.navigationItem.setRightBarButtonItem(self.btnSaveChanges, animated: true)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            var imag = UIImagePickerController()
            imag.delegate = self
            imag.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imag.allowsEditing = false
            
            self.presentViewController(imag, animated: true, completion: nil)
        }
    }
    
    func takeNewProfileImagePic(sender: AnyObject){
        if self.navigationItem.rightBarButtonItem != self.btnSaveChanges{
            self.navigationItem.setRightBarButtonItem(self.btnSaveChanges, animated: true)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            var imag = UIImagePickerController()
            imag.delegate = self
            imag.sourceType = UIImagePickerControllerSourceType.Camera;
            imag.allowsEditing = false
            
            self.presentViewController(imag, animated: true, completion: nil)
        }
        
    }
    
    func deleteProfileImagePic(sender: AnyObject){
        if self.navigationItem.rightBarButtonItem != self.btnSaveChanges{
            self.navigationItem.setRightBarButtonItem(self.btnSaveChanges, animated: true)
        }
        
        self.imgProfile.image = UIImage(named: "userDefaultImg.png")
        self.currUser.nvImage = ImageHandler.convertImageToString(ImageHandler.scaledImage(self.imgProfile.image, newSize: CGSizeMake(115, 115)))//ImageHandler.convertImageToString(ImageHandler.compressUserImage(self.imgProfile.image))
    }
    
   func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!){
        self.dismissViewControllerAnimated(true, completion: nil)
        self.imgProfile.image = image
        self.currUser.nvImage = ImageHandler.convertImageToString(ImageHandler.scaledImage(self.imgProfile.image, newSize: CGSizeMake(115, 115)))//ImageHandler.convertImageToString(ImageHandler.compressUserImage(self.imgProfile.image))
    }
    
    func addViewSection(sender: AnyObject){
        if let currBtn = sender as? UIButton{
            self.getViewForSection(currBtn)
            currBtn.setTitle(NSLocalizedString("Close", comment: "") as String/*"סגור"*/, forState: UIControlState.Normal)
            currBtn.setTitle(NSLocalizedString("Close", comment: "") as String/*"סגור"*/, forState: UIControlState.Highlighted)
            currBtn.removeTarget(self, action: "addViewSection:", forControlEvents: UIControlEvents.TouchUpInside)
            currBtn.addTarget(self, action: "closeSection:", forControlEvents: UIControlEvents.TouchUpInside)
        }
    }
    
    func closeSection(ofBtn: UIButton){
        ofBtn.setTitle(NSLocalizedString("Edit", comment: "") as String/*"ערוך"*/, forState: UIControlState.Normal)
        ofBtn.setTitle(NSLocalizedString("Edit", comment: "") as String/*"ערוך"*/, forState: UIControlState.Highlighted)
        
        ofBtn.removeTarget(self, action: "closeSection:", forControlEvents: UIControlEvents.TouchUpInside)
        ofBtn.addTarget(self, action: "addViewSection:", forControlEvents: UIControlEvents.TouchUpInside)
        
        switch (ofBtn){
        case self.btnPersonalDetails:
            removeUITextField(self.viewPersonalDetails)
          changeFrames("PersonalDetails")
            
        case self.btnPersonalProfile:
            removeUITextField(self.viewPersonalProfile)
           changeFrames("PersonalProfile")
        case self.btnRestDetails:
            removeUITextField(self.viewRestDetails)
           changeFrames("RestDetails")
        default:
            break
        }
        
    }
    
    // remove all UITextField From Superview
    func removeUITextField(removeFromView: UIView){
        for view in removeFromView.subviews{
            if view.isKindOfClass(UITextField) || view.isKindOfClass(UITextView){
                view.removeFromSuperview()}
        }
    }
    // click on "סגור" change the frames
    func changeFrames(changeByView:NSString){
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(1)
        switch (changeByView){
        case "PersonalDetails":
            self.viewPersonalDetails.frame = CGRectMake(self.viewPersonalDetails.frame.origin.x, self.viewPersonalDetails.frame.origin.y, self.viewPersonalDetails.frame.size.width, 70.0)
            self.viewPersonalProfile.frame = CGRectMake(/*0*/self.viewPersonalDetails.frame.origin.x, self.viewPersonalDetails.frame.origin.y + self.viewPersonalDetails.frame.size.height + spaceBetweenViews, self.viewPersonalProfile.frame.size.width, self.viewPersonalProfile.frame.size.height)
            self.viewRestDetails.frame = CGRectMake(/*0*/self.viewPersonalDetails.frame.origin.x, self.viewPersonalProfile.frame.origin.y + self.viewPersonalProfile.frame.size.height + spaceBetweenViews, self.viewRestDetails.frame.size.width, self.viewRestDetails.frame.size.height)
           
        case "PersonalProfile":
            self.viewPersonalDetails.frame = CGRectMake(self.viewPersonalDetails.frame.origin.x, self.viewPersonalDetails.frame.origin.y, self.viewPersonalDetails.frame.size.width, self.viewPersonalDetails.frame.size.height)
            self.viewPersonalProfile.frame = CGRectMake(/*0*/self.viewPersonalDetails.frame.origin.x, self.viewPersonalDetails.frame.origin.y + self.viewPersonalDetails.frame.size.height + spaceBetweenViews, self.viewPersonalProfile.frame.size.width, 70.0)
            self.viewRestDetails.frame = CGRectMake(/*0*/self.viewPersonalDetails.frame.origin.x, self.viewPersonalProfile.frame.origin.y + self.viewPersonalProfile.frame.size.height + spaceBetweenViews, self.viewRestDetails.frame.size.width, self.viewRestDetails.frame.size.height)
        
        case "RestDetails":
            self.viewPersonalDetails.frame = CGRectMake(self.viewPersonalDetails.frame.origin.x, self.viewPersonalDetails.frame.origin.y, self.viewPersonalDetails.frame.size.width, viewPersonalDetails.frame.size.height)
            self.viewPersonalProfile.frame = CGRectMake(/*0*/self.viewPersonalDetails.frame.origin.x, self.viewPersonalDetails.frame.origin.y + self.viewPersonalDetails.frame.size.height + spaceBetweenViews, self.viewPersonalProfile.frame.size.width, self.viewPersonalProfile.frame.size.height)
            self.viewRestDetails.frame = CGRectMake(/*0*/self.viewPersonalDetails.frame.origin.x, self.viewPersonalProfile.frame.origin.y + self.viewPersonalProfile.frame.size.height + spaceBetweenViews, self.viewRestDetails.frame.size.width, 70.0)
      
        default:
            break
        }
        UIView.commitAnimations()
    }
    
    func getViewForSection(ofBtn: UIButton){
        switch (ofBtn){
        case self.btnPersonalDetails:
            self.changeViewOfSectionPersonalDetails()
            break
        case self.btnPersonalProfile:
            self.changeViewOfSectionPersonalProfile()
            break
        case self.btnRestDetails:
            self.changeViewOfSectionRestDetails()
            break
        default:
            break
        }
    }
    
    func changeViewOfSectionPersonalDetails(){
        self.viewPersonalDetails.frame = CGRectMake(self.viewPersonalDetails.frame.origin.x, self.viewPersonalDetails.frame.origin.y, self.viewPersonalDetails.frame.size.width, 373.0)
        
        let txtsFont = UIFont(name: "spacer", size: 15.0)
        let txtBgColor = UIColor.whiteColor()
        let textColor = UIColor.grayMedium()
        let txtsH = CGFloat(45.5)
        let txtsW = CGFloat(291)
        var txtY = CGFloat(79.0)
        let txtX = (UIScreen.mainScreen().bounds.size.width - txtsW)/2
        let spaceBeweenTxt = CGFloat(5.5)
        let txtsArry: [UITextField] = [/*self.txtEmail,self.txtPassword,*/self.txtFirstName,self.txtLastName,self.txtPhone]
        
        for txt in txtsArry{
            txt.backgroundColor = txtBgColor
            txt.textAlignment = NSTextAlignment.Right
            txt.textColor = textColor
//            txt.font = txtsFont
            txt.layer.cornerRadius = 1.5
            txt.layer.borderWidth = 1
            txt.layer.borderColor = UIColor.offwhiteDark().CGColor
            txt.delegate = self
            txt.frame = CGRectMake(txtX, txtY, txtsW, txtsH)
            
            txtY = txtY + txtsH + spaceBeweenTxt
            
            switch (txt){
            case self.txtEmail:
                txt.placeholder = NSLocalizedString("Email", comment: "") as String/*"מייל"*/
                txt.keyboardType = UIKeyboardType.EmailAddress
                break
                
            case self.txtPassword:
                txt.placeholder = NSLocalizedString("Password", comment: "") as String/* "סיסמה"*/
                break
                
            case self.txtFirstName:
                txt.placeholder = NSLocalizedString("First Name", comment: "") as String/* "שם פרטי"*/
                break
                
            case self.txtLastName:
                txt.placeholder = NSLocalizedString("Last Name", comment: "") as String/*"שם משפחה"*/
                break
                
            case self.txtPhone:
                txt.placeholder = NSLocalizedString("Mobile", comment: "") as String/*"נייד"*/
                txt.keyboardType = UIKeyboardType.PhonePad
                break
                
            default:
                break
            }
            UIView.beginAnimations("animateTextField", context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(1)
            
            self.viewPersonalDetails.addSubview(txt)
            UIView.commitAnimations()
        }
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(1)
        
        self.pushViews(viewPersonalDetails)
        UIView.commitAnimations()
        
        
    }
    
    func changeViewOfSectionPersonalProfile(){
        self.viewPersonalProfile.frame = CGRectMake(self.viewPersonalProfile.frame.origin.x, self.viewPersonalProfile.frame.origin.y, self.viewPersonalProfile.frame.size.width, 373.0)
        
        let txtsFont = UIFont(name: "spacer", size: 15.0)
        let txtBgColor = UIColor.whiteColor()
        let textColor = UIColor.grayMedium()
        let txtsH = CGFloat(45.5)
        let txtsW = CGFloat(291)
        var txtY = CGFloat(79.0)
        let txtX = (UIScreen.mainScreen().bounds.size.width - txtsW)/2
        let spaceBeweenTxt = CGFloat(5.5)
        let txtsArry: [UITextField] = [self.txtCountry,self.txtBirthday,self.txtGender,self.txtReligion/*,self.txtReligionLevel*/]
        
        for txt in txtsArry{
            txt.backgroundColor = txtBgColor
            txt.textAlignment = NSTextAlignment.Right
            txt.textColor = textColor
//            txt.font = txtsFont
            txt.layer.cornerRadius = 1.5
            txt.layer.borderWidth = 1
            txt.layer.borderColor = UIColor.offwhiteDark().CGColor
            txt.delegate = self
            txt.frame = CGRectMake(txtX, txtY, txtsW, txtsH)
            
            txtY = txtY + txtsH + spaceBeweenTxt
            
            switch (txt){
            case self.txtCountry:
                txt.placeholder = NSLocalizedString("Country of residence", comment: "") as String/*"ארץ מגורים"*/
                break
                
            case self.txtBirthday:
                txt.placeholder = NSLocalizedString("Date of Birth", comment: "") as String/*"תאריך לידה"*/
                break
                
            case self.txtGender:
                txt.placeholder = NSLocalizedString("Gender", comment: "") as String/* "מגדר"*/
                break
                
            case self.txtReligion:
                txt.placeholder =  NSLocalizedString("Faith", comment: "") as String/*"דת"*/
                break
                
                //            case self.txtReligionLevel:
                //                txt.placeholder = "יחס לדת"
                //                break
                
            default:
                break
            }
            UIView.beginAnimations("animateTextField", context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(1)
            
            self.viewPersonalProfile.addSubview(txt)
            UIView.commitAnimations()
        }
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(1)
        
        self.pushViews(viewPersonalProfile)
        
        UIView.commitAnimations()
  
        
    }
    
    func changeViewOfSectionRestDetails(){
        self.viewRestDetails.frame = CGRectMake(self.viewRestDetails.frame.origin.x, self.viewRestDetails.frame.origin.y, self.viewRestDetails.frame.size.width, 373.0)
        
        let txtsFont = UIFont(name: "spacer", size: 15.0)
        let txtBgColor = UIColor.whiteColor()
        let textColor = UIColor.grayMedium()
        let txtsH = CGFloat(45.5)
        let txtsW = CGFloat(291)
        let txtVH = CGFloat(95)
        var txtY = CGFloat(79.0)
        let txtX = (UIScreen.mainScreen().bounds.size.width - txtsW)/2
        let spaceBeweenTxt = CGFloat(5.5)
        let txtsArry: [UIView] = [self.txtProfession,self.txtHobby,self.txtLanguages,self.txtMoreDetails]
        
        for txt in txtsArry{
            if txt.isKindOfClass(UITextField){
                let curTxt = txt as! UITextField
                curTxt.backgroundColor = txtBgColor
                curTxt.textAlignment = NSTextAlignment.Right
                curTxt.textColor = textColor
//                curTxt.font = txtsFont
                curTxt.layer.cornerRadius = 1.5
                curTxt.layer.borderWidth = 1
                curTxt.layer.borderColor = UIColor.offwhiteDark().CGColor
                curTxt.delegate = self
                curTxt.frame = CGRectMake(txtX, txtY, txtsW, txtsH)
                txtY = txtY + txtsH + spaceBeweenTxt
                
                switch (curTxt){
                case self.txtProfession:
                    curTxt.placeholder = NSLocalizedString("Profession or Occupation", comment: "") as String
                    /*"מקצוע או תחום עיסוק"*/
                    break
                    
                case self.txtHobby:
                    curTxt.placeholder = NSLocalizedString("Hobby", comment: "") as String/*"תחביב"*/
                    break
                    
                case self.txtLanguages:
                    curTxt.placeholder = NSLocalizedString("Spoken languages", comment: "") as String/* "שפות מדוברות"*/
                    break
                default:
                    break
                }
                
            }else if txt.isKindOfClass(UITextView){
                let curTxt = txt as! UITextView
                curTxt.backgroundColor = txtBgColor
                curTxt.textAlignment = NSTextAlignment.Right
                curTxt.textColor = textColor
//                curTxt.font = txtsFont
                curTxt.layer.cornerRadius = 1.5
                curTxt.layer.borderWidth = 1
                curTxt.layer.borderColor = UIColor.offwhiteDark().CGColor
                curTxt.delegate = self
                curTxt.frame = CGRectMake(txtX, txtY, txtsW, txtVH)
                txtY = txtY + txtVH + spaceBeweenTxt
                
                switch (curTxt){
                case self.txtMoreDetails:
                    curTxt.text = NSLocalizedString("More about yourself", comment: "") as String  + "... "/* "עוד על עצמך..."*/
                    break
                    
                default:
                    break
                }
                
            }
            UIView.beginAnimations("animateTextField", context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(1)
            
            self.viewRestDetails.addSubview(txt)
            
            UIView.commitAnimations()
            
        }
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(1)
        
        self.pushViews(viewRestDetails)
        
        UIView.commitAnimations()
  
       
    }
    
    func pushViews(underView: UIView){
        for view in self.viewInScrollView.subviews{
            if (view as! UIView) == self.viewPersonalDetails || (view as! UIView) == self.viewPersonalProfile || (view as! UIView) == self.viewRestDetails{
                if view.frame.origin.y > underView.frame.origin.y{
                    if (view as! UIView) == self.viewPersonalDetails{
                        println("viewPersonalDetails")

                    }
                    
                    if (view as! UIView) == self.viewPersonalProfile{//viewPersonalProfile{
                        println("********viewPersonalProfile")
                        (view as! UIView).frame = CGRectMake(view.frame.origin.x, self.viewPersonalDetails.frame.origin.y + self.viewPersonalDetails.frame.size.height + spaceBetweenViews, view.frame.size.width, view.frame.size.height)
                    }
                    
                    if (view as! UIView) == self.viewRestDetails{
                        println("**********viewRestDetails")
                        //
                                  (view as! UIView).frame = CGRectMake(view.frame.origin.x, self.viewPersonalDetails.frame.origin.y + self.viewPersonalDetails.frame.size.height + spaceBetweenViews+/*self.viewPersonalProfile.frame.origin.y +*/ self.viewPersonalProfile.frame.size.height + spaceBetweenViews, view.frame.size.width, view.frame.size.height)
                        
//                        (view as! UIView).frame = CGRectMake(view.frame.origin.x, self.viewPersonalProfile.frame.origin.y + self.viewPersonalProfile.frame.size.height + spaceBetweenViews, view.frame.size.width, view.frame.size.height)
                    }
//
                }
            }
        }
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.viewRestDetails.frame.origin.y + self.viewRestDetails.frame.size.height + spaceBetweenViews)

       
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        
        textField.textColor = UIColor.grayDark()
        
        if self.navigationItem.rightBarButtonItem != self.btnSaveChanges{
            self.navigationItem.setRightBarButtonItem(self.btnSaveChanges, animated: true)
        }
        
        
        if textField == self.txtEmail || textField == self.txtPassword || textField == self.txtFirstName || textField == self.txtLastName || textField == self.txtPhone || textField == self.txtBirthday || textField == self.txtProfession || textField == self.txtHobby {
            return true
        }
        
        textField.resignFirstResponder()
        
        let popupView: PopubViewController = PopubViewController(nibName: "PopubViewController", bundle: nil)
        popupView.parentView = self
        popupView.delegate = self
        
        switch (textField) {
        case self.txtCountry:
            popupView.mode = "Countries"
            break
            
        case self.txtGender:
            popupView.mode = "Gender"
            break
            
        case self.txtReligion:
            popupView.mode = "Religion"
            break
            
            //        case self.txtReligionLevel:
            //            popupView.mode = "ReligionLevel"
            //            break
            
        case txtLanguages:
            popupView.mode = "Language"
        default: break
        }
        
        if (popupView.mode != "") {
            self.presentPopupViewController(popupView, animationType: MJPopupViewAnimationFade)
        }
        
        return false
    }
    
    func didEndSelection(arraySelections: [CodeValue], mode: String) {
        self.dismissPopupViewControllerWithanimationType(MJPopupViewAnimationFade)
        switch mode{
        case "Language":
            if arraySelections.count > 0{
                self.txtLanguages.text = ""
                self.currUser.oLanguages.removeAllObjects()
                for (index,element) in enumerate(arraySelections) {
                    var val = element.iKeyId
                    self.currUser.oLanguages.addObject(element)
                    if element.iKeyId == -1 {
                        self.txtLanguages.text = nil
                    }else{
                        self.txtLanguages.text = self.txtLanguages.text + element.nvValue + ", "
                    }
                }
            }
            
            break
        case "Countries":
            if let codeVal = (arraySelections as NSArray).objectAtIndex(0) as? CodeValue{
                self.currUser.oCountry = codeVal
                
                if codeVal.iKeyId == -1 {
                    self.txtCountry.text = nil
                }else{
                    self.txtCountry.text = codeVal.nvValue
                }
            }
            break
        case "Gender":
            if let codeVal = (arraySelections as NSArray).objectAtIndex(0) as? CodeValue{
                self.currUser.iGenderId = codeVal.iKeyId
                
                if codeVal.iKeyId == -1 {
                    self.txtGender.text = nil
                }else{
                    self.txtGender.text = codeVal.nvValue
                }
            }
            break
        case "Religion":
            if let codeVal = (arraySelections as NSArray).objectAtIndex(0) as? CodeValue{
                self.currUser.iReligionId = codeVal.iKeyId
                
                if codeVal.iKeyId == -1 {
                    self.txtReligion.text = nil
                }else{
                    self.txtReligion.text = codeVal.nvValue
                }
            }
            break
        case "ReligionLevel":
            if let codeVal = (arraySelections as NSArray).objectAtIndex(0) as? CodeValue{
                self.currUser.iReligiousLevelId = codeVal.iKeyId
                
                if codeVal.iKeyId == -1 {
                    //                    self.txtReligionLevel.text = nil
                }else{
                    //                    self.txtReligionLevel.text = codeVal.nvValue
                }
            }
            break
            
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        animateTextField(textField, up: false)
        textField.textColor = UIColor.grayMedium()
        
        if textField.text != "" && textField.text != " "{
            switch(textField){
                
            case self.txtEmail:
                break
                
            case self.txtPassword:
                break
                
            case self.txtFirstName:
                self.currUser.nvFirstName = textField.text
                break
                
            case self.txtLastName:
                self.currUser.nvLastName = textField.text
                break
                
            case self.txtPhone:
                self.currUser.nvPhone = textField.text
                break
                
            case self.txtBirthday:
                self.currUser.dtBirthDate = textField.text
                break
            case self.txtProfession:
                self.currUser.nvProfession = textField.text
                break
            case self.txtHobby:
                self.currUser.nvHobby = textField.text
                break
            default:
                break
            }
        }
    }
    
    func toolBarItemClicked(sender: AnyObject){
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateStr = dateFormatter.stringFromDate(datePicker.date)
        self.txtBirthday.text = dateStr
        self.currUser.dtBirthDate = dateStr
        self.txtBirthday.resignFirstResponder()
    }
    
    func saveUserUpdates(sender: AnyObject){
        self.dismissKeyboard()
        var generic = Generic()
        generic.showNativeActivityIndicator(self)
        //FIXME1.11
        var userDics:NSMutableDictionary = ["newUser":User.getUserDictionary(self.currUser)]
        Connection.connectionToService("UpdateUser", params: /*User.getUserDictionary(self.currUser)*/userDics, completion: {
            data -> Void in
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("UpdateUser:\(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            if json != nil{
                if let parseJSON = json {
                    let returnedUser = User.parseUserJson(JSON(parseJSON))
                    if (returnedUser.iUserId != -1 && returnedUser.iUserId != 0){
                        self.changeActiveUserSettings(JSON(parseJSON))
                        
                        generic.hideNativeActivityIndicator(self)
                        var alert = UIAlertController(title: "", message: NSLocalizedString("The profile has been updated", comment: "") as String/*"הפרופיל עודכן"*/, preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("Confirmation", comment: "") as String/*"אישור"*/, style: UIAlertActionStyle.Cancel, handler: {
                            action -> Void in
                            println()
                            self.navigationController!.popViewControllerAnimated(true)
                        }))
                        
                        self.presentViewController(alert, animated: true, completion:nil)
                        
                    } else {
                        generic.hideNativeActivityIndicator(self)
                        var alert = UIAlertController(title: NSLocalizedString("Error", comment: "") as String/*"Error"*/, message:NSLocalizedString("Fail update youre profile", comment: "") as String/* "Fail update youre profile"*/, preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title:NSLocalizedString("Confirmation", comment: "") as String/* "OK"*/, style: UIAlertActionStyle.Cancel, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            }else{
                generic.hideNativeActivityIndicator(self)
                var alert = UIAlertController(title:NSLocalizedString("Error", comment: "") as String /*"Error"*/, message:NSLocalizedString("Fail update youre profile", comment: "") as String /*"Fail update youre profile"*/, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Confirmation", comment: "") as String/*"OK"*/, style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            generic.hideNativeActivityIndicator(self)
        })
    }
    
    func changeActiveUserSettings(parseJson: JSON){
        ActiveUser.setUser(User.parseUserJson(parseJson))
        ActiveUser.sharedInstace.oLocation.iDriverId = ActiveUser.sharedInstace.iUserId
        //FIXME1.11
        var userDics:NSMutableDictionary = ["newUser":User.getUserDictionary(ActiveUser.sharedInstace)]
        NSUserDefaults.standardUserDefaults().setValue(/*User.getUserDictionary(ActiveUser.sharedInstace)*/userDics, forKey:"user")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        //change the MainPageMarker
        var controllers = self.navigationController?.viewControllers as [AnyObject]!
        for view in controllers{
            if view.isKindOfClass(MainPage){
                if let mainView = view as? MainPage{
                    mainView.myLocationMarker.changeMarkerIcon(ActiveUser.sharedInstace)
                }
            }
        }
    }
    
    func dismissKeyboard(){
        for view in self.scrollView.subviews{
            if view.isKindOfClass(UIView){
                for v in view.subviews{
                    if v.isKindOfClass(UITextField){
                        v.resignFirstResponder()
                    }
                }
            }
        }
    }
    func textViewDidBeginEditing(textView: UITextView){
        if textView.text==NSLocalizedString("More about yourself", comment: "") as String  + "..." /*"עוד על עצמך..."*/ {
            textView.text = ""
        }
        animateTextView(textView, up: true)
        
    }
    func textViewDidEndEditing(textView: UITextView){
        if textView.text=="" || textView.text == " "{
            textView.text = NSLocalizedString("More about yourself", comment: "") as String  + "..."  /*"עוד על עצמך..."*/
        }
        animateTextView(textView, up: false)
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool{
        if text == "\n"{
            textView.resignFirstResponder()
            return false;
        }
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField){
        animateTextField(textField, up: true)
    }
    
    func animateTextField(textField: UITextField, up: Bool){
        
        
        var keyboardSize = CGRectMake(0, UIScreen.mainScreen().bounds.size.height - 253, UIScreen.mainScreen().bounds.size.width, 253)
        let movementDistance: CGFloat = keyboardSize.height
        let movement = (up ? -movementDistance : movementDistance)
        let currentView : UIView = textField.superview!
        if keyboardSize.origin.y <= textField.frame.origin.y + currentView.frame.origin.y + 60{
            UIView.beginAnimations("animateTextField", context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(1)
            self.view.frame = CGRectOffset(self.view.frame, 0, movement);
            UIView.commitAnimations()
            
        }
    }
    
    func animateTextView(textView:UITextView , up: Bool){
        var keyboardSize = CGRectMake(0, UIScreen.mainScreen().bounds.size.height - 253, UIScreen.mainScreen().bounds.size.width, 253)
        let movementDistance: CGFloat = keyboardSize.height
        let movement = (up ? -movementDistance : movementDistance)
        let currentView : UIView = textView.superview!
        if keyboardSize.origin.y <= textView.frame.origin.y + currentView.frame.origin.y + 60{
            UIView.beginAnimations("animateTextField", context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(1)
            self.view.frame = CGRectOffset(self.view.frame, 0, movement);
            UIView.commitAnimations()
            
        }

    }
    //FIXME:prefix
    func didEndSelectionKey(arraySelections: [KeyValue], mode: String)
        
    {
        
    }
}

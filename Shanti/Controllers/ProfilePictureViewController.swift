//
//  ProfilePictureViewController.swift
//  Shanti
//
//  Created by hodaya ohana on 2/4/15.
//  Copyright (c) 2015 webit. All rights reserved.
//NSLocalizedString("", comment: "")  as String

import UIKit

class ProfilePictureViewController: GlobalViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var btnCamrea: UIButton!
    @IBOutlet weak var btnGalery: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    
    var user:User = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        User.sighUpToXmpp(self.user)
        self.setSubviewsConfig()
        self.navigationItem.rightBarButtonItem = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func popBack(sender: AnyObject){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func setSubviewsConfig(){
        self.setSubviewsGraphics()
        self.setSubviewsFrames()
        self.setSubviewsActions()
    }
    
    func setSubviewsGraphics(){
        self.lblUserName.text = (NSLocalizedString("Welcome", comment: "")  as String) + " " + user.nvShantiName + "!"
        self.lblUserName.textColor = UIColor.whiteColor()
        self.lblUserName.textAlignment = NSTextAlignment.Center
        self.lblUserName.sizeToFit()
        
        self.imgProfile.image = UIImage(named: "userDefaultImg")
        
        self.lblNote.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.lblNote.numberOfLines = 0
        let lblNoteWidth = CGFloat(291.0)
        self.lblNote.text = (NSLocalizedString("People like to know the members of their group", comment: "")  as String)/* "משתמשים אוהבים להכיר את חבריהם לקבוצה.\nהשלם את עריכת הפרופיל שלך כדי לעזור לקבוצה להכיר אותך."*/ + "," + (NSLocalizedString("Complete your profile editing to help the group to know you", comment: "")  as String)
        self.lblNote.textColor = UIColor.grayMedium()
        self.lblNote.textAlignment = NSTextAlignment.Center
        self.lblNote.sizeToFit()
        
        self.btnCamrea.setTitle(NSLocalizedString("Take a picture", comment: "")  as String/*"צלם תמונה"*/, forState: UIControlState.Normal)
        self.btnCamrea.setTitle(NSLocalizedString("Take a picture", comment: "")  as String/*"צלם תמונה"*/, forState: UIControlState.Highlighted)
        self.btnCamrea.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.btnCamrea.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        self.btnCamrea.titleLabel!.textAlignment = NSTextAlignment.Center
        self.btnCamrea.backgroundColor = UIColor(red: 176.0/255.0, green: 0.0/255.0, blue: 247.0/255.0, alpha: 0.8)
        self.btnCamrea.sizeToFit()
        self.btnCamrea.layer.cornerRadius = 3.0;
        self.btnCamrea.layer.shadowRadius = 1.0
        self.btnCamrea.layer.shadowOffset = CGSizeMake(0, -1.0)
        self.btnCamrea.layer.shadowColor = UIColor(red: 30/255.0, green: 10/255.0, blue: 40/255.0, alpha: 0.75).CGColor
        
        self.btnGalery.setTitle(NSLocalizedString("Select from the pool", comment: "")  as String/*"בחר מהאלבום"*/, forState: UIControlState.Normal)
        self.btnGalery.setTitle(NSLocalizedString("Select from the pool", comment: "")  as String/*"בחר מהאלבום"*/, forState: UIControlState.Highlighted)
        self.btnGalery.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.btnGalery.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        self.btnGalery.titleLabel!.textAlignment = NSTextAlignment.Center
        self.btnGalery.backgroundColor = UIColor(red: 176.0/255.0, green: 0.0/255.0, blue: 247.0/255.0, alpha: 0.8)
        self.btnGalery.sizeToFit()
        self.btnGalery.layer.cornerRadius = 3.0;
        self.btnGalery.layer.shadowRadius = 1.0
        self.btnGalery.layer.shadowOffset = CGSizeMake(0, -1.0)
        self.btnGalery.layer.shadowColor = UIColor(red: 30/255.0, green: 10/255.0, blue: 40/255.0, alpha: 0.75).CGColor
        
        self.btnSkip.setTitle(NSLocalizedString("Add later", comment: "")  as String/*"הוסף מאוחר יותר"*/, forState: UIControlState.Normal)
        self.btnSkip.setTitle(NSLocalizedString("Add later", comment: "")  as String/*"הוסף מאוחר יותר"*/, forState: UIControlState.Highlighted)
        self.btnSkip.setTitleColor(UIColor.grayMedium(), forState: UIControlState.Normal)
        self.btnSkip.setTitleColor(UIColor.grayMedium(), forState: UIControlState.Highlighted)
        self.btnSkip.titleLabel?.font =  UIFont(name: "spacer", size: 15.0)
        self.btnSkip.backgroundColor = UIColor.clearColor()
        self.btnSkip.sizeToFit()
    }
    
    func setSubviewsFrames(){
        let imgWH = CGFloat(87.0)
        let txtsWidth = CGFloat(291.5)
        let txtsHight = CGFloat(46.0)
        let lblNoteWidth = txtsWidth
    }
    
    func setSubviewsActions(){
        self.btnCamrea.addTarget(self, action: "getCamera:", forControlEvents: UIControlEvents.TouchUpInside)
        self.btnGalery.addTarget(self, action: "getAlbum:", forControlEvents: UIControlEvents.TouchUpInside)
        self.btnSkip.addTarget(self, action: "skip:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func getCamera(sender: AnyObject){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            var imag = UIImagePickerController()
            imag.delegate = self
            imag.sourceType = UIImagePickerControllerSourceType.Camera;
            imag.allowsEditing = false
            
            self.presentViewController(imag, animated: true, completion: nil)
        }
    }
    
    func getAlbum(sender: AnyObject){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            var imag = UIImagePickerController()
            imag.delegate = self
            imag.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imag.allowsEditing = false
            
            self.presentViewController(imag, animated: true, completion: nil)
        }
    }
    
   func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!){
        self.dismissViewControllerAnimated(true, completion: nil)
        let ConfirmPicView = self.storyboard!.instantiateViewControllerWithIdentifier("ConfirmeProfilePictureViewControllerId") as! ConfirmeProfilePictureViewController
        ConfirmPicView.currUser = self.user
        ConfirmPicView.imgReference = image
        self.navigationController?.pushViewController(ConfirmPicView, animated: true)
    }
    
    func skip(sender: AnyObject){
        self.moveToFillDetailsPage()
    }
    
    func moveToFillDetailsPage(){
        let fiilingDetailsView: FillingDetailsViewController = self.storyboard!.instantiateViewControllerWithIdentifier("FillingDetailsViewControllerId") as! FillingDetailsViewController
        
        fiilingDetailsView.user = self.user
        self.navigationController!.pushViewController(fiilingDetailsView, animated: true)
    }
    
}

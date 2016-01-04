//
//  ConfirmeProfilePictureViewController.swift
//  Shanti
//
//  Created by hodaya ohana on 2/4/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

class ConfirmeProfilePictureViewController: GlobalViewController {
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var btnUpdateProfilePic: UIButton!
    @IBOutlet weak var btnTakePicAgain: UIButton!
    
    var currUser: User = User()
    var imgReference: UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setSubviewsConfig()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setSubviewsConfig(){
        self.setSubviewsGraphics()
        self.setSubviewsFrames()
        self.setSubviewsActions()
        self.navigationItem.rightBarButtonItem = nil
    }
    
    func setSubviewsGraphics(){
        self.lblUserName.text = (NSLocalizedString("Welcome", comment: "")  as String) /*"ברוך הבא, "*/ + "," + currUser.nvShantiName + "!"
        self.lblUserName.textColor = UIColor.whiteColor()
        self.lblUserName.textAlignment = NSTextAlignment.Center
        self.lblUserName.sizeToFit()
        
        self.imgProfile.image = UIImage(named: "userDefaultImg.png")
        self.imgProfile.image = self.imgReference
        self.imgProfile.contentMode = UIViewContentMode.ScaleAspectFill
        self.imgProfile.clipsToBounds = true
        
        self.lblNote.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.lblNote.numberOfLines = 0
        
        let lblNoteWidth = CGFloat(291.0)
        self.lblNote.frame = CGRectMake(0, 0, lblNoteWidth, 0)
        self.lblNote.text = (NSLocalizedString("Here is your selected image", comment: "")  as String) + " " + /* "הנה התמונה שבחרת.\nהאם זה אתה?"*/(NSLocalizedString("Is that you?", comment: "")  as String)
        self.lblNote.textColor = UIColor.grayMedium()
        self.lblNote.textAlignment = NSTextAlignment.Center
        self.lblNote.sizeToFit()
        
        self.btnUpdateProfilePic.setTitle((NSLocalizedString("Yes. Complete Signup", comment: "")  as String)/*"כן. השלם הרשמה"*/, forState: UIControlState.Normal)
        self.btnUpdateProfilePic.setTitle((NSLocalizedString("Yes. Complete Signup", comment: "")  as String)/*"כן. השלם הרשמה"*/, forState: UIControlState.Highlighted)
        self.btnUpdateProfilePic.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.btnUpdateProfilePic.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        self.btnUpdateProfilePic.titleLabel!.textAlignment = NSTextAlignment.Center
        self.btnUpdateProfilePic.backgroundColor = UIColor(red: 176.0/255.0, green: 0.0/255.0, blue: 247.0/255.0, alpha: 0.8)
        self.btnUpdateProfilePic.sizeToFit()
        self.btnUpdateProfilePic.layer.cornerRadius = 3.0;
        self.btnUpdateProfilePic.layer.shadowRadius = 1.0
        self.btnUpdateProfilePic.layer.shadowOffset = CGSizeMake(0, -1.0)
        self.btnUpdateProfilePic.layer.shadowColor = UIColor(red: 30/255.0, green: 10/255.0, blue: 40/255.0, alpha: 0.75).CGColor
        
        self.btnTakePicAgain.setTitle((NSLocalizedString("Take another picture", comment: "")  as String)/*"צלם שוב"*/, forState: UIControlState.Normal)
        self.btnTakePicAgain.setTitle((NSLocalizedString("Take another picture", comment: "")  as String)/*"צלם שוב"*/, forState: UIControlState.Highlighted)
        self.btnTakePicAgain.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.btnTakePicAgain.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        self.btnTakePicAgain.titleLabel!.textAlignment = NSTextAlignment.Center
        self.btnTakePicAgain.backgroundColor = UIColor(red: 176.0/255.0, green: 0.0/255.0, blue: 247.0/255.0, alpha: 0.8)
        self.btnTakePicAgain.sizeToFit()
        self.btnTakePicAgain.layer.cornerRadius = 3.0;
        self.btnTakePicAgain.layer.shadowRadius = 1.0
        self.btnTakePicAgain.layer.shadowOffset = CGSizeMake(0, -1.0)
        self.btnTakePicAgain.layer.shadowColor = UIColor(red: 30/255.0, green: 10/255.0, blue: 40/255.0, alpha: 0.75).CGColor
        
    }
    
    func setSubviewsFrames(){
        let imgWH = CGFloat(87.0)
        let txtsWidth = CGFloat(291.5)
        let txtsHight = CGFloat(46.0)
        let lblNoteWidth = txtsWidth
        
    }
    
    func setSubviewsActions(){
        self.btnUpdateProfilePic.addTarget(self, action: "updateUserProfilePicture:", forControlEvents: UIControlEvents.TouchUpInside)
        self.btnTakePicAgain.addTarget(self, action: "takePictureAgain:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func updateUserProfilePicture(sender: AnyObject){
        //TODO: use the server function updateUser
        self.currUser.nvImage = ImageHandler.convertImageToString(ImageHandler.scaledImage(self.imgProfile.image!, newSize: CGSizeMake(115, 115)))
        
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
                        let fiilingDetailsView: FillingDetailsViewController = self.storyboard!.instantiateViewControllerWithIdentifier("FillingDetailsViewControllerId") as! FillingDetailsViewController
                        
                        fiilingDetailsView.user = self.currUser
                        self.navigationController!.pushViewController(fiilingDetailsView, animated: true)
                        generic.hideNativeActivityIndicator(self)
                        
                    } else {
                        generic.hideNativeActivityIndicator(self)
                        var alert = UIAlertController(title: "Error", message: "Fail update youre profile picture", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            }else{
                generic.hideNativeActivityIndicator(self)
                var alert = UIAlertController(title: "Server error", message: "Fail update youre profile picture", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
        generic.hideNativeActivityIndicator(self)
    }
    
    //    func convertImageToString() -> String {
    //        var imageData = UIImagePNGRepresentation(self.compressUserImage())
    //        return imageData.base64EncodedStringWithOptions(.allZeros)
    //    }
    //
    //    func compressUserImage() -> UIImage{
    //        var compressedImg = UIImage()
    //        var imageData = UIImagePNGRepresentation(self.imgProfile.image)
    //        var newSize: CGSize = CGSize(width: 50.0,height: 50.0)
    //
    //        UIGraphicsBeginImageContext(newSize)
    //        self.imgProfile.image!.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
    //        compressedImg = UIGraphicsGetImageFromCurrentImageContext()
    //        UIGraphicsEndImageContext()
    //
    //        return compressedImg
    //    }
    
    func takePictureAgain(sender: AnyObject){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
}

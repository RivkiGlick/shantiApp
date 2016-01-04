//
//  ShantiMarker.swift
//  Shanti
//
//  Created by hodaya ohana on 12/30/14.
//  Copyright (c) 2014 webit. All rights reserved.
//
//import GoogleMaps


class ShantiMarker: GMSMarker {
    var user: User = User()
    var markerSize = CGSize()
    var markerImage : UIImage?{
        set{
            super.icon = self.markerImage
        }get{
            return super.icon
        }
    }
    override init() {
        super.init()
    }
    
    init(user: User) {
        super.init()
        
        self.user = user
        self.didReleasMarker()
    }
    
    class func imageWithView(view: UIView) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0)
        
        view.layer.renderInContext(UIGraphicsGetCurrentContext())
        
        var img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img
    }
    
    func changeMarkerIcon(withUser: User){
        self.user = withUser
        self.didTapMarker()
    }
    
    
    func didTapMarker(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var profileImg: UIImage!
        if self.user.iUserId != ActiveUser.sharedInstace.iUserId{ //TODO: chack if the image null
            profileImg = User.getUserImageBase64(self.user.nvImage)
        }else{
            profileImg = self.user.image
            
        }
        
        var merchantImg = profileImg
        var pinImg: UIImage?
        
        
        if self.user.bIsMainUser{
            if (self.user.iUserId == ActiveUser.sharedInstace.iUserId){
                pinImg = UIImage(named: "markerMeManagerBig")
            }else{
                pinImg = UIImage(named: "markerManagerBig")
                
            }
        }else{
            if (self.user.iUserId == ActiveUser.sharedInstace.iUserId){
                pinImg = UIImage(named: "pupleMarker")//Does not exist
            }else{
                pinImg = UIImage(named: "greenMarker")
            }
        }
        
        var newSize = CGSizeMake(pinImg!.size.width, pinImg!.size.height)
        println("newSize:\(newSize)")
        UIGraphicsBeginImageContext(newSize)
        merchantImg.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        pinImg?.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        var newImage: UIImage
        if (self.user.iUserId == ActiveUser.sharedInstace.iUserId){
            newImage = UIGraphicsGetImageFromCurrentImageContext()
            newImage = ImageProcessor.logPixelsOfImage(pinImg, userImage: newImage)
            newImage = ImageProcessor.getUserMarker(pinImg, userImage: newImage)
            
        }
        else
        {
            newImage=merchantImg
            var imageView: UIImageView = UIImageView(image: newImage)
            var layer: CALayer = CALayer()
            layer = imageView.layer
            
            layer.masksToBounds = true
            layer.cornerRadius = CGFloat(150.0)
            
            UIGraphicsBeginImageContext(imageView.bounds.size)
            layer.renderInContext(UIGraphicsGetCurrentContext())
            var roundedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            newImage = roundedImage
        }
        
        
        
        self.icon = newImage
        
    }
    
    func didReleasMarker(){
        var profileImg: UIImage!
        if self.user.iUserId != ActiveUser.sharedInstace.iUserId{ //TODO: chack if the image null
            profileImg = User.getUserImageBase64(self.user.nvImage)
        }
        else
        {
            profileImg = self.user.image
            
        }
        
        var merchantImg = profileImg
        var pinImg: UIImage?
        
        if self.user.bIsMainUser{
            if (self.user.iUserId == ActiveUser.sharedInstace.iUserId){
                pinImg = UIImage(named: "markerMeManager")
            }else{
                pinImg = UIImage(named: "markerManager")
            }
        }else{
            if (self.user.iUserId == ActiveUser.sharedInstace.iUserId){
                pinImg = UIImage(named: "pupleMarker")
            }else{
                pinImg = UIImage(named: "greenMarker")
            }
        }
        
        var newSize = CGSizeMake(pinImg!.size.width, pinImg!.size.height)
        println("newSize:\(newSize)")
        UIGraphicsBeginImageContext(newSize)
        merchantImg.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        pinImg?.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        
        var newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        newImage = ImageProcessor.logPixelsOfImage(pinImg, userImage: newImage)
        
        if (self.user == ActiveUser.sharedInstace){
            merchantImg = UIImage(named: "massage_icn_maps")!
            
        }
        self.icon = newImage
    }
}

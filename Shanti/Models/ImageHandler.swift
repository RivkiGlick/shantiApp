//
//  ImageHandler.swift
//  Shanti
//
//  Created by hodaya ohana on 3/2/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

class ImageHandler: NSObject {
    class func convertImageToString(image: UIImage?) -> String {
        if image != nil{
            var imageData = UIImagePNGRepresentation(image)
            return imageData.base64EncodedStringWithOptions(.allZeros)
        }
        return ""
    }
    
    class func compressUserImage(image: UIImage?) -> UIImage{
        var compressedImg = UIImage()
        var imageData = UIImagePNGRepresentation(image)
        var newSize: CGSize = CGSize(width: 115.0,height: 115.0)
        
        UIGraphicsBeginImageContext(newSize)
        image?.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        compressedImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return compressedImg
    }
    
    class func getImageBase64FromUrl(stringUrl: String) -> UIImage{
        var url: NSURL = NSURL(string: stringUrl)!
        var convertedImg: UIImage = UIImage()
        if let data = NSData(contentsOfURL: url, options: nil, error: nil){
            let image = UIImage(data: data)
            var imageView: UIImageView = UIImageView(image: image)
            imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width/2, imageView.frame.size.height/2)
            convertedImg = UIImage(data: data)!
        }else{
            url = NSURL(string: "http://qa.webit-track.com/ShantiWS/Files/Users/marker_defualt.png")!
            if let data = NSData(contentsOfURL: url, options: nil, error: nil){
                let image = UIImage(data: data)
                var imageView: UIImageView = UIImageView(image: image)
                imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width/2, imageView.frame.size.height/2)
                convertedImg = UIImage(data: data)!
            }
        }
        return convertedImg
    }
    
    class func imageWithView(view: UIView) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0)
        
        view.layer.renderInContext(UIGraphicsGetCurrentContext())
        
        var img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img
    }
    
    class func imageWithColor(color: UIColor) -> UIImage{
        return ImageProcessor.imageWithColor(color)
    }
    
    class func getUserProfileMarkerImage(pinImg: UIImage, userImage: UIImage) -> UIImage{
        return ImageProcessor.logPixelsOfImage(pinImg, userImage: userImage)
    }
    
    class func scaledImage(image: UIImage?, newSize: CGSize) -> UIImage?{
        var newImage: UIImage?
        if image != nil{
            UIGraphicsBeginImageContext(newSize)
            // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
            // Pass 1.0 to force exact pixel size.
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            image!.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
            newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
        }
        return newImage
    }
    
    class func drawText(text: NSString, inImage: UIImage, atPoint: CGPoint) -> UIImage{
        let font: UIFont = UIFont.boldSystemFontOfSize(17)
        let textFontAttributes = [NSFontAttributeName: font,NSForegroundColorAttributeName: UIColor.whiteColor(),]
        UIGraphicsBeginImageContext(inImage.size)
        inImage.drawInRect(CGRectMake(0,0,inImage.size.width,inImage.size.height))
        let rect: CGRect = CGRectMake(atPoint.x, atPoint.y, inImage.size.width, inImage.size.height)
        UIColor.whiteColor().set()
        text.drawInRect(CGRectIntegral(rect), withAttributes: textFontAttributes)
        var newImage = UIGraphicsGetImageFromCurrentImageContext()
        return newImage
    }
}

//
//  GooglePlaceResultObject.swift
//  Shanti
//
//  Created by hodaya ohana on 3/30/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

class GooglePlaceResultObject: NSObject {
    var location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0,longitude: 0)
    var icon: String = String("")
    var iconImg: UIImage?
    var name: String = String("")
    var reference: String = String("")
    var vicinity: String = String("")
    var place_id: String = String("")
    var id: String = String("")
    var photos: [GooglePhoto] = [GooglePhoto]()
    
    class func parseGooglePlaceResultObjectDict(googleDict: NSDictionary) -> GooglePlaceResultObject{
        var googlePlaceObj = GooglePlaceResultObject()
        var json = JSON(googleDict)
        
        if let  geometryDict = googleDict.valueForKey("geometry") as? NSDictionary{
            if let locationDict = geometryDict.valueForKey("location") as? NSDictionary{
                var json = JSON(locationDict)
                googlePlaceObj.location = CLLocationCoordinate2DMake(json["lat"].asDouble!, json["lat"].asDouble!)
            }
        }
        
        if let photoesArry = googleDict.valueForKey("photos") as? NSArray{
            for photo in photoesArry{
                googlePlaceObj.photos += [GooglePhoto.parsGooglePhotoDict(photo as! NSDictionary)]
            }
        }
        
        googlePlaceObj.place_id = googleDict.valueForKey("place_id") as! String
        googlePlaceObj.id = googleDict.valueForKey("id") as! String
        googlePlaceObj.icon = googleDict.valueForKey("icon") as! String
        googlePlaceObj.name = googleDict.valueForKey("name") as! String
        googlePlaceObj.reference = googleDict.valueForKey("reference") as! String
        googlePlaceObj.vicinity = googleDict.valueForKey("vicinity") as! String
     
        return googlePlaceObj
    }
}

class GogglePlaceItemDetails: NSObject{
    var formatted_address: String = String("")
    var formatted_phone_number: String = String("")
    var location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0,longitude: 0)
    var icon: String = String("")
    var id: String = String("")
    var international_phone_number: String = String("")
    var name: String = String("")
    var place_id: String = String("")
    var opening_hours: GoogleOpeningHours = GoogleOpeningHours()
    var photos: [GooglePhoto] = [GooglePhoto]()
    var website: String = String("")
    var url: String = String("")
    var user_ratings_total: Int = Int(0)
    var reviews: [GoogleReview] = [GoogleReview]()

    class func parsGogglePlaceItemDetails(itemDetails: NSDictionary) -> GogglePlaceItemDetails{
        var gogglePlaceItemDetails = GogglePlaceItemDetails()
        
        var json = JSON(itemDetails)
        gogglePlaceItemDetails.formatted_address = (json["formatted_address"].asString != nil) ? json["formatted_address"].asString! : ""
        gogglePlaceItemDetails.formatted_phone_number = (json["formatted_phone_number"].asString != nil) ? json["formatted_phone_number"].asString! : ""
        
        if let  geometryDict = itemDetails.valueForKey("geometry") as? NSDictionary{
            if let locationDict = geometryDict.valueForKey("location") as? NSDictionary{
                var json = JSON(locationDict)
                gogglePlaceItemDetails.location = CLLocationCoordinate2DMake(json["lat"].asDouble!, json["lat"].asDouble!)
            }
        }
       
        gogglePlaceItemDetails.icon =  (json["icon"].asString != nil) ? json["icon"].asString! : ""
        gogglePlaceItemDetails.id =  (json["id"].asString != nil) ? json["id"].asString! : ""
        gogglePlaceItemDetails.international_phone_number =  (json["international_phone_number"].asString != nil) ? json["international_phone_number"].asString! : ""
        gogglePlaceItemDetails.name =  (json["name"].asString != nil) ? json["name"].asString! : ""
        gogglePlaceItemDetails.place_id =  (json["place_id"].asString != nil) ? json["place_id"].asString! : ""
        
        if let openingHoursDict = itemDetails.valueForKey("opening_hours") as? NSDictionary{
            gogglePlaceItemDetails.opening_hours = GoogleOpeningHours.parsGoogleOpeningHours(openingHoursDict)
        }
        
        if let photoesArry = itemDetails.valueForKey("photos") as? NSArray{
            for photo in photoesArry{
                gogglePlaceItemDetails.photos += [GooglePhoto.parsGooglePhotoDict(photo as! NSDictionary)]
            }
        }
        
        gogglePlaceItemDetails.website = (json["website"].asString != nil) ? json["website"].asString! : ""
        gogglePlaceItemDetails.url = (json["url"].asString != nil) ? json["url"].asString! : ""
        gogglePlaceItemDetails.user_ratings_total = (json["user_ratings_total"].asInt != nil) ? json["user_ratings_total"].asInt! : 0
        
        if let reviewsArr = itemDetails.valueForKey("reviews") as? NSArray{
            for reviewsDict in reviewsArr{
                gogglePlaceItemDetails.reviews += [GoogleReview.parsGoogleReview(reviewsDict as! NSDictionary)]
            }
        }
        
        return gogglePlaceItemDetails
    }
}

class GooglePhoto: NSObject{
    var height: CGFloat = CGFloat(0.0)
    var width: CGFloat = CGFloat(0.0)
    var html_attributions: String = String("")
    var photo_reference: String = String("")
    
    var photoImg: UIImage? // only application varable, not google!
    
    class func parsGooglePhotoDict(photoDict: NSDictionary) ->GooglePhoto{
        var json = JSON(photoDict)
        var googlePhoto = GooglePhoto()
        
        googlePhoto.height = (json["height"].asDouble != nil) ? CGFloat(json["height"].asDouble!) : 0
        googlePhoto.width = (json["width"].asDouble != nil) ? CGFloat(json["width"].asDouble!) : 0
        googlePhoto.html_attributions = (json["html_attributions"].asString != nil) ? json["html_attributions"].asString! : ""
        googlePhoto.photo_reference = (json["photo_reference"].asString != nil) ? json["photo_reference"].asString! : ""
        
        return googlePhoto
    }
}

class GoogleOpeningHours: NSObject{
    var open_now: Bool = false
    var weekday_text: [String] = [String]()
    
    class func parsGoogleOpeningHours(dict: NSDictionary) ->GoogleOpeningHours{
        var googleOpeningHours = GoogleOpeningHours()

        googleOpeningHours.open_now = dict.valueForKey("open_now") != nil ? dict.valueForKey("open_now") as! Bool : false
        
        if let weekdayDict = dict.valueForKey("weekday_text") as? NSArray{
            for text in weekdayDict{
                googleOpeningHours.weekday_text += [(text as! String)]
            }
            
        }
        
        return googleOpeningHours
    }
    
}

class GoogleReview: NSObject{
    var author_name: String = String("")
    var rating: Int = Int(0)
    var text: String = String("")
    var time: NSDate = NSDate()
    
    class func parsGoogleReview(dict: NSDictionary) -> GoogleReview{
        var googleReview = GoogleReview()
        
        var json = JSON(dict)
        googleReview.author_name = (json["author_name"].asString != nil) ? json["author_name"].asString! : ""
        googleReview.rating = (json["rating"].asInt != nil) ? json["rating"].asInt! : 0
        googleReview.text = (json["text"].asString != nil) ? json["text"].asString! : ""
        
        return googleReview
    }
    
    func getDate(dateString: String){
        /*- (NSDate*) getDateFromJSON:(NSString *)dateString
        {
        // Expect date in this format "/Date(1268123281843)/"
        int startPos = (int)[dateString rangeOfString:@"("].location+1;
        int endPos = (int)[dateString rangeOfString:@")"].location;
        NSRange range = NSMakeRange(startPos,endPos-startPos);
        unsigned long long milliseconds = [[dateString substringWithRange:range] longLongValue];
        //NSLog(@"%llu",milliseconds);
        NSTimeInterval interval = milliseconds/1000;
        return [NSDate dateWithTimeIntervalSince1970:interval];
        }
        */
    }
   
}



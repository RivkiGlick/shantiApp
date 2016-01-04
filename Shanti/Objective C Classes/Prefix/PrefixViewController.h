//
//  PrefixViewController.h
//  Shanti
//
//  Created by hodaya ohana on 7/21/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface PrefixViewController : UIViewController

@property (nonatomic,strong)NSDictionary * prefixDict;
@property (nonatomic, retain)NSString*Country_code;
@property (nonatomic, retain)NSString*Country_num;
@property (nonatomic, retain)NSString * prefixNumber;
- (id)init;
-(NSString *)getPrefixByCityName:(NSString *)cityName;
-(NSString *)getPrefix;
-(NSString *)getPrefixNum;
@end

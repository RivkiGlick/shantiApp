//
//  Generic.h
//  JewishCard
//
//  Created by nissim h on 6/3/13.
//  Copyright (c) 2013 webit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Generic : UIViewController

@property (nonatomic, retain) UIViewController *controller;
+ (id)shareGeneric;

- (void) showNativeActivityIndicator:(UIViewController *)cont;
- (void) hideNativeActivityIndicator:(UIViewController *)cont;

- (void) pushTextField:(UITextField *)textField controller:(UIViewController *)cont;
- (void) returnTextField:(UITextField *)textField controller:(UIViewController *)cont;




@end

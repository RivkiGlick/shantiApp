//
//  Generic.m
//  JewishCard
//
//  Created by nissim h on 6/3/13.
//  Copyright (c) 2013 webit. All rights reserved.
//

#import "Generic.h"

#define ACTIVITY_INDICATOR_VIEW_TAG 123

@interface Generic ()

@end

@implementation Generic
@synthesize controller;

CGFloat animatedDistance;

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void) showNativeActivityIndicator: (UIViewController *)cont
{
    [self hideNativeActivityIndicator:cont];
    controller = cont;
    UIActivityIndicatorView  *avToShow = [[UIActivityIndicatorView alloc]
                                          initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    avToShow.frame=CGRectMake(145, 160, 25, 25);
    avToShow.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    avToShow.tag  = ACTIVITY_INDICATOR_VIEW_TAG;
    avToShow.color = [UIColor colorWithRed:0.0 green:0.0 blue:85.0/255.0 alpha:1.000];
    
    [self.controller.view addSubview:avToShow];
    [avToShow startAnimating];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

- (void) hideNativeActivityIndicator:(UIViewController *)cont
{
    controller = cont;
    UIActivityIndicatorView* showedAv = (UIActivityIndicatorView*)[self.controller.view viewWithTag:ACTIVITY_INDICATOR_VIEW_TAG];
    [showedAv removeFromSuperview];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) pushTextField:(UITextField *)textField controller:(UIViewController *)cont
{
    controller = cont;
    CGRect textFieldRect =
    [controller.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
    [controller.view.window convertRect:controller.view.bounds fromView:controller.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    CGRect viewFrame = controller.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [controller.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void) returnTextField:(UITextField *)textField controller:(UIViewController *)cont
{
    controller = cont;
    CGRect viewFrame = controller.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [controller.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

+ (id)shareGeneric {
    static Generic *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

@end

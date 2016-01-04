//
//  Connection.m
//  JewishCard
//
//  Created by nissim h on 6/6/13.
//  Copyright (c) 2013 webit. All rights reserved.
//

#import "Connection.h"
#import <dispatch/dispatch.h>
#import "Reachability.h"
#import "Generic.h"

@interface Connection ()
{
    dispatch_queue_t queue;
    NSOperationQueue *operationQueue;
}
@end




@implementation Connection
@synthesize recordResults;
@synthesize webData;

Generic *generic;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)connectionToService: (NSString *)action jsonDictionary:(NSDictionary *)jsonDict controller:(UIViewController *)cont withSelector:(SEL)sel
{
    generic = [[Generic alloc] init];
    operationQueue =[NSOperationQueue new];
     [generic showNativeActivityIndicator:cont];
    if([self checkConnection]){
        _controller = cont;
        recordResults = FALSE;
        
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://qa.webit-track.com/ShantiWS/Service1.svc/%@", action]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        NSError *error;
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&error];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: requestData];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:operationQueue // created at class init
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
//                                   NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   dispatch_async(dispatch_get_main_queue(),^{
                                       if(error== NULL){
                                           [generic hideNativeActivityIndicator:cont];
                                           [cont performSelector:(sel) withObject:data];
                                       }else{
                                           [generic hideNativeActivityIndicator:cont];
                                           [self showError:@"אירעה שגיאה לא צפויה, אנא נסה שנית מאוחר יותר"];
                                       }
                                   });
                               }];
    }else{
        [generic hideNativeActivityIndicator:cont];
        [self showError:@"Your device is not connected with the internet, Please check your connections"];
    }
}


-(BOOL)checkConnection{
    if ([[Reachability reachabilityWithHostName:@"google.com"] currentReachabilityStatus] == ReachableViaWiFi) {
        return YES;
    } else if ([[Reachability reachabilityWithHostName:@"google.com"] currentReachabilityStatus] == ReachableViaWWAN) {
        return NO;
    } else if ([[Reachability reachabilityWithHostName:@"google.com"] currentReachabilityStatus] == NotReachable) {
        return NO;
    }
    return NO;
}

- (void)showError:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"הודעה" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}






-(void)getGoogleRoute: (double)originLat originLon:(double)originLon destinationLat:(double)destinationLat destinationLon:(double)destinationLon withSelector:(SEL)sel controller:(UIViewController *)cont
{
    generic = [[Generic alloc] init];
    
    if([self checkConnection]){
        recordResults = FALSE;
        [generic showNativeActivityIndicator:cont];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
        NSString* reqStr=[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=true&mode=driving&units=metric", originLat,originLon,destinationLat,destinationLon];
        [request setURL:[NSURL URLWithString: reqStr]];
        
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        NSURLResponse *response;
        NSError *err;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        
        NSString *responseBody = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        
        [cont performSelector:(sel) withObject:responseBody];
        [generic hideNativeActivityIndicator:cont];
    }else{
        [generic hideNativeActivityIndicator:cont];
        [self showError:@"Your device is not connected with the internet, Please check your connections"];
    }
    
    
}

- (void)connectionToService: (NSString *)action jsonDictionary:(NSDictionary *)jsonDict controller:(UIViewController *)cont withGeneric:(BOOL )useGeneric withSuccsessBlock:(void (^) (NSData *data))completion{
    generic = [[Generic alloc] init];
    if (useGeneric)
        [generic showNativeActivityIndicator:cont];
    
    
    operationQueue =[NSOperationQueue new];
    
    if([self checkConnection]){
        _controller = cont;
        recordResults = FALSE;
        
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://qa.webit-track.com/ShantiWS/Service1.svc/%@", action]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        NSError *error;
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&error];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: requestData];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:operationQueue // created at class init
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
//                                   NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   dispatch_async(dispatch_get_main_queue(),^{
                                       if(error== NULL){
                                           if (useGeneric)
                                               [generic hideNativeActivityIndicator:cont];
            
                                           completion(data);
                                       }else{
                                           if (useGeneric)
                                               [generic hideNativeActivityIndicator:cont];
                                           [self showError:@"אירעה שגיאה לא צפויה, אנא נסה שנית מאוחר יותר"];
                                       }
                                   });
                               }];
    }else{
        if (useGeneric)
            [generic hideNativeActivityIndicator:cont];
        [self showError:@"Your device is not connected with the internet, Please check your connections"];
    }

}

- (void)sendLocationWithjsonDictionary:(NSDictionary *)jsonDict controller:(UIViewController *)cont bakcToThreadQueue:(dispatch_queue_t)backgroudQueue withSuccsessBlock:(void (^) (NSData *data))completion{
    operationQueue =[NSOperationQueue new];
    
    if([self checkConnection]){
        _controller = cont;
        recordResults = FALSE;
        
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://qa.webit-track.com/ShantiWS/Service1.svc/%@", @"SetLocationGetUsersList"]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        NSError *error;
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&error];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: requestData];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:operationQueue // created at class init
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                                   //                                   NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   dispatch_async(backgroudQueue,^{
                                       if(error== NULL){
                                           
                                           completion(data);
                                       }else{
                                           [self showError:@"אירעה שגיאה לא צפויה, אנא נסה שנית מאוחר יותר"];
                                       }
                                   });
                               }];
    }else{
        [self showError:@"Your device is not connected with the internet, Please check your connections"];
    }
    
}
@end

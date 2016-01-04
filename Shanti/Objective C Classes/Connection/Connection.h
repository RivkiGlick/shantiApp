//
//  Connection.h
//  JewishCard
//
//  Created by nissim h on 6/6/13.
//  Copyright (c) 2013 webit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Generic.h"


@interface Connection : UIViewController {
    BOOL recordResults;
    NSMutableData *webData;
    
}

@property(nonatomic, strong) NSMutableData *webData;
@property(nonatomic, readwrite) BOOL recordResults;
@property (nonatomic, retain) UIViewController *controller;
@property (nonatomic,strong) Generic *generic;

//- (void)connectionToService: (NSString *)action jsonDictionary:(NSDictionary *)jsonDict controller:(UIViewController *)cont withSelector:(SEL)sel;
- (void)connectionToService: (NSString *)action jsonDictionary:(NSDictionary *)jsonDict controller:(UIViewController *)cont withGeneric:(BOOL )useGeneric withSuccsessBlock:(void (^) (NSData *data))completion;
- (void)sendLocationWithjsonDictionary:(NSDictionary *)jsonDict controller:(UIViewController *)cont bakcToThreadQueue:(dispatch_queue_t)backgroudQueue withSuccsessBlock:(void (^) (NSData *data))completion;
-(void)getGoogleRoute: (double)originLat originLon:(double)originLon destinationLat:(double)destinationLat destinationLon:(double)destinationLon withSelector:(SEL)sel controller:(UIViewController *)cont;
-(BOOL)checkConnection;
@end

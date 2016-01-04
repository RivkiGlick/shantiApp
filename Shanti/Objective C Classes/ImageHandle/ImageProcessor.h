//
//  ImageProcessor.h
//
//
//  
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol ImageProcessorDelegate <NSObject>
-(void)imageFound:(UIImage*)img;
@end

@interface ImageProcessor : NSObject

+ (UIImage*) getUserMarker:(UIImage*)pinImage UserImage:(UIImage*)userImage;
+ (UIImage*)logPixelsOfImage:(UIImage*)pinImage UserImage:(UIImage*)userImage;
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (void)bitMap:(UIImage*) pinImage;
+(UIImage*)getMarkerUser:(UIImage*)pinImage UserImage:(UIImage*)userImage;
-(void)PresentImage:(NSString*) assetUrl;

@property (weak, nonatomic) id<ImageProcessorDelegate> delegate;

@end

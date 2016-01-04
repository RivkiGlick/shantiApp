//
//  ImageProcessor.m
//  SpookCam
//
//  Created by Jack Wu on 2/21/2014.
//
//

#import "ImageProcessor.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

@interface ImageProcessor ()

@end

@implementation ImageProcessor
+ (UIImage*) getUserMarker:(UIImage*)pinImage UserImage:(UIImage*)userImage{
    // 1. Get pixels of image
    CGImageRef inputCGImage = [pinImage CGImage];
    NSUInteger width = CGImageGetWidth(inputCGImage);
    NSUInteger height = CGImageGetHeight(inputCGImage);
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    
    UInt32 * pixels;
    pixels = (UInt32 *) calloc(height * width, sizeof(UInt32));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixels, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), inputCGImage);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    CGImageRef userImageCGImage = [userImage CGImage];
    NSUInteger userImagewidth = CGImageGetWidth(userImageCGImage);
    NSUInteger userImageheight = CGImageGetHeight(userImageCGImage);
    
    NSUInteger userImagebytesPerPixel = 4;
    NSUInteger userImagebytesPerRow = userImagebytesPerPixel * userImagewidth;
    NSUInteger userImagebitsPerComponent = 8;
    
    UInt32 * userImagePixels;
    userImagePixels = (UInt32 *) calloc(userImagewidth * userImageheight, sizeof(UInt32));
    
    CGColorSpaceRef userImageColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef userImageContext = CGBitmapContextCreate(userImagePixels, userImagewidth, userImageheight,
                                                          userImagebitsPerComponent, userImagebytesPerRow, userImageColorSpace,
                                                          kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(userImageContext, CGRectMake(0, 0, userImagewidth, userImageheight), userImageCGImage);
    CGColorSpaceRelease(userImageColorSpace);
    
    #define Mask8(x) ( (x) & 0xFF )
    #define R(x) ( Mask8(x) )
    #define G(x) ( Mask8(x >> 8 ) )
    #define B(x) ( Mask8(x >> 16) )

    UInt32 *currentPixel = pixels;
    UInt32 * currentPixelUserImage = userImagePixels;
    for (NSUInteger j = 0; j < userImageheight; j++) {
        
        NSUInteger i = 0;
        currentPixel = pixels + j * width + i ;
        currentPixelUserImage = userImagePixels + j * userImagewidth + i ;
        UInt32 pixColor = *currentPixel;
        
        while (i < userImagewidth && (R(pixColor)+G(pixColor)+B(pixColor))/3.0 == 0){
            i++;
            currentPixel = pixels + j * width + i ;
            currentPixelUserImage = userImagePixels + j * userImagewidth + i ;
            pixColor = *currentPixel;
        }
    
        while (i < userImagewidth && (R(pixColor)+G(pixColor)+B(pixColor))/3.0 != 0) {
            *currentPixelUserImage = pixColor;
            i++;
            currentPixel = pixels + j * width + i ;
            currentPixelUserImage = userImagePixels + j * userImagewidth + i ;
            pixColor = *currentPixel;
        }
        
        
        
        if (i != userImagewidth){
            i = userImagewidth -1;
            currentPixel = pixels + j * width + i ;
            currentPixelUserImage = userImagePixels + j * userImagewidth + i ;
            pixColor = *currentPixel;
            
            while (i > 0 && (R(pixColor)+G(pixColor)+B(pixColor))/3.0 == 0){
                i--;
                currentPixel = pixels + j * width + i ;
                currentPixelUserImage = userImagePixels + j * userImagewidth + i ;
                pixColor = *currentPixel;
            }
            
            while (i > 0 && (R(pixColor)+G(pixColor)+B(pixColor))/3.0 != 0) {
                *currentPixelUserImage = pixColor;
                i--;
                currentPixel = pixels + j * width + i ;
                currentPixelUserImage = userImagePixels + j * userImagewidth + i ;
                pixColor = *currentPixel;
            }
            
        }
    }
    
    CGImageRef newCGImage = CGBitmapContextCreateImage(userImageContext);
    UIImage * processedImage = [UIImage imageWithCGImage:newCGImage];
    
    free(userImagePixels);
    
    #undef R
    #undef G
    #undef B
    
    return processedImage;

}
+ (void)bitMap:(UIImage*) pinImage{
    // 1. Get pixels of image
    CGImageRef inputCGImage = [pinImage CGImage];
    NSUInteger width = CGImageGetWidth(inputCGImage);
    NSUInteger height = CGImageGetHeight(inputCGImage);
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    
    UInt32 * pixels;
    pixels = (UInt32 *) calloc(height * width, sizeof(UInt32));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixels, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), inputCGImage);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
#define Mask8(x) ( (x) & 0xFF )
#define R(x) ( Mask8(x) )
#define G(x) ( Mask8(x >> 8 ) )
#define B(x) ( Mask8(x >> 16) )
    
    // 2. Iterate and log!
        NSLog(@"Brightness of image:");
    UInt32 * currentPixel = pixels;
        for (NSUInteger j = 0; j < height; j++) {
            for (NSUInteger i = 0; i < width; i++) {
                            UInt32 color = *currentPixel;
    
                            printf("%3.0f ", (R(color)+G(color)+B(color))/3.0);
                currentPixel++;
            }
                    printf("\n");
        }
    
            printf("qqqqqqqqqqqqqqqqqqqqq\n");
    
#undef R
#undef G
#undef B
}

+(UIImage*)getMarkerUser:(UIImage*)pinImage UserImage:(UIImage*)userImage{
    // 1. Get pixels of image
    CGImageRef inputCGImage = [pinImage CGImage];
    NSUInteger width = CGImageGetWidth(inputCGImage);
    NSUInteger height = CGImageGetHeight(inputCGImage);
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    
    UInt32 * pixels;
    pixels = (UInt32 *) calloc(height * width, sizeof(UInt32));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixels, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), inputCGImage);
    
    CGColorSpaceRelease(colorSpace);
//    CGContextRelease(context);
    
#define Mask8(x) ( (x) & 0xFF )
#define R(x) ( Mask8(x) )
#define G(x) ( Mask8(x >> 8 ) )
#define B(x) ( Mask8(x >> 16) )
    
    // 2. Iterate and log!
    //    NSLog(@"Brightness of image:");
    UInt32 * currentPixel = pixels;
        for (NSUInteger j = 0; j < height; j++) {
            for (NSUInteger i = 0; i < width; i++) {
                            UInt32 color = *currentPixel;
    
                            printf("%3.0f ", (R(color)+G(color)+B(color))/3.0);
                currentPixel++;
            }
                    printf("\n");
        }
    
            printf("qqqqqqqqqqqqqqqqqqqqq\n");
    
    CGImageRef userImageCGImage = [userImage CGImage];
    NSUInteger userImagewidth = CGImageGetWidth(userImageCGImage);
    NSUInteger userImageheight = CGImageGetHeight(userImageCGImage);
    
    NSUInteger userImagebytesPerPixel = 4;
    NSUInteger userImagebytesPerRow = userImagebytesPerPixel * userImagewidth;
    NSUInteger userImagebitsPerComponent = 8;
    
    UInt32 * userImagePixels;
    userImagePixels = (UInt32 *) calloc(userImagewidth * userImageheight, sizeof(UInt32));
    
    CGColorSpaceRef userImageColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef userImageContext = CGBitmapContextCreate(userImagePixels, userImagewidth, userImageheight,
                                                          userImagebitsPerComponent, userImagebytesPerRow, userImageColorSpace,
                                                          kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(userImageContext, CGRectMake(0, 0, userImagewidth, userImageheight), userImageCGImage);
    CGColorSpaceRelease(userImageColorSpace);
    
    UInt32 * currentPixelUserImage = userImagePixels;
    
    currentPixel = pixels;
    /*  UInt32 * */currentPixelUserImage = userImagePixels;
    for (NSUInteger j = 0; j < userImageheight; j++) {
        
        NSUInteger i = 0;
        currentPixel = pixels + j * width + i ;
        currentPixelUserImage = userImagePixels + j * userImagewidth + i ;
        UInt32 pixColor = *currentPixelUserImage;
        UInt32 pixColor1 = *currentPixel;
        
        while (i < userImagewidth && (R(pixColor1)+G(pixColor1)+B(pixColor1))/3.0 != 90 && (R(pixColor1)+G(pixColor1)+B(pixColor1))/3.0 != 91) {
            i++;
            currentPixel = pixels + j * width + i ;
            currentPixelUserImage = userImagePixels + j * userImagewidth + i ;
            pixColor1 = *currentPixel;
            pixColor = *currentPixelUserImage;
        }
        
        while (((i < userImagewidth && R(pixColor1)+G(pixColor1)+B(pixColor1))/3.0 == 90) || (i < userImagewidth && R(pixColor1)+G(pixColor1)+B(pixColor1))/3.0 == 9) {
            *currentPixel = pixColor;
            i++;
            currentPixel = pixels + j * width + i ;
            currentPixelUserImage = userImagePixels + j * userImagewidth + i ;
            pixColor1 = *currentPixel;
            pixColor = *currentPixelUserImage;
        }
//        while (i < userImagewidth && (R(pixColor1)+G(pixColor1)+B(pixColor1))/3.0 != 90 && (R(pixColor1)+G(pixColor1)+B(pixColor1))/3.0 != 91) {
//            i++;
//            currentPixel = pixels + j * width + i ;
//            currentPixelUserImage = userImagePixels + j * userImagewidth + i ;
//            pixColor = *currentPixelUserImage;
//            pixColor1 = *currentPixel;
//
//        };
//        
//        while (i < userImagewidth && ((R(pixColor1)+G(pixColor1)+B(pixColor1))/3.0 == 90 || (R(pixColor1)+G(pixColor1)+B(pixColor1))/3.0 == 91)) {
//            *currentPixel = pixColor;
//            i++;
//            currentPixel = pixels + j * width + i ;
//            currentPixelUserImage = userImagePixels + j * userImagewidth + i ;
//            pixColor = *currentPixelUserImage;
//            pixColor1 = *currentPixel;
//        }
//        
////        if (i != userImagewidth){
////            i = userImagewidth -1;
////            currentPixel = pixels + j * width + i ;
////            currentPixelUserImage = userImagePixels + j * userImagewidth + i ;
////            pixColor = *currentPixel;
////            
////            while (i > 0 && (R(pixColor)+G(pixColor)+B(pixColor))/3.0 == 0.0) {
////                *currentPixelUserImage = pixColor;
////                i--;
////                currentPixel = pixels + j * width + i ;
////                currentPixelUserImage = userImagePixels + j * userImagewidth + i ;
////                pixColor = *currentPixel;
////            }
////            
////        }
    }
    
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    UIImage * processedImage = [UIImage imageWithCGImage:newCGImage];
    
    free(userImagePixels);
    
    
    
#undef R
#undef G
#undef B
    
    
    return processedImage;
}
+ (UIImage*)logPixelsOfImage:(UIImage*)pinImage UserImage:(UIImage*)userImage{
    // 1. Get pixels of image
    CGImageRef inputCGImage = [pinImage CGImage];
    NSUInteger width = pinImage.size.width;//CGImageGetWidth(inputCGImage);
    NSUInteger height = pinImage.size.height;//CGImageGetHeight(inputCGImage);
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    
    UInt32 * pixels;
    pixels = (UInt32 *) calloc(height * width, sizeof(UInt32));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixels, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), inputCGImage);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
#define Mask8(x) ( (x) & 0xFF )
#define R(x) ( Mask8(x) )
#define G(x) ( Mask8(x >> 8 ) )
#define B(x) ( Mask8(x >> 16) )
    
    // 2. Iterate and log!
//    NSLog(@"Brightness of image:");
    UInt32 * currentPixel = pixels;
//    for (NSUInteger j = 0; j < height; j++) {
//        for (NSUInteger i = 0; i < width; i++) {
//                        UInt32 color = *currentPixel;
//            
//                        printf("%3.0f ", (R(color)+G(color)+B(color))/3.0);
//            currentPixel++;
//        }
//                printf("\n");
//    }
//    
//        printf("qqqqqqqqqqqqqqqqqqqqq\n");
    
    CGImageRef userImageCGImage = [userImage CGImage];
    NSUInteger userImagewidth = userImage.size.width;//CGImageGetWidth(userImageCGImage);
    NSUInteger userImageheight = userImage.size.height;//CGImageGetHeight(userImageCGImage);
    
    NSUInteger userImagebytesPerPixel = 4;
    NSUInteger userImagebytesPerRow = userImagebytesPerPixel * userImagewidth;
    NSUInteger userImagebitsPerComponent = 8;
    
    UInt32 * userImagePixels;
    userImagePixels = (UInt32 *) calloc(userImagewidth * userImageheight, sizeof(UInt32));
    
    CGColorSpaceRef userImageColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef userImageContext = CGBitmapContextCreate(userImagePixels, userImagewidth, userImageheight,
                                                          userImagebitsPerComponent, userImagebytesPerRow, userImageColorSpace,
                                                          kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(userImageContext, CGRectMake(0, 0, userImagewidth, userImageheight), userImageCGImage);
    CGColorSpaceRelease(userImageColorSpace);
//    CGContextRelease(userImageContext);
    
     UInt32 * currentPixelUserImage = userImagePixels;
//    for (NSUInteger j = 0; j < height; j++) {
//        for (NSUInteger i = 0; i < width; i++) {
//                UInt32 color = *currentPixelUserImage;
//                printf("%3.0f ", (R(color)+G(color)+B(color))/3.0);
//                currentPixelUserImage++;
//            }
//            printf("\n");
//        }
//
//        NSLog(@"Brightness of image:");
    currentPixel = pixels;
  /*  UInt32 * */currentPixelUserImage = userImagePixels;
    for (NSUInteger j = 0; j < userImageheight; j++) {
        
        NSUInteger i = 0;
        currentPixel = pixels + j * width + i ;
        currentPixelUserImage = userImagePixels + j * userImagewidth + i ;
        UInt32 pixColor = *currentPixel;
        
        
        while (i < userImagewidth && (R(pixColor)+G(pixColor)+B(pixColor))/3.0 == 0.0) {
            *currentPixelUserImage = pixColor;
            i++;
            currentPixel = pixels + j * width + i ;
            currentPixelUserImage = userImagePixels + j * userImagewidth + i ;
            pixColor = *currentPixel;
        }
        
        if (i != userImagewidth){
            i = userImagewidth -1;
            currentPixel = pixels + j * width + i ;
            currentPixelUserImage = userImagePixels + j * userImagewidth + i ;
            pixColor = *currentPixel;
            
            while (i > 0 && (R(pixColor)+G(pixColor)+B(pixColor))/3.0 == 0.0) {
                *currentPixelUserImage = pixColor;
                i--;
                currentPixel = pixels + j * width + i ;
                currentPixelUserImage = userImagePixels + j * userImagewidth + i ;
                pixColor = *currentPixel;
            }
            
        }
    }
    
    CGImageRef newCGImage = CGBitmapContextCreateImage(userImageContext);
    UIImage * processedImage = [UIImage imageWithCGImage:newCGImage];
    
    free(userImagePixels);


    
#undef R
#undef G
#undef B
    
    
    return processedImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)PresentImage:(NSString*) assetUrl{
    
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *rep = [myasset defaultRepresentation];
        CGImageRef iref = [rep fullResolutionImage];
        if (iref) {
            UIImage *largeimage = [UIImage imageWithCGImage:iref];
            [self.delegate imageFound:largeimage];
//            yourImageView.image = largeImage;
//            return UIImage
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
    {
        NSLog(@"Can't get image - %@",[myerror localizedDescription]);
//        return nil
    };
    
    NSURL *asseturl = [NSURL URLWithString:assetUrl];
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:asseturl
                   resultBlock:resultblock
                  failureBlock:failureblock];
}
@end

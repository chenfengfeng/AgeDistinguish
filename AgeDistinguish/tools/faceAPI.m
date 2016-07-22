//
//  faceAPI.m
//  AgeRecognition
//
//  Created by 陈泽峰 on 15/8/14.
//  Copyright (c) 2015年 Feng. All rights reserved.
//

#import "faceAPI.h"
#import <FaceppAPI.h>

#define _API_KEY @"d5e6073baa632071b7b737e1bf6546ff"
#define _API_SECRET @"qwCkMyHhdY20S5zVLq5dSBc0VaqifHjt"

@interface faceAPI()

@end

static faceAPI *_share = nil;

@implementation faceAPI

+(faceAPI *)shareFace
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _share = [[faceAPI alloc]init];
    });
    return _share;
}

+(void)initWithFaceApi
{
    [FaceppAPI initWithApiKey:_API_KEY andApiSecret:_API_SECRET andRegion:APIServerRegionCN];
}

- (UIImage *)fixOrientation:(UIImage *)aImage
{
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

-(void)detectionWithImage:(UIImage *)image Sucess:(SuccessBlock)sucessBlock Error:(ErrorBlock)errorBlock
{
    // 顶部小菊花
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
    
    [faceAPI initWithFaceApi];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        FaceppResult *result = [[FaceppAPI detection] detectWithURL:nil orImageData:UIImageJPEGRepresentation(image, 0.3) mode:FaceppDetectionModeOneFace attribute:FaceppDetectionAttributeAll];
        if (result.success && [[[result content]valueForKey:@"face"] count] > 0) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            sucessBlock([result content][@"face"][0][@"attribute"]);
            
        } else {
            NSError *error = [NSError errorWithDomain:@"获取信息错误!\n解析人物图像发生异常\n请重新选择人物图片进行解析" code:404 userInfo:nil];
            errorBlock(error);
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    });
}

-(NSString *)getFaceID:(UIImage *)image
{
    FaceppResult *result = [[FaceppAPI detection] detectWithURL:nil orImageData:UIImageJPEGRepresentation(image, 0.3) mode:FaceppDetectionModeOneFace attribute:FaceppDetectionAttributeNone];
    if (result.success && [[[result content]valueForKey:@"face"] count] > 0) {
        return [result content][@"face"][0][@"face_id"];
    }else{
        return @"0";
    }
}

@end

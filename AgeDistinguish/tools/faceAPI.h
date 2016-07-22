//
//  faceAPI.h
//  AgeRecognition
//
//  Created by 陈泽峰 on 15/8/14.
//  Copyright (c) 2015年 Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SuccessBlock)(NSDictionary *dic);
typedef void (^ErrorBlock)(NSError *error);

@interface faceAPI : NSObject

 /** 单例 */
+(faceAPI *)shareFace;

- (UIImage *)fixOrientation:(UIImage *)aImage;

-(void)detectionWithImage:(UIImage *)image Sucess:(SuccessBlock)sucessBlock Error:(ErrorBlock)errorBlock;

@end

//
//  FFTextView.h
//  AgeDistinguish
//
//  Created by Mac on 16/6/30.
//  Copyright © 2016年 chenfengfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CompleteBlock)(void);
typedef void (^FinishBlock)(void);

@interface FFTextView : UITextView
 /** 索引 */
@property (nonatomic) int currentIndex;
/** 网络加载完成 */
@property (nonatomic) BOOL isOK;
 /** 正文 */
@property (nonatomic,strong) NSMutableString *contentText;

-(void)startPrint;

-(void)continuePrint;

@property (nonatomic, copy) CompleteBlock completeblock;
@property (nonatomic, copy) FinishBlock finish;

@end

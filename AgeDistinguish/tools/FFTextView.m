//
//  FFTextView.m
//  AgeDistinguish
//
//  Created by Mac on 16/6/30.
//  Copyright © 2016年 chenfengfeng. All rights reserved.
//

#import "FFTextView.h"
//#import <AudioToolbox/AudioToolbox.h>

static FFTextView *_share;
//static SystemSoundID soundID = 0;
@implementation FFTextView

-(NSMutableString *)contentText
{
    if (!_contentText) {
        _contentText = [NSMutableString string];
    }
    return _contentText;
}

-(void)startPrint
{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"typing" ofType:@"wav"];
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    [NSTimer scheduledTimerWithTimeInterval:0.07 target:self selector:@selector(outPutWord:) userInfo:nil repeats:YES];
}

-(void)continuePrint
{
    [NSTimer scheduledTimerWithTimeInterval:0.07 target:self selector:@selector(continuePutWord:) userInfo:nil repeats:YES];
}

-(void)outPutSound:(id)atimer
{
//    AudioServicesPlaySystemSound (soundID);
}

-(void)outPutWord:(id)atimer
{
    if (self.contentText.length == self.currentIndex) {
        [atimer invalidate];
        atimer = nil;
        if (self.isOK) {
            self.completeblock();
        }
    }else{
        self.currentIndex++;
//        AudioServicesPlaySystemSound (soundID);
        NSString *str = [self.contentText substringWithRange:NSMakeRange(0, self.currentIndex)];
        str = [NSString stringWithFormat:@"%@_",str];
        self.text = str;
        [self scrollRangeToVisible:NSMakeRange(self.text.length, 1)];
    }
}

-(void)continuePutWord:(id)atimer
{
    if (self.contentText.length == self.currentIndex) {
        [atimer invalidate];
        atimer = nil;
//        AudioServicesPlaySystemSound (0);
        NSString *str = self.text;
        self.text = [str substringWithRange:NSMakeRange(0, str.length-1)];
        self.finish();
    }else{
//        AudioServicesPlayAlertSound(soundID);
        self.currentIndex++;
        NSString *str = [self.contentText substringWithRange:NSMakeRange(0, self.currentIndex)];
        str = [NSString stringWithFormat:@"%@_",str];
        self.text = str;
        [self scrollRangeToVisible:NSMakeRange(self.text.length, 1)];
    }
}

@end

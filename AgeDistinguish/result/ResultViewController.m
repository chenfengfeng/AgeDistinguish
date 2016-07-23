//
//  ResultViewController.m
//  AgeDistinguish
//
//  Created by Feng on 16/6/28.
//  Copyright © 2016年 chenfengfeng. All rights reserved.
//

#import "ResultViewController.h"
#import <BmobSDK/Bmob.h>
#import <UMSocial.h>
#import "faceAPI.h"
#import "FFTextView.h"

@interface ResultViewController ()
 /** 照片 */
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (nonatomic,strong) UIImage *photo;
 /** 结果正文 */
@property (weak, nonatomic) IBOutlet  FFTextView *content;
 /** 分享按钮 */
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@end

@implementation ResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.photoView.image = self.photo;
    
    self.content.layoutManager.allowsNonContiguousLayout = NO;
    
    NSString *str1 = @"插入栓 插入...\n解放传导系统 准备接续...\n探针插入 完毕\n神经同调装置在基准范围内\n第一次接触...\n主电源连接完毕...\n开始进行第二次接触...\n交互界面连接...\n思考形态以中文作为基准,进行思维连接...\n连接没有异常\n同步率为 1000.0000%\n第一锁定器解除...\n第二锁定器解除...\n连接服务器进行扫描...\n正在获取人物信息...\n";
    NSString *str2 = @"准备启动系统\n神经同调装置在基准范围内\n连接器检测通过\n识别系统检测通过\n感应系统启动完毕\n交互界面连接...\n思考形态以中文作为基准,进行思维连接...\n连接没有异常\n同步率为 1000.0000%\n解除所有限制\n连接服务器进行扫描...\n正在获取人物信息...\n";
    NSString *str3 = @"第一次接触...\n主电源连接完毕...\n开始进行第二次接触...\n交互界面连接...\n连接没有异常\n同步率为 1000.0000%\n第一锁定器解除...\n第二锁定器解除...\n连接服务器进行扫描...\n正在获取人物信息...\n";
    
    NSArray *arr = [NSArray arrayWithObjects:str1,str2,str3, nil];
    [self.content.contentText appendString:arr[arc4random_uniform(3)]];
    [self.content startPrint];
    
    [[faceAPI shareFace] detectionWithImage:self.photo Sucess:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.content.currentIndex==self.content.contentText.length) {
                [self getMessage:dic];
            }else{
                self.content.isOK = YES;
                self.content.completeblock = ^{
                    [self getMessage:dic];
                };
            }
            
        });
    } Error:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.content.currentIndex==self.content.contentText.length) {
                [self.content.contentText appendString:error.domain];
                [self.content continuePrint];
            }else{
                self.content.isOK = YES;
                self.content.completeblock = ^{
                    [self.content.contentText appendString:error.domain];
                    [self.content continuePrint];
                };
            }
            self.content.finish = ^{
            };
        });
    }];
}

-(void)getMessage:(NSDictionary *)dic
{    /** 性别 */
    NSString *gender;
    float genderconfidence = [dic[@"gender"][@"confidence"]floatValue];
    if ([dic[@"gender"][@"value"]isEqualToString:@"Female"]) gender = @"妹子"; else gender = @"汉子";
    /** 年龄 */
    int age = [dic[@"age"][@"value"]intValue];
    int agerange = [dic[@"age"][@"range"]intValue];
    /** 种族 */
    NSString *race;
    if ([dic[@"race"][@"value"]isEqualToString:@"White"]||[dic[@"race"][@"value"]isEqualToString:@"Asian"]) race = @"亚洲人"; else race = @"黑种人";
    float raceconfidence = [dic[@"race"][@"confidence"]floatValue];
    /** 表情&欢乐值 */
    NSString *mood;
    float smiling = [dic[@"smiling"][@"value"]floatValue];
    if (smiling < 10.0) mood = @"淡定"; else if(smiling > 10.0 && smiling < 50.0) mood = @"开心";else mood = @"欢乐";
    /** 魅力值 */
    float charm;
    if (age<10) {
        charm = 20-agerange;
    }else if (age>=10 && age<20){
        charm = 30-agerange;
    }else if (age>=20 && age<30){
        charm = 40-agerange;
    }else if (age>=30 && age<40){
        charm = 30-agerange;
    }else{
        charm = 20-agerange;
    }
    charm = charm*smiling;
    
    //获取排行
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"ranking"];
    [bquery whereKey:@"charm" greaterThan:[NSNumber numberWithInt:charm]];
    [bquery countObjectsInBackgroundWithBlock:^(int number,NSError  *error){
        NSString *message = [NSString stringWithFormat:@"获取相关信息成功!\n性别:%@(%.2f%%)\n年龄:%d岁(±%d岁)\n种族:%@(%.2f%%)\n心情:%@\n欢乐值:%.2f\n魅力值:%.f\n当前排名:第%d名\n信息获取完毕!",gender,genderconfidence,age,agerange,race,raceconfidence,mood,smiling,charm,number+1];
        
        [self.content.contentText appendString:message];
        [self.content continuePrint];
        
        self.content.finish = ^{
            self.shareBtn.enabled = YES;
            [self updateMessage:age gender:gender charm:charm];
        };
    }];
}

#pragma mark - 数据库操作
#pragma mark 更新数据
-(void)updateMessage:(int)age gender:(NSString *)gender charm:(int)charm
{
    BmobObject *obj = [[BmobObject alloc] initWithClassName:@"ranking"];
    [obj setObject:[NSNumber numberWithInt:age] forKey:@"age"];
    [obj setObject:gender forKey:@"gender"];
    [obj setObject:[NSNumber numberWithInt:charm] forKey:@"charm"];
    [obj saveInBackground];
}

#pragma mark - 点击事件
- (IBAction)click_back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)click_share
{
    //延迟是为了让按钮在截图后恢复
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *shareText = @"如果你问我年龄,我只能说无可奉告,但是你可以用<年龄识别>看出来.";
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareText;
        [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:nil
                                          shareText:shareText
                                         shareImage:[self cutWithView:self.view]
                                    shareToSnsNames:@[UMShareToWechatTimeline,UMShareToWechatSession,UMShareToWechatFavorite,UMShareToSina,UMShareToQQ,UMShareToQzone,UMShareToInstagram,UMShareToLine]
                                           delegate:nil];
    });
}

#pragma mark -截图
- (UIImage *)cutWithView:(UIView *)view
{
    // 截图
    UIView *cutView = view;
    
    // 截出原图
    CGSize size = CGSizeMake(cutView.frame.size.width, cutView.frame.size.height);
    UIGraphicsBeginImageContextWithOptions(size, YES, 2.0);
    
    // 将cutView的图层渲染到上下文中
    [cutView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // 取出UIImage
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return image;
}

@end

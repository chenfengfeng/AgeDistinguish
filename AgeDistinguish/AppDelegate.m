//
//  AppDelegate.m
//  AgeDistinguish
//
//  Created by Mac on 16/6/17.
//  Copyright © 2016年 chenfengfeng. All rights reserved.
//

#import "AppDelegate.h"
#import <UMSocialInstagramHandler.h>
#import <UMSocialSinaSSOHandler.h>
#import <UMSocialWechatHandler.h>
#import <UMMobClick/MobClick.h>
#import <UMSocialLineHandler.h>
#import <UMSocialQQHandler.h>
#import <BmobSDK/Bmob.h>
#import <UMSocial.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //友盟统计
    UMConfigInstance.appKey = @"553bab0067e58e9639002255";
    [MobClick startWithConfigure:UMConfigInstance];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    //友盟分享
    [UMSocialData setAppKey:@"553bab0067e58e9639002255"];
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToWechatFavorite,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToLine,UMShareToInstagram,UMShareToQzone]];
    //微信
    [UMSocialWechatHandler setWXAppId:@"wx8a27f10fa1998421" appSecret:@"0965a8bab29685914923e22d421b6457" url:@"https://itunes.apple.com/cn/app/nian-ling-shi-bie-qi/id845996071?mt=8"];
    //QQ
    [UMSocialQQHandler setQQWithAppId:@"1104208414" appKey:@"aFuEWNVWg8Q3IRtZ" url:@"https://itunes.apple.com/cn/app/nian-ling-shi-bie-qi/id845996071?mt=8"];
    //微博
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"2213057972"
                                              secret:@"b26589c9697964fe29dd203e18948170"
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    //Instagram
    [UMSocialInstagramHandler openInstagramWithScale:YES paddingColor:[UIColor blackColor]];
    //line
    [UMSocialLineHandler openLineShare:UMSocialLineMessageTypeImage];
    //BMOB
    [Bmob registerWithAppKey:@"9ea81061d628a9170d410f4e3fb104e6"];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

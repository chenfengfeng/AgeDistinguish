//
//  MainViewController.m
//  AgeDistinguish
//
//  Created by Mac on 16/6/27.
//  Copyright © 2016年 chenfengfeng. All rights reserved.
//

#import "MainViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

#define kiconWH 100

@interface MainViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,GADBannerViewDelegate>

 /** 相机按钮 */
@property (nonatomic,strong) UIButton *camera;
 /** 相册按钮 */
@property (nonatomic,strong) UIButton *photo;
 /** 广告 */
@property (weak, nonatomic) IBOutlet UIView *ADView;
@property (strong, nonatomic) GADBannerView *bannerView;

@end

@implementation MainViewController

-(UIButton *)camera
{
    if (!_camera) {
        _camera = [UIButton buttonWithType:UIButtonTypeCustom];
        [_camera setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
        [_camera setFrame:CGRectMake((kScreenW*0.25)-(kiconWH/2), kScreenH, kiconWH, kiconWH)];
        [_camera addTarget:self action:@selector(click_camera) forControlEvents:UIControlEventTouchUpInside];
        [_camera setAlpha:0.0];
    }
    return _camera;
}

-(UIButton *)photo
{
    if (!_photo) {
        _photo = [UIButton buttonWithType:UIButtonTypeCustom];
        [_photo setImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
        [_photo setFrame:CGRectMake((kScreenW*0.75)-(kiconWH/2), kScreenH, kiconWH, kiconWH)];
        [_photo addTarget:self action:@selector(click_photo) forControlEvents:UIControlEventTouchUpInside];
        [_photo setAlpha:0.0];
    }
    return _photo;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /** 添加按钮 */
    [self.view addSubview:self.camera];
    [self.view addSubview:self.photo];
    /** 动画 */
    [UIView animateWithDuration:1.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_camera setFrame:CGRectMake((kScreenW*0.25)-(kiconWH/2), kScreenH*0.7, kiconWH, kiconWH)];
        [_camera setAlpha:1.0];
    } completion:nil];
    
    [UIView animateWithDuration:1.0 delay:0.3 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_photo setFrame:CGRectMake((kScreenW*0.75)-(kiconWH/2), kScreenH*0.7, kiconWH, kiconWH)];
        [_photo setAlpha:1.0];
    } completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     /** 广告 */
    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    self.bannerView.adUnitID = @"ca-app-pub-3818890078157411/5592023889";
    self.bannerView.delegate = self;
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];
}

#pragma mark 广告协议
- (void)adViewDidReceiveAd:(GADBannerView *)adView
{
    [self.ADView addSubview:self.bannerView];
    self.ADView.hidden = NO;
}

#pragma mark - 点击按钮事件
-(void)click_camera
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self presentViewController:picker animated:YES completion:nil];
    }];
}

-(void)click_photo
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self presentViewController:picker animated:YES completion:nil];
    }];
}

#pragma mark - 代理
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *OriginalImage = info[UIImagePickerControllerEditedImage];
    
    NSLog(@"%@",OriginalImage);
    
    UIViewController *resultVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"result"];
    [resultVC setValue:OriginalImage forKey:@"photo"];
    [self.navigationController pushViewController:resultVC animated:NO];
    
    // 恢复按钮起始位置
    [_camera setFrame:CGRectMake((kScreenW*0.25)-(kiconWH/2), kScreenH, kiconWH, kiconWH)];
    [_photo setFrame:CGRectMake((kScreenW*0.75)-(kiconWH/2), kScreenH, kiconWH, kiconWH)];
    [_camera setAlpha:0.0];
    [_photo setAlpha:0.0];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end

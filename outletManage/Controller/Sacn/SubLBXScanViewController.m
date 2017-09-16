//
//
//
//
//  Created by lbxia on 15/10/21.
//  Copyright © 2015年 lbxia. All rights reserved.
//

#import "SubLBXScanViewController.h"
#import <LBXScanResult.h>
#import <LBXScanWrapper.h>
#import "oneButtonAlert.h"
//#import "MyQRViewController.h"
//#import "ScanResultViewController.h"



@interface SubLBXScanViewController ()<oneButtonAlertDelegate>

@end

@implementation SubLBXScanViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    self.style = style;
//    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
//        
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
    
    self.view.backgroundColor = [UIColor blackColor];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

         [self drawBottomItems];
        [self drawTitle];
         [self.view bringSubviewToFront:_topTitle];

   
}

- (void)drawTitle
{
    if (!_topTitle)
    {
        self.topTitle = [[UILabel alloc]init];
        _topTitle.bounds = CGRectMake(0, 0, 145, 60);
        _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 50);
        
        //3.5inch iphone
        if ([UIScreen mainScreen].bounds.size.height <= 568 )
        {
            _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 38);
            _topTitle.font = [UIFont systemFontOfSize:14];
        }

        _topTitle.textAlignment = NSTextAlignmentCenter;
        _topTitle.numberOfLines = 0;
        _topTitle.text = @"将取景框对准二维码即可自动扫描";
        _topTitle.textColor = [UIColor whiteColor];
        [self.view addSubview:_topTitle];
    }
    
    
}

- (void)drawBottomItems
{
    if (_bottomItemsView) {
        
        return;
    }
    
    self.bottomItemsView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60,SCREEN_WIDTH, 60)];
    self.bottomItemsView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [self.view addSubview:self.bottomItemsView];
    

    self.btnBack = [[UIButton alloc]init];
    self.btnBack.frame = CGRectMake(0, 0, _bottomItemsView.width/2, _bottomItemsView.height);
    [self.btnBack setTitle:@"返回" forState:UIControlStateNormal];
    [self.btnBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomItemsView addSubview:self.btnBack];
    
    self.btnPhoto = [[UIButton alloc]init];
    self.btnPhoto.frame = CGRectMake(_btnBack.right, 0, _bottomItemsView.width/2, _bottomItemsView.height);
    [self.btnPhoto setTitle:@"相册" forState:UIControlStateNormal];
    [self.btnPhoto addTarget:self action:@selector(openPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomItemsView addSubview:self.btnPhoto];
    
    
}


- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    
    if (array.count < 1)
    {
        [self popAlertMsgWithScanResult:nil];
     
        return;
    }
    
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    for (LBXScanResult *result in array) {
        
        NSLog(@"scanResult:%@",result.strScanned);
    }
    
    LBXScanResult *scanResult = array[0];
    
    NSString*strResult = scanResult.strScanned;
    
    self.scanImage = scanResult.imgScanned;
    
    if (!strResult) {
        
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //震动提醒
    [LBXScanWrapper systemVibrate];
    //声音提醒
    [LBXScanWrapper systemSound];
    
    if ([self.delegate respondsToSelector:@selector(scanData:)]) {
        
        [self.delegate scanData:scanResult.strScanned];
        
        [self backAction];
    }

}

- (void)popAlertMsgWithScanResult:(NSString*)strResult
{
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"识别失败" preferredStyle:UIAlertControllerStyleAlert];
//    __weak __typeof(self) weakSelf = self;
//    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//        [weakSelf reStartDevice];
//    }];
//    [alert addAction:defaultAction];
//    [self presentViewController:alert animated:YES completion:nil];
    
    
    oneButtonAlert *alertView = [[[NSBundle mainBundle]loadNibNamed:@"oneButtonAlert" owner:self options:nil] lastObject];
    alertView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    alertView.alert.text = @"提示";
    alertView.message.text = @"识别失败";
    alertView.tag = 100;
    [alertView.button setTitle:@"确定" forState:UIControlStateNormal];
    alertView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.4];
    alertView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
    
}

- (void)buttonMethod:(oneButtonAlert *)view {

    if (view.tag == 100) {
        [self reStartDevice];
    }else {
    
        
    }
}

//
//- (void)showNextVCWithScanResult:(LBXScanResult*)strResult
//{
//    ScanResultViewController *vc = [ScanResultViewController new]; 
//    vc.strScan = strResult.strScanned;
//        CGSize size = CGSizeMake(CGRectGetWidth(self.view.frame)-12, CGRectGetWidth(self.view.frame)-12);
//        vc.imgScan = [LBXScanWrapper createQRWithString: strResult.strScanned size:size];
//    [self.navigationController pushViewController:vc animated:YES];
//}
//

#pragma mark -底部功能项
//打开相册
- (void)openPhoto
{
    if ([LBXScanWrapper isGetPhotoPermission])
        [self openLocalPhoto];
    else{
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请到设置->隐私中开启本程序相册权限" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//            
//        }];
//        [alert addAction:defaultAction];
//        [self presentViewController:alert animated:YES completion:nil];
        
        
        oneButtonAlert *alertView = [[[NSBundle mainBundle]loadNibNamed:@"oneButtonAlert" owner:self options:nil] lastObject];
        alertView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        alertView.alert.text = @"提示";
        alertView.message.text = @"请到设置->隐私中开启本程序相册权限";
        alertView.tag = 100;
        [alertView.button setTitle:@"OK" forState:UIControlStateNormal];
        alertView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.4];
        alertView.delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:alertView];
    }
}

- (void)backAction {

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

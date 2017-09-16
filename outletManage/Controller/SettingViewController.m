//
//  SettingViewController.m
//  outletManage
//
//  Created by 张海勇 on 16/3/12.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "SettingViewController.h"
#import "GestuerPwdVC.h"
#import "LoginTimeSet.h"
#import "LoginViewController.h"
#import "CustomAlertView.h"
@interface SettingViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *sw;


@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    [self setNavigationLeft:@"back"];
    
    if ([[Uitils getUserDefaultsForKey:isOpenGestuerPwd] isEqualToString:@"YES"]) {
        [_sw setOn:YES];
    }else {
    
        [_sw setOn:NO];
    }
    
}

- (IBAction)swAction:(id)sender {
    
    UISwitch *sw = (UISwitch *)sender;
    
    if (sw.isOn) {
        [sw setOn:YES];
        
        [Uitils setUserDefaultsObject:@"YES" ForKey:isOpenGestuerPwd];
        
    }else {
    
        [sw setOn:NO];
        [Uitils setUserDefaultsObject:@"NO" ForKey:isOpenGestuerPwd];
    }
    
    
}

- (IBAction)changeGesturePwd:(id)sender {
    
    GestuerPwdVC *vc = [[GestuerPwdVC alloc]init];
    vc.isReset = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)LoginTimeSet:(id)sender {
    
    LoginTimeSet *loginTimeSet = [[[NSBundle mainBundle] loadNibNamed:@"LoginTimeSet" owner:self options:nil] lastObject];
    loginTimeSet.frame = self.view.bounds;
    [self.view addSubview:loginTimeSet];
}

- (IBAction)clearCache:(id)sender {

    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"清除缓存?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [Uitils alertWithTitle:@"缓存清除成功"];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}




- (IBAction)Logout:(id)sender {
    
    LoginViewController *login = [[LoginViewController alloc]init];
    kAppDelegate.window.rootViewController = login;
}

@end

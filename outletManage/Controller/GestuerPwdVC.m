//
//  textgestuerPwdVC.m
//  outletManage
//
//  Created by ksm on 16/3/10.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "GestuerPwdVC.h"
#import "DBGuestureLock.h"
#import "MainViewController.h"
#import "LoginViewController.h"
@interface GestuerPwdVC ()
@property (nonatomic,strong) UIButton *tips;
@property (nonatomic,strong)  UIImageView *avatar;
@property (nonatomic,strong)  UILabel *nick;
@property (nonatomic,strong)  NSString *oldPassword;

@end

@implementation GestuerPwdVC
{

    DBGuestureLock *guestureLock;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"1919门店管理";
    
    if (self.isReset) {
        _oldPassword = [DBGuestureLock getGuestureLockPassword];
        NSLog(@"fff = %@",_oldPassword);
        [DBGuestureLock clearGuestureLockPassword];
        
        [self setNavigationLeft:@"back"];
    }

    self.view.backgroundColor = [Uitils colorWithHex:backgroudColor];
    
    self.avatar = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-30, 30, 60, 60)];
    self.avatar.layer.cornerRadius = 30;
    self.avatar.backgroundColor  = [Uitils colorWithHex:avatarBackgroundColor];
    [self.view addSubview:self.avatar];
    
    
    self.nick = [[UILabel alloc]initWithFrame:CGRectMake(0, self.avatar.bottom, SCREEN_WIDTH, 40)];
    self.nick.textAlignment = NSTextAlignmentCenter;
    self.nick.textColor = [UIColor blackColor];
    self.nick.text = _account.verify.phonenum;
    [self.view addSubview:self.nick];
    
    
    //Working with block:
    guestureLock = [DBGuestureLock lockOnView:self.view onPasswordSet:^(DBGuestureLock *lock, NSString *password) {
        if (password.length<4) {
            [Uitils alertWithTitle:@"密码太简单了"];
            [DBGuestureLock clearGuestureLockPassword];
            
        }
        else if(lock.firstTimeSetupPassword == nil) {
            lock.firstTimeSetupPassword = password;
             NSLog(@"varify your password = %@",password);
            [Uitils alertWithTitle:@"请确认手势设定"];
        }
    } onGetCorrectPswd:^(DBGuestureLock *lock, NSString *password) {
        if (lock.firstTimeSetupPassword && ![lock.firstTimeSetupPassword isEqualToString:DBFirstTimeSetupPassword]) {
            lock.firstTimeSetupPassword = DBFirstTimeSetupPassword;
            [Uitils alertWithTitle:@"手势设定完成"];;
            
        } else {
            NSLog(@"login success");
            [Uitils alertWithTitle:@"登录成功"];
            
        }
        [Uitils setUserDefaultsObject:[FxDate stringFromDateYMDHMS:[NSDate date]] ForKey:LastGestuerPwdDate];
        
        //重设密码，返回上一页
        if (self.isReset) {
            
            [self performSelector:@selector(changePwd) withObject:self afterDelay:1];
            
        }else{ //从后台返回，进入主页
            
            [self performSelector:@selector(toMainVC) withObject:self afterDelay:1];
        }
        
    } onGetIncorrectPswd:^(DBGuestureLock *lock, NSString *password) {
        
        NSLog(@"firstTimeSetupPassword = %@",lock.firstTimeSetupPassword);
        
        if (![lock.firstTimeSetupPassword isEqualToString:DBFirstTimeSetupPassword]&&lock.firstTimeSetupPassword) {
            NSLog(@"Error: password not equal to first setup!");
            [Uitils alertWithTitle:@"两次密码不一致"];
            [DBGuestureLock clearGuestureLockPassword];
        } else {
            NSLog(@"login failed");
            [Uitils alertWithTitle:@"密码错误"];
        }
    }];
    
    [self.view addSubview:guestureLock];
    
    self.tips = [[UIButton alloc]initWithFrame:CGRectMake(0, guestureLock.bottom+10, SCREEN_WIDTH, 30)];
    [self.tips addTarget:self action:@selector(otherLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.tips setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];;
    
    if (self.isFirst|| self.isReset) {
        [self.tips setTitle:@"请设置手势密码" forState:UIControlStateNormal];
    }else {
        [self.tips setTitle:@"切换登录" forState:UIControlStateNormal];
    }
    
    [self.view addSubview:self.tips];
}

- (void)changePwd {

     [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)doBack:(id)sender {

    guestureLock.firstTimeSetupPassword = _oldPassword;
    [Uitils setUserDefaultsObject:_oldPassword ForKey:DBFirstTimeSetupPassword];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)toMainVC {

    MainViewController *mainVC = [[MainViewController alloc]init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:mainVC];
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)otherLogin:(UIButton *)sender {

    if ([sender.titleLabel.text isEqualToString:@"切换登录"]) {
        LoginViewController *login = [[LoginViewController alloc]init];
        [Uitils setUserDefaultsObject:@"NO" ForKey:isOpenGestuerPwd];
        kAppDelegate.window.rootViewController = login;
        
    }
}


@end

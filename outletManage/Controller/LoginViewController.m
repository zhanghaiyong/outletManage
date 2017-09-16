//
//  LoginViewController.m
//  outletManage
//
//  Created by ksm on 16/3/10.
//  Copyright © 2016年 ksm. All rights reserved.
//

#define logoWidth  80
#define SPAC       20
#import "LoginViewController.h"
#import "UIView+Line.h"
#import "GestuerPwdVC.h"
#import "getVerifyCodeParams.h"
#import "LoginParams.h"
#import "UserMsgModel.h"
#import "UserMsgTool.h"
#import "MainViewController.h"
#import "DBGuestureLock.h"
@interface LoginViewController ()
{
    UIView *nameView;
    UIView *codeView;
    UITextField *nameTF;
    UITextField *codeTF;
    UIButton *codeButton;
    NSInteger count;
    NSTimer *timer;
    UIButton *loginButton;
    UILabel *label1;
    UILabel *label2;
    UIButton *button;
    UserMsgModel *userMsgModel;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userMsgModel = [UserMsgTool account];

    [self setUp];
}

- (void)backgoundColor {

    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setUp {

    //蓝色背景
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,190)];
    backImage.image = [UIImage imageNamed:@"hz-logo"];
    [self.view addSubview:backImage];

    
    //用户名输入框底层view
    nameView = [[UIView alloc]initWithFrame:CGRectMake(SPAC, backImage.bottom+SPAC, SCREEN_WIDTH-SPAC*2, 44)];
    nameView.layer.cornerRadius = CORNER_RADIUS;
    nameView.layer.borderWidth = 1;
    nameView.clipsToBounds = YES;
    nameView.layer.borderColor = [Uitils colorWithHex:buttonTitleColor].CGColor;
    [self.view addSubview:nameView];
    
    //用户名输入框
    nameTF = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, nameView.width, nameView.height)];
    nameTF.placeholder = @"用户名";
    nameTF.text = @"";
    nameTF.keyboardType = UIKeyboardTypeNumberPad;
    nameTF.font = [UIFont systemFontOfSize:MEDIUM_FONT];
    nameTF.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *nameIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hz-people"]];
    nameIV.width += 15;
    nameIV.contentMode = UIViewContentModeCenter;
    nameTF.leftView = nameIV;
    [nameView addSubview:nameTF];
    
    //验证码输入底层view
    codeView = [[UIView alloc]initWithFrame:CGRectMake(SPAC, nameView.bottom+SPAC, SCREEN_WIDTH-SPAC*2, 44)];
    codeView.layer.cornerRadius = CORNER_RADIUS;
    codeView.layer.borderWidth = 1;
    codeView.clipsToBounds = YES;
    codeView.layer.borderColor = [Uitils colorWithHex:buttonTitleColor].CGColor;
    [self.view addSubview:codeView];
    
    //验证码输入框
    codeTF = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, nameView.width/5*3, nameView.height)];
    codeTF.placeholder = @"输入验证码";
    codeTF.keyboardType = UIKeyboardTypeNumberPad;
    codeTF.font = [UIFont systemFontOfSize:MEDIUM_FONT];
    codeTF.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *codeIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hz-lock"]];
    codeIV.width += 15;
    codeIV.contentMode = UIViewContentModeCenter;
    codeTF.leftView = codeIV;
    [codeView addSubview:codeTF];
    
    //分割线
    UIView *line = [UIView lineWithFrame:CGRectMake(codeTF.right, 0, 1, codeView.height) color:[Uitils colorWithHex:buttonTitleColor]];
    [codeView addSubview:line];
    
    //获取验证码
    codeButton = [[UIButton alloc]initWithFrame:CGRectMake(line.right, 0, codeView.width-codeTF.width, codeView.height)];
    [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeButton setTitleColor:[Uitils colorWithHex:buttonTitleColor] forState:UIControlStateNormal];
    codeButton.titleLabel.font = [UIFont systemFontOfSize:MEDIUM_FONT];
    codeButton.tag = 1000;
    [codeButton addTarget:self action:@selector(getCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    [codeView addSubview:codeButton];
    
    //登录按钮
    loginButton = [[UIButton alloc]initWithFrame:CGRectMake(SPAC, codeView.bottom+SPAC, SCREEN_WIDTH-SPAC*2, 44)];
    loginButton.backgroundColor = [Uitils colorWithHex:buttonTitleColor];
    loginButton.layer.cornerRadius = CORNER_RADIUS;
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:MAX_FONT];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, loginButton.bottom+SPAC, 100, 30)];
    label1.font =[UIFont systemFontOfSize:MEDIUM_FONT];
    label1.text = @"接收不到验证码？尝试一下";
    label1.textColor = [UIColor blackColor];
    [self.view addSubview:label1];
    
    button = [[UIButton alloc]initWithFrame:CGRectMake(label1.right, loginButton.bottom+SPAC, 100, 30)];
    [button setTitleColor:[Uitils colorWithHex:buttonTitleColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = CORNER_RADIUS;
    button.titleLabel.font = [UIFont systemFontOfSize:MEDIUM_FONT];
    [button addTarget:self action:@selector(getCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 1001;
    [button setTitle:@"语音验证码" forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    label2 = [[UILabel alloc]initWithFrame:CGRectMake(button.right, loginButton.bottom+SPAC, 20, 30)];
    label2.font =[UIFont systemFontOfSize:MEDIUM_FONT];
    label2.textColor = [UIColor blackColor];
    label2.text = @"吧";
    [self.view addSubview:label2];
    
    [self initTips:@"语言验证码" color:[Uitils colorWithHex:buttonTitleColor]];
}

- (void)initTips:(NSString *)tips color:(UIColor *)color {

    NSString *str1 = @"接收不到验证码？尝试一下";
    NSString *str2 = @"吧";
    
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:loginButton];
    
    CGRect frame1 = [str1 boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:MEDIUM_FONT]} context:nil];
    
    CGRect frame2 = [tips boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:MEDIUM_FONT]} context:nil];
    
    CGRect frame3 = [str2 boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:MEDIUM_FONT]} context:nil];
    

    label1.frame = CGRectMake(SCREEN_WIDTH/2-(frame1.size.width+frame2.size.width+frame3.size.width)/2, loginButton.bottom+SPAC, frame1.size.width, 30);
    button.frame =  CGRectMake(label1.right, loginButton.bottom+SPAC, frame2.size.width, 30);
    [button setTitle:tips forState:UIControlStateNormal];
    label2.frame = CGRectMake(button.right, loginButton.bottom+SPAC, frame3.size.width, 30);
}

- (void)login:(UIButton *)sender {
    
    
    if (![validateFile checkTel:nameTF.text]) {
        
        [Uitils alertWithTitle:@"请输入正确的手机号码"];
        
    }else if(codeTF.text.length == 0){
    
        [Uitils alertWithTitle:@"请输入验证码"];
    }else {
        
        [self showGifAnimation];

        LoginParams *params = [[LoginParams alloc]init];
        params.phone_num = nameTF.text;
        params.code      = codeTF.text;
        
        NSLog(@"%@",params.mj_keyValues);
        
        [KSMNetworkRequest postRequest:KLogin params:params.mj_keyValues success:^(id responseObj) {
            
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingAllowFragments error:nil];
            
            [self stopGifAnimation];
            
        if ([[dic objectForKey:@"success"] integerValue] == 1) {
            
            NSDictionary *msg = [dic objectForKey:@"attributes"];
            UserMsgModel *model = [UserMsgModel mj_objectWithKeyValues:msg];
            model.verify.phonenum = nameTF.text;
                
            if (userMsgModel) {
                    
                if (![userMsgModel.verify.phonenum isEqualToString:nameTF.text]) {
                    
                    [Uitils UserDefaultRemoveObjectForKey:ReadedNewsID];
                    [DBGuestureLock clearGuestureLockPassword];
                    [Uitils setUserDefaultsObject:@"YES" ForKey:isOpenGestuerPwd];
                }
            }
            
            [UserMsgTool saveAccount:model];
            
            if ([[Uitils getUserDefaultsForKey:isOpenGestuerPwd] isEqualToString:@"YES"]) {
                
                if ([DBGuestureLock passwordSetupStatus] == YES) {
                    
                    MainViewController *mainVC = [[MainViewController alloc]init];
                    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:mainVC];
                    [self presentViewController:navi animated:YES completion:nil];
                    
                }else {
                
                    GestuerPwdVC *gesturePwd = [[GestuerPwdVC alloc]init];
                    gesturePwd.isFirst = YES;
                    [self presentViewController:gesturePwd animated:NO completion:nil];
                }
            }else {
            
                MainViewController *mainVC = [[MainViewController alloc]init];
                UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:mainVC];
                [self presentViewController:navi animated:YES completion:nil];
            }
            
        }else {
        
            [Uitils alertWithTitle:[dic objectForKey:@"obj"]];
        }
        NSLog(@"%@",dic);
            
        } failure:^(NSError *error) {
            
            NSLog(@"%@",error);
            [self stopGifAnimation];
            
        }];
    }
}

#pragma mark 获取验证码
- (void)getCodeAction:(UIButton *)sender {
    
    switch (sender.tag) {
        case 1000: //获取验证码
            
            if ([sender.currentTitle isEqualToString:@"获取验证码"]) {
                
                if (![validateFile checkTel:nameTF.text]) {
                    
                    [Uitils alertWithTitle:@"请输入正确的手机号码"];
                    
                }else {
                
                    getVerifyCodeParams *params = [[getVerifyCodeParams alloc]init];
                    params.phone_num = nameTF.text;
                    params.mesType = @"sms";
                    [self requestdata:params.mj_keyValues];
                    
                }
            }
            
            break;
        case 1001: //语音验证码
            
            if ([sender.currentTitle isEqualToString:@"语言验证码"]) {
                
                if (![validateFile checkTel:nameTF.text]) {
                    
                    [Uitils alertWithTitle:@"请输入正确的手机号码"];
                    
                }else {
                    
                    getVerifyCodeParams *params = [[getVerifyCodeParams alloc]init];
                    params.phone_num = nameTF.text;
                    params.mesType = @"voice";
                    [self requestdata:params.mj_keyValues];
                    
                }
            }
            
            break;
        default:
            break;
    }
    
}

- (void)requestdata:(NSDictionary *)params {

    count = 60;
    [nameTF resignFirstResponder];
    
    [KSMNetworkRequest postRequest:KGetVerifyCode params:params success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingAllowFragments error:nil];
        [Uitils alertWithTitle:[dic objectForKey:@"obj"]];
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
    [codeButton setTitle:[NSString stringWithFormat:@"重新获取(%ld)",(long)count] forState:UIControlStateNormal];
    codeButton.alpha = 0.7;
    [self initTips:[NSString stringWithFormat:@"重新获取(%ld)",(long)count] color:[Uitils colorWithHex:buttonTitleColor]];
}

#pragma mark 验证倒计时
- (void)countDown:(NSTimer *)time {
    
    if (count == 1) {
        [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [button setTitle:@"语言验证码" forState:UIControlStateNormal];
        [codeButton setTitleColor:[Uitils colorWithHex:buttonTitleColor] forState:UIControlStateNormal];
        [time invalidate];
    }else {
        count--;
        [codeButton setTitle:[NSString stringWithFormat:@"重新获取(%ld)",(long)count] forState:UIControlStateNormal];
        [self initTips:[NSString stringWithFormat:@"重新获取(%ld)",(long)count] color:[Uitils colorWithHex:buttonTitleColor]];
    }
    
}

@end

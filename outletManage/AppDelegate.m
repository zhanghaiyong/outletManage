//
//  AppDelegate.m
//  outletManage
//
//  Created by ksm on 16/3/10.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "NewFeatureViewController.h"
#import "IQKeyboardManager.h"
#import "DBGuestureLock.h"
#import "GestuerPwdVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    [Uitils reach];
    
    //键盘控制
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    if ([Uitils getUserDefaultsForKey:NewFeature]) {
        
        if ([[Uitils getUserDefaultsForKey:isOpenGestuerPwd] isEqualToString:@"YES"]) {
            
            NSString *dateString = [Uitils getUserDefaultsForKey:LastGestuerPwdDate];
            NSDate *date = [FxDate dateFromStringYMDHMS:dateString];
            NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:date];
            //大于登录时间
            if ([Uitils getUserDefaultsForKey:TimeParag] && interval > [[Uitils getUserDefaultsForKey:TimeParag] doubleValue]) {
                
                LoginViewController *rootVC = [[LoginViewController alloc]init];
                self.window.rootViewController = rootVC;
                
            }else {
            
                GestuerPwdVC *gesture = [[GestuerPwdVC alloc]init];
                self.window.rootViewController = gesture;
            }
        }else {
        
            LoginViewController *rootVC = [[LoginViewController alloc]init];
            self.window.rootViewController = rootVC;
        }
    }else {
        
        //引导页
        [Uitils setUserDefaultsObject:@"YES" ForKey:NewFeature];
        //默认手势密码开启
        [Uitils setUserDefaultsObject:@"YES" ForKey:isOpenGestuerPwd];
        
        //登录时间默认为7天
        NSTimeInterval interval = 60*60*7;
        [Uitils setUserDefaultsObject:[NSNumber numberWithDouble:interval] ForKey:TimeParag];
        
        NewFeatureViewController *newFeatureViewController = [[NewFeatureViewController alloc]init];
        self.window.rootViewController = newFeatureViewController;
    }
    
    [[UINavigationBar appearance] setBarTintColor:[Uitils colorWithHex:naviBarColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor redColor]}];
    
    
    //设置UINavigationBar标题的字体风格
    //    NSShadow *shadow    = [[NSShadow alloc] init];
    //    shadow.shadowColor  = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    //    shadow.shadowOffset = CGSizeMake(0, 0.4);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor blackColor],
                                                           NSForegroundColorAttributeName,
                                                           nil, NSShadowAttributeName,
                                                           [UIFont boldSystemFontOfSize:25],
                                                           NSFontAttributeName, nil]];
    

    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if ([[Uitils getUserDefaultsForKey:isOpenGestuerPwd] isEqualToString:@"YES"]) {
        
        NSString *dateString = [Uitils getUserDefaultsForKey:LastGestuerPwdDate];
        NSDate *date = [FxDate dateFromStringYMDHMS:dateString];
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:date];
        
        //大于两分钟,从后台返回需要手势密码
        if (interval > 30) {
            
            GestuerPwdVC *controller = [[GestuerPwdVC alloc] init];
            
            if (self.window.rootViewController != nil) {
                CGRect frame = self.window.rootViewController.view.bounds;
                controller.view.frame = frame;
                [[UIApplication sharedApplication].keyWindow addSubview:controller.view];
            }
            else {
                self.window.rootViewController = controller;
                [self.window makeKeyAndVisible];
            }
        }
        
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

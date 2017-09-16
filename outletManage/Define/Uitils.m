//
//  Uitils.m
//  MouthHealth
//
//  Created by 张海勇 on 15/3/16.
//  Copyright (c) 2015年 张海勇. All rights reserved.
//

#import "Uitils.h"
#import "UIImageView+WebCache.h"
#import "AFNetworkReachabilityManager.h"

static MBProgressHUD *HUD = nil;

@implementation Uitils
//检测可用网络
+ (void)reach {
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络,不花钱
     */
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case 0:
                [Uitils alertWithTitle:@"请检查网络"];
                break;
            case 1:
                [Uitils alertWithTitle:@"网络已连接"];
                
                break;
            case 2:
                [Uitils alertWithTitle:@"wifi已连接"];
                
                break;
            default:
                break;
        }
        
        NSLog(@"%ld",status);
    }];
}


+ (void)shake:(UITextField *)label {
    
    label.transform = CGAffineTransformIdentity;
    [UIView beginAnimations:nil context:nil];//动画的开始
    [UIView setAnimationDuration:0.05];//完成时间
    [UIView setAnimationRepeatCount:3];//重复
    [UIView setAnimationRepeatAutoreverses:YES];//往返运动
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];//控制速度变化
    label.transform = CGAffineTransformMakeTranslation(-5, 0);//设置横纵坐标的移动
    [UIView commitAnimations];//动画结束
}


//照片压缩
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

+(void)returnHUD:(UIView *)view title:(NSString *)title img:(NSString *)imgname {
    
    //    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    HUD.labelText = title;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgname]];
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
    //    });
}

+ (MBProgressHUD *)sharedHUD {
    static MBProgressHUD *HUD = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    });
    return HUD;
}

//获取AuthData
+ (id)getUserDefaultsForKey:(NSString *)key
{
    if (key ==nil || [key length] <=0) {
        return nil;
    }
    id  AuthData = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return AuthData;
}

//保存AuthData
+ (void)setUserDefaultsObject:(id)value ForKey:(NSString *)key
{
    if (key !=nil && [key length] >0) {
        [[NSUserDefaults standardUserDefaults]setObject:value forKey:key];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

//删除NSUserdefault
+ (void)UserDefaultRemoveObjectForKey:(NSString *)key
{
    if (key !=nil && [key length] >0) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (UIColor *)colorWithHex:(unsigned long)col {
    unsigned char r, g, b;
    b = col & 0xFF;
    g = (col >> 8) & 0xFF;
    r = (col >> 16) & 0xFF;
    return [UIColor colorWithRed:(double)r/255.0f green:(double)g/255.0f blue:(double)b/255.0f alpha:1];
}

//提示信息
+ (void)alertWithTitle:(NSString *)title {
    
    [HUD removeFromSuperview];
    HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    HUD.mode = MBProgressHUDModeText;
    HUD.userInteractionEnabled = NO;
    HUD.margin = 10;
    HUD.removeFromSuperViewOnHide = YES;
    HUD.labelText = title;
    [HUD show:YES];
    [HUD hide:YES afterDelay:0.8];

}


+(NSArray *)returnWeekdy:(NSDate *)date
{

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitDay
                                         fromDate:date];
    // 得到星期几
    // 1(星期天) 2(星期二) 3(星期三) 4(星期四) 5(星期五) 6(星期六) 7(星期天)
    NSInteger weekDay = [comp weekday];
    // 得到几号
    NSInteger day = [comp day];

    // 计算当前日期和这周的星期一和星期天差的天数
    long firstDiff,lastDiff;
    if (weekDay == 1) {
        firstDiff = 1;
        lastDiff = 0;
    }else{
        firstDiff = [calendar firstWeekday] - weekDay;
        lastDiff = 9 - weekDay;
    }
    
    // 在当前日期(去掉了时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    [firstDayComp setDay:day + firstDiff];
    NSDate *firstDayOfWeek= [calendar dateFromComponents:firstDayComp];
    
    NSDateComponents *lastDayComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    [lastDayComp setDay:day + lastDiff];
    NSDate *lastDayOfWeek= [calendar dateFromComponents:lastDayComp];
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM"];
//    NSLog(@"星期一开始 %@",[formater stringFromDate:firstDayOfWeek]);
//    NSLog(@"当前 %@",[formater stringFromDate:now]);
//    NSLog(@"星期天结束 %@",[formater stringFromDate:lastDayOfWeek]);
    
    return [[NSArray alloc]initWithObjects:[formater stringFromDate:firstDayOfWeek],[formater stringFromDate:date],[formater stringFromDate:lastDayOfWeek], nil];
}

+(BOOL)isEmpty:(NSString *)text
{
    if (text.length == 0) {
        return YES;
    }
    return NO;
}


+(NSString *)isNullClass:(id)obj
{
    if ([obj isEqual:[NSNull null]]) {
        return @"";
    }
    return obj;
}

+(NSString *)nullClass:(NSString *)obj returnStr:(NSString *)str
{
    if (obj.length == 0) {
        return str;
    }
    return obj;
}


//获取documents下的文件路径
+ (NSString *)getDocumentsPath:(NSString *)fileName {
    
    NSString *documents = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *path = [documents stringByAppendingPathComponent:fileName];
    return path;
}

//给你一个方法，输入参数是NSDate，输出结果是星期几的字符串。
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

@end

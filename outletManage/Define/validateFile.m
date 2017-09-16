//
//  validateFile.m
//  cdcarlife
//
//  Created by ksm on 15/12/7.
//  Copyright © 2015年 ksm. All rights reserved.
//

#import "validateFile.h"

@implementation validateFile

/*车牌号验证 MODIFIED BY HELENSONG*/
+ (BOOL)validateCarNo:(NSString*)carNo {
    NSString *carRegex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:carNo];
}

//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


+ (BOOL)checkTel:(NSString *)str {
    
    NSString * MOBILE = @"^((13[0-9])|(14[^4,\\D])|(15[^4,\\D])|(18[0-9]))\\d{8}$|^1(7[0-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if ([regextestmobile evaluateWithObject:str] == YES){
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)validateAge_driverAge:(NSString *)ageString {

    NSString * MOBILE = @"^[0-9]*$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if ([regextestmobile evaluateWithObject:ageString] == YES){
        return YES;
    }else{
        return NO;
    }
}


+ (NSString *)TimespToTimeStr:(NSTimeInterval)timesp {

     NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timesp/1000];
    NSString *weekly = [Uitils weekdayStringFromDate:confromTimesp];
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"yyyy年MM月dd日  HH时mm分";
    NSString *timeStr = [formatter stringFromDate:confromTimesp];
    NSMutableString *params = [NSMutableString stringWithString:timeStr];
    [params insertString:weekly atIndex:12];
    return params;
}

+ (BOOL)isBoy:(NSString *)sex {
    
    if ([sex integerValue] == 1) {
        return NO;
    }else {
        
        return YES;
    }
}

+ (NSString *)nullClass:(NSString *)obj returnStr:(NSString *)str {
    if (obj.length == 0) {
        return str;
    }
    return obj;
}


@end

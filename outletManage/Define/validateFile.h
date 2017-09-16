//
//  validateFile.h
//  cdcarlife
//
//  Created by ksm on 15/12/7.
//  Copyright © 2015年 ksm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface validateFile : NSObject


/*车牌号验证 MODIFIED BY HELENSONG*/
+ (BOOL)validateCarNo:(NSString*)carNo;

+ (BOOL)checkTel:(NSString *)str;

//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
//邮箱
+ (BOOL) validateEmail:(NSString *)email;

//时间戳转时间
+ (NSString *)TimespToTimeStr:(NSTimeInterval)timesp;

+ (BOOL)isBoy:(NSString *)sex;

+(NSString *)nullClass:(NSString *)obj returnStr:(NSString *)str;
@end

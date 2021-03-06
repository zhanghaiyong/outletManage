//
//  Uitils.h
//  MouthHealth
//
//  Created by 张海勇 on 15/3/16.
//  Copyright (c) 2015年 张海勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface Uitils : NSObject

+ (void)shake:(UITextField *)label;

+ (void)reach;
//照片压缩
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

+(void)returnHUD:(UIView *)view title:(NSString *)title img:(NSString *)imgname;

+ (MBProgressHUD *)sharedHUD;

//获取AuthData
+ (id)getUserDefaultsForKey:(NSString *)key;

//保存AuthData
+ (void)setUserDefaultsObject:(id)value ForKey:(NSString *)key;

//删除NSUserdefault
+ (void)UserDefaultRemoveObjectForKey:(NSString *)key;

//颜色转换
+ (UIColor *)colorWithHex:(unsigned long)col;

//提示信息
+ (void)alertWithTitle:(NSString *)title;


+(NSArray *)returnWeekdy:(NSDate *)date;


+(BOOL)isEmpty:(NSString *)text;

//判断是否为NSNUll对象
+(NSString *)isNullClass:(id)obj;

+(NSString *)nullClass:(NSString *)obj returnStr:(NSString *)str;

+ (NSString *)getDocumentsPath:(NSString *)fileName;


//给你一个方法，输入参数是NSDate，输出结果是星期几的字符串。
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;


@end


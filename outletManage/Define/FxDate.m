//
//  FxDate.m
//  FxUtility
//
//  Created by Jinbo He on 12-5-15.
//  Copyright (c) 2012年 Hejinbo. All rights reserved.
//

#import "FxDate.h"

#define YMDFormat       @"YYYYMMdd"

#define Y_M_DFormat       @"YYYY-MM-dd"
#define YMDEHMFormat    @"YYYY-MM-dd EEE HH:mm"
#define YMDHMSFormat    @"YYYY-MM-dd HH:mm:ss"

static NSDateFormatter *s_formatterYMD = nil;
static NSDateFormatter *s_formatterYMDEHM = nil;
static NSDateFormatter *s_formatterYMDHMS = nil;

@implementation FxDate 

+ (NSDate *)adjustDateHour:(NSDate *)srcDate 
                   minHour:(NSUInteger)minHour 
                   maxHour:(NSUInteger)maxHour 
                   fitHour:(NSUInteger)fitHour
{
    //参数有效性检查
    if (srcDate == nil) {
        return srcDate;
    }
    if (minHour >= 24 || maxHour >= 24 || fitHour >=24) {
        minHour %= 24;
        maxHour %= 24;
        fitHour %= 24;
    }
    
    NSInteger unitFlags = NSCalendarUnitHour;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componets = [calendar components:unitFlags fromDate:srcDate];  
    NSInteger hour = [componets hour];
    
    if (hour <= minHour) {
        //(NSInteger)(fitHour-hour)*60*60：必须先转为NSInteger，否则无符号相减后的负数是自动转换为非常大的double类型
        srcDate = [srcDate dateByAddingTimeInterval:(NSInteger)(fitHour-hour)*60*60];
    }
    else if (hour >= maxHour) {
        srcDate = [srcDate dateByAddingTimeInterval:(24+fitHour-hour)*60*60];
    }
    
    return srcDate;
}

+ (NSString *)stringFromDate:(NSDate *)date
                    formater:(NSDateFormatter * __strong *)formatter
                      format:(NSString *)format
{
    if (*formatter == nil) {
        *formatter = [[NSDateFormatter alloc] init];
        
        [*formatter setLocale:[NSLocale  currentLocale]];
        [*formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        [*formatter setDateStyle:NSDateFormatterMediumStyle];
        [*formatter setTimeStyle:NSDateFormatterShortStyle];
        [*formatter setDateFormat:format];
    }
    
    return [*formatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)dateString
                  formater:(NSDateFormatter * __strong *)formatter
                    format:(NSString *)format
{
    if (dateString.length <= 0) {
        return [NSDate date];
    }
    if (*formatter == nil) {
        *formatter = [[NSDateFormatter alloc] init];
        
        [*formatter setLocale:[NSLocale  currentLocale]];
        [*formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        [*formatter setDateStyle:NSDateFormatterMediumStyle];
        [*formatter setTimeStyle:NSDateFormatterShortStyle];
        [*formatter setDateFormat:format];
    }
    
    return [*formatter dateFromString:dateString];
}


+ (NSString *)stringFromDateY_M_D:(NSDate *)date
{
    return [FxDate stringFromDate:date formater:&s_formatterYMD format:Y_M_DFormat];
}

+ (NSDate *)dateFromStringY_M_D:(NSString *)dateString
{
    return [FxDate dateFromString:dateString formater:&s_formatterYMD format:Y_M_DFormat];
}


+ (NSString *)stringFromDateYMD:(NSDate *)date
{
    return [FxDate stringFromDate:date formater:&s_formatterYMD format:YMDFormat];
}

+ (NSDate *)dateFromStringYMD:(NSString *)dateString
{
    return [FxDate dateFromString:dateString formater:&s_formatterYMD format:YMDFormat];
}



+ (NSString *)stringFromDateYMDEHM:(NSDate *)date
{
    return [FxDate stringFromDate:date formater:&s_formatterYMDEHM format:YMDEHMFormat];
}

+ (NSDate *)dateFromStringYMDEHM:(NSString *)dateString
{
    return [FxDate dateFromString:dateString formater:&s_formatterYMDEHM format:YMDEHMFormat];
}

+ (NSString *)stringFromDateYMDHMS:(NSDate *)date
{
    return [FxDate stringFromDate:date formater:&s_formatterYMDHMS format:YMDHMSFormat];
}

+ (NSDate *)dateFromStringYMDHMS:(NSString *)dateString
{
    return [FxDate dateFromString:dateString formater:&s_formatterYMDHMS format:YMDHMSFormat];
}

+ (NSString *)getYear:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = nil;
    
    /*
     // 年月日获得
     comps = [calendar components:NSYearCalendarUnit  | NSMonthCalendarUnit |
     NSDayCalendarUnit
     fromDate:date];
     */
    comps = [calendar components:NSCalendarUnitYear fromDate:date];
    NSString *year = [NSString stringWithFormat:@"%@", @([comps year])];
    
    return year;
}

+ (NSString *)getMonth:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSCalendarUnitMonth fromDate:date];
    NSString *month = [NSString stringWithFormat:@"%@", @([comps month])];
    
    return month;
}

+ (NSString *)getDay:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = nil;
    
    comps = [calendar components:
             NSCalendarUnitDay fromDate:date];
    NSString *day = [NSString stringWithFormat:@"%@", @([comps day])];
    
    return day;
}

+ (NSDate *)dateWithStamp:(double)timeStamp {

    return [NSDate dateWithTimeIntervalSince1970:timeStamp];
}

+ (NSDate *)date:(NSDate *)date LastMonth:(NSInteger)count {

    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *compoents = [cal components:(NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [compoents setMonth:([compoents month] - count)];
    return [cal dateFromComponents:compoents];
}

@end

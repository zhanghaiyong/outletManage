//
//  Defaults.h
//  有车生活
//
//  Created by ksm on 15/11/2.
//  Copyright © 2015年 ksm. All rights reserved.
//

#ifndef Defaults_h
#define Defaults_h


#endif /* Defaults_h */

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define RGBA(r,g,b,a)      [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
//
//#define BASE_BACKCOLOR     RGBA(240,240,240,1)
//#define MAIN_COLOR         0x177EFB
//#define LINE_COLOR         BASE_BACKCOLOR
#define placeholder_Color  RGBA(204,204,204,1)
//#define ALERT_COLOR        RGBA(142,142,142,1)
//#define noClick            RGBA(159,217,244,1)
//#define heightLoghted      RGBA(58,133,167,1)
//#define TITLE_COLOR        RGBA(59,59,59,1)


//帐号信息
#define Account  @"account"

#define NewFeature  @"NewFeature"
//门店总数
#define STORESTOTAL @"storesTotal"

//圆角
#define CORNER_RADIUS 4


//高德地图APIKey
const static NSString *APIKey = @"ceb82ef94584d0dd03e3a66b95572177";

//shareSDK APIKey
const static NSString *SMSKey = @"c373e2a8cd1e";
const static NSString *SMSecret = @"bf42dc2382f06a6bc05846365ce14b76";

#define kAppDelegate   ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#define MAX_FONT   17
#define MEDIUM_FONT   15
#define SMALL_FONT  13

/**
 *  是否开启手势密码
 */
#define isOpenGestuerPwd           (@"isOpenGestuerPwd")
/**
 *  密码设置时间
 */
#define LastGestuerPwdDate       (@"LastGestuerPwdDate")

/**
 *  设置的时间段
 */
#define TimeParag            (@"timeParag")

#define ReadedNewsID              (@"ReadedNewsID")

#define NewestDate           (@"NewestDate")





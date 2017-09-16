//
//  noticeList.h
//  text
//
//  Created by ksm on 16/3/14.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface noticeListParams : NSObject
/**
 *  获取公告列表
 */

/**
*  取“”不限时间
*/
@property (nonatomic,strong)NSString *flagTime;

/**
 *  取“down”或“up” 获取flagTime时间下方或上方的数据
 */
@property (nonatomic,strong)NSString *flag;

/**
 *  关键字搜索条件
 */
@property (nonatomic,strong)NSString *searchName;
@end

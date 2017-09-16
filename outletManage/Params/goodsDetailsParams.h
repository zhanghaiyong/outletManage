//
//  goodsDetails.h
//  text
//
//  Created by ksm on 16/3/14.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  显示一条商品的销售信息情况
 */

@interface goodsDetailsParams : NSObject
/**
 *  商品 编号
 */
@property (nonatomic,strong)NSString *itemCode;
/**
 *  暂时用“”
 */
@property (nonatomic,strong)NSString *dateFlag;
/**
 *  用户名
 */
@property (nonatomic,strong)NSString *userName;
/**
 *  店门列表,all为全部
 */
@property (nonatomic,strong)NSString *stores;
/**
 *  开始时间
 */
@property (nonatomic,strong)NSString *startTime;
/**
 *  结束时间
 */
@property (nonatomic,strong)NSString *endTime;
@end

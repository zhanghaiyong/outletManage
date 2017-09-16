//
//  getMainData.h
//  text
//
//  Created by ksm on 16/3/14.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface getMainDataParams : NSObject
/**
 *  手机号码
 */
@property (nonatomic,strong)NSString *username;
/**
 *  暂时用“”
 */
@property (nonatomic,strong)NSString *dateFlag;
/**
 *  查看门店列表，查看所有门店用“all”
 */
@property (nonatomic,strong)NSString *stores;
/**
 *  数据起始时间
 */
@property (nonatomic,strong)NSString *startTime;
/**
 *  数据结束时间
 */
@property (nonatomic,strong)NSString *endTime;
/**
 *  新通告查看时间
 */
@property (nonatomic,strong)NSString *newnoticeTime;

@property (nonatomic,strong)NSString *qryGB;
@property (nonatomic,strong)NSString *ver;
@end

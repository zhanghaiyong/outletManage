//
//  SaleCheckParams.h
//  outletManage
//
//  Created by 张海勇 on 16/3/21.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaleCheckParams : NSObject

@property (nonatomic,strong)NSString *dateFlag;
@property (nonatomic,strong)NSString *username;
@property (nonatomic,strong)NSString *stores;
@property (nonatomic,strong)NSString *startTime;
@property (nonatomic,strong)NSString *endTime;
@property (nonatomic,strong)NSString *channelType;
@property (nonatomic,strong)NSString *channelCode;

@end

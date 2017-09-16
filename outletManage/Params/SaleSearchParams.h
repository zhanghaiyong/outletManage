//
//  SaleSearchParams.h
//  outletManage
//
//  Created by 张海勇 on 16/3/22.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaleSearchParams : NSObject
@property (nonatomic,strong)NSString *username;
@property (nonatomic,strong)NSString *page;
@property (nonatomic,strong)NSString *pageSize;
@property (nonatomic,strong)NSString *stores;
@property (nonatomic,strong)NSString *dateFlag;
@property (nonatomic,strong)NSString *startTime;
@property (nonatomic,strong)NSString *endTime;
@property (nonatomic,strong)NSString *saleQueryKey;
@property (nonatomic,strong)NSString *saleQueryValue;

@property (nonatomic,strong)NSString *channelType;
@property (nonatomic,strong)NSString *channelCode;
@end

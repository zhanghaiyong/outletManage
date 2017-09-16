//
//  StockDetailParams.h
//  outletManage
//
//  Created by 张海勇 on 16/3/25.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockDetailParams : NSObject

@property (nonatomic,strong)NSString *itemCode;
@property (nonatomic,strong)NSString *username;
@property (nonatomic,strong)NSString *stores;
@property (nonatomic,strong)NSString *page;
@property (nonatomic,strong)NSString *pageSize;
@end

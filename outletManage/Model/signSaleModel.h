//
//  signSaleModel.h
//  outletManage
//
//  Created by 张海勇 on 16/3/21.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface signSaleModel : NSObject
/**
 *  商品条码
 */
@property (nonatomic,strong)NSString *code;
/**
 *  商品名称
 */
@property (nonatomic,strong)NSString *item_name;
/**
 *  商品数量
 */
@property (nonatomic,strong)NSString *item_num;
/**
 *  总价
 */
@property (nonatomic,strong)NSString *totlePrice;

@property (nonatomic,strong)NSString *xy;


@property (nonatomic,strong)NSString *amt;
/**
 *  搜索商品编码
 */
@property (nonatomic,strong)NSString *item_code;
/**
 *  数量
 */
 @property (nonatomic,strong)NSString *qty;


 @property (nonatomic,strong)NSString *cost;
 @property (nonatomic,strong)NSString *itemCode;
 @property (nonatomic,strong)NSString *mcuCode;
 @property (nonatomic,strong)NSString *mcuName;
 @property (nonatomic,strong)NSString *prc20;
@property (nonatomic,strong)NSArray   *xyList;

@end

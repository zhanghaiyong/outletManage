//
//  SaleModel.h
//  outletManage
//
//  Created by 张海勇 on 16/3/21.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "gbSaleModel.h"
#import "otherSaleModel.h"
#import "signSaleModel.h"
#import "smokeSaleModel.h"
#import "wineSaleModel.h"
@interface SaleModel : NSObject<MJKeyValue>

/**
 *  其他销售额
 */
@property (nonatomic,strong)gbSaleModel *gbSale;
/**
 *  销售总额
 */
@property (nonatomic,strong)otherSaleModel *otherSale;

/**
 *  查询时间
 */
@property (nonatomic,strong)NSString *queryDate;
/**
 *  TOP销售
 */
@property (nonatomic,strong)NSMutableArray  *saleTops;

/**
 *  烟销售额
 */
@property (nonatomic,strong)smokeSaleModel  *smokeSale;


/**
 *  酒销售额
 */
@property (nonatomic,strong)wineSaleModel  *wineSale;

@end

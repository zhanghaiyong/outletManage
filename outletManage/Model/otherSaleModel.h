//
//  OtherSaleModel.h
//  outletManage
//
//  Created by 张海勇 on 16/3/21.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface otherSaleModel : NSObject

/**
 *  总客单数
 */
@property (nonatomic,strong)NSString *guestTotal;
/**
 *  销售总额
 */
@property (nonatomic,strong)NSString *saleAmount;

/**
 *  总销售毛利
 */
@property (nonatomic,strong)NSString *saleAmountPG;

/**
 *  总销售毛利率
 */
@property (nonatomic,strong)NSString *saleGPM;

/**
 *  门店总数
 */
@property (nonatomic,strong)NSString *storesTotal;

/**
 *  平均客单价
 */
@property (nonatomic,strong)NSString *unitPrice;

@end

//
//  smokeSaleModel.h
//  outletManage
//
//  Created by 张海勇 on 16/3/21.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface smokeSaleModel : NSObject
/**
 *  销售额
 */
@property (nonatomic,strong)NSString *saleAmount;
/**
 *  毛利率
 */
@property (nonatomic,strong)NSString *gpm;
/**
 *  毛利额
 */
@property (nonatomic,strong)NSString *gp;
@end

//
//  osModel.h
//  outletManage
//
//  Created by 张海勇 on 16/3/21.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface gbSaleModel : NSObject
/**
 *  其他毛利额
 */
@property (nonatomic,strong)NSString *gp;
/**
 *  其他毛利率
 */
@property (nonatomic,strong)NSString *gpm;
/**
 *  其他销售额
 */
@property (nonatomic,strong)NSString *saleAmount;
@end

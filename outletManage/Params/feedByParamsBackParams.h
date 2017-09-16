//
//  feedMsgByParamsBack.h
//  text
//
//  Created by ksm on 16/3/14.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface feedByParamsBackParams : NSObject

/**
 *  采购商品信息反馈
 *  通过商品参数
 */


/**
*  用户名
*/
@property (nonatomic,strong)NSString *userName;


/**
 *  商品名称
 */
@property (nonatomic,strong)NSString *itemName;


/**
 *  商品编码
 */
@property (nonatomic,strong)NSString *itemCode;


/**
 *   国际编码（条形码）
 */
@property (nonatomic,strong)NSString *citmCode;


/**
 *  酒精度
 */
@property (nonatomic,strong)NSString *alcohol;


/**
 *  规格
 */
@property (nonatomic,strong)NSString *itemSpec;


/**
 *  单价 必填
 */
@property (nonatomic,strong)NSString *offerPrice;

/**
 *  价格来源 必填
 */
@property (nonatomic,strong)NSString *sourcePrice;

/**
 *  暂时固定为“元／瓶”
 */
@property (nonatomic,strong)NSString *unit;
@end

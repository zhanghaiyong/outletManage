//
//  feedMsgBack.h
//  text
//
//  Created by ksm on 16/3/14.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface feedByCodeBackParams : NSObject
/**
 *  采购商品信息反馈
 *  通过条码获取商品信息
 */

/**
*  用户名
*/
@property (nonatomic,strong)NSString *userName;
/**
 *  条形码值
 */
@property (nonatomic,strong)NSString *citm_code;

@end

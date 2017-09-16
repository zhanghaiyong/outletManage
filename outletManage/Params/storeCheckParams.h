//
//  storeCheck.h
//  text
//
//  Created by ksm on 16/3/14.
//  Copyright © 2016年 ksm. All rights reserved.
//


#import <Foundation/Foundation.h>



/**
 *  商品及库存查询
 */

@interface storeCheckParams : NSObject
/**
 *  用户名
 */
@property (nonatomic,strong)NSString *username;
/**
 *  查询页数
 */
@property (nonatomic,strong)NSString *page;
/**
 *  每页条数
 */
@property (nonatomic,strong)NSString *pageSize;
/**
 *  查询门店列表，all为全部
 */
@property (nonatomic,strong)NSString *stores;
/**
 *  查询项目，取值说明：itemName商品名称，type商品分类，citmCode商品条码
 */
@property (nonatomic,strong)NSString *queryKey;
/**
 *  查询条件
 */
@property (nonatomic,strong)NSString *queryValue;

/*  商品分类取值
 
 all 全部
 XY  香烟
 BJ  白酒
 HJ  黄酒
 GN  功能酒
 PT  葡萄酒
 YJ  洋酒
 PJ  啤酒
 YL  饮料
 QJ  酒具
 
 */

@end

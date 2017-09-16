//
//  checkShopList.h
//  text
//
//  Created by ksm on 16/3/14.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface checkShopListParams : NSObject
/**
 *  查看门店列表
 */


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
 *  搜索关键字
 */
@property (nonatomic,strong)NSString *serchName;
@end


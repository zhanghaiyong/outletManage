//
//  MainModel.h
//  outletManage
//
//  Created by 张海勇 on 16/3/19.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainModel : NSObject
/**
 *  总收入
 */
@property (nonatomic,strong)NSString *guestTotal;
/**
 *  酒
 */
@property (nonatomic,strong)NSString *jamt;
@property (nonatomic,strong)NSString *jprofit;

//隔壁 销售
@property (nonatomic,strong)NSString *gbamt;
//隔壁 毛利
@property (nonatomic,strong)NSString *gbprofit;

/**
 *  <#Description#>
 */
@property (nonatomic,strong)NSString *slmcu_code;
@property (nonatomic,strong)NSString *slmcu_name;
/**
 *  <#Description#>
 */
@property (nonatomic,strong)NSString *storeTotal;
@property (nonatomic,strong)NSString *total;

/**
 *  香烟
 */
@property (nonatomic,strong)NSString *xyamt;
@property (nonatomic,strong)NSString *xyprofit;

@end

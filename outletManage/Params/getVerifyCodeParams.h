//
//  getVerifyCode.h
//  text
//
//  Created by ksm on 16/3/14.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface getVerifyCodeParams : NSObject
/**
 *  电话号码
 */
@property (nonatomic,strong)NSString *phone_num;
/**
 *  验证方法
 */
@property (nonatomic,strong)NSString *mesType;

@end

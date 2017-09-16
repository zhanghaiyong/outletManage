//
//  Login.h
//  text
//
//  Created by ksm on 16/3/14.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginParams : NSObject
/**
 *  电话号码
 */
@property (nonatomic,strong)NSString *phone_num;
/**
 *  验证码
 */
@property (nonatomic,strong)NSString *code;
@end

//
//  noticeBack.h
//  text
//
//  Created by ksm on 16/3/14.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  意见反馈
 */

@interface ideaBackParams : NSObject
/**
 *  用户名
 */
@property (nonatomic,strong)NSString *userName;
/**
 *  反馈内容
 */
@property (nonatomic,strong)NSString *content;
@end

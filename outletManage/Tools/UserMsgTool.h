//
//  UserMsgTool.h
//  outletManage
//
//  Created by 张海勇 on 16/3/14.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserMsgModel.h"
@interface UserMsgTool : NSObject
+ (void)saveAccount:(UserMsgModel *)account;

+ (UserMsgModel *)account;

+ (void)DeleteAccount;
@end

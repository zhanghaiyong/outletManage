//
//  UserMsgTool.m
//  outletManage
//
//  Created by 张海勇 on 16/3/14.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "UserMsgTool.h"

@implementation UserMsgTool

#pragma mark 保存数据
+ (void)saveAccount:(UserMsgModel *)account {
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:account];
    //保存账号信息：数据存储一般我们开发中会搞一个业务类，专门处理数据的存储
    //好处：以后我不想归档，用数据库，直接改业务类
    [Uitils setUserDefaultsObject:data ForKey:Account];
}

#pragma mark  取数据并转模型
+ (UserMsgModel *)account {
    
    NSData *data = [Uitils getUserDefaultsForKey:Account];
    UserMsgModel *account = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return account;
    
}

+ (void)DeleteAccount {

    [Uitils UserDefaultRemoveObjectForKey:Account];
}
@end

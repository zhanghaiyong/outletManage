//
//  UserMsgModel.h
//  outletManage
//
//  Created by 张海勇 on 16/3/14.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VerifyModel.h"
@interface UserMsgModel : NSObject<NSCoding>
@property (nonatomic,strong)NSString *storesTotal;
@property (nonatomic,strong)VerifyModel *verify;
@end

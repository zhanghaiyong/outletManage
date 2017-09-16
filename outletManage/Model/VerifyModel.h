//
//  VerifyModel.h
//  outletManage
//
//  Created by 张海勇 on 16/3/14.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VerifyModel : NSObject<NSCoding>
@property (nonatomic,strong)NSString *code;
@property (nonatomic,strong)NSString *createDate;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *phonenum;
@property (nonatomic,strong)NSString *username;
@end

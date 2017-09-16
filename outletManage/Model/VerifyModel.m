//
//  VerifyModel.m
//  outletManage
//
//  Created by 张海勇 on 16/3/14.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "VerifyModel.h"

@implementation VerifyModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder  encodeObject:_code forKey:@"code"];
    [aCoder encodeObject:_createDate forKey:@"createDate"];
    [aCoder  encodeObject:_id forKey:@"id"];
    [aCoder encodeObject:_phonenum forKey:@"phonenum"];
    [aCoder encodeObject:_username forKey:@"username"];
    
}

//解的时候调用，告诉系统哪个属性要解档，如何解档
- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        //一定要赋值
        _code = [aDecoder decodeObjectForKey:@"code"];
        _createDate  = [aDecoder decodeObjectForKey:@"createDate"];
        _id  = [aDecoder decodeObjectForKey:@"id"];
        _phonenum  = [aDecoder decodeObjectForKey:@"phonenum"];
        _username  = [aDecoder decodeObjectForKey:@"username"];
        
    }
    return self;
}


@end

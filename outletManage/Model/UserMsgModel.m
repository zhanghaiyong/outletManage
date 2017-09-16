//
//  UserMsgModel.m
//  outletManage
//
//  Created by 张海勇 on 16/3/14.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "UserMsgModel.h"

@implementation UserMsgModel


- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder  encodeObject:_storesTotal forKey:@"storesTotal"];
    [aCoder encodeObject:_verify forKey:@"verify"];

}

//解的时候调用，告诉系统哪个属性要解档，如何解档
- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        //一定要赋值
        _storesTotal = [aDecoder decodeObjectForKey:@"storesTotal"];
        _verify  = [aDecoder decodeObjectForKey:@"verify"];

        
        
    }
    return self;
}

@end

//
//  ProductModel.m
//  outletManage
//
//  Created by 张海勇 on 16/3/20.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "ProductModel.h"

@implementation ProductModel

//实现这个方法，就会自动吧数组中的字典转化成对应的模型
+ (NSDictionary *)objectClassInArray {
    
    return @{@"obj":[goodsModel class]};
}

@end

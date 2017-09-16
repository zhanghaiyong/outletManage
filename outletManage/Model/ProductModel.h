//
//  ProductModel.h
//  outletManage
//
//  Created by 张海勇 on 16/3/20.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "goodsModel.h"
@interface ProductModel : NSObject<MJKeyValue>
@property (nonatomic,strong)NSDictionary *attributes;
@property (nonatomic,strong)NSMutableArray *obj;
@property (nonatomic,strong)NSString *msg;

@end

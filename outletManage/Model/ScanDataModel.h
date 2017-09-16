//
//  ScanDataModel.h
//  outletManage
//
//  Created by 张海勇 on 16/3/25.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScanDataModel : NSObject
@property (nonatomic,strong)NSString *item_code;
@property (nonatomic,strong)NSString *item_name;
@property (nonatomic,strong)NSString *item_spec;
@property (nonatomic,strong)NSString *account_type;
@property (nonatomic,strong)NSString *inv_unit;
@property (nonatomic,strong)NSString *dr_code;
@end

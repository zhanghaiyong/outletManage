//
//  SaleDetailViewController.h
//  outletManage
//
//  Created by 张海勇 on 16/3/26.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "signSaleModel.h"
@interface SaleDetailViewController : BaseViewController

@property (nonatomic,strong)signSaleModel *superSale;
@property (nonatomic,assign)NSInteger headOrSearch;
@property (nonatomic,strong)NSString *startTime;
@property (nonatomic,strong)NSString *endTime;
@property (nonatomic,strong)NSString *dateFlag;
@property (nonatomic,strong)NSString *stores;
@end

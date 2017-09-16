//
//  StockCheckHeaderView1.h
//  outletManage
//
//  Created by 张海勇 on 16/3/12.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol headeroneDelegate <NSObject>

- (void)isZoom;

@end

@interface StockCheckHeaderView1 : UIView
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;
@property (weak, nonatomic) IBOutlet UILabel *shopCount;
@property (weak, nonatomic) IBOutlet UIButton *zoomButton;

@property (nonatomic,assign)NSInteger aFlag;
@property (nonatomic,assign)id<headeroneDelegate>delegate;

@end

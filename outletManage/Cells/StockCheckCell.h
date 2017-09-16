//
//  StockCheckHeaderView2.h
//  outletManage
//
//  Created by 张海勇 on 16/3/12.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StockCheckCell : UITableViewCell
//名称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//型号
@property (weak, nonatomic) IBOutlet UILabel *typeNumLabel;
//总价
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
//数量
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
//单价
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
//会员价
@property (weak, nonatomic) IBOutlet UILabel *memberPriceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeNumH;
@property (weak, nonatomic) IBOutlet UILabel *lsjLabel;
@property (weak, nonatomic) IBOutlet UILabel *spsxLabel;

//联营
@property (weak, nonatomic) IBOutlet UILabel *LYLabel;

- (void)cellAutoLayoutHeightWithName:(NSString *)name total:(NSString *)total;
@end

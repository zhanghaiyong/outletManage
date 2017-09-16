//
//  StockCheckHeaderView2.m
//  outletManage
//
//  Created by 张海勇 on 16/3/12.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "StockCheckCell.h"

@implementation StockCheckCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellAutoLayoutHeightWithName:(NSString *)name total:(NSString *)total {

    self.nameLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.nameLabel.frame);
    self.nameLabel.text = name;
    
    self.totalLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.totalLabel.frame);
    self.totalLabel.text = total;
}

@end

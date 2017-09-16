
//
//  NoticeMsgCell.m
//  outletManage
//
//  Created by 张海勇 on 16/3/12.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "NoticeMsgCell.h"

@implementation NoticeMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)cellAutoLayoutHeight:(NSString *)string {

//    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.titleLabel.frame);
    self.titleLabel.text = string;
}

@end

//
//  TypeTableViewCell.m
//  outletManage
//
//  Created by 张海勇 on 16/3/12.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "TypeTableViewCell.h"

@implementation TypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)typeAction:(id)sender {
    
    for (int i = 0; i<10; i++) {
        
        UIButton *button = [self viewWithTag:i+100];
        button.layer.borderColor = [Uitils colorWithHex:0xC5C6CA].CGColor;
        [button setTitleColor:[Uitils colorWithHex:0x5D5F61] forState:UIControlStateNormal];
    }
    
        UIButton *selectedButton = (UIButton *)sender;
        selectedButton.layer.borderColor = [Uitils colorWithHex:buttonTitleColor].CGColor;
        [selectedButton setTitleColor:[Uitils colorWithHex:buttonTitleColor] forState:UIControlStateNormal];
    
    if ([self.delegate respondsToSelector:@selector(typeToCheck:)]) {
        
        [self.delegate typeToCheck:selectedButton];
    }
}

@end

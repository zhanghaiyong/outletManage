//
//  SelectCheckDateViewController.m
//  text
//
//  Created by ksm on 16/3/16.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "SelectCheckDateView.h"

@interface SelectCheckDateView ()

@end

@implementation SelectCheckDateView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
         self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    }
    return self;
}

- (IBAction)closeViewAction:(id)sender {
    
    [self removeFromSuperview];
}

- (IBAction)searchAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(startEndSearch)]) {
        
        [self removeFromSuperview];
        [self.delegate startEndSearch];
    }
}

//tag 200 ／201
//选择日期
- (IBAction)choseDateAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(showDatePicker:)]) {
        UIButton *button = (UIButton *)sender;
        [self.delegate showDatePicker:button];
    }
}

////按周100 按月101 按季102 按年103
- (IBAction)withToDateAction:(id)sender {
    NSLog(@"xixixixi");
    
    if ([self.delegate respondsToSelector:@selector(withDateSearch:)]) {
    
        [self.delegate withDateSearch:sender];
    }
}
@end

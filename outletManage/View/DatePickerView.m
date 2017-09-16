//
//  DatePickerViewController.m
//  text
//
//  Created by ksm on 16/3/16.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "DatePickerView.h"

@interface DatePickerView ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@end

@implementation DatePickerView


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
       self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];

    }
    return self;
}

-(void)awakeFromNib {

    
    [super awakeFromNib];
//    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60*2)];
//    self.datePicker.date = date;
//    self.datePicker.maximumDate = date;
}

- (IBAction)clickSureBtn:(id)sender {
    
    [self removeFromSuperview];

    // 获取用户通过UIDatePicker设置的日期和时间
    NSDate *selected = [self.datePicker date];
    
    if ([self.delegate respondsToSelector:@selector(selectedDate:btnTag:)]) {
        [self.delegate selectedDate:selected btnTag:self.tag];
    }
}


@end

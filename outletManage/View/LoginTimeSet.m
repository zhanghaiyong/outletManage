//
//  LoginTimeSet.m
//  outletManage
//
//  Created by 张海勇 on 16/3/28.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "LoginTimeSet.h"

@implementation LoginTimeSet

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        
        NSInteger days = [[Uitils getUserDefaultsForKey:TimeParag] doubleValue]/60/60/24;
        UIButton *redBtn;
        
        for (int i = 0; i<3; i++) {
            
            UIButton *btn = (UIButton *)[self viewWithTag:100+i];
            [btn setTitleColor:[Uitils colorWithHex:0x818181] forState:UIControlStateNormal];
        }
        
        switch (days) {
            case 7:
                redBtn = (UIButton *)[self viewWithTag:100];
                
                break;
            case 9:
                redBtn = (UIButton *)[self viewWithTag:101];
                
                break;
            case 30:
                redBtn = (UIButton *)[self viewWithTag:102];
                
                break;
                
            default:
                break;
        }
        
        [redBtn setTitleColor:[Uitils colorWithHex:0xFF3F2F] forState:UIControlStateNormal];
        
    }
    return self;
}
- (IBAction)closeView:(id)sender {
    [self removeFromSuperview];
}

//100-7  101－9  102-30
- (IBAction)timeParagAction:(id)sender {
    
    UIButton *selectenBtn = (UIButton *)sender;
    [selectenBtn setTitleColor:[Uitils colorWithHex:0xFF3F2F] forState:UIControlStateNormal];
    
    for (int i = 0; i<3; i++) {
        
        UIButton *btn = (UIButton *)[self viewWithTag:100+i];
        [btn setTitleColor:[Uitils colorWithHex:0x818181] forState:UIControlStateNormal];
    }
    
    NSTimeInterval timeLong;
    
    switch (selectenBtn.tag) {
        case 100:
            timeLong = 60*60*7*24;
            break;
        case 101:
            timeLong = 60*60*9*24;
            break;
        case 102:
            timeLong = 60*60*30*24;
            break;
            
        default:
            break;
    }
    
    [Uitils setUserDefaultsObject:[NSNumber numberWithDouble:timeLong] ForKey:TimeParag];
    [self removeFromSuperview];
}

@end

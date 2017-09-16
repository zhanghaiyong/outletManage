//
//  oneButtonAlert.m
//  outletManage
//
//  Created by 张海勇 on 16/4/16.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "oneButtonAlert.h"

@implementation oneButtonAlert

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)buttonAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(buttonMethod:)]) {
        [self.delegate buttonMethod:self];
    }
    
    [self removeFromSuperview];
}
@end

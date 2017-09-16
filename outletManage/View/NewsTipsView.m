//
//  NewsTipsView.m
//  outletManage
//
//  Created by 张海勇 on 16/3/28.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "NewsTipsView.h"

@implementation NewsTipsView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }
    return self;
}

- (IBAction)checkNews:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(toNewsVC)]) {
        
        [self.delegate toNewsVC];
        [self removeFromSuperview];
    }
}

@end

//
//  colorView.m
//  text
//
//  Created by ksm on 16/3/11.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "colorView.h"

@implementation colorView
{

//    UIView *centerView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
//        self.layer.borderWidth = 0.8;
//        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.cornerRadius = self.width/2;
//        centerView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width/4, self.frame.size.width/4, self.frame.size.width/2, self.frame.size.width/2)];
        
//        [self addSubview:centerView];
        
    }
    return self;
}

-(void)setCenterColor:(UIColor *)centerColor {

    _centerColor = centerColor;
    self.backgroundColor = centerColor;
    
}

@end

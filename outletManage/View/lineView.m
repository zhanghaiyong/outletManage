//
//  lineView.m
//  outletManage
//
//  Created by 张海勇 on 16/5/13.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "lineView.h"

@implementation lineView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [super bringSubviewToFront:self];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(-0.5,0, self.width/2+0.5, self.height)];
        line.backgroundColor = [UIColor whiteColor];
        [self addSubview:line];
        
        //加阴影--任海丽编辑
//        self.layer.shadowColor = [UIColor redColor].CGColor;//shadowColor阴影颜色
//        self.layer.shadowOffset = CGSizeMake(-2,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
//        self.layer.shadowOpacity = 1;//阴影透明度，默认0
//        self.layer.shadowRadius = 4;//阴影半径，默认3
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

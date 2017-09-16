//
//  UIView+Line.m
//  outletManage
//
//  Created by 张海勇 on 16/3/10.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "UIView+Line.h"

@implementation UIView (Line)
+(instancetype)lineWithFrame:(CGRect)frame color:(UIColor *)color {

    UIView *line = [[UIView alloc]initWithFrame:frame];
    line.backgroundColor = color;

    return line;
    
}
@end

//
//  MainLabel.m
//  outletManage
//
//  Created by 张海勇 on 16/5/12.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "MainLabel.h"

@implementation MainLabel

- (void)drawRect:(CGRect)rect {

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 0.8);  //线宽
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetRGBStrokeColor(context, 212 / 255.0, 215 / 255.0, 220 / 255.0, 0.8);  //线的颜色
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, self.height/2);  //起点坐标
    CGContextAddLineToPoint(context, self.width, self.height/2);   //终点坐标
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, self.width/3, self.height*0.2);  //起点坐标
    CGContextAddLineToPoint(context, self.width/3, self.height*0.8);   //终点坐标
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, self.width/3*2, self.height*0.2);  //起点坐标
    CGContextAddLineToPoint(context, self.width/3*2, self.height*0.8);   //终点坐标
    CGContextStrokePath(context);
    
    
}


@end

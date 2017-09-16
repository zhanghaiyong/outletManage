//
//  CALayer+XibConfiguration.m
//  outletManage
//
//  Created by 张海勇 on 16/3/13.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "CALayer+XibConfiguration.h"

@implementation CALayer (XibConfiguration)

-(void)setBorderUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}
-(UIColor*)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

@end

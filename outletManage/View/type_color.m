//
//  type_color.m
//  text
//
//  Created by ksm on 16/3/11.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "type_color.h"
#import "colorView.h"
@implementation type_color
{
    colorView *colorV;
    UILabel   *type;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {

    colorV = [[colorView alloc]initWithFrame:CGRectMake(0, 3, self.height-6, self.height-6)];
    [self addSubview:colorV];
    
    type = [[UILabel alloc]initWithFrame:CGRectMake(colorV.right+2, 0, self.width-colorV.width, self.height)];
    type.font = [UIFont systemFontOfSize:10];
    type.textColor = [UIColor blackColor];
    [self addSubview:type];
}

-(void)setViewColor:(UIColor *)viewColor {

    _viewColor = viewColor;
    
    colorV.centerColor = viewColor;
}

- (void)setTypeStr:(NSString *)typeStr {

    _typeStr = typeStr;
    
    type.text = typeStr;
}

@end

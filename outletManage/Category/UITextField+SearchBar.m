//
//  UITextField+ImportTF.m
//  outletManage
//
//  Created by 张海勇 on 16/3/10.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "UITextField+SearchBar.h"

@implementation UITextField (SearchBar)

+ (instancetype)textWithFrame:(CGRect)frame placeholder:(NSString *)ph {

    UITextField *searchBar = [[UITextField alloc]initWithFrame:frame];
    searchBar.placeholder = ph;

    searchBar.font = [UIFont systemFontOfSize:MEDIUM_FONT];
    searchBar.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *nameIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search-logo"]];
    nameIV.width += 15;
    nameIV.contentMode = UIViewContentModeCenter;
    searchBar.leftView = nameIV;
    searchBar.layer.borderColor = [Uitils colorWithHex:cutofflineColor].CGColor;
    searchBar.layer.borderWidth = 0.8;
    searchBar.layer.cornerRadius = CORNER_RADIUS;
    searchBar.backgroundColor = [UIColor whiteColor];
    return searchBar;
}

@end

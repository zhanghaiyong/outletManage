//
//  CustomAlertView.m
//  outletManage
//
//  Created by 张海勇 on 16/4/16.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "CustomAlertView.h"

@implementation CustomAlertView


- (IBAction)yesAction:(id)sender {
    
    [Uitils alertWithTitle:@"缓存清除成功"];
    
    
    [self removeFromSuperview];
}

- (IBAction)noAction:(id)sender {
    
    [self removeFromSuperview];
}
@end

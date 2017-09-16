//
//  SaleHeader1.m
//  outletManage
//
//  Created by 张海勇 on 16/3/14.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "SaleHeader1.h"



@implementation SaleHeader1

-(void)setAFlag:(NSInteger)aFlag {
    
    _aFlag = aFlag;
    
    if (aFlag == 0) {
        
        [self.zoomButton setTitle:@"展开" forState:UIControlStateNormal];
        self.zoomButton.selected = NO;
    }else {
        
        [self.zoomButton setTitle:@"关闭" forState:UIControlStateNormal];
        self.zoomButton.selected = YES;
    }
}

- (IBAction)zoomCell:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(isZoom)]) {
        
        [self.delegate isZoom];
    }
}

@end

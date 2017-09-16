//
//  StockCheckHeaderView1.m
//  outletManage
//
//  Created by 张海勇 on 16/3/12.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "StockCheckHeaderView1.h"

@implementation StockCheckHeaderView1


- (IBAction)zoomCell:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(isZoom)]) {
        
        [self.delegate isZoom];
    }
    
}


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

@end

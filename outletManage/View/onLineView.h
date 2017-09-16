//
//  onLineView.h
//  outletManage
//
//  Created by 张海勇 on 16/9/5.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol onLineViewDelegate <NSObject>

- (void)onlineCode:(NSString *)code;

@end

@interface onLineView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong)id<onLineViewDelegate>delegate;

@end

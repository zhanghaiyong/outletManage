//
//  BaseViewController.h
//  outletManage
//
//  Created by ksm on 16/3/10.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserMsgModel.h"
@interface BaseViewController : UIViewController
{

    UserMsgModel *_account;
}

@property (nonatomic,strong)UIButton *refreshBtn;

- (void)stopGifAnimation;
- (void)showGifAnimation;

- (void)setNavigationTitleImage:(NSString *)imageName;
- (void)setNavigationLeft:(NSString *)imageName;
- (void)setNavigationRight:(NSString *)imageName;
- (void)setNavigationRightTitle:(NSString *)title;
- (UIButton *)customButton:(NSString *)imageName
                  selector:(SEL)sel;
- (void)setRefreshButton:(CGRect)frame;

- (void)refreshData;

- (void)doBack:(id)sender;

- (void)backgoundColor;

@end

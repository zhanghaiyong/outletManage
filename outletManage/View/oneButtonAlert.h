//
//  oneButtonAlert.h
//  outletManage
//
//  Created by 张海勇 on 16/4/16.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <UIKit/UIKit.h>
@class oneButtonAlert;
@protocol oneButtonAlertDelegate <NSObject>

- (void)buttonMethod:(oneButtonAlert *)view;

@end

@interface oneButtonAlert : UIView

@property (nonatomic,assign)id<oneButtonAlertDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *alert;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UIButton *button;
@end

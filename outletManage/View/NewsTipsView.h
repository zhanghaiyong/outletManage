//
//  NewsTipsView.h
//  outletManage
//
//  Created by 张海勇 on 16/3/28.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewsTipsViewDelegate <NSObject>

- (void)toNewsVC;

@end

@interface NewsTipsView : UIView

@property (weak, nonatomic) IBOutlet UILabel *newsCount;

@property (nonatomic,assign)id<NewsTipsViewDelegate>delegate;
@end

//
//  ChoseShopViewController.h
//  outletManage
//
//  Created by 张海勇 on 16/3/13.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ChoseShopViewControllerDelegate <NSObject>

- (void)selectedStores:(NSArray *)array;

@end

@interface ChoseShopViewController : BaseViewController
@property (nonatomic,assign)id<ChoseShopViewControllerDelegate>delegate;
@end

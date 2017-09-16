//
//  TypeTableViewCell.h
//  outletManage
//
//  Created by 张海勇 on 16/3/12.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TypeTableViewCellDelegate <NSObject>

- (void)typeToCheck:(UIButton *)sender;

@end

@interface TypeTableViewCell : UITableViewCell
@property (nonatomic,assign)id<TypeTableViewCellDelegate>delegate;
@end
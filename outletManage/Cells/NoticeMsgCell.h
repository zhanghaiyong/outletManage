//
//  NoticeMsgCell.h
//  outletManage
//
//  Created by 张海勇 on 16/3/12.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeMsgCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *newsImg;

- (void)cellAutoLayoutHeight:(NSString *)string;

@end

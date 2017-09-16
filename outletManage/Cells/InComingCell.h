//
//  InComingCell.h
//  outletManage
//
//  Created by 张海勇 on 16/3/29.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InComingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *storesLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalSaleLabel;

@property (weak, nonatomic) IBOutlet UILabel *SignNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *SignPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *smoke1;
@property (weak, nonatomic) IBOutlet UILabel *smoke2;
@property (weak, nonatomic) IBOutlet UILabel *smoke3;
@property (weak, nonatomic) IBOutlet UILabel *wine1;
@property (weak, nonatomic) IBOutlet UILabel *wine2;
@property (weak, nonatomic) IBOutlet UILabel *wine3;
@property (weak, nonatomic) IBOutlet UILabel *other1;
@property (weak, nonatomic) IBOutlet UILabel *other2;
@property (weak, nonatomic) IBOutlet UILabel *other3;
@end

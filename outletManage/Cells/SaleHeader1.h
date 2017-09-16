//
//  SaleHeader1.h
//  outletManage
//
//  Created by 张海勇 on 16/3/14.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SaleHeader1Delegate <NSObject>

- (void)isZoom;


@end

@interface SaleHeader1 : UIView
@property (weak, nonatomic) IBOutlet UITextField *searchBar;

/**
 *  门店数量
 */
@property (weak, nonatomic) IBOutlet UILabel *storesLabel;
/**
 *  销售总额
 */
@property (weak, nonatomic) IBOutlet UILabel *saleAmount;
/**
 *  总销售毛利(元)
 */
@property (weak, nonatomic) IBOutlet UILabel *saleAmountPG;
/**
 *  总销售毛利率
 */
@property (weak, nonatomic) IBOutlet UILabel *saleGPM;
/**
 *  总客单数(个)
 */
@property (weak, nonatomic) IBOutlet UILabel *guestTotal;
/**
 *  平均客单价(元)
 */
@property (weak, nonatomic) IBOutlet UILabel *unitPrice;
/**
 *  烟销售额
 */
@property (weak, nonatomic) IBOutlet UILabel *smokeSaleAmount;
/**
 *  烟毛利额
 */
@property (weak, nonatomic) IBOutlet UILabel *smokeGP;
/**
 *  烟毛利率
 */
@property (weak, nonatomic) IBOutlet UILabel *smokeGPM;
/**
 *  酒销售额
 */
@property (weak, nonatomic) IBOutlet UILabel *wineSaleAmount;
/**
 *  酒毛利额
 */
@property (weak, nonatomic) IBOutlet UILabel *wineGP;
/**
 *  酒毛利率
 */
@property (weak, nonatomic) IBOutlet UILabel *wineGPM;


@property (weak, nonatomic) IBOutlet UIButton *zoomButton;
@property (nonatomic,assign)NSInteger aFlag;
@property (nonatomic,assign)id<SaleHeader1Delegate>delegate;
@end

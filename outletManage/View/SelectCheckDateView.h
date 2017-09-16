//
//  SelectCheckDateViewController.h
//  text
//
//  Created by ksm on 16/3/16.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelectCheckDateView;
@protocol SelectCheckDateViewDetegate <NSObject>

- (void)showDatePicker:(UIButton *)sender;

- (void)withDateSearch:(UIButton *)sender;

- (void)startEndSearch;

@end
@interface SelectCheckDateView : UIView

- (IBAction)closeViewAction:(id)sender;
- (IBAction)searchAction:(id)sender;
- (IBAction)choseDateAction:(id)sender;
- (IBAction)withToDateAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *beginTime;
@property (weak, nonatomic) IBOutlet UIButton *endTime;

@property (nonatomic,assign)id<SelectCheckDateViewDetegate>delegate;
@end

//
//  ButtonView.h
//  有车生活
//
//  Created by ksm on 15/11/2.
//  Copyright © 2015年 ksm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ButtonViewDeleage <NSObject>

- (void)buttonViewTap:(NSInteger)aFlag;

@end

@interface ButtonView : UIView

@property (nonatomic,strong)NSString *labelTitle;
@property (nonatomic,strong)NSString *imageName;
@property (nonatomic,strong)UIButton *badgeBtn;
@property (nonatomic,assign)BOOL      samllImage;
@property (nonatomic,assign)id<ButtonViewDeleage>delegate;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title image:(NSString *)image;

@end

//
//  CZNewFealtureCell.m
//  weibo
//
//  Created by JZB on 15/9/17.
//  Copyright © 2015年 JZB. All rights reserved.
//

#import "NewFealtureCell.h"


@interface NewFealtureCell ()

@property (nonatomic,weak)UIImageView *imagView;



@end

@implementation NewFealtureCell

#pragma mark lazyAction------------
- (UIImageView *)imagView {

    if (_imagView == nil) {
        UIImageView *imageV = [[UIImageView alloc]init];
//        imageV.contentMode = UIViewContentModeScaleAspectFill;
        _imagView = imageV;
        [self.contentView addSubview:imageV];
    }
    return _imagView;
}

#pragma mark - Lifecycle--------------
- (void)layoutSubviews {

    [super layoutSubviews];
    
    _imagView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
}


#pragma mark - paramsSetting-------------
-(void)setImage:(UIImage *)image {

    _image = image;
    
    self.imagView.image = image;
}

//#pragma mark customAction----------
//- (void)setIndexPath:(NSIndexPath *)indexPath cunt:(int)count {
//
////    if (indexPath.row == count - 1) {
////        self.beginButton.hidden = NO;
////        
////    }else {
////    
////        self.beginButton.hidden = YES;
////    }
//}


@end


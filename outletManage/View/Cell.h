//
//  Cell.h
//  CollectionView
//
//  Created by Li Hongjun on 13-5-23.
//  Copyright (c) 2013年 Li Hongjun. All rights reserved.
//

typedef void(^collectionBlock)(NSInteger tag);

#import <UIKit/UIKit.h>

@interface Cell : UICollectionViewCell
@property(nonatomic,strong)UIButton *itemButton;
@property (nonatomic,copy)collectionBlock block;

- (void)returnBtnTag:(collectionBlock)block;

@end

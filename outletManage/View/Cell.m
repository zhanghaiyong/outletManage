//
//  Cell.m
//  CollectionView
//
//  Created by Li Hongjun on 13-5-23.
//  Copyright (c) 2013年 Li Hongjun. All rights reserved.
//

#import "Cell.h"

@implementation Cell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _itemButton.backgroundColor = [Uitils colorWithHex:0xf4f4f4];
        _itemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        [_itemButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _itemButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _itemButton.layer.borderColor = [Uitils colorWithHex:cutofflineColor].CGColor;
        _itemButton.layer.borderWidth = 0.5;
        [_itemButton addTarget:self action:@selector(selectOnline:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_itemButton];

    }
    return self;
}

- (void)selectOnline:(UIButton *)sender {

    if (sender.selected) {
        
        sender.selected = NO;
        _itemButton.backgroundColor = [Uitils colorWithHex:0xf4f4f4];
        
    }else {
    
        sender.selected = YES;
        _itemButton.backgroundColor = [Uitils colorWithHex:smokeIncomeColor];
    }
    
    self.block(sender.tag);
}

- (void)returnBtnTag:(collectionBlock)block {

    _block = block;
}

@end

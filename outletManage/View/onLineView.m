//
//  onLineView.m
//  outletManage
//
//  Created by 张海勇 on 16/9/5.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "onLineView.h"
#import "CellLayout.h"
#import "Cell.h"

static NSString * const reuseIdentifier = @"Cell";

@implementation onLineView
{

    UICollectionView *collection;
    NSMutableArray *dataSource;
    NSMutableArray *selectedData;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        
        self.backgroundColor = [Uitils colorWithHex:backgroudColor];
    }
    return self;
}

- (void)initSubViews {
    
    dataSource = [NSMutableArray array];
    selectedData = [NSMutableArray array];
    
    collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.width, 12*30) collectionViewLayout:[[CellLayout alloc]init]];
    collection.backgroundColor = [UIColor clearColor];
    collection.dataSource = self;
    collection.delegate = self;
    [collection registerClass:[Cell class] forCellWithReuseIdentifier:reuseIdentifier];//注册item或cell
    collection.alwaysBounceVertical = YES;
    collection.showsHorizontalScrollIndicator = NO;
    collection.bounces = NO;
    collection.pagingEnabled = YES;
    [self addSubview:collection];
    
    
    UIButton *sureButton = [[UIButton alloc]initWithFrame:CGRectMake(10, collection.bottom+20, SCREEN_WIDTH-20, 40)];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    sureButton.backgroundColor = [Uitils colorWithHex:smokeIncomeColor];
    sureButton.layer.cornerRadius = CORNER_RADIUS;
    [sureButton addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sureButton];
    
    if (dataSource.count == 0) {
        
        [self getGoodsType];
    }
    
}

- (void)sureAction {

    
    if (selectedData.count == 0) {
        
         [Uitils alertWithTitle:@"请选择线上渠道"];
    }else {
    
        if ([self.delegate respondsToSelector:@selector(onlineCode:)]) {
            
            NSMutableArray *codes = [NSMutableArray array];
            for (int i = 0; i<selectedData.count; i++) {
                NSDictionary *dic = selectedData[i];
                [codes addObject:[dic objectForKey:@"itemCode"]];
            }
            
            [self.delegate onlineCode:[codes componentsJoinedByString:@","]];
        }
    }
    
}

- (void)getGoodsType {
    
    [KSMNetworkRequest postRequest:KGetOnlineChannel params:nil success:^(id responseObj) {
        
//        [self stopGifAnimation];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"线上渠道 = %@",dic);
        
        
        if ([[dic objectForKey:@"success"] integerValue]==1) {
            
            dataSource = [dic objectForKey:@"obj"];
            [collection reloadData];
            
        }else {
            
            [Uitils alertWithTitle:@"网络故障，请重试"];
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
//        [self stopGifAnimation];
    }];
}


//-(void)setDataSource:(NSArray *)dataSource {
//
//    _dataSource = dataSource;
//    [collection reloadData];
//}

#pragma mark UICollectionView代理和数据源
//返回组的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

//返回组的cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return dataSource.count;
}

//返回cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSDictionary *dic = dataSource[indexPath.row];
    cell.itemButton.tag = 100+indexPath.row;
    [cell.itemButton setTitle:[dic objectForKey:@"itemName"] forState:UIControlStateNormal];
    
    [cell returnBtnTag:^(NSInteger tag) {
        
        NSDictionary *dic = dataSource[tag-100];
        
        if ([selectedData containsObject:dic]) {
            
            [selectedData removeObject:dic];
            
        }else {
        
            [selectedData addObject:dic];
        }
    }];
    
    
    return cell;
}


@end

//
//  StockDetailViewController.m
//  outletManage
//
//  Created by 张海勇 on 16/3/25.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "StockDetailViewController.h"
#import "StockCheckCell.h"
#import "StockCheckHeaderView2.h"
#import "StockDetailParams.h"
#import "ProductModel.h"
@interface StockDetailViewController ()
    
    @property (nonatomic,strong)StockDetailParams *params;
    
    @end
@interface StockDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
    {
        
        UITableView *detailTable;
        ProductModel *model;
    }
    @end

@implementation StockDetailViewController
    
-(StockDetailParams *)params {
    
    if (_params == nil) {
        
        StockDetailParams *params = [[StockDetailParams alloc]init];
        params.itemCode = self.supGoods.item_code;
        params.username = _account.verify.phonenum;
        params.stores = @"";
        params.page = @"0";
        params.pageSize = @"10";
        _params = params;
    }
    return _params;
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    model = [ProductModel mj_objectWithKeyValues:@{@"attributes":[NSNull class],@"msg":[NSNull class],@"obj":[NSNull class]}];
    self.title = @"商品及库存查询";
    [self setNavigationLeft:@"back"];
    
    [self initSubViews];
    
    [self loadMoreData];
    
}
    
- (void)initSubViews {
    
    detailTable = [[UITableView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, SCREEN_HEIGHT-74) style:UITableViewStyleGrouped];
    detailTable.dataSource = self;
    detailTable.delegate = self;
    detailTable.bounces = NO;
    detailTable.backgroundColor = [UIColor clearColor];
    detailTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.view addSubview:detailTable];
}
    
- (void)loadMoreData {
    
    [self showGifAnimation];
    self.params.page = [NSString stringWithFormat:@"%ld",[self.params.page integerValue]+1];
    [KSMNetworkRequest postRequest:KStockDetail params:self.params.mj_keyValues success:^(id responseObj) {
        
        [self stopGifAnimation];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",dic);
        
        if ([[dic objectForKey:@"success"]integerValue]==1) {
            
            NSArray *goodArray = [dic objectForKey:@"obj"];
            
            
            if (![goodArray isEqual:[NSNull null]]) {
                
                NSMutableArray *modelArray = [goodsModel mj_objectArrayWithKeyValuesArray:goodArray];
                if (model.obj.count) {
                    [model.obj addObjectsFromArray:modelArray];
                }else {
                    model.obj = modelArray;
                }
                
                NSLog(@"model = %@",model);
                
                [detailTable reloadData];
                
                if (goodArray.count < 10) {
                    
                    [detailTable.mj_footer endRefreshingWithNoMoreData];
                    
                }else {
                    
                    [detailTable.mj_footer endRefreshing];
                }
            }else {
                
                [detailTable.mj_footer endRefreshing];
                [Uitils alertWithTitle:@"暂无数据"];
            }
        }else {
            
            [Uitils alertWithTitle:@"加载失败，请重试"];
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self stopGifAnimation];
    }];
}
    
    
#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 2;
    }else {
        return model.obj.count;
    }
}
    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 40;
    }else {
        
        goodsModel *goods = model.obj[indexPath.row];
        StockCheckCell *cell = (StockCheckCell *)[self tableView:detailTable cellForRowAtIndexPath:indexPath];
        [cell cellAutoLayoutHeightWithName:goods.mcuName total:[NSString stringWithFormat:@"成本总价:%@",goods.amt]];
        CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height+1;
    }
}
    
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
    }else {
        
        return 60;
    }
}
    
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1;
}
    
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        StockCheckHeaderView2 *header2 = [[[NSBundle mainBundle] loadNibNamed:@"StockCheckHeaderView2" owner:self options:nil] lastObject];
        header2.label2.text = @" 名称";
        header2.label3.text = @"数量(瓶)";
        header2.label4.text = @"成本单价(元)";
        return header2;
    }
    return nil;
    
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        static NSString *ID = @"cell1";//注意cell中，它的identifier设置为“cell”
        // 1.拿到一个标识先去缓存池中查找对应的Cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            //            cell = [[[NSBundle mainBundle] loadNibNamed:@"TypeTableViewCell" owner:self options:nil] lastObject];
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [Uitils colorWithHex:detailContentColor];
        if (indexPath.section == 0) {
            
            switch (indexPath.row) {
                case 0:
                cell.textLabel.text = [NSString stringWithFormat:@"商品名称  %@",self.supGoods.item_name];
                break;
                case 1:
                cell.textLabel.text = [NSString stringWithFormat:@"商品编号  %@",self.supGoods.item_code];
                break;
                
                default:
                break;
            }
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else {
        
        static NSString *identifier = @"StockCheckCell";
        StockCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"StockCheckCell" owner:self options:nil] lastObject];
        }
        
        goodsModel *goods = model.obj[indexPath.row];
        cell.nameLabel.text = goods.mcuName;
        cell.typeNumLabel.text = goods.itemCode;
        cell.totalLabel.text = [NSString stringWithFormat:@"成本总价:%.2f",[goods.amt floatValue]];
        cell.countLabel.text = goods.qty;
        cell.priceLabel.text = [NSString stringWithFormat:@"%.2f",[goods.amt floatValue] / [goods.qty floatValue]];
        cell.memberPriceLabel.text = [NSString stringWithFormat:@"20倍会员价:%@",goods.prc20];
        cell.spsxLabel.text = [NSString stringWithFormat:@"商品属性：%@",goods.item_PROPERTY];
        cell.lsjLabel.text = [NSString stringWithFormat:@"零售价：%@",goods.retail_PRICE];
        
        
        if ([goods.joinOperation isEqualToString:@"LY"]) {
            
            cell.LYLabel.hidden = NO;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
    
    @end

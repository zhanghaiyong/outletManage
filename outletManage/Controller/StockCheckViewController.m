//
//  StockCheckViewController.m
//  outletManage
//
//  Created by 张海勇 on 16/3/12.
//  Copyright © 2016年 ksm. All rights reserved.
//

#define ITEMNAME    (@"itemName") //商品名称
#define TYPE        (@"type")     //商品类型
#define CITMCODE    (@"citmCode") //商品条码

#import "StockCheckViewController.h"
#import "UITextField+SearchBar.h"
#import "UIView+Line.h"
#import "TypeTableViewCell.h"
#import "StockCheckCell.h"
#import "StockCheckHeaderView1.h"
#import "StockCheckHeaderView2.h"
#import "ChoseShopViewController.h"
#import "storeCheckParams.h"
#import "ProductModel.h"
#import "goodsModel.h"
#import <LBXScanViewController.h>
#import "SubLBXScanViewController.h"
#import "StockDetailViewController.h"
@interface StockCheckViewController ()
    
    @property (nonatomic,strong)storeCheckParams *params;
    
    @end

@interface StockCheckViewController ()<UITableViewDelegate,UITableViewDataSource,headeroneDelegate,TypeTableViewCellDelegate,ChoseShopViewControllerDelegate,UITextFieldDelegate,SubLBXScanDelelage>
    {
        UITextField *searchBar;
        UITableView *checkTable;
        NSInteger   aFlag;
        NSInteger   currentType;
        ProductModel *model;
        NSString *shouldShowStoreCount;
    }
    
    @property (nonatomic,strong)NSMutableArray *goodsTypeArr;
    
    @end

@implementation StockCheckViewController
    
- (NSMutableArray *)goodsTypeArr {
    
    if (_goodsTypeArr == nil) {
        
        NSMutableArray *goodsTypeArr = [NSMutableArray array];
        _goodsTypeArr = goodsTypeArr;
    }
    return _goodsTypeArr;
}
    
-(storeCheckParams *)params {
    
    if (_params == nil) {
        
        storeCheckParams *params = [[storeCheckParams alloc]init];
        params.username = _account.verify.phonenum;
        params.page = @"0";
        params.pageSize = @"10";
        params.queryKey = TYPE;
        params.queryValue = @"all";
        _params = params;
    }
    return _params;
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    model = [ProductModel mj_objectWithKeyValues:@{@"attributes":[NSNull class],@"msg":[NSNull class],@"obj":[NSNull class]}];
    aFlag = 1;
    currentType = 100;
    self.title = @"商品及库存查询";
    [self setNavigationLeft:@"back"];
    [self setNavigationRight:@"title-house"];
    
    shouldShowStoreCount = [Uitils getUserDefaultsForKey:STORESTOTAL];
    
    [self initSubViews];
    
    [self loadMoreData];
    
    [self getGoodsType];
    
}
    
- (void)getGoodsType {
    
    [KSMNetworkRequest postRequest:KGetGoodsType params:nil success:^(id responseObj) {
        
        [self stopGifAnimation];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"商品分类 = %@",dic);
        
        
        if ([[dic objectForKey:@"success"] integerValue]==1) {
            
            self.goodsTypeArr = [dic objectForKey:@"obj"];
            
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [checkTable reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }else {
            
            [Uitils alertWithTitle:@"网络故障，请重试"];
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self stopGifAnimation];
    }];
}
    
- (void)refreshData {
    
    [model.obj removeAllObjects];
    self.params.page = @"0";
    [self loadMoreData];
}
    
- (void)loadMoreData {
    
    self.params.page = [NSString stringWithFormat:@"%ld",[self.params.page integerValue]+1];
    
    NSLog(@"%@",self.params.mj_keyValues);
    
    [self showGifAnimation];
    
    [KSMNetworkRequest postRequest:KItemStockData params:self.params.mj_keyValues success:^(id responseObj) {
        
        [self stopGifAnimation];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"商品及库存查询 = %@",dic);
        
        
        if ([[dic objectForKey:@"success"] integerValue]==1) {
            
            NSDictionary *attributes = [dic objectForKey:@"attributes"];
            if ([attributes isKindOfClass:[NSDictionary class]]) {
                model.attributes = attributes;
            }
            
            if ([dic objectForKey:@"msg"]) {
                
                model.msg = [dic objectForKey:@"msg"];
            }
            
            NSArray *goodArray = [dic objectForKey:@"obj"];
            
            if (![goodArray isEqual:[NSNull null]]) {
                
                NSMutableArray *modelArray = [goodsModel mj_objectArrayWithKeyValuesArray:goodArray];
                
                if (model.obj.count) {
                    
                    [model.obj addObjectsFromArray:modelArray];
                }else {
                    model.obj = modelArray;
                }
                
                NSLog(@"model = %@",model);
                
                if (goodArray.count < 10) {
                    
                    [checkTable.mj_footer endRefreshingWithNoMoreData];
                    
                }else {
                    
                    [checkTable.mj_footer endRefreshing];
                }
            }else {
                
                [Uitils alertWithTitle:@"暂无数据"];
                [checkTable.mj_footer endRefreshing];
            }
            [checkTable reloadData];
            
        }else {
            
            [Uitils alertWithTitle:@"网络故障，请重试"];
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self stopGifAnimation];
    }];
}
    
- (void)initSubViews {
    
    searchBar = [UITextField textWithFrame:CGRectMake(10, 74, SCREEN_WIDTH-70, 40) placeholder:@"按关键字搜索"];
    searchBar.returnKeyType = UIReturnKeySearch;
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
    
    UIButton *saomiao = [UIButton buttonWithType:UIButtonTypeSystem];
    saomiao.frame = CGRectMake(searchBar.right+10, searchBar.top+4, 32, 32);
    [saomiao setBackgroundImage:[UIImage imageNamed:@"title-toplogo"] forState:UIControlStateNormal];
    saomiao.contentMode = UIViewContentModeCenter;
    [saomiao addTarget:self action:@selector(ScanAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saomiao];
    
    UIView *line = [UIView lineWithFrame:CGRectMake(0, searchBar.bottom+10, SCREEN_WIDTH, 1) color:[Uitils colorWithHex:cutofflineColor]];
    [self.view addSubview:line];
    
    checkTable = [[UITableView alloc]initWithFrame:CGRectMake(10, line.bottom, SCREEN_WIDTH-20, SCREEN_HEIGHT-74-searchBar.height-10) style:UITableViewStyleGrouped];
    checkTable.dataSource = self;
    checkTable.delegate = self;
    checkTable.bounces = NO;
    checkTable.backgroundColor = [UIColor clearColor];
    checkTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.view addSubview:checkTable];
    
    [self setRefreshButton:CGRectMake(SCREEN_WIDTH-45, searchBar.bottom+15, 30, 30)];
}
    
#pragma mark UITableVIewDelegate------------
    /*
     1、分组数：numberOfSectionsInTableView；
     2、行数：numberOfRowsInSection；
     3、显示每行的cell内容：cellForRowAtIndexPath；
     4、行的高度：heightForRowAtIndexPath；
     */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }else {
        
        return model.obj.count;
    }
}
    
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        static NSString *ID = @"cell1";//注意cell中，它的identifier设置为“cell”
        // 1.拿到一个标识先去缓存池中查找对应的Cell
        TypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TypeTableViewCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        
        if (self.goodsTypeArr.count > 0) {
            
            for (int i = 0; i<=self.goodsTypeArr.count; i++) {
                UIButton *button = (UIButton *)[cell viewWithTag:100+i];
                button.hidden = NO;
                if (i == 0) {
                    
                    [button setTitle:@"全部" forState:UIControlStateNormal];
                    
                }else {
                    
                    NSDictionary *dic = self.goodsTypeArr[i-1];
                    [button setTitle:[dic objectForKey:@"itemName"] forState:UIControlStateNormal];
                }
                
            }
        }
        UIButton *sender = (UIButton *)[cell viewWithTag:currentType];
        sender.layer.borderColor = [Uitils colorWithHex:buttonTitleColor].CGColor;
        [sender setTitleColor:[Uitils colorWithHex:buttonTitleColor] forState:UIControlStateNormal];
        
        return cell;
        
    }else {
        
        static NSString *identifier = @"StockCheckCell";
        StockCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"StockCheckCell" owner:self options:nil] lastObject];
        }
        goodsModel *goods = model.obj[indexPath.row];
        cell.nameLabel.text = goods.item_name;
        cell.typeNumLabel.text = goods.item_code;
        cell.totalLabel.text = [NSString stringWithFormat:@"成本总价:%.2f",[goods.amt doubleValue]];
        cell.countLabel.text = goods.qty;
        cell.spsxLabel.text = [NSString stringWithFormat:@"商品属性：%@",goods.item_PROPERTY];
        cell.lsjLabel.text = [NSString stringWithFormat:@"零售价：%@",goods.retail_PRICE];
        
        
        if ([goods.qty integerValue]==0) {
            
            cell.priceLabel.text = @"0";
            
        }else {
            
            cell.priceLabel.text = [NSString stringWithFormat:@"%.2f",[goods.amt doubleValue] / [goods.qty doubleValue]];
        }
        cell.memberPriceLabel.text = [NSString stringWithFormat:@"20倍会员价:%.2f",[goods.prc20 doubleValue]];
        if ([goods.joinOperation isEqualToString:@"LY"]) {
            cell.LYLabel.hidden = NO;
        }
        
        return cell;
    }
}
    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (aFlag == 1) {
            return 210;
        }else {
            
            return 0;
        }
    }else {
        
        goodsModel *goods = model.obj[indexPath.row];
        StockCheckCell *cell = (StockCheckCell *)[self tableView:checkTable cellForRowAtIndexPath:indexPath];
        [cell cellAutoLayoutHeightWithName:[NSString stringWithFormat:@"%@%@",goods.item_name,goods.item_spec] total:[NSString stringWithFormat:@"成本总价:%@",goods.amt]];
        CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height+1;
    }
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        goodsModel *goods = model.obj[indexPath.row];
        StockDetailViewController *StockDetailView = [[StockDetailViewController alloc]init];
        StockDetailView.supGoods = goods;
        [self.navigationController pushViewController:StockDetailView animated:YES];
    }
}
    
    /*
     添加分组名称在viewForHeaderInSection上
     1、在viewForHeaderInSection方法里面创建一个UIView；
     2、在UIView上创建一个UILabel用来显示分组名称；
     3、为UIView添加点击监听手势；
     4、添加手势监听事件，监听分组是否被点击。
     */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 130;
    }else {
        return 60;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1;
}
    
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        StockCheckHeaderView1 *header1 = [[[NSBundle mainBundle] loadNibNamed:@"StockCheckHeaderView1" owner:self options:nil] lastObject];
        
        //1.02354656E7
        if ([model.attributes objectForKey:@"sumAmt"]) {
            header1.totalMoney.text = [NSString stringWithFormat:@"成本总价:%.2f",[[model.attributes objectForKey:@"sumAmt"] doubleValue]];
        }
        
        
        //查询时间
        if (model.msg) {
            header1.shopCount.text = [NSString stringWithFormat:@"共%@家门店,%@",shouldShowStoreCount,model.msg];
        }
        
        header1.aFlag = aFlag;
        header1.delegate = self;
        return header1;
    }else {
        
        StockCheckHeaderView2 *header2 = [[[NSBundle mainBundle] loadNibNamed:@"StockCheckHeaderView2" owner:self options:nil] lastObject];
        header2.label2.text = @" 名称";
        header2.label3.text = @"数量(瓶)";
        header2.label4.text = @"成本单价(元)";
        return header2;
    }
}
    
#pragma mark TypeTableViewCellDelegate
- (void)typeToCheck:(UIButton *)sender {
    
    currentType = sender.tag;
    [model.obj removeAllObjects];
    self.params.page = @"0";
    self.params.queryKey = TYPE;
    
    if (sender.tag == 100) {
        
        self.params.queryValue = @"all";
        
    }else {
        NSDictionary *dic = self.goodsTypeArr[sender.tag-101];
        self.params.queryValue = [dic objectForKey:@"itemCode"];
    }
    
    [self loadMoreData];
}
    
    
#pragma mark StockCheckHeaderView1 ----Delegate
- (void)isZoom {
    
    //关闭状态
    if (aFlag == 0) {
        aFlag = 1;
        
    }else {
        
        aFlag = 0;
    }
    
    [checkTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
}
    
#pragma mark ChoseShopViewController Delegate
- (void)selectedStores:(NSArray *)array {
    
    shouldShowStoreCount = [NSString stringWithFormat:@"%ld",array.count];
    
    [model.obj removeAllObjects];
    self.params.page = @"0";
    NSString *storeString = [array componentsJoinedByString:@","];
    self.params.stores = storeString;
    
    [self loadMoreData];
    
}
    
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [model.obj removeAllObjects];
    self.params.page = @"0";
    self.params.queryKey = ITEMNAME;
    self.params.queryValue = searchBar.text;
    [searchBar resignFirstResponder];
    [self loadMoreData];
    return YES;
}
    
#pragma  mark 条形码扫描
- (void)ScanAction {
    
    SubLBXScanViewController *vc = [SubLBXScanViewController new];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}
    
#pragma mark SubLBXScanViewControllerDelegate
- (void)scanData:(NSString *)scanString {
    
    NSLog(@"%@",scanString);
    [model.obj removeAllObjects];
    self.params.page = @"0";
    self.params.queryKey = CITMCODE;
    self.params.queryValue = scanString;
    [self loadMoreData];
}
    
    
- (void)doRight:(id)sender {
    
    ChoseShopViewController *choseShop = [[ChoseShopViewController alloc]init];
    choseShop.delegate = self;
    [self.navigationController pushViewController:choseShop animated:YES];
    
}
    @end


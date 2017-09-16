//
//  SaleCheckViewController.m
//  outletManage
//
//  Created by 张海勇 on 16/3/14.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "SaleCheckViewController.h"
#import "TypeTableViewCell.h"
#import "StockCheckCell.h"
#import "SaleHeader1.h"
#import "StockCheckHeaderView2.h"
#import "ChoseShopViewController.h"
#import "DatePickerView.h"
#import "SelectCheckDateView.h"
//#import "SaleCheckParams.h"
#import "SaleModel.h"
#import "signSaleModel.h"
#import "gbSaleModel.h"
#import "otherSaleModel.h"
#import "signSaleModel.h"
#import "smokeSaleModel.h"
#import "wineSaleModel.h"
#import "SaleSearchParams.h"
#import "SaleDetailViewController.h"
#import "onLineView.h"
@interface SaleCheckViewController ()<TypeTableViewCellDelegate,UITextFieldDelegate>

@property (nonatomic,strong)SaleSearchParams *searchParams;
//@property (nonatomic,strong)SaleCheckParams *CheckParams;
@property (nonatomic,strong)onLineView *onlineView;

@end

@interface SaleCheckViewController ()<UITableViewDataSource,UITableViewDelegate,SaleHeader1Delegate,SelectCheckDateViewDetegate,DatePickerViewDelegate,ChoseShopViewControllerDelegate,onLineViewDelegate>
{

    UITableView *saleTable;
    /**
     *  是否打开分类列表
     */
    NSInteger aFlag;
    SaleModel *saleModel;
    SaleHeader1 *header1;
    /**
     *  当前选择的类型
     */
    NSInteger   currentType;
    //选择时间搜索
    SelectCheckDateView *SelectCheck;
    //暂存开始搜索时间
    NSString *startTimeString;
    //暂存结束搜素时间
    NSString *endTimeString;
    NSInteger   headOrSearch;
    
    NSString *shouldShowStoreCount;
}

@property (nonatomic,strong)NSMutableArray *goodsTypeArr;

@end

@implementation SaleCheckViewController

- (NSMutableArray *)goodsTypeArr {
    
    if (_goodsTypeArr == nil) {
        
        NSMutableArray *goodsTypeArr = [NSMutableArray array];
        _goodsTypeArr = goodsTypeArr;
    }
    return _goodsTypeArr;
}

-(onLineView *)onlineView {
    
    if (_onlineView == nil) {
        onLineView *onlineView = [[onLineView alloc]initWithFrame:CGRectMake(0, saleTable.top, SCREEN_WIDTH, saleTable.height)];
        onlineView.delegate = self;
//        onlineView.frame = CGRectMake(0, saleTable.top, SCREEN_WIDTH, saleTable.height);
//        [onlineView closeView:^(NSString *str) {
//            
//            UIButton *sender = (UIButton *)[self.view viewWithTag:504];
//            [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [_onlineView removeFromSuperview];
//            _onlineView = nil;
//            
//        }];
        
        _onlineView = onlineView;
    }
    return _onlineView;
}

-(SaleSearchParams *)searchParams {

    if (_searchParams == nil) {
        
        SaleSearchParams *searchParams = [[SaleSearchParams alloc]init];
        searchParams.username = _account.verify.phonenum;
        searchParams.page = @"1";
        searchParams.pageSize = @"10";
        searchParams.stores = @"all";
        searchParams.dateFlag = @"";
        searchParams.channelType = @"";
        searchParams.channelCode = @"";
        
        //前天的时间
        NSDate *qiantianDate = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)*2];
        NSString *qiantian = [FxDate stringFromDateYMD:qiantianDate];
        searchParams.startTime = qiantian;
        searchParams.endTime = qiantian;

        _searchParams = searchParams;
    }
    return _searchParams;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    aFlag = 0;
    currentType = 0;
    //0为刷新head 1为刷新search
    headOrSearch = 0;
    
    shouldShowStoreCount = [Uitils getUserDefaultsForKey:STORESTOTAL];
    
    self.title = @"销售查询";
    [self setNavigationLeft:@"back"];
    UIButton *dateButton = [self customButton:@"title-rili" selector:@selector(pickDate:)];
    UIButton *storeButton = [self customButton:@"title-house" selector:@selector(pickStore:)];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:dateButton];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:storeButton];
    self.navigationItem.rightBarButtonItems = @[item2,item1];
    
    [self initSubViews];
    
    [self requestHeadData];
    
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
            [saleTable reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }else {
            
            [Uitils alertWithTitle:@"网络故障，请重试"];
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self stopGifAnimation];
    }];
}

//刷新界面
- (void)refreshData {

   [self requestHeadData];
}

- (void)requestHeadData {

    [self showGifAnimation];
    headOrSearch = 0;
    aFlag = 0;
    NSLog(@"%@",self.searchParams.mj_keyValues);

    [KSMNetworkRequest postRequest:KSaleCheck params:self.searchParams.mj_keyValues success:^(id responseObj) {

        if (SelectCheck) {
            [SelectCheck removeFromSuperview];
        }
       [self stopGifAnimation];
        
       NSDictionary *d = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingAllowFragments error:nil];

        saleModel = [SaleModel mj_objectWithKeyValues:d];
        
        [saleTable reloadData];
        [saleTable.mj_footer endRefreshing];
        
       NSLog(@"销售统计查询 ＝ %@ \n",d);

       } failure:^(NSError *error) {
           
        [self stopGifAnimation];
           [saleTable.mj_footer endRefreshing];
       }];
}

- (void)requestSearchData {

    headOrSearch = 1;
    [self showGifAnimation];
    [KSMNetworkRequest postRequest:KSaleSearch params:self.searchParams.mj_keyValues success:^(id responseObj) {
        NSLog(@"KSaleSearch = %@",KSaleSearch);
        NSLog(@"mj_keyValues = %@",self.searchParams.mj_keyValues);
        
        [self stopGifAnimation];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"dic = %@",dic);
        
        [Uitils alertWithTitle:[dic objectForKey:@"msg"]];
        
        
        if ([[dic objectForKey:@"success"] integerValue]==1) {
            
            if (![[dic objectForKey:@"obj"] isEqual:[NSNull null]]) {
                
                NSArray *searchData = [dic objectForKey:@"obj"];
                NSArray *modelArray = [signSaleModel mj_objectArrayWithKeyValuesArray:searchData];
                [saleModel.saleTops addObjectsFromArray:modelArray];
                
                if (searchData.count < 10) {
                    [saleTable.mj_footer endRefreshingWithNoMoreData];
                }else {
                    
                    [saleTable.mj_footer endRefreshing];
                }
            }
            [saleTable.mj_footer endRefreshingWithNoMoreData];
            [saleTable reloadData];
        }

    } failure:^(NSError *error) {
        [saleTable.mj_footer endRefreshing];
        [self stopGifAnimation];
    }];
}

- (void)loadMoreData {

    if (headOrSearch == 0) {
        
        [self requestHeadData];
    }else {
        self.searchParams.page = [NSString stringWithFormat:@"%ld",[self.searchParams.page integerValue]+1];
        [self requestSearchData];
    }
}


#pragma mark 选择门店
- (void)pickStore:(UIButton *)sender {
    
    ChoseShopViewController *choseShop = [[ChoseShopViewController alloc]init];
    choseShop.delegate = self;
    [self.navigationController pushViewController:choseShop animated:YES];
    
}

#pragma mark 选择日期查询
- (void)pickDate:(UIButton *)sender {
    
    SelectCheck = [[[NSBundle mainBundle] loadNibNamed:@"SelectCheckDateView" owner:self options:nil] lastObject];
    SelectCheck.frame = self.view.bounds;
    SelectCheck.delegate = self;
    [self.view addSubview:SelectCheck];
    
}


#pragma mark ChoseShopViewController Delegate
- (void)selectedStores:(NSArray *)array {

    shouldShowStoreCount = [NSString stringWithFormat:@"%ld",array.count];
    NSString *storeString = [array componentsJoinedByString:@","];
    self.searchParams.stores = storeString;
    
    [self requestHeadData];
}

#pragma mark DatePickerViewDelegate 选择时间段的界面
- (void)showDatePicker:(UIButton *)sender {
    
    DatePickerView *dateP = [[[NSBundle mainBundle] loadNibNamed:@"DatePickerView" owner:self options:nil] lastObject];
    dateP.frame = self.view.bounds;
    dateP.tag = sender.tag;
    dateP.delegate = self;
    [self.view addSubview:dateP];
}

#pragma mark Delegte 选择的时间段
- (void)selectedDate:(NSDate *)date btnTag:(NSInteger)btnTag {

    NSDate *yesDate = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60*2)];
    if ([yesDate compare:date] == NSOrderedAscending) {
        date = yesDate;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"日期选择错误,已为你自动跳转到T+2" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        }]];
        [self presentViewController:alert animated:yesDate completion:nil];
        
    }
        // 创建一个日期格式器
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // 为日期格式器设置格式字符串
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        // 使用日期格式器格式化日期、时间
        NSString *destDateString = [dateFormatter stringFromDate:date];
         [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    switch (btnTag) {
        case 200:
            if (endTimeString) {
                
                NSDate *end = [dateFormatter dateFromString:endTimeString];
                
                if ([end compare:date] == NSOrderedAscending) {
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"开始日期大于结束日期，已自动重置为结束日期" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }]];
                    [self presentViewController:alert animated:yesDate completion:nil];
                    startTimeString = endTimeString;
                    [SelectCheck.beginTime setTitle:SelectCheck.endTime.currentTitle forState:UIControlStateNormal];
                }else {
                
                    startTimeString = [dateFormatter stringFromDate:date];
                    [SelectCheck.beginTime setTitle:destDateString forState:UIControlStateNormal];
                }
                
            }else {
                
                startTimeString = [dateFormatter stringFromDate:date];
                [SelectCheck.beginTime setTitle:destDateString forState:UIControlStateNormal];
            }
            break;
        case 201:
            
            if (startTimeString) {
                
                NSDate *start = [dateFormatter dateFromString:startTimeString];
                if ([start compare:date] == NSOrderedDescending) {
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"结束日期小于开始日期，已自动重置为T+2" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }]];
                    [self presentViewController:alert animated:yesDate completion:nil];
                    [dateFormatter setDateFormat:@"yyyyMMdd"];
                    endTimeString = [dateFormatter stringFromDate:yesDate];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                    [SelectCheck.endTime setTitle:[dateFormatter stringFromDate:yesDate] forState:UIControlStateNormal];
                }else {
                
                    endTimeString = [dateFormatter stringFromDate:date];
                    [SelectCheck.endTime setTitle:destDateString forState:UIControlStateNormal];
                }
            }else {
                endTimeString = [dateFormatter stringFromDate:date];
                [SelectCheck.endTime setTitle:destDateString forState:UIControlStateNormal];
            }
            break;
            
        default:
            break;
    }
}

//通过时间段开始搜索
- (void)startEndSearch {
    
    self.searchParams.startTime = startTimeString;
    self.searchParams.endTime = endTimeString;
    
    NSLog(@"%@",self.searchParams.mj_keyValues);
    
    [self requestHeadData];
}

//通过 年季周来查询
- (void)withDateSearch:(UIButton *)sender {
    
    ////按周100 按月101 按季102 按年103
    switch (sender.tag) {
        case 100:
            self.searchParams.dateFlag = @"week";
            break;
        case 101:
            self.searchParams.dateFlag = @"month";
            break;
        case 102:
            self.searchParams.dateFlag = @"quarter";
            break;
        case 103:
            self.searchParams.dateFlag = @"year";
            break;
            
        default:
            break;
    }
    
    NSLog(@"%@",self.searchParams.mj_keyValues);
    
    [self requestHeadData];
}

#pragma mark SaleCheckHeadDelegate
- (void)tapButton:(UIButton *)btn {
    
    for (int i = 0; i<5; i++) {
        UIButton *send = (UIButton *)[self.view viewWithTag:500+i];
        [send setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    [btn setTitleColor:[Uitils colorWithHex:smokeIncomeColor] forState:UIControlStateNormal];
    
    if (self.searchParams.stores.length == 0) {
        self.searchParams.stores = @"all";
    }
    
    switch (btn.tag) {
        case 500: //全部
            
            self.searchParams.channelType = @"";
            self.searchParams.channelCode = @"";
            [self requestHeadData];
            
            break;
        case 501:  //隔壁仓库
            self.searchParams.channelType = @"GB";
            self.searchParams.channelCode = @"";
            [self requestHeadData];
            
            break;
        case 502:  //线下
            self.searchParams.channelType = @"S";
            self.searchParams.channelCode = @"";
            [self requestHeadData];
            
            break;
        case 503:  //电话
            self.searchParams.channelType = @"T";
            self.searchParams.channelCode = @"";
            [self requestHeadData];
            break;
        case 504:  //线上
            self.searchParams.channelType = @"W";

            if (_onlineView) {
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [_onlineView removeFromSuperview];
                _onlineView = nil;
            }else {
            
                [self.view addSubview:self.onlineView];
            }
            
            break;
            
        default:
            break;
    }
}

#pragma mark OnlineViewDelegte
- (void)onlineCode:(NSString *)code {

    [_onlineView removeFromSuperview];
    _onlineView = nil;
    self.searchParams.channelCode = code;
    [self requestHeadData];
}

- (void)initSubViews {
    
    
    NSArray *titles = @[@"全部",@"隔壁仓库",@"线下",@"电话",@"线上▴"];
    for (int i = 0; i<5; i++) {
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH/5, 70, SCREEN_WIDTH/5, 40)];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        button.tag = 500+i;
        button.backgroundColor = [UIColor whiteColor];
        [button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    saleTable = [[UITableView alloc]initWithFrame:CGRectMake(10, 115, SCREEN_WIDTH-20, SCREEN_HEIGHT-114) style:UITableViewStyleGrouped];
    saleTable.dataSource = self;
    saleTable.delegate = self;
    saleTable.bounces = NO;
    saleTable.backgroundColor = [UIColor clearColor];
    saleTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [saleTable.mj_footer endRefreshingWithNoMoreData];
    [self.view addSubview:saleTable];
    
    [self setRefreshButton:CGRectMake(SCREEN_WIDTH-45, 120, 30, 30)];

}

#pragma mark UITableVIewDelegate------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }else {
        
        return saleModel.saleTops.count;
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
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
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
        
        if (currentType !=0) {
            
            UIButton *sender = (UIButton *)[cell viewWithTag:currentType];
            if (headOrSearch != 0) {
                
                sender.layer.borderColor = [Uitils colorWithHex:buttonTitleColor].CGColor;
                [sender setTitleColor:[Uitils colorWithHex:buttonTitleColor] forState:UIControlStateNormal];
            }else {
            
                sender.layer.borderColor = [Uitils colorWithHex:0xC5C6CA].CGColor;
                [sender setTitleColor:[Uitils colorWithHex:0x5D5F61] forState:UIControlStateNormal];
            }
        }
        

        return cell;
        
    }else {
        
        NSLog(@"ppppp = %ld",saleModel.saleTops.count);
        static NSString *identifier = @"StockCheckCell";
        StockCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"StockCheckCell" owner:self options:nil] lastObject];
        }
        
        signSaleModel *model = saleModel.saleTops[indexPath.row];
        
        cell.nameLabel.text = model.item_name;
         cell.typeNumH.constant = 1;
        
        NSArray *xyList = model.xyList;
        //条
        NSString *BE;
        //包
        NSString *EA;
        NSString *final;
        
        if (xyList.count > 0) {
          
            for (NSDictionary *dic in xyList) {
                
                //条
                if ([[dic objectForKey:@"unit"] isEqualToString:@"BX"]) {
                    if (BE.length == 0) {
                        
                        BE = [NSString stringWithFormat:@"%@条",[dic objectForKey:@"qty"]];
                        
                    }else {
                        BE = [NSString stringWithFormat:@"%@+%@条",BE,[dic objectForKey:@"qty"]];
                    }
                }
                //包
                if ([[dic objectForKey:@"unit"] isEqualToString:@"EA"]) {
                   
                    if (EA.length == 0) {
                        
                        EA = [NSString stringWithFormat:@"%@包",[dic objectForKey:@"qty"]];
                        
                    }else {
                        EA = [NSString stringWithFormat:@"%@+%@包",EA,[dic objectForKey:@"qty"]];
                    }
                }
                if (BE.length == 0&&EA.length !=0) {
                    final = EA;
                }else if (BE.length != 0&&EA.length ==0) {
                    final = BE;
                }else {
                    final = [NSString stringWithFormat:@"%@+%@",BE,EA];
                }
            }
        }else {
        
            if (headOrSearch == 0) {
                final  = model.item_num;

            }else {
            
                final  = model.qty;
            }
        }
        
        if (headOrSearch == 0) {
            
            cell.totalLabel.text = model.code;
            cell.priceLabel.text = [NSString stringWithFormat:@"%.2f",[model.totlePrice doubleValue]];
        }else {
        
            cell.totalLabel.text = model.item_code;
            cell.priceLabel.text = [NSString stringWithFormat:@"%.2f",[model.amt doubleValue]];
        }
        
        cell.countLabel.text = final;
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
        
        signSaleModel *model = saleModel.saleTops[indexPath.row];
        
        NSString *code = nil;
        if (currentType == 0) {
            code = model.code;
        }else {
        
            code = model.item_code;
        }
        
        StockCheckCell *cell = (StockCheckCell *)[self tableView:saleTable cellForRowAtIndexPath:indexPath];
        [cell cellAutoLayoutHeightWithName:model.item_name total:code];
        CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height+2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 450;
    }else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        header1 = [[[NSBundle mainBundle] loadNibNamed:@"SaleHeader1" owner:self options:nil] lastObject];
        header1.searchBar.leftViewMode = UITextFieldViewModeAlways;
        UIImageView *nameIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search-logo"]];
        nameIV.width += 15;
        nameIV.contentMode = UIViewContentModeCenter;
        header1.searchBar.leftView = nameIV;
        header1.delegate = self;
        //门店
        if (saleModel.queryDate) {
            header1.storesLabel.text = [NSString stringWithFormat:@"%@家门店%@ 销售总额",shouldShowStoreCount,saleModel.queryDate];  
        }

        //销售总额
        if (saleModel.smokeSale.saleAmount || saleModel.wineSale.saleAmount) {
            header1.saleAmount.text = [NSString stringWithFormat:@"%.2f",[saleModel.smokeSale.saleAmount doubleValue]+ [saleModel.wineSale.saleAmount doubleValue]];
        }

        
        //酒及其他毛利率
        if (saleModel.wineSale.gp) {
          header1.saleAmountPG.text = [NSString stringWithFormat:@"%.2f",[saleModel.wineSale.gp doubleValue]];
        }
        
        //烟销售额
        if (saleModel.smokeSale.saleAmount) {
            header1.saleGPM.text = [NSString stringWithFormat:@"%.2f",[saleModel.smokeSale.saleAmount doubleValue]];
        }
        
        //总客单数
        if (saleModel.otherSale.guestTotal) {
            header1.guestTotal.text = saleModel.otherSale.guestTotal;
        }
        
        //平均客单价
        if (saleModel.otherSale.unitPrice) {
            header1.unitPrice.text = [NSString stringWithFormat:@"%.2f",[saleModel.otherSale.unitPrice doubleValue]];
        }
        
        
        //烟销售额
        if (saleModel.smokeSale.saleAmount) {
            header1.smokeSaleAmount.text = [NSString stringWithFormat:@"%.2f",[saleModel.smokeSale.saleAmount doubleValue]];
        }
        
        //烟毛利额
        if (saleModel.smokeSale.gp) {
            header1.smokeGP.text = [NSString stringWithFormat:@"%.2f",[saleModel.smokeSale.gp doubleValue]];
        }
        
        //烟毛利率
        if (saleModel.smokeSale.gpm) {
            header1.smokeGPM.text = [NSString stringWithFormat:@"%.2f％",[saleModel.smokeSale.gpm doubleValue]*100];
        }
        
        
        //酒销售额
        if (saleModel.wineSale.saleAmount) {
            header1.wineSaleAmount.text = [NSString stringWithFormat:@"%.2f",[saleModel.wineSale.saleAmount doubleValue]];
        }
        
        //酒毛利额
        if (saleModel.wineSale.gp) {
           header1.wineGP.text = [NSString stringWithFormat:@"%.2f",[saleModel.wineSale.gp doubleValue]];
        }
        
        //酒毛利率
        if (saleModel.wineSale.gpm) {
            header1.wineGPM.text = [NSString stringWithFormat:@"%.2f％",[saleModel.wineSale.gpm doubleValue]*100];
        }
        
        header1.aFlag = aFlag;
        return header1;
        
    }else {
        
        StockCheckHeaderView2 *header2 = [[[NSBundle mainBundle] loadNibNamed:@"StockCheckHeaderView2" owner:self options:nil] lastObject];
        header2.label1.text = @"  TOP销售";
        header2.label2.text = @" NO 名称";
        header2.label3.text = @"数量(瓶)";
        header2.label4.text = @"金额(元)";
        header2.backgroundColor = [UIColor whiteColor];
        return header2;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 1) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        SaleDetailViewController *saleDetail = [[SaleDetailViewController alloc]init];
        signSaleModel *model = saleModel.saleTops[indexPath.row];
        saleDetail.superSale = model;
        saleDetail.headOrSearch = headOrSearch;
        saleDetail.dateFlag = self.searchParams.dateFlag;
        saleDetail.startTime = self.searchParams.startTime;
        saleDetail.endTime = self.searchParams.endTime;

        [self.navigationController pushViewController:saleDetail animated:YES];
    }
}

#pragma mark TypeTableViewCellDelegate  通过商品类型来搜索
- (void)typeToCheck:(UIButton *)sender {

    [saleModel.saleTops removeAllObjects];
    
//    self.searchParams.stores = @"";
    
    if ([self.searchParams.stores isEqualToString:@"all"]) {
    
        self.searchParams.stores = @"";
    }
    
    self.searchParams.saleQueryKey = @"type";
    self.searchParams.page = @"1";
    
    currentType = sender.tag;
    
    if (sender.tag == 100) {
        
        self.searchParams.saleQueryValue = @"all";
        
    }else {
        
        NSDictionary *dic = self.goodsTypeArr[sender.tag-101];
        self.searchParams.saleQueryValue = [dic objectForKey:@"itemCode"];
    }
    
//    switch (sender.tag) {
//        case 100:
//            self.searchParams.saleQueryValue = @"all";
//            break;
//        case 101:
//            self.searchParams.saleQueryValue = @"XY";
//            break;
//        case 102:
//            self.searchParams.saleQueryValue = @"BJ";
//            break;
//        case 103:
//            self.searchParams.saleQueryValue = @"HJ";
//            break;
//        case 104:
//            self.searchParams.saleQueryValue = @"GN";
//            break;
//        case 105:
//            self.searchParams.saleQueryValue = @"PT";
//            break;
//        case 106:
//            self.searchParams.saleQueryValue = @"YJ";
//            break;
//        case 107:
//            self.searchParams.saleQueryValue = @"PJ";
//            break;
//        case 108:
//            self.searchParams.saleQueryValue = @"YL";
//            break;
//        case 109:
//            self.searchParams.saleQueryValue = @"QJ";
//            break;
//            
//        default:
//            break;
//    }
    [saleTable.mj_footer endRefreshing];

    [self requestSearchData];
}

#pragma mark UITextFieldDelegate  通过关键字来搜索
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [saleModel.saleTops removeAllObjects];
    self.searchParams.page = @"0";
    self.searchParams.saleQueryKey = @"itemName";
    self.searchParams.saleQueryValue = header1.searchBar.text;
    [header1.searchBar resignFirstResponder];
    [self loadMoreData];
    return YES;
}

#pragma mark StockCheckHeaderView1 ----Delegate  关闭展开  商品类型
- (void)isZoom {
    
    //关闭状态
    if (aFlag == 0) {
        aFlag = 1;
        
    }else {
        
        aFlag = 0;
    }
    
    [saleTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
}

- (NSString *)stringWithInt:(NSInteger)i {
    
    if (i<10) {
        return [NSString stringWithFormat:@"0%ld",i];
    }else {
        
        return [NSString stringWithFormat:@"%ld",i];
    }
}

@end

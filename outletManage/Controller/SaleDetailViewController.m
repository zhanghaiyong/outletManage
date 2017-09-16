//
//  SaleDetailViewController.m
//  outletManage
//
//  Created by 张海勇 on 16/3/26.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "SaleDetailViewController.h"
#import "SaleDetailParams.h"
#import "StockCheckHeaderView2.h"
#import "StockCheckCell.h"
#import "DatePickerView.h"
#import "SelectCheckDateView.h"
@interface SaleDetailViewController ()

@property (nonatomic,strong)SaleDetailParams *params;

@end

@interface SaleDetailViewController ()<SelectCheckDateViewDetegate,DatePickerViewDelegate,UITableViewDataSource,UITableViewDelegate,SelectCheckDateViewDetegate>
{
    
    UITableView *detailTable;
    NSString    *searchDate;
    NSMutableArray *dataArray;
    
    //选择时间搜索
    SelectCheckDateView *SelectCheck;
    //暂存开始搜索时间
    NSString *startTimeString;
    //暂存结束搜素时间
    NSString *endTimeString;
}
@end

@implementation SaleDetailViewController

-(SaleDetailParams *)params {
    
    if (_params == nil) {
        
        SaleDetailParams *params = [[SaleDetailParams alloc]init];
        params.username = _account.verify.phonenum;
        if (_superSale.code) {
            params.itemCode = _superSale.code;
        }else {
            params.itemCode = _superSale.item_code;
        }
        
        NSLog(@"%@   %@",_superSale.code,_superSale.item_code);
        
        params.page = @"1";
        params.pageSize = @"10";
        params.stores = @"";
        params.dateFlag = _dateFlag;
        params.startTime = _startTime;
        params.endTime = _endTime;
        _params = params;
    }
    return _params;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"销售明细";
    [self setNavigationLeft:@"back"];
    [self setNavigationRight:@"title-rili"];
    dataArray = [NSMutableArray array];
    
    [self initSubViews];
    
    [self loadMoreData];
    
}

//选择日期查询
- (void)doRight:(id)sender {
    
    SelectCheck = [[[NSBundle mainBundle] loadNibNamed:@"SelectCheckDateView" owner:self options:nil] lastObject];
    SelectCheck.frame = self.view.bounds;
    SelectCheck.delegate = self;
    [self.view addSubview:SelectCheck];
    
}

#pragma mark DatePickerViewDelegate 时间段选择器
- (void)showDatePicker:(UIButton *)sender {
    
    DatePickerView *dateP = [[[NSBundle mainBundle] loadNibNamed:@"DatePickerView" owner:self options:nil] lastObject];
    dateP.frame = self.view.bounds;
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
    
    [dataArray removeAllObjects];
    self.params.dateFlag = @"";
    self.params.startTime = startTimeString;
    self.params.endTime = endTimeString;
    
    NSLog(@"%@",self.params.mj_keyValues);
    
    [self loadMoreData];
}

//通过 年季周来查询
- (void)withDateSearch:(UIButton *)sender {
    
    [dataArray removeAllObjects];
    
    ////按周100 按月101 按季102 按年103
    switch (sender.tag) {
        case 100:
            self.params.dateFlag = @"week";
            break;
        case 101:
            self.params.dateFlag = @"month";
            break;
        case 102:
            self.params.dateFlag = @"quarter";
            break;
        case 103:
            self.params.dateFlag = @"year";
            break;
            
        default:
            break;
    }
    
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
    NSLog(@"mj_keyValues = %@",self.params.mj_keyValues);
    
    [KSMNetworkRequest postRequest:KSaleDetail params:self.params.mj_keyValues
                           success:^(id responseObj) {
                               
                               
       [self stopGifAnimation];
       NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingAllowFragments error:nil];
       NSLog(@"销售详情 ＝ %@ \n ",dic);
       if ([[dic objectForKey:@"success"] integerValue]==1) {
           
           if (SelectCheck) {
               [SelectCheck removeFromSuperview];
           }
           
           searchDate = [[dic objectForKey:@"attributes"] objectForKey:@"time"];
           
           NSArray *array = [dic objectForKey:@"obj"];

           if (![array isEqual:[NSNull null]]) {
               
               [dataArray addObjectsFromArray:[signSaleModel mj_objectArrayWithKeyValuesArray:array]];
               
               [detailTable reloadData];
               
               if (array.count < 10) {
                   [detailTable.mj_footer endRefreshingWithNoMoreData];
               }else {
                   
                   [detailTable.mj_footer endRefreshing];
               }
           }else {
           
               [Uitils alertWithTitle:@"暂无数据"];
               [detailTable.mj_footer endRefreshing];
           }
           
       }else {
       
           [Uitils alertWithTitle:@"加载失败"];
       }

   } failure:^(NSError *error) {
       [self stopGifAnimation];
   }];
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 3;
    }else {
        return dataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 40;
    }else {
        signSaleModel *sale = dataArray[indexPath.row];
        
        StockCheckCell *cell = (StockCheckCell *)[self tableView:detailTable cellForRowAtIndexPath:indexPath];
        [cell cellAutoLayoutHeightWithName:sale.mcuName total:0];
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
        header2.label2.text = @" 门店名称";
        header2.label3.text = @"数量(瓶)";
        header2.label4.text = @"销售金额(元)";
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
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = [NSString stringWithFormat:@"商品名称  %@",self.superSale.item_name];
                break;
            case 1:{
                
                NSString *saleCode = nil;
                if (_superSale.code) {
                    saleCode = _superSale.code;
                }else {
                
                    saleCode = _superSale.item_code;
                }
                cell.textLabel.text = [NSString stringWithFormat:@"商品编号  %@",saleCode];
            }
                break;
            case 2:
                cell.textLabel.text = [NSString stringWithFormat:@"日期  %@",searchDate];
                break;
                
            default:
                break;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        
        static NSString *identifier = @"StockCheckCell";
        StockCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"StockCheckCell" owner:self options:nil] lastObject];
        }
        
        signSaleModel *model = dataArray[indexPath.row];
        
        
        cell.nameLabel.text = model.mcuName;
        
        NSArray *xyList = model.xyList;
        NSLog(@"fsagdsdfg = %ld",xyList.count);
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
            
            if (_headOrSearch == 0) {
                final  = model.qty;

            }else {
                
                final  = model.qty;

            }
        }
        
        if (_headOrSearch == 0) {
            cell.typeNumLabel.text = model.itemCode;
            //            cell.countLabel.text = model.item_num;
            cell.priceLabel.text = [NSString stringWithFormat:@"%.2f",[model.amt doubleValue]];
        }else {
        
            cell.typeNumLabel.text = model.itemCode;
            //            cell.countLabel.text = model.qty;
            cell.priceLabel.text = [NSString stringWithFormat:@"%.2f",[model.amt doubleValue]];
        }
        
        cell.countLabel.text = final;

        
        
//        cell.nameLabel.text = sale.mcuName;
//        cell.typeNumLabel.text = sale.itemCode;
//        
//        
//        
//        
//        cell.countLabel.text = sale.qty;
//        cell.priceLabel.text = [NSString stringWithFormat:@"%.2f",[sale.amt floatValue] / [sale.qty floatValue]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

@end

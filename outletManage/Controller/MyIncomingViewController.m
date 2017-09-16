//
//  MyIncomingViewController.m
//  outletManage
//
//  Created by 张海勇 on 16/3/29.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "MyIncomingViewController.h"
#import "InComingCell.h"
#import "ChoseShopCell.h"
#import "UITextField+SearchBar.h"
#import "SelectCheckDateView.h"
#import "DatePickerView.h"
#import "getMainDataParams.h"
#import "MainModel.h"
#import "checkShopListParams.h"
#import "StoresModel.h"
#import "ChoseShopViewController.H"

@interface MyIncomingViewController ()<ChoseShopViewControllerDelegate>

@property (nonatomic,strong)getMainDataParams *params;
@property (nonatomic,strong)checkShopListParams *storesParams;
@property (nonatomic,strong)NSMutableArray *selectedStores;

@end

@interface MyIncomingViewController ()<UITableViewDelegate,UITableViewDataSource,DatePickerViewDelegate,SelectCheckDateViewDetegate>
{

    SelectCheckDateView *SelectCheck;
    //暂存结束搜素时间
    NSString *endTimeString;
    //暂存开始搜索时间
    NSString *startTimeString;
    MainModel *mainModel;
    NSString *times;
    NSMutableArray  *storesArray;
    NSString *shouldShowStoreCount;
    
}
@property (weak, nonatomic) IBOutlet UITableView *incomeTable;
@end

@implementation MyIncomingViewController

-(NSMutableArray *)selectedStores {
    
    if (_selectedStores == nil) {
        
        NSMutableArray *selectedStores = [NSMutableArray array];
        _selectedStores = selectedStores;
    }
    return _selectedStores;
}

-(getMainDataParams *)params {

    if (_params == nil) {
        getMainDataParams *params = [[getMainDataParams alloc]init];
        params.username = _account.verify.phonenum;
        params.dateFlag = @"";
        params.stores = @"all";
        params.qryGB = @"true";
        params.newnoticeTime = @"1999-01-01 00:00:00";
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
        NSInteger day = [dateComponent day];
        //取一天,当前时间减去两天，只剩下一天
        if (day-2 == 1) {
            params.startTime = [NSString stringWithFormat:@"%ld%@%@",(long)[dateComponent year],[self stringWithInt:[dateComponent month]],[self stringWithInt:[dateComponent day]-2]];
            params.endTime = [NSString stringWithFormat:@"%ld%@%@",(long)[dateComponent year],[self stringWithInt:[dateComponent month]],[self stringWithInt:[dateComponent day]-2]];
            
            
            //当前时间减去两天，剩余天数大于1，则时间段是月初到当前时间减去两天的日期
        }else if (day-2 > 1) {
            
            params.startTime = [NSString stringWithFormat:@"%ld%@%@",(long)[dateComponent year],[self stringWithInt:[dateComponent month]],[self stringWithInt:1]];
            params.endTime = [NSString stringWithFormat:@"%ld%@%@",(long)[dateComponent year],[self stringWithInt:[dateComponent month]],[self stringWithInt:[dateComponent day]-2]];
            
            //否则，计算上个月全天
        } else {
            
            [dateComponent setYear:[dateComponent year]];
            [dateComponent setMonth:[dateComponent month]-1];
            [dateComponent setDay:[dateComponent day]];
            NSDate *lastMonth = [calendar dateFromComponents:dateComponent];
            
            NSCalendar *c = [NSCalendar currentCalendar];
            NSRange days = [c rangeOfUnit:NSCalendarUnitDay
                                   inUnit:NSCalendarUnitMonth
                                  forDate:lastMonth];
            
            params.startTime = [NSString stringWithFormat:@"%ld%@%@",(long)[dateComponent year],[self stringWithInt:[dateComponent month]],[self stringWithInt:1]];
            params.endTime = [NSString stringWithFormat:@"%ld%@%lu",(long)[dateComponent year],[self stringWithInt:[dateComponent month]],(unsigned long)days.length];
        }
        _params = params;
    }
    return _params;
}

- (checkShopListParams *)storesParams {

    if (_storesParams == nil) {
        checkShopListParams *storesParams = [[checkShopListParams alloc]init];
        storesParams.username = _account.verify.phonenum;
        storesParams.page = @"0";
        storesParams.pageSize = @"10";
        
        _storesParams = storesParams;
    }
    return _storesParams;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    times = @"~~";
    
    shouldShowStoreCount = [Uitils getUserDefaultsForKey:STORESTOTAL];
    
    self.title = @"我的收入";
    storesArray = [NSMutableArray arrayWithObjects:@"全部", nil];
    [self.incomeTable.mj_footer beginRefreshing];
    [self setNavigationLeft:@"back"];
    
    UIButton *dateButton = [self customButton:@"title-rili" selector:@selector(showDatePicker:)];
    UIButton *storeButton = [self customButton:@"title-house" selector:@selector(pickStore:)];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:dateButton];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:storeButton];
    self.navigationItem.rightBarButtonItems = @[item2,item1];
    
    
    [self requestheadData];
    
    [self setRefreshButton:CGRectMake(SCREEN_WIDTH-45, 75, 30, 30)];
    
}

#pragma mark 选择门店
- (void)pickStore:(UIButton *)sender {
    
    ChoseShopViewController *choseShop = [[ChoseShopViewController alloc]init];
    choseShop.delegate = self;
    [self.navigationController pushViewController:choseShop animated:YES];
    
}


#pragma mark ChoseShopViewController Delegate
- (void)selectedStores:(NSArray *)array {
    
    if (array.count == 0) {
        
        shouldShowStoreCount = [Uitils getUserDefaultsForKey:STORESTOTAL];
        
        self.params.stores = @"all";
    }else {
        
        shouldShowStoreCount = [NSString stringWithFormat:@"%ld",array.count];
        
    NSString *storeString = [array componentsJoinedByString:@","];
        self.params.stores = storeString;
    }
    
    [self requestheadData];
}

//刷新界面
- (void)refreshData {
    [self requestheadData];
}

- (void)requestheadData {
    
    [self showGifAnimation];
    NSLog(@"%@",self.params.mj_keyValues);

    [KSMNetworkRequest postRequest:KGetMainData params:self.params.mj_keyValues success:^(id responseObj) {
        
        if (SelectCheck) {
            [SelectCheck removeFromSuperview];
        }
        [self stopGifAnimation];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"我的收入 ＝ %@",dic);
        if ([[dic objectForKey:@"success"] integerValue] == 1) {
            
            NSDictionary *attributes = [dic objectForKey:@"attributes"];
            
            times = [attributes objectForKey:@"time"];
            
            mainModel = [MainModel mj_objectWithKeyValues:[attributes objectForKey:@"incomingVo"]];
            
//            if (!isSelectedStore) {
//              storesCount = mainModel.storeTotal;
//            }
            
           [self.incomeTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        }
    } failure:^(NSError *error) {
        
        [self stopGifAnimation];
    }];
}


#pragma mark 选择日期查询
- (void)doRight:(id)sender {
    
    SelectCheck = [[[NSBundle mainBundle] loadNibNamed:@"SelectCheckDateView" owner:self options:nil] lastObject];
    SelectCheck.frame = self.view.bounds;
    SelectCheck.delegate = self;
    [self.view addSubview:SelectCheck];
    
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
 
    self.params.startTime = startTimeString;
    self.params.endTime = endTimeString;
    
    NSLog(@"%@",self.params.mj_keyValues);
    
    [self requestheadData];
    
}

//通过 年季周来查询
- (void)withDateSearch:(UIButton *)sender {
    
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
    
    [self requestheadData];
    
}


#pragma mark UITableView deletage
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 321;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        static NSString *ID = @"cell1";//注意cell中，它的identifier设置为“cell”
        // 1.拿到一个标识先去缓存池中查找对应的Cell
        InComingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"InComingCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //门店数量，查询时间
        cell.storesLabel.text = [NSString stringWithFormat:@"%@家门店%@收入:",shouldShowStoreCount,times];
        
        //总价
        if (mainModel.total) {
           cell.totalSaleLabel.text = [NSString stringWithFormat:@"%.2f",[mainModel.total doubleValue]];
        }
        if (mainModel.guestTotal) {
            cell.SignNumLabel.text = mainModel.guestTotal;
        }
    
        if (mainModel.total || mainModel.guestTotal) {
            cell.SignPriceLabel.text = [NSString stringWithFormat:@"%.2f",[mainModel.total doubleValue]/[mainModel.guestTotal doubleValue]];
        }
    
        
        //香烟收入
        if (mainModel.xyamt) {
            cell.smoke1.text = [NSString stringWithFormat:@"%.2f",[mainModel.xyamt doubleValue]];
        }
    
        //香烟毛利额
        if (mainModel.xyprofit) {
            cell.smoke2.text = [NSString stringWithFormat:@"%.2f",[mainModel.xyprofit doubleValue]];
        }
    
        
        if ([mainModel.xyamt doubleValue] !=0) {
            //香烟毛利率
            cell.smoke3.text = [NSString stringWithFormat:@"%.2f％",[mainModel.xyprofit doubleValue]/[mainModel.xyamt doubleValue]*100];
        }

        //酒收入
        if (mainModel.jamt) {
            cell.wine1.text = [NSString stringWithFormat:@"%.2f",[mainModel.jamt doubleValue]];
        }
    
        //酒毛利额
        if (mainModel.jprofit) {
            cell.wine2.text = [NSString stringWithFormat:@"%.2f",[mainModel.jprofit doubleValue]];
        }
    
        if ([mainModel.jamt doubleValue] !=0) {
            //酒毛利率
            cell.wine3.text = [NSString stringWithFormat:@"%.2f％",[mainModel.jprofit doubleValue]/[mainModel.jamt doubleValue]*100];
        }

        //隔壁收入
        if (mainModel.gbamt) {
            cell.other1.text = [NSString stringWithFormat:@"%.2f",[mainModel.gbamt doubleValue]];
        }
    
        //隔壁毛利额
        if (mainModel.gbprofit) {
            cell.other2.text = [NSString stringWithFormat:@"%.2f",[mainModel.gbprofit doubleValue]];
        }
    
        if ([mainModel.gbamt doubleValue] != 0) {
        //隔壁毛利率
          cell.other3.text = [NSString stringWithFormat:@"%.2f％",[mainModel.gbprofit doubleValue]/[mainModel.gbamt doubleValue]*100];
        }
        return cell;
}

- (NSString *)stringWithInt:(NSInteger)i {
    
    if (i<10) {
        return [NSString stringWithFormat:@"0%ld",i];
    }else {
        
        return [NSString stringWithFormat:@"%ld",i];
    }
}

@end

//
//  MainViewController.m
//  text
//
//  Created by ksm on 16/3/11.
//  Copyright © 2016年 ksm. All rights reserved.
//
#define SPAC  5
#import "MainViewController.h"
#import "type_color.h"
#import "PiechartDetchView.h"
#import "PiechartModel.h"
#import "ButtonView.h"
#import "PieceBackViewController.h"
#import "SettingViewController.h"
#import "NoticeMessageViewController.h"
#import "StockCheckViewController.h"
#import "getMainDataParams.h"
#import "SaleCheckViewController.h"
#import "MainModel.h"
#import "NewsTipsView.h"
#import "MyIncomingViewController.h"
#import "MainLabel.h"


@interface MainViewController ()<ButtonViewDeleage>

@property (strong,nonatomic) PiechartDetchView *chartTwo;
@property (strong,nonatomic) NewsTipsView      *newsTipsView;

@end
@interface MainViewController ()<NewsTipsViewDelegate>
{
    getMainDataParams *params;
    UIButton *chartButton;
    NSString  *newsCount;
    MainLabel *mainLabel;
    UILabel   *dateLabel;
    BOOL      first;
    UILabel   *switchLabel;
    NSArray   *colors;
    NSArray   *titles;
    NSString  *news;
}
@end

@implementation MainViewController

-(NewsTipsView *)newsTipsView {

    if (_newsTipsView == nil) {
        NewsTipsView *newsTipsView = [[[NSBundle mainBundle] loadNibNamed:@"NewsTipsView" owner:self options:nil] lastObject];
        newsTipsView.frame = [UIScreen mainScreen].bounds;
        newsTipsView.delegate = self;
        _newsTipsView = newsTipsView;
    }
     return  _newsTipsView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Uitils setUserDefaultsObject:@"YES" ForKey:isOpenGestuerPwd];
    
    colors = @[[Uitils colorWithHex:wineIncomeColor],[Uitils colorWithHex:smokeIncomeColor],[Uitils colorWithHex:otherIncomeColor]];
    titles = @[@"烟销售额",@"酒及其他销售额",@"隔壁仓库销售额"];
    
    [self initSubViews];
    
    first = YES;
    
    UILabel *titleView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    titleView.text = [NSString stringWithFormat:@"%@,您好，欢迎回来！",_account.verify.username];
    titleView.font = [UIFont systemFontOfSize:MAX_FONT];
    titleView.textColor = [UIColor blackColor];
    self.navigationItem.titleView = titleView;
    
    [self setNavigationRight:@"main-header"];
    
   
    
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
     [self setRefreshButton:CGRectMake(SCREEN_WIDTH-45, 75, 30, 30)];
    
    
    ButtonView *btnView = (ButtonView *)[self.view viewWithTag:203];
    NSArray *readedNews = [Uitils getUserDefaultsForKey:ReadedNewsID];
    NSLog(@"readedNews = %ld  %ld",readedNews.count,[news integerValue]);
    if ([news integerValue] == readedNews.count) {
        btnView.badgeBtn.hidden = YES;
    }else {
    
        [btnView.badgeBtn setTitle:[NSString stringWithFormat:@"%lu",[news integerValue]-readedNews.count] forState:UIControlStateNormal];
    }
}

- (void)refreshData {

    [self requestData];
}

/**
 *  获取主页的数据
 */
- (void)requestData {

    [self showGifAnimation];

    params = [[getMainDataParams alloc]init];
    params.username = _account.verify.phonenum;
    params.dateFlag = @"";
    params.stores = @"all";
    params.qryGB = @"true";
    params.ver = @"1";
    //当前时间
    NSDate *yesterDay = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    NSString *yester = [FxDate stringFromDateYMD:yesterDay];
    
    //第一次进入
    if (first) {
        params.startTime = yester;
        params.endTime = [FxDate stringFromDateYMD:[NSDate date]];
        
    }else {
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
    }
    if ([Uitils getUserDefaultsForKey:NewestDate]) {
        params.newnoticeTime = [FxDate stringFromDateYMDHMS:[FxDate dateWithStamp:[[Uitils getUserDefaultsForKey:NewestDate] doubleValue]/1000]];
    }else {
        params.newnoticeTime = @"1999-01-01 00:00:00";
    }
    
    NSLog(@"mainParams = %@",params.mj_keyValues);
    
    [KSMNetworkRequest postRequest:KGetMainData params:params.mj_keyValues success:^(id responseObj) {
        
        [self stopGifAnimation];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"dic = %@ ",dic);
        
        if ([[dic objectForKey:@"success"] integerValue]==1) {
            
            NSDictionary *attributes = [dic objectForKey:@"attributes"];
            
            MainModel *mainModel = [MainModel mj_objectWithKeyValues:[attributes objectForKey:@"incomingVo"]];
            
            [Uitils setUserDefaultsObject:mainModel.storeTotal ForKey:STORESTOTAL];
            
            [self refreshMainDate:mainModel];
            
            if ([attributes.allKeys containsObject:@"news"]) {

                news = [attributes objectForKey:@"news"];
                NSArray *readedNews = [Uitils getUserDefaultsForKey:ReadedNewsID];
                
                if ([news integerValue] != readedNews.count) {
                    ButtonView *btnView = (ButtonView *)[self.view viewWithTag:203];
                    btnView.badgeBtn.hidden = NO;
                    [btnView.badgeBtn setTitle:[NSString stringWithFormat:@"%@",[attributes objectForKey:@"news"]] forState:UIControlStateNormal];
                    
                    self.newsTipsView.newsCount.text = [NSString stringWithFormat:@"您有%ld条公告未阅读",[news integerValue]-readedNews.count];
                    [[UIApplication sharedApplication].keyWindow addSubview:self.newsTipsView];
                }
                //最新公告时间
                [Uitils setUserDefaultsObject:[attributes objectForKey:@"newnoticeTime"] ForKey:NewestDate];
            }
        }
        

    } failure:^(NSError *error) {
        
        [self stopGifAnimation];
        NSLog(@"%@",error);
    }];
}

#pragma mark NewsTipsViewDelegate
- (void)toNewsVC {

    NoticeMessageViewController *noticeMsg = [[NoticeMessageViewController alloc]init];
    [self.navigationController pushViewController:noticeMsg animated:YES];
}

-(void)refreshMainDate:(MainModel *)model {
    
    [_chartTwo removeFromSuperview];
    
    //烟
    if (model.xyamt) {
        mainLabel.label1.text = [NSString stringWithFormat:@"￥%.2f",[model.xyamt doubleValue]];
    }
    if (model.xyprofit) {
        mainLabel.label4.text = [NSString stringWithFormat:@"￥%.2f",[model.xyprofit doubleValue]];
    }
    
    
    //酒及其他
    if (model.jamt) {
        mainLabel.label2.text = [NSString stringWithFormat:@"￥%.2f",[model.jamt doubleValue]];
    }
    if (model.jprofit) {
        mainLabel.label5.text = [NSString stringWithFormat:@"￥%.2f",[model.jprofit doubleValue]];
    }
    
    NSLog(@"dfzdgffh = %@",model.jamt);

    //隔壁
    if (model.gbamt) {
        mainLabel.label3.text = [NSString stringWithFormat:@"￥%.2f",[model.gbamt doubleValue]];
    }
    if (model.gbprofit) {
        mainLabel.label6.text = [NSString stringWithFormat:@"￥%.2f",[model.gbprofit doubleValue]];
    }
    
    CGFloat totleAmt = [model.gbamt doubleValue]+[model.xyamt doubleValue]+[model.jamt doubleValue];
    
    UIColor *chartColor = [UIColor lightGrayColor];
    NSArray *testArray = nil;
    
    //如果香烟销售额＋酒销售额＋隔壁销售额＝＝0
    if ([model.xyamt doubleValue]+[model.jamt doubleValue]+[model.gbamt doubleValue] == 0 ){
        
        chartColor = [Uitils colorWithHex:BFB];
        
    }else if ([model.xyprofit doubleValue]+[model.jprofit doubleValue]+[model.gbprofit doubleValue] < 0) {
    
        chartColor = [Uitils colorWithHex:incomeIsDown];
        
    }else {
    
        //香烟比例
        PiechartModel *model1 = [[PiechartModel alloc]init];
        model1.color = [Uitils colorWithHex:smokeIncomeColor];
        model1.perStr = [NSString stringWithFormat:@"%f",[model.xyamt doubleValue] / totleAmt];
        
        //酒及其他比例
        PiechartModel *model2 = [[PiechartModel alloc]init];
        model2.color = [Uitils colorWithHex:wineIncomeColor];
        model2.perStr = [NSString stringWithFormat:@"%f",[model.jamt doubleValue] / totleAmt];
        
        //隔壁
        PiechartModel *model3 = [[PiechartModel alloc]init];
        model3.color = [Uitils colorWithHex:otherIncomeColor];
        model3.perStr = [NSString stringWithFormat:@"%f",[model.gbamt doubleValue] / totleAmt];
        
        testArray = [NSArray arrayWithObjects:model1,model2,model3, nil];
    }
    
    _chartTwo = [[PiechartDetchView alloc]initWithFrame:CGRectMake(chartButton.width/2-60, -5, SCREEN_WIDTH/3, chartButton.height/5*3.5) withStrokeWidth:SCREEN_WIDTH/3/10 andColor:chartColor andPerArray:testArray andAnimation:YES];
    [chartButton addSubview:_chartTwo];
    _chartTwo.textV.text = [NSString stringWithFormat:@"￥\n%.2f",totleAmt];
    if (first) {
        _chartTwo.lab.text = @"系统审核中销售额";
        switchLabel.text = @"当月累计";
    }else {
    
        _chartTwo.lab.text = @"系统已审核销售额";
        switchLabel.text = @"系统审核中";
    }
    
    dateLabel.text = [NSString stringWithFormat:@"%@家门店,%@-%@",model.storeTotal,params.startTime,params.endTime];
    
}

- (void)switchAction {

    if (first) {
        first = NO;
        
    }else {
    
        first = YES;
    }
    
    [self requestData];
}

- (void)initSubViews {

    chartButton = [[UIButton alloc]initWithFrame:CGRectMake(SPAC,64+SPAC, SCREEN_WIDTH-SPAC*2,(SCREEN_HEIGHT-64)/2)];
    chartButton.backgroundColor = [UIColor whiteColor];
    chartButton.layer.borderColor = [Uitils colorWithHex:cutofflineColor].CGColor;
    chartButton.layer.borderWidth = 0.5;
    chartButton.userInteractionEnabled = YES;
    [chartButton addTarget:self action:@selector(toIncoming) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chartButton];
    
    dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH, 20)];
    dateLabel.textColor = [UIColor blackColor];
    dateLabel.font = [UIFont systemFontOfSize:12];
    [chartButton addSubview:dateLabel];
    
    UIButton *switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    switchBtn.frame = CGRectMake(chartButton.width/6-30, chartButton.height/3-chartButton.height/9, 40, 40);
    [switchBtn setImage:[UIImage imageNamed:@"main"] forState:UIControlStateNormal];
    [switchBtn addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventTouchUpInside];
    [chartButton addSubview:switchBtn];
    
    switchLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, switchBtn.bottom, chartButton.width/3-20, 20)];
    switchLabel.font = [UIFont systemFontOfSize:11];
    switchLabel.text = @"系统审核中";
    switchLabel.textAlignment = NSTextAlignmentCenter;
    switchLabel.textColor = [UIColor blackColor];
    [chartButton addSubview:switchLabel];
    
    _chartTwo = [[PiechartDetchView alloc]initWithFrame:CGRectMake(chartButton.width/2-60, 0, SCREEN_WIDTH/3, chartButton.height/5*3) withStrokeWidth:SCREEN_WIDTH/3/10 andColor:[UIColor lightGrayColor] andPerArray:nil andAnimation:YES];
    _chartTwo.userInteractionEnabled = NO;
    [chartButton addSubview:_chartTwo];
    _chartTwo.lab.text = @"系统审核中销售额";
    
    for (int i = 0; i<titles.count; i++) {
        type_color *TC = [[type_color alloc]initWithFrame:CGRectMake(_chartTwo.right+3, 35+i*30, chartButton.width/3, 20)];
        TC.viewColor = colors[i];
        TC.typeStr = titles[i];
        TC.userInteractionEnabled = NO;
        TC.tag = 500+i;
        [chartButton addSubview:TC];
    }
    
    mainLabel = [[[NSBundle mainBundle] loadNibNamed:@"MainLabel" owner:self options:nil] lastObject];
    mainLabel.frame = CGRectMake(0,chartButton.height-chartButton.height/5*2, chartButton.width, chartButton.height/5*2);
    [chartButton addSubview:mainLabel];
    
    NSArray *buttonTitles = @[@"商品及库存查询",@"销售查询",@"意见反馈",@"公告信息"];
    NSArray *buttonImages = @[@"sale-logo1.png",@"sale-logo2.png",@"sale-logo3.png",@"sale-logo4.png"];
    
    CGFloat H  = (((SCREEN_HEIGHT-64)/2)-SPAC*4)/2;
    CGFloat W = (SCREEN_WIDTH-SPAC*3)/2;
    
    for (int i = 0; i<4; i++) {
        
        ButtonView *buttonView = [[ButtonView alloc]initWithFrame:CGRectMake(SPAC+i%2*(W+SPAC), chartButton.bottom+SPAC+i/2*(H+SPAC), W, H) title:buttonTitles[i] image:buttonImages[i]];
        buttonView.backgroundColor = [UIColor whiteColor];
        buttonView.layer.borderColor = [Uitils colorWithHex:cutofflineColor].CGColor;
        buttonView.layer.borderWidth = 0.5;
        buttonView.samllImage = YES;
        buttonView.delegate = self;
        buttonView.tag = 200+i;
        [self.view addSubview:buttonView];
    }
    
}

- (void)buttonViewTap:(NSInteger)aFlag {

    switch (aFlag) {
        case 200: {
            NSLog(@"商品及库存查询");
            StockCheckViewController *stockCheck = [[StockCheckViewController alloc]init];
            [self.navigationController pushViewController:stockCheck animated:YES];
        }
            break;
        case 201: {
            NSLog(@"销售查询");
            SaleCheckViewController *stockCheck = [[SaleCheckViewController alloc]init];
            [self.navigationController pushViewController:stockCheck animated:YES];
            
        }
            break;
        case 202: {
            NSLog(@"意见反馈");
            PieceBackViewController *pieceBack = [[PieceBackViewController alloc]init];
            [self.navigationController pushViewController:pieceBack animated:YES];
        }
            break;
        case 203: {
            NSLog(@"公告信息");
            NoticeMessageViewController *noticeMsg = [[NoticeMessageViewController alloc]init];
            [self.navigationController pushViewController:noticeMsg animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)toIncoming {

    MyIncomingViewController *myIncoming = [[MyIncomingViewController alloc]init];
    [self.navigationController pushViewController:myIncoming animated:YES];
}

- (void)doRight:(id)sender {

    SettingViewController *setting = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:setting animated:YES];
}

- (NSString *)stringWithInt:(NSInteger)i {

    if (i<10) {
        return [NSString stringWithFormat:@"0%ld",i];
    }else {
    
        return [NSString stringWithFormat:@"%ld",i];
    }
}

@end

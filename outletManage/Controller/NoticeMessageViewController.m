//
//  NoticeMessageViewController.m
//  outletManage
//
//  Created by 张海勇 on 16/3/12.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "NoticeMessageViewController.h"
#import "UIView+Line.h"
#import "NoticeMsgCell.h"
#import "UITextField+SearchBar.h"
#import "noticeListParams.h"
#import "NoticeListModel.h"
#import "NoticeDetailViewController.h"
@interface NoticeMessageViewController ()

@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) noticeListParams *params;
@end

@interface NoticeMessageViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{

    UITextField *searchBar;
    UITableView *noticeMsgTable;
}
@end

@implementation NoticeMessageViewController

- (noticeListParams *)params {

    if (_params == nil) {
        
        noticeListParams *params = [[noticeListParams alloc]init];
        _params = params;
    }
    return _params;
}

- (NSMutableArray *)tableData {

    if (_tableData == nil) {
        
        NSMutableArray *tableData = [NSMutableArray array];
        _tableData = tableData;
    }
    return _tableData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"公告信息";
    [self setNavigationLeft:@"back"];
    
     [self initSearchBar];
    
    [self requestData];
    
    
}

- (void)requestData {
    
    
    NSLog(@"params = %@",self.params.mj_keyValues);
    
    [KSMNetworkRequest postRequest:KNoticeList params:self.params.mj_keyValues success:^(id responseObj) {
        
        [noticeMsgTable.mj_header endRefreshing];
        [noticeMsgTable.mj_footer endRefreshing];
        
        NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingAllowFragments error:nil];
        
        if (array.count) {
            
            for (NSDictionary *dic in array) {
                
                NoticeListModel *model = [NoticeListModel mj_objectWithKeyValues:dic];
                [self.tableData addObject:model];
            }
            
            NSLog(@"dsfdsf = %ld",self.tableData.count);
            
        }else {
        
            [noticeMsgTable.mj_footer endRefreshingWithNoMoreData];
        }
        
        [noticeMsgTable reloadData];
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
    }];
}

- (void)initSearchBar {

    searchBar = [UITextField textWithFrame:CGRectMake(10, 74, SCREEN_WIDTH-20, 40) placeholder:@"按关键字搜索"];
    searchBar.delegate = self;
    searchBar.returnKeyType = UIReturnKeySearch;
    [self.view addSubview:searchBar];
    
    UIView *line = [UIView lineWithFrame:CGRectMake(0, searchBar.bottom+10, SCREEN_WIDTH, 1) color:[Uitils colorWithHex:cutofflineColor]];
    [self.view addSubview:line];
    
    noticeMsgTable = [[UITableView alloc]initWithFrame:CGRectMake(10, line.bottom, SCREEN_WIDTH-20, SCREEN_HEIGHT-74-searchBar.height-10) style:UITableViewStyleGrouped];
    noticeMsgTable.delegate = self;
    noticeMsgTable.dataSource = self;
    noticeMsgTable.separatorColor = [UIColor clearColor];
    noticeMsgTable.backgroundColor = [UIColor clearColor];
    
    noticeMsgTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    noticeMsgTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    noticeMsgTable.mj_footer.automaticallyHidden = NO;
    [self.view addSubview:noticeMsgTable];
}

#pragma mark MJRefresh Delegate-----
- (void)loadNewData {

    self.params.flag = @"down";
    NoticeListModel *model = self.tableData[0];
    NSDate *lastDate = [FxDate dateWithStamp:[model.publishTime doubleValue]/1000];
    NSString *lastStr = [FxDate stringFromDateYMDHMS:lastDate];
    self.params.flagTime = lastStr;
    [self requestData];
}

- (void)loadMoreData {

    self.params.flag = @"up";
    NoticeListModel *model = [self.tableData lastObject];
    NSDate *firstDate = [FxDate dateWithStamp:[model.publishTime doubleValue]/1000];
    NSString *firstStr = [FxDate stringFromDateYMDHMS:firstDate];
    self.params.flagTime = firstStr;
    [self requestData];
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.tableData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"NoticeMsgCell";
    NoticeMsgCell *cell = cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NoticeMsgCell" owner:self options:nil] lastObject];
    }
    cell.layer.borderColor = [Uitils colorWithHex:cutofflineColor].CGColor;
    cell.layer.borderWidth = 0.8;
    NoticeListModel *model = self.tableData[indexPath.section];
    
     NSMutableArray *cachedId = [Uitils getUserDefaultsForKey:ReadedNewsID];
    if ([cachedId containsObject:model.id]) {
        
        cell.newsImg.hidden = YES;
        
    }else {
    
        cell.newsImg.hidden = NO;
    }
    
    cell.titleLabel.text = model.title;
    cell.detailLabel.text = model.noticeAbstract;
    cell.timeLabel.text = [FxDate stringFromDateYMDHMS:[FxDate dateWithStamp:[model.createTime doubleValue]/1000]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    NoticeMsgCell *cell = (NoticeMsgCell *)[self tableView:noticeMsgTable cellForRowAtIndexPath:indexPath];
    NoticeListModel *model = self.tableData[indexPath.section];
    [cell cellAutoLayoutHeight:model.title];
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NoticeListModel *model = self.tableData[indexPath.section];
    
    NSMutableArray *cachedId = [Uitils getUserDefaultsForKey:ReadedNewsID];
    NSMutableArray *array = [NSMutableArray array];
    if (cachedId) {
        [array addObjectsFromArray:cachedId];
        if (![cachedId containsObject:model.id]) {
            [array addObject:model.id];
        }
    }else {
        
        if (![cachedId containsObject:model.id]) {
            [array addObject:model.id];
        }
    }
    [Uitils setUserDefaultsObject:array ForKey:ReadedNewsID];
    
    NoticeMsgCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.newsImg.hidden = YES;
    
    NoticeDetailViewController *noticeDtail = [[NoticeDetailViewController alloc]init];
    noticeDtail.contentID = model.id;
    [self.navigationController pushViewController:noticeDtail animated:YES];
    
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.tableData removeAllObjects];
    self.params.searchName = searchBar.text;
    self.params.flag = @"";
    self.params.flagTime = @"";
    [self requestData];
    [searchBar resignFirstResponder];
    return YES;
}


@end

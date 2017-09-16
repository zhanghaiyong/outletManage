//
//  ChoseShopViewController.m
//  outletManage
//
//  Created by 张海勇 on 16/3/13.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "ChoseShopViewController.h"
#import "UITextField+SearchBar.h"
#import "ChoseShopCell.h"
#import "checkShopListParams.h"
#import "StoresModel.h"

@interface ChoseShopViewController()

@property (nonatomic,strong)    UIView      *searchBack;
@property (nonatomic,strong) NSMutableArray *selectedStores;
@end

@interface ChoseShopViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{

    UITableView *choseTableV;
    UITextField *searchBar;
    NSMutableArray  *dataArray;
    NSInteger   page;
   

}
@end

@implementation ChoseShopViewController

-(NSMutableArray *)selectedStores {

    if (_selectedStores == nil) {
        
        NSMutableArray *selectedStores = [NSMutableArray array];
        _selectedStores = selectedStores;
    }
    return _selectedStores;
}

-(UIView *)searchBack {
    
    if (_searchBack == nil) {
        
        UIView *searchBack = [[UIView alloc]initWithFrame:CGRectMake(0, 0, choseTableV.width, 60)];
        searchBack.backgroundColor = [UIColor whiteColor];
        searchBar = [UITextField textWithFrame:CGRectMake(10, 10, searchBack.width-20, 40) placeholder:@"按关键字搜索"];
        searchBar.returnKeyType = UIReturnKeySearch;
        searchBar.delegate = self;
        [searchBack addSubview:searchBar];
        
        _searchBack = searchBack;
    }
    
    return _searchBack;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    dataArray = [NSMutableArray arrayWithObjects:@"全部", nil];
    page = 0;
    
    self.title = @"选择门店";
    [self setNavigationLeft:@"back"];
    [self setNavigationRightTitle:@"确认"];
    
    [self requestData:@""];
    
    [self initSubViews];
    
}

- (void)initSubViews {
    
    choseTableV = [[UITableView alloc]initWithFrame:CGRectMake(10, 74, SCREEN_WIDTH-20, SCREEN_HEIGHT-74)];
    choseTableV.dataSource = self;
    choseTableV.delegate = self;
    choseTableV.backgroundColor = [UIColor clearColor];
    choseTableV.separatorColor = [UIColor clearColor];
    choseTableV.layer.borderColor = [Uitils colorWithHex:cutofflineColor].CGColor;
    choseTableV.layer.borderWidth = 0.8;
    
    choseTableV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [self.view addSubview:choseTableV];

}

- (void)requestData:(NSString *)searchName {

    page += 1;
    
    checkShopListParams *params = [[checkShopListParams alloc]init];
    params.username = _account.verify.phonenum;
    params.page = [NSString stringWithFormat:@"%ld",(long)page];
    params.pageSize = @"20";
    params.serchName = searchName;
    
    NSLog(@"params = %@",params.mj_keyValues);
    
    [KSMNetworkRequest postRequest:KStoresList params:params.mj_keyValues success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingAllowFragments error:nil];
        NSArray *array = [dic objectForKey:@"obj"];
        if (![array isEqual:[NSNull null]]) {
            
            for (int i = 0; i<array.count; i++) {
                
                StoresModel *model = [StoresModel mj_objectWithKeyValues:array[i]];
                
                [dataArray insertObject:model atIndex:dataArray.count];
            }
            NSLog(@"dic = %@",dic);
            
            [choseTableV reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            
            if (array.count < 20) {
                [choseTableV.mj_footer endRefreshingWithNoMoreData];
            }else {
                
                [choseTableV.mj_footer endRefreshing];
            }
        }else {
        
            [Uitils alertWithTitle:@"暂无数据"];
        }

        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

- (void)loadMoreData {

    [self requestData:@""];

}


#pragma mark UITableViewDelegate----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    return self.searchBack;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifier = @"cell";
    ChoseShopCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoseShopCell" owner:self options:nil] lastObject];
    }

    
    if (indexPath.row == 0) {
            cell.shopNameLabel.text = dataArray[indexPath.row];
    }else {
    StoresModel *model = dataArray[indexPath.row];
     cell.shopNameLabel.text = model.MCU_NAME;
        
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if (indexPath.row == 0) {
        
        ChoseShopCell *allCell = [choseTableV cellForRowAtIndexPath:indexPath];
        
        if (!allCell.isSelectButton.selected) {
            for (int i = 1; i<dataArray.count; i++) {
                NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
                ChoseShopCell *cell = [choseTableV cellForRowAtIndexPath:path];
                allCell.isSelectButton.selected = YES;
                cell.isSelectButton.selected = YES;
                
                StoresModel *model = dataArray[i];
                [self.selectedStores addObject:model.MCU_CODE];
                
            }
        }else {
        
            for (int i = 1; i<dataArray.count; i++) {
                
                NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
                ChoseShopCell *cell = [choseTableV cellForRowAtIndexPath:path];
                cell.isSelectButton.selected = NO;
                allCell.isSelectButton.selected = NO;
                
                [self.selectedStores removeAllObjects];
            }
        }
    }else {
    
        StoresModel *model = dataArray[indexPath.row];
        ChoseShopCell *cell = [choseTableV cellForRowAtIndexPath:indexPath];
        if (cell.isSelectButton.selected) {
            cell.isSelectButton.selected = NO;
            [self.selectedStores removeObject:model.MCU_CODE];
            
        }else {
            cell.isSelectButton.selected = YES;
            [self.selectedStores addObject:model.MCU_CODE];
            
        }
    }
}


- (void)doRight:(id)sender
{
 
    if ([self.delegate respondsToSelector:@selector(selectedStores:)]) {
        
//        [Uitils setUserDefaultsObject:[NSString stringWithFormat:@"%ld",(unsigned long)self.selectedStores.count] ForKey:STORESTOTAL];
        
        [self.delegate selectedStores:self.selectedStores];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    page = 0;
    [dataArray removeAllObjects];
    [dataArray addObject:@"全部"];
    [self requestData:searchBar.text];
    [searchBar resignFirstResponder];
    return YES;
}

@end

//
//  NoticeDetailViewController.m
//  outletManage
//
//  Created by 张海勇 on 16/3/15.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "NoticeDetailViewController.h"
#import "noticeDetailParams.h"
@interface NoticeDetailViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *web;

@end

@implementation NoticeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"公告信息";
    [self setNavigationLeft:@"back"];
    
    [self requestData];
    
}

- (void)requestData {
    
    [self showGifAnimation];

    noticeDetailParams *params = [[noticeDetailParams alloc]init];
    params.id = self.contentID;
    NSLog(@"%@",self.contentID);
    
    [KSMNetworkRequest postRequest:KNoticeDetail params:params.mj_keyValues success:^(id responseObj) {
        
        [self stopGifAnimation];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"公告详情 = %@ ",dic);
        
        [self.web loadHTMLString:[dic objectForKey:@"obj"] baseURL:nil];
        
        
    } failure:^(NSError *error) {

        [self stopGifAnimation];
        NSLog(@"%@",error);
        
    }];
    
}

@end

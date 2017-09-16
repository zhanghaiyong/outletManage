//
//  BaseViewController.m
//  outletManage
//
//  Created by ksm on 16/3/10.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "BaseViewController.h"

static UIView *gifView= nil;

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self shareGifView];
    
    [self backgoundColor];
    
    _account = [UserMsgTool account];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
//    [self.refreshBtn removeFromSuperview];
//    self.refreshBtn = nil;
}

- (void)backgoundColor {

    self.view.backgroundColor = [Uitils colorWithHex:backgroudColor];
}



- (void)setNavigationTitleImage:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    self.navigationItem.titleView = imageView;
}


- (UIButton *)customButton:(NSString *)imageName
                  selector:(SEL)sel
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)setNavigationRightTitle:(NSString *)title {

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [btn addTarget:self action:@selector(doRight:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setNavigationLeft:(NSString *)imageName
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:[self customButton:imageName selector:@selector(doBack:)]];
    
    self.navigationItem.leftBarButtonItem = item;
}

- (void)setNavigationRight:(NSString *)imageName
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:[self customButton:imageName selector:@selector(doRight:)]];
    
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setRefreshButton:(CGRect)frame {

    self.refreshBtn = [[UIButton alloc]initWithFrame:frame];
    [self.refreshBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-shuaxinliebiao"] forState:UIControlStateNormal];
    [self.refreshBtn addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.refreshBtn];
}


- (void)doRight:(id)sender
{
    
}

- (void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshData {

    
}


- (UIView *)shareGifView {
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        gifView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        gifView.backgroundColor = [UIColor whiteColor];
        gifView.alpha  = 0.8;
        gifView.userInteractionEnabled = YES;
        CGSize size =  [UIImage imageNamed:@"loading.gif"].size;
        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(gifView.width/2-size.width/2, gifView.height/2-size.height/2, size.width, size.height)];
        webView.backgroundColor = [UIColor clearColor];
        webView.userInteractionEnabled = NO;
        // 读取gif图片数据
        NSData *gif = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"]];
        [webView loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
        [gifView addSubview:webView];
        
    });
    return gifView;
}

- (void)stopGifAnimation{
    
    [gifView removeFromSuperview];
}

- (void)showGifAnimation {
    
    if (gifView == nil) {
        
        gifView = [self shareGifView];
    }
    
    [self.view addSubview:gifView];
}


@end

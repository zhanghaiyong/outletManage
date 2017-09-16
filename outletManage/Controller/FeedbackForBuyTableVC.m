//
//  FeedbackForBuyTableVC.m
//  outletManage
//
//  Created by 张海勇 on 16/3/24.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "FeedbackForBuyTableVC.h"
#import <LBXScanViewController.h>
#import "SubLBXScanViewController.h"
#import "feedByCodeBackParams.h"
#import "feedByParamsBackParams.h"
#import "ScanDataModel.h"

static UIView *gifView= nil;

@interface FeedbackForBuyTableVC ()<UITextViewDelegate>

@property (nonatomic,strong)feedByCodeBackParams *citmCodeParams;
@property (nonatomic,strong)feedByParamsBackParams *paramsParams;

@end
@interface FeedbackForBuyTableVC ()<SubLBXScanDelelage>{

    UserMsgModel *account;
}
/**
 *  轨迹编码
 */
@property (weak, nonatomic) IBOutlet UITextField *natureCode;
/**
 *  商品编码
 */
@property (weak, nonatomic) IBOutlet UITextField *goodsCode;
/**
 *  商品名称
 */
@property (weak, nonatomic) IBOutlet UITextField *goodsName;
/**
 *  酒精浓度
 */
@property (weak, nonatomic) IBOutlet UITextField *alcohol;
/**
 *  规格
 */
@property (weak, nonatomic) IBOutlet UITextField *spec;
/**
 *  报价
 */
@property (weak, nonatomic) IBOutlet UITextField *price;
/**
 *  价格来源
 */
@property (weak, nonatomic) IBOutlet UITextView *priceSource;


@end

@implementation FeedbackForBuyTableVC

-(feedByCodeBackParams *)citmCodeParams {

    if (_citmCodeParams == nil) {
        feedByCodeBackParams *citmCodeParams = [[feedByCodeBackParams alloc]init];
        citmCodeParams.userName = account.verify.phonenum;
        _citmCodeParams = citmCodeParams;
    }
    return _citmCodeParams;
}

-(feedByParamsBackParams *)paramsParams {

    if (_paramsParams == nil) {
        feedByParamsBackParams *paramsParams = [[feedByParamsBackParams alloc]init];
        paramsParams.userName = account.verify.phonenum;
        paramsParams.unit = @"元/瓶";
        _paramsParams = paramsParams;
    }
    return _paramsParams;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    account = [UserMsgTool account];
    
    self.title = @"采购商品信息反馈";
    [self setLeftBarButton];
    self.view.backgroundColor = [Uitils colorWithHex:backgroudColor];
}

- (void)setLeftBarButton {

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
    
    [self.natureCode  setValue:@10 forKey:@"paddingLeft"];
    [self.goodsCode   setValue:@10 forKey:@"paddingLeft"];
    [self.goodsName   setValue:@10 forKey:@"paddingLeft"];
    [self.alcohol     setValue:@10 forKey:@"paddingLeft"];
    [self.spec        setValue:@10 forKey:@"paddingLeft"];
    [self.price       setValue:@10 forKey:@"paddingLeft"];
    
}


#pragma mark UITableVIewDelegate
- (IBAction)ScanAction:(id)sender {
    
    SubLBXScanViewController *vc = [SubLBXScanViewController new];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark SubLBXScanViewControllerDelegate
- (void)scanData:(NSString *)scanString {
    
    [self showGifAnimation];
    
    self.citmCodeParams.citm_code = scanString;
    NSLog(@"%@",self.citmCodeParams.mj_keyValues);
    
    [KSMNetworkRequest postRequest:KScanKnowData params:self.citmCodeParams.mj_keyValues success:^(id responseObj) {
        
        [self stopGifAnimation];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",dic);
        
        [Uitils alertWithTitle:[dic objectForKey:@"msg"]];
        
        if ([[dic objectForKey:@"success"] integerValue]==1) {
            
            NSDictionary *goodsDic = [dic objectForKey:@"obj"];
            ScanDataModel *model = [ScanDataModel mj_objectWithKeyValues:goodsDic];
            
            _natureCode.text = scanString;
            _goodsCode.text = model.item_code;
            _goodsName.text = model.item_name;
            _spec.text = model.item_spec;
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        [self stopGifAnimation];
        
    }];
    
}

- (IBAction)subitAction:(id)sender {
    
    if (_price.text.length == 0) {
        
        [Uitils alertWithTitle:@"报价不能为空"];
        
    }else if (_priceSource.text.length == 0) {
    
        [Uitils alertWithTitle:@"价格来源不能为空"];
        
    }else {
    
        self.paramsParams.itemName = _goodsName.text;
        self.paramsParams.itemCode = _goodsCode.text;
        self.paramsParams.citmCode = _natureCode.text;
        self.paramsParams.alcohol = _alcohol.text;
        self.paramsParams.itemSpec = _spec.text;
        self.paramsParams.offerPrice = _price.text;
        self.paramsParams.sourcePrice = _priceSource.text;
        
        [KSMNetworkRequest postRequest:KScanBack params:self.paramsParams.mj_keyValues success:^(id responseObj) {
            
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"dic = %@",dic);
            if ([[dic objectForKey:@"success"] integerValue] == 1) {
                
                [self performSelector:@selector(backAction) withObject:self afterDelay:1];
                
            }
            [Uitils alertWithTitle:[dic objectForKey:@"msg"]];
            
        } failure:^(NSError *error) {
            
            [Uitils alertWithTitle:@"反馈失败，请检查参数"];
            
            NSLog(@"%@",error);
        }];
    }
}

#pragma mark UITextViewDelegate)
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([_priceSource.text isEqualToString:@"价格来源"]) {
        _priceSource.text = @"";
        _priceSource.textColor = [UIColor blackColor];
    }
}

-(BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if (_priceSource.text.length == 0) {
        _priceSource.text = @"价格来源";
        _priceSource.textColor =  [Uitils colorWithHex:0xD8D8D8];
    }
}


- (void)backAction {

    [self.navigationController popViewControllerAnimated:YES];
}


- (UIView *)shareGifView {
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        gifView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        gifView.backgroundColor = [UIColor whiteColor];
        gifView.userInteractionEnabled = YES;
        gifView.alpha = 0.9;
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

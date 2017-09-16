//
//  Fan_kuiViewController.m
//  outletManage
//
//  Created by 张海勇 on 16/3/12.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "Fan_kuiViewController.h"
#import "ideaBackParams.h"
@interface Fan_kuiViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textF;
@property (weak, nonatomic) IBOutlet UIButton *subitButton;

@end

@implementation Fan_kuiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"反馈意见";
    
    [self setNavigationLeft:@"back"];
    
    _textF.textColor = [Uitils colorWithHex:detailContentColor];
    _textF.layer.borderColor = [Uitils colorWithHex: cutofflineColor].CGColor;
    _textF.layer.borderWidth = 0.8;
    
}

- (IBAction)subitAction:(id)sender {
    
    if (_textF.text.length > 0 &&![_textF.text isEqualToString:@"请输入您的宝贵意见或建议"]) {
        
        ideaBackParams *params = [[ideaBackParams alloc]init];
        params.userName = _account.verify.phonenum;
        params.content  = _textF.text;
        
        [KSMNetworkRequest postRequest:KIdeaBack params:params.mj_keyValues success:^(id responseObj) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"%@",dic);
            
            [Uitils alertWithTitle:[dic objectForKey:@"msg"]];
            
            if ([[dic objectForKey:@"success"] integerValue] == 1) {
            
                [self performSelector:@selector(toBack) withObject:self afterDelay:1];    
            }
            
        } failure:^(NSError *error) {
            
            NSLog(@"%@",error);
        }];
        
    }else {
    
        [Uitils alertWithTitle:@"请输入您的宝贵意见或建议"];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {

    if ([_textF.text isEqualToString:@"请输入您的宝贵意见或建议"]) {
        _textF.text = @"";
        _textF.textColor = [UIColor blackColor];
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

    if (_textF.text.length == 0) {
        _textF.text = @"请输入您的宝贵意见或建议";
        _textF.textColor =  [Uitils colorWithHex:detailContentColor];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [_textF resignFirstResponder];
}

- (void)toBack {

    [self.navigationController popViewControllerAnimated:YES];
}

@end

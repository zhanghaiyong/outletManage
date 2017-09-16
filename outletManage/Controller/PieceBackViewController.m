//
//  PieceBackViewController.m
//  text
//
//  Created by ksm on 16/3/11.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "PieceBackViewController.h"
#import "ButtonView.h" 
#import "Fan_kuiViewController.h"
#import "FeedbackForBuyTableVC.h"
@interface PieceBackViewController ()<ButtonViewDeleage>

@end

@implementation PieceBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"意见反馈";
    
    [self setNavigationLeft:@"back"];
    
    [self initSubViews];
    
}

- (void)initSubViews {
    
    NSArray *buttonTitles = @[@"进价反馈",@"反馈意见"];
    NSArray *buttonImages = @[@"jinjiefankui",@"fankui"];
    for (int i = 0; i<2; i++) {
        
        ButtonView *buttonView = [[ButtonView alloc]initWithFrame:CGRectMake(10+i*(SCREEN_WIDTH-20)/2,70,(SCREEN_WIDTH-20)/2,(SCREEN_WIDTH-20)/2) title:buttonTitles[i] image:buttonImages[i]];
        buttonView.backgroundColor = [UIColor whiteColor];
        buttonView.layer.borderColor = [Uitils colorWithHex:cutofflineColor].CGColor;
        buttonView.layer.borderWidth = 0.5;
        buttonView.delegate = self;
        buttonView.tag = 200+i;
        [self.view addSubview:buttonView];
    }
    
}

- (void)buttonViewTap:(NSInteger)aFlag {

    if (aFlag == 200) {
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"feedbackForBuy" bundle:nil];
        FeedbackForBuyTableVC *feedbackForBuy = [storyBoard instantiateViewControllerWithIdentifier:@"FeedbackForBuy"];
        [self.navigationController pushViewController:feedbackForBuy animated:YES];
        
    }else {
    
        Fan_kuiViewController *fankui = [[Fan_kuiViewController alloc]init];
        [self.navigationController pushViewController:fankui animated:YES];
    }
}



@end

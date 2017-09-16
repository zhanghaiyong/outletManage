//
//  NewFeatureViewController.m
//  有车生活
//
//  Created by ksm on 15/11/2.
//  Copyright © 2015年 ksm. All rights reserved.
//

#import "NewFeatureViewController.h"
#import "NewFealtureCell.h"
#import "LoginViewController.h"
@interface NewFeatureViewController ()
{

    UIButton *passButton;
}
@property (nonatomic,weak)UIPageControl *control;

@end

@implementation NewFeatureViewController

static NSString * const reuseIdentifier = @"Cell";

#pragma mark initSubViews-------------------
- (instancetype)init {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    //行间距
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return [super initWithCollectionViewLayout:layout];
}

- (void)setUpPageController {
    
    UIPageControl *control = [[UIPageControl alloc]init];
    control.numberOfPages = 4;
    control.pageIndicatorTintColor = placeholder_Color;
    control.currentPageIndicatorTintColor = [UIColor blackColor];
    
    control.center = CGPointMake(self.view.width * 0.5, self.view.height-20);
    _control = control;
    
    [self.view addSubview:control];
}

#pragma mark - Lifecycle--------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;

        
    passButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, SCREEN_HEIGHT-100*SCREEN_HEIGHT/568, 200, 60)];
    [passButton addTarget:self action:@selector(pass) forControlEvents:UIControlEventTouchUpInside];
    passButton.userInteractionEnabled = NO;
    [self.view addSubview:passButton];
    
    //关闭弹性
//    self.collectionView.bounces = NO;
    //一页一页的翻
    self.collectionView.pagingEnabled = YES;
    //注册cell,默认就会创建这个类
    [self.collectionView registerClass:[NewFealtureCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self setUpPageController];

}


#pragma mark - customAction--------------------
- (void)pass {
    // 进入tabBarVc
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    // 切换根控制器:可以直接把之前的根控制器清空
    [UIApplication sharedApplication].keyWindow.rootViewController = loginVC;
}

#pragma mark UIScrollerView 代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
//    if (scrollView.contentOffset.x>SCREEN_WIDTH*2) {
//        
//        [self pass];
//        
//        [self performSelector:@selector(pass) withObject:self afterDelay:0.8];
//    }
    
    int page = scrollView.contentOffset.x / scrollView.bounds.size.width +0.5;
    
    _control.currentPage = page;
    if (page==3) {
        passButton.userInteractionEnabled = YES;
    }
    
    NSLog(@"%d,,,",page);
}


#pragma mark UICollectionView代理和数据源
//返回组的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

//返回组的cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 4;
}

//返回cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NewFealtureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    //1.首先从缓存池中去cell
    //2.看下当前是否注册cell。如果注册了cell，就会帮你创建cell
    //3.没有注册，报错
    NSString *imageName = [NSString stringWithFormat:@"guide_%ld.jpg",(long)indexPath.row+1];
    
    cell.image = [UIImage imageNamed:imageName];
//    [cell setIndexPath:indexPath cunt:4];
    
    return cell;
}


@end

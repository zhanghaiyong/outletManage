//
//  NoticeListModel.h
//  outletManage
//
//  Created by 张海勇 on 16/3/15.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeListModel : NSObject
@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSString *covertitlePage;
@property (nonatomic,strong)NSString *createTime;
@property (nonatomic,strong)NSString *createUser;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *isPublish;
@property (nonatomic,strong)NSString *istopShow;
@property (nonatomic,strong)NSString *noticeAbstract;
@property (nonatomic,strong)NSString *originalLink;
@property (nonatomic,strong)NSString *publishTime;
@property (nonatomic,strong)NSString *title;
@end

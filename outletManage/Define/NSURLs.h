//
//  NSURLs.h
//  cdcarlife
//
//  Created by ksm on 15/11/26.
//  Copyright © 2015年 ksm. All rights reserved.
//

#ifndef NSURLs_h
#define NSURLs_h
//http://hzzapp.1919.cn:8088/app/
#define  BaseURLString (@"http://hzzapp.1919.cn:8088/app/")
//#define  BaseURLString (@"http://localhost:8080/app/")
//#define  BaseURLString (@"http://10.1.100.6:80/app/")

#endif /* NSURLs_h */

//商品分类
#define KGetGoodsType [BaseURLString stringByAppendingString:@"itemController.do?getGoodsType"]

#define KGetOnlineChannel [BaseURLString stringByAppendingString:@"itemController.do?getOnlineChannel"]

//获取验证码
#define KGetVerifyCode [BaseURLString stringByAppendingString:@"appLoginController.do?verifyCode"]

//登录
#define KLogin [BaseURLString stringByAppendingString:@"appLoginController.do?login"]

//获取首页信息
#define KGetMainData [BaseURLString stringByAppendingString:@"indexController.do?indexMain"]

//意见反馈
#define KIdeaBack [BaseURLString stringByAppendingString:@"feedBackController.do?feedBack"]

//公告列表
#define KNoticeList [BaseURLString stringByAppendingString:@"tAppNoticeController.do?loadNotice"]

//公告详情
#define KNoticeDetail [BaseURLString stringByAppendingString:@"tAppNoticeController.do?noticeContent"]

//门店列表
#define KStoresList [BaseURLString stringByAppendingString:@"storesController.do?storesQuery"]

//搜索商品及库存
#define KItemStockData [BaseURLString stringByAppendingString:@"itemController.do?itemStock"]

//商品及库存详情
#define KStockDetail [BaseURLString stringByAppendingString:@"itemController.do?itemStockDetail"]

//销售统计查询
#define KSaleCheck [BaseURLString stringByAppendingString:@"saleQueryController.do?saleQuery"]


//销售项目查询
#define KSaleSearch ([BaseURLString stringByAppendingString:[NSString stringWithFormat:@"itemController.do?itemSearch2&m=%d",arc4random() % 1000]])

//销售详情
#define KSaleDetail [BaseURLString stringByAppendingString:@"itemController.do?itemSaleDetail"]


//通过条码获取商品信息
#define KScanKnowData [BaseURLString stringByAppendingString:@"itemController.do?queryItemByCitm"]


//采购商品信息反馈
#define KScanBack [BaseURLString stringByAppendingString:@"feedBackController.do?purchaseFb"]


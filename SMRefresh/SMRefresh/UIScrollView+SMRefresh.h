//
//  UIScrollView+CXRrefresh.h
//  SMRefresh
//
//  Created by 朱思明 on 15/11/17.
//  Copyright © 2015年 北京畅想未来科技有限公司 网址：http://cxwlbj.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMRefreshHeaderView.h"
#import "SMRefreshFooterClass.h"

@interface UIScrollView (SMRefresh)


/**
 *  添加一个下拉刷新头部控件
 *
 *  @param callback 回调
 */
- (void)addHeaderRefreshWithRefreshBlock:(RefreshBlock)headerRefreshBlock;

/**
 *  添加一个下拉刷新头部控件
 *
 *  @param target 目标
 *  @param action 回调方法
 */
- (void)addHeaderRefreshWithTarget:(id)target action:(SEL)action;

/**
 *  移除下拉刷新头部控件
 */
- (void)removeHeader;

/**
 *  主动让下拉刷新头部控件进入刷新状态
 */
- (void)headerBeginRefreshing;

/**
 *  让下拉刷新头部控件停止刷新状态(刷新成功)
 */
- (void)headerEndRefreshing;

/**
 *  让下拉刷新头部控件停止刷新状态(刷新失败)
 */
- (void)headerEndRefreshingError;

/**
 *  下拉刷新头部控件的可使用
 */
@property (nonatomic, assign, getter = isHeaderEnabled) BOOL headerEnabled;

/**
 *  是否正在下拉刷新
 */
@property (nonatomic, assign, readonly, getter = isHeaderRefreshing) BOOL headerRefreshing;

#pragma mark - 上拉加载更多

/**
 *  添加一个上拉加载更多尾部控件
 *
 *  @param footerRefreshBlock 回调
 */
- (void)addFooterMoreWithRefreshBlock:(RefreshBlock)footerRefreshBlock;

/**
 *  添加一个上拉加载更多尾部控件
 *
 *  @param target 目标
 *  @param action 回调方法
 */
- (void)addFooterMoreWithTarget:(id)target action:(SEL)action;

/**
 *  移除上拉加载更多尾部控件
 */
- (void)removeFooter;

/**
 *  让上拉加载更多尾部控件停止刷新状态
 */
- (void)footerEndRefreshing;

/**
 *  是否正在上拉加载更多
 */
@property (nonatomic, assign, readonly, getter = isFooterRefreshing) BOOL footerRefreshing;

@end

//
//  UIScrollView+CXRrefresh.m
//  SMRefresh
//
//  Created by 朱思明 on 15/11/17.
//  Copyright © 2015年 北京畅想未来科技有限公司 网址：http://cxwlbj.com. All rights reserved.
//

#import "UIScrollView+SMRefresh.h"
#import <objc/runtime.h>

@implementation UIScrollView (SMRefresh)

static char SMRefreshHeaderViewKey;
static char SMRefreshFooterClassKey;

#pragma mark - 下拉刷新视图的setter/getter
- (void)setHeader:(SMRefreshHeaderView *)header {
    [self willChangeValueForKey:@"SMRefreshHeaderViewKey"];
    objc_setAssociatedObject(self, &SMRefreshHeaderViewKey,
                             header,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"SMRefreshHeaderViewKey"];
}

- (SMRefreshHeaderView *)header {
    return objc_getAssociatedObject(self, &SMRefreshHeaderViewKey);
}

#pragma mark - 懒加载更多类的setter/getter
- (void)setFooter:(SMRefreshFooterClass *)footer {
    [self willChangeValueForKey:@"SMRefreshFooterClassKey"];
    objc_setAssociatedObject(self, &SMRefreshFooterClassKey,
                             footer,
                             OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"SMRefreshFooterClassKey"];
}

- (SMRefreshFooterClass *)footer {
    return objc_getAssociatedObject(self, &SMRefreshFooterClassKey);
}


/**
 *  添加一个下拉刷新头部控件
 *
 *  @param callback 回调
 */
- (void)addHeaderRefreshWithRefreshBlock:(RefreshBlock)headerRefreshBlock
{
    // 1.创建新的header
    if (!self.header) {
        SMRefreshHeaderView *header = [SMRefreshHeaderView header];
        [self addSubview:header];
        self.header = header;
    }
    
    // 2.设置block回调
    self.header.headerRefreshBlock = headerRefreshBlock;
}

/**
 *  添加一个下拉刷新头部控件
 *
 *  @param target 目标
 *  @param action 回调方法
 */
- (void)addHeaderRefreshWithTarget:(id)target action:(SEL)action
{
    // 1.创建新的header
    if (!self.header) {
        SMRefreshHeaderView *header = [SMRefreshHeaderView header];
        [self addSubview:header];
        self.header = header;
    }
    
    // 2.设置block回调
    self.header.target = target;
    self.header.action = action;
}

/**
 *  移除下拉刷新头部控件
 */
- (void)removeHeader
{
    [self.header removeFromSuperview];
    self.header = nil;
}

/**
 *  主动让下拉刷新头部控件进入刷新状态
 */
- (void)headerBeginRefreshing
{
    [self.header beginRefreshing];
}

/**
 *  让下拉刷新头部控件停止刷新状态
 */
- (void)headerEndRefreshing
{
    [self.header endRefreshing];
}

/**
 *  让下拉刷新头部控件停止刷新状态(刷新失败)
 */
- (void)headerEndRefreshingError
{
    [self.header endRefreshingError];
}

/**
 *  下拉刷新头部控件的可见性
 */
- (void)setHeaderEnabled:(BOOL)headerEnabled
{
    self.header.hidden = !headerEnabled;
}

- (BOOL)isHeaderEnabled
{
    return !self.header.isHidden;
}

- (BOOL)isHeaderRefreshing
{
    return self.header.refreshStateType == SMRefreshStateTypeLoading;
}

#pragma mark - 上拉加载更多

/**
 *  添加一个上拉加载更多尾部控件
 *
 *  @param footerRefreshBlock 回调
 */
- (void)addFooterMoreWithRefreshBlock:(RefreshBlock)footerRefreshBlock
{
    // 1.创建新的header
    if (!self.footer) {
        SMRefreshFooterClass *footer = [SMRefreshFooterClass footer];
        footer.scrollView = self;
        self.footer = footer;
    }
    
    // 2.设置block回调
    self.footer.footerRefreshBlock = footerRefreshBlock;
}

/**
 *  添加一个上拉加载更多尾部控件
 *
 *  @param target 目标
 *  @param action 回调方法
 */
- (void)addFooterMoreWithTarget:(id)target action:(SEL)action
{
    // 1.创建新的header
    if (!self.footer) {
        SMRefreshFooterClass *footer = [SMRefreshFooterClass footer];
        footer.scrollView = self;
        self.footer = footer;
    }
    
    // 2.设置block回调
    self.footer.target = target;
    self.footer.action = action;
}

/**
 *  移除上拉加载更多尾部控件
 */
- (void)removeFooter
{
    self.footer = nil;
}

/**
 *  让上拉加载更多尾部控件停止刷新状态
 */
- (void)footerEndRefreshing
{
    [self.footer endMoreRefreshing];
}

/**
 *  是否正在上拉加载更多
 */
- (BOOL)isFooterRefreshing
{
    return self.footer.refreshMoreStateType == SMRefreshFooterStateTypeLoading;
}

@end

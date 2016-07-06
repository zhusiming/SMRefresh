//
//  SMRefresh.h
//  SMRefresh
//
//  Created by 朱思明 on 15/11/19.
//  Copyright © 2015年 北京畅想未来科技有限公司 网址：http://cxwlbj.com. All rights reserved.
//

#import "UIScrollView+SMRefresh.h"
#import "SMRefreshHeaderView.h"
#import "SMRefreshFooterClass.h"
#import "SMRefreshConfigure.h"

/*
 *  版本：1.0
 *  功能：
 *  1.下拉刷新，有动态图片效果
 *  2.上拉加载更多，懒加载效果
 *
 */


/*
 对下拉刷新视图的内容进行配置：
 1.配置刷新图片
 2.配置刷新内容的动态图片：图片名字数组
 3.配置下拉时文本内容
 4.配置提示可以刷新信息
 5.配置正在刷新时文本内容
 6.配置刷新成功文本内容
 7.配置刷新失败时文本内容
 
 默认可以直接在SMRefresh.plist里面进行配置，
 如需要动态设置<SMRefreshConfigure>，可以通过修改该类的属性进行设置
 */


// 使用说明：核心类<UIScrollView+SMRefresh.h> 可以查看该类的属性和方法


/*
    ------------下拉刷新------------
    1.添加一个下拉刷新（block）
    - (void)addHeaderRefreshWithRefreshBlock:(RefreshBlock)headerRefreshBlock;
    2.添加一个下拉刷新（回调方法）
    - (void)addHeaderRefreshWithTarget:(id)target action:(SEL)action;  
    3.移除下拉刷新头部控件
    - (void)removeHeader;
    4.主动让下拉刷新头部控件进入刷新状态
    - (void)headerBeginRefreshing;
    5.让下拉刷新头部控件停止刷新状态(刷新成功)
    - (void)headerEndRefreshing; 
    6.让下拉刷新头部控件停止刷新状态(刷新失败)
    - (void)headerEndRefreshingError;
    7.下拉刷新头部控件的可使用
    @property (nonatomic, assign, getter = isHeaderEnabled) BOOL headerEnabled;
    8.是否正在下拉刷新
    @property (nonatomic, assign, readonly, getter = isHeaderRefreshing) BOOL headerRefreshing;
 
    ------------上拉加载更多------------
    1.添加一个上拉加载更多尾部控件（block）
    - (void)addFooterMoreWithRefreshBlock:(RefreshBlock)footerRefreshBlock;
    2.添加一个上拉加载更多尾部控件(方法回调)
    - (void)addFooterMoreWithTarget:(id)target action:(SEL)action;
    3.移除上拉加载更多尾部控件
    - (void)removeFooter;
    4.让上拉加载更多尾部控件停止刷新状态
    - (void)footerEndRefreshing;
    5.是否正在上拉加载更多
    @property (nonatomic, assign, readonly, getter = isFooterRefreshing) BOOL footerRefreshing;
 */





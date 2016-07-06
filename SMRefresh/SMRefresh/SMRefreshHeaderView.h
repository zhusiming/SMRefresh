//
//  SMRefreshHeaderView.h
//  SMRefresh
//
//  Created by 朱思明 on 15/11/17.
//  Copyright © 2015年 北京畅想未来科技有限公司 网址：http://cxwlbj.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMRefreshConfigure.h"

/*
 *  当前控件加载的状态
 */
typedef enum {
    SMRefreshStateTypeNormal,
    SMRefreshStateTypePulling,
    SMRefreshStateTypeLoading,
    SMRefreshStateTypeWillCloseLoading
} SMRefreshStateType;

/*
 *  刷下block回调类型
 */
typedef void(^RefreshBlock) ();

// 下拉刷新视图的高度
#define headerView_height 64

// 动态图片速度
#define CXLoadingDuration 1.0

// loading图片大小设置
#define CXLoadingImageSize 30

@interface SMRefreshHeaderView : UIView
{
    UIImageView *_loadingImageView;
    UILabel *_loadingLabel;
    // 俯视图的填充高度
    CGFloat _scrollViewContentInset_y;
    // 当前视图内容的配置信息
    SMRefreshConfigure *_refreshCongigure;
    // 加载图片
    UIImage *_loadingImage;
    // 默认图片
    UIImage *_image;
    // 标识当前是有存在观察者
    BOOL _haveKVO;
}

// 当前控件加载的状态
@property (nonatomic, assign) SMRefreshStateType refreshStateType;
// 当前空间所添加的父视图
@property (nonatomic, weak, readonly) UIScrollView *scrollView;
// 触发刷新时候调用的block
@property (nonatomic, copy)  RefreshBlock headerRefreshBlock;
// 设置出发事件调用对象
@property (nonatomic, weak) id target;
// 设置触发事件调用的方法
@property (nonatomic, assign) SEL action;

/*
 *  创建下拉刷新头头视图
 */
+ (SMRefreshHeaderView *)header;

/*
 *  开始执行下拉刷新
 */
- (void)beginRefreshing;

/*
 *  结束执行下拉刷新
 */
- (void)endRefreshing;

/*
 *  结束执行下拉刷新（失败）
 */
- (void)endRefreshingError;

@end

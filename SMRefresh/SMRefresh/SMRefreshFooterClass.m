//
//  SMRefreshFooterClass.m
//  SMRefresh
//
//  Created by 朱思明 on 15/11/19.
//  Copyright © 2015年 北京畅想未来科技有限公司 网址：http://cxwlbj.com. All rights reserved.
//

#import "SMRefreshFooterClass.h"

@implementation SMRefreshFooterClass

#pragma mark - 当前类被销毁
- (void)dealloc
{
    if (_haveKVO == YES) {
        // 移除之前滑动视图的观察者模式
        [_scrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];
        _haveKVO = NO;
    }
}

#pragma mark - 类方法创建对象
/*
 *  创建懒加载更多类
 */
+ (SMRefreshFooterClass *)footer
{
    SMRefreshFooterClass *footer = [[SMRefreshFooterClass alloc] init];
    return footer;
}

#pragma mark - 滑动视图发生变化的时候
- (void)setScrollView:(UIScrollView *)scrollView
{
    if (_scrollView != scrollView) {
        if (_haveKVO == YES) {
            // 移除之前滑动视图的观察者模式
            [_scrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];
            _haveKVO = NO;
        }
        
        // 保存当前滑动视图
        _scrollView = scrollView;
        
        if (_haveKVO == NO) {
            // 为当前的滑动视图添加观察者模式
            [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            _haveKVO = YES;
        }
        
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 如果正在刷新，直接返回
    if (self.refreshMoreStateType == SMRefreshFooterStateTypeLoading) {
        return;
    }
    
    if ([@"contentOffset" isEqualToString:keyPath]) {
        if (_refreshMoreStateType == SMRefreshFooterStateTypeNormal) {
            NSLog(@"1:%f,2%f",_scrollView.contentOffset.y,_scrollView.frame.size.height + _scrollView.contentSize.height - Range_bottom_height);
            if (_scrollView.contentOffset.y >= _scrollView.contentSize.height - _scrollView.frame.size.height - Range_bottom_height) {
                // 开始执行下拉加载更多
                // 02 调用事件
                if (_footerRefreshBlock != nil) {
                    // 01 记录当前状态
                    _refreshMoreStateType = SMRefreshFooterStateTypeLoading;
                    _footerRefreshBlock();
                } else if (_target != nil && _action != nil) {
                    // 01 记录当前状态
                    _refreshMoreStateType = SMRefreshFooterStateTypeLoading;
                    [_target performSelector:_action withObject:nil];
                }
            }
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

/*
 *  结束执行上拉加载更多
 */
- (void)endMoreRefreshing
{
    _refreshMoreStateType = SMRefreshFooterStateTypeNormal;
}
@end

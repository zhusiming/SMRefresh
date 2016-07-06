//
//  SMRefreshHeaderView.m
//  SMRefresh
//
//  Created by 朱思明 on 15/11/17.
//  Copyright © 2015年 北京畅想未来科技有限公司 网址：http://cxwlbj.com. All rights reserved.
//

#import "SMRefreshHeaderView.h"

@implementation SMRefreshHeaderView

#pragma mark - 下拉刷新视图被销毁
- (void)dealloc
{
    if (_haveKVO == YES) {
        [self.superview removeObserver:self forKeyPath:@"contentOffset" context:nil];
        _haveKVO = NO;
    }
}

#pragma mark - 初始化方法
- (instancetype)init
{
    self = [super init];
    if (self) {
        // 1.设置下拉刷新视图的下
        self.frame = CGRectMake(0, -headerView_height, [UIScreen mainScreen].bounds.size.width, headerView_height);
        
        // 2.实例化配置文件信息
        _refreshCongigure = [SMRefreshConfigure shareSMRefreshConfigure];
        
        // 3.初始化子视图
        [self _initViews];
        
        // 4.超出视图部分截取掉
        self.clipsToBounds = YES;
        
        // 5.获取刷新动态图片
        // 默认图片
        _image = SMRefreshImageWithImageName(_refreshCongigure.refreshImageName);
        
        // 动态图片
        NSMutableArray *images = [NSMutableArray array];
        for (NSString *imageName in _refreshCongigure.refreshLoadimageNames) {
            [images addObject:SMRefreshImageWithImageName(imageName)];
        }
        _loadingImage = [UIImage animatedImageWithImages:images duration:CXLoadingDuration];
        
    
    }
    return self;
}

/*
 *  创建下拉刷新头头视图
 */
+ (SMRefreshHeaderView *)header
{
    SMRefreshHeaderView *header = [[SMRefreshHeaderView alloc] init];
    return header;
}

#pragma mark - 视图的父视图放生改变
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // 如果有观察者，移除观察者
    if (_haveKVO == YES) {
        [self.superview removeObserver:self forKeyPath:@"contentOffset" context:nil];
        _haveKVO = NO;
    }

    if (newSuperview) { // 新的父控件
        [newSuperview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        // 标识有KVO
        _haveKVO = YES;
        
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        // 记录UIScrollView最开始的contentInset
        _scrollViewContentInset_y = _scrollView.contentInset.top;
        // 设置当前
        self.frame = CGRectMake(0, -headerView_height, _scrollView.bounds.size.width, headerView_height);
    }
}

/*
 *  创建子视图
 */
- (void)_initViews
{
    // 01 创建下拉加载图片
    _loadingImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - CXLoadingImageSize) / 2.0, 0, CXLoadingImageSize, CXLoadingImageSize)];
    _loadingImageView.image =  _image;
    _loadingImageView.alpha = 0;
    [self addSubview:_loadingImageView];
    
    // 02 创建下拉加载文本视图
    _loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 20)];
    _loadingLabel.textColor = [UIColor grayColor];
    _loadingLabel.font = [UIFont systemFontOfSize:10];
    _loadingLabel.textAlignment = NSTextAlignmentCenter;
    _loadingLabel.text = _refreshCongigure.refreshHeaderTitle;
    _loadingLabel.alpha = 0;
    [self addSubview:_loadingLabel];

    
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 不能跟用户交互就直接返回
    if (!self.userInteractionEnabled || self.hidden) {
            return;
    }
    
    // 如果正在刷新，直接返回
    if (self.refreshStateType == SMRefreshStateTypeLoading) {
        return;
    }
    
    if ([@"contentOffset" isEqualToString:keyPath]) {
        [self adjustStateWithContentOffset];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

/*
 *  滑动视图的可视区域发生变化做成相对应的处理操作
 */
- (void)adjustStateWithContentOffset
{
    // 当前的contentOffset
    CGFloat currentOffsetY = self.scrollView.contentOffset.y;
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = - _scrollViewContentInset_y;
    
    // 如果是向上滚动到看不见头部控件，直接返回
    if (currentOffsetY >= happenOffsetY) return;
    
    if (self.scrollView.isDragging) {
        // 普通 和 即将刷新 的临界点
        CGFloat normal2pullingOffsetY = happenOffsetY - self.frame.size.height;
        if (self.refreshStateType == SMRefreshStateTypeNormal || self.refreshStateType == SMRefreshStateTypePulling) {
            if (currentOffsetY < normal2pullingOffsetY) {
                // 01 下拉过程还达到刷新状态
                // 设置当前状态的样式
                if (self.refreshStateType == SMRefreshStateTypePulling) {
                    _loadingImageView.frame = CGRectMake((self.frame.size.width - CXLoadingImageSize) / 2.0,20 - CXLoadingImageSize + 24, CXLoadingImageSize, CXLoadingImageSize);
                    _loadingImageView.alpha = 1.0;
                    _loadingImageView.image = _loadingImage;
                    
                    _loadingLabel.frame = CGRectMake(0, self.frame.size.height - 24, self.frame.size.width, 20);
                    _loadingLabel.alpha = 1.0;
                    _loadingLabel.text = _refreshCongigure.refreshHeaderAlertTitle;
                } else {
                    // 设置当前状态
                    self.refreshStateType = SMRefreshStateTypePulling;
                }
                
            } else {
                // 02 下拉过程还没达到刷新状态
                // 设置当前状态
                self.refreshStateType = SMRefreshStateTypeNormal;
                // 设置当前视图内容
                CGFloat show_y = MIN(ABS(currentOffsetY - happenOffsetY), headerView_height);
                // 设置视图
                _loadingImageView.frame = CGRectMake((self.frame.size.width - CXLoadingImageSize) / 2.0,20 - CXLoadingImageSize + show_y / headerView_height * 24, CXLoadingImageSize, CXLoadingImageSize);
                _loadingImageView.alpha = show_y / headerView_height;
                _loadingImageView.image = _image;
                // 设置是文本
                _loadingLabel.text = _refreshCongigure.refreshHeaderTitle;
                _loadingLabel.frame = CGRectMake(0, self.frame.size.height - show_y / headerView_height * 24, self.frame.size.width, 20);
                _loadingLabel.alpha = show_y / headerView_height;
            }
            
            
        }
    } else if (self.refreshStateType == SMRefreshStateTypePulling) {
        // 即将刷新 && 手松开
        if (_headerRefreshBlock != nil) {
            // 开始刷新
            self.refreshStateType = SMRefreshStateTypeLoading;
            _loadingLabel.text = _refreshCongigure.refreshHeaderLoadingTitle;
            _headerRefreshBlock();
            [_scrollView setContentInset:UIEdgeInsetsMake(self.frame.size.height + _scrollViewContentInset_y, 0, 0, 0)];
        } else if (_target != nil && _action != nil) {
            // 开始刷新
            self.refreshStateType = SMRefreshStateTypeLoading;
            _loadingLabel.text = _refreshCongigure.refreshHeaderLoadingTitle;
            [_target performSelector:_action withObject:nil];
            [_scrollView setContentInset:UIEdgeInsetsMake(self.frame.size.height + _scrollViewContentInset_y, 0, 0, 0)];
        }  
    }
}

/*
 *  开始执行下拉刷新
 */
- (void)beginRefreshing
{
    if (_refreshStateType == SMRefreshStateTypeNormal) {
        // 动画之前初始化位置
        _loadingImageView.frame = CGRectMake((self.frame.size.width - CXLoadingImageSize) / 2.0, 0, CXLoadingImageSize, CXLoadingImageSize);
        _loadingImageView.image =  _image;
        _loadingImageView.alpha = 0;
        
        _loadingLabel.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 20);
        _loadingLabel.text = _refreshCongigure.refreshHeaderTitle;
        _loadingLabel.alpha = 0;
        
        // 开始设置刷新状态
        self.refreshStateType = SMRefreshStateTypeLoading;
        CGFloat top = -_scrollViewContentInset_y - self.frame.size.height;
        // 执行动画
        [UIView animateWithDuration:.25 animations:^{
            // 1.增加滚动区域
            self.scrollView.contentInset = UIEdgeInsetsMake(-top, 0, 0, 0);
            // 2.设置滚动位置
            _scrollView.contentOffset = CGPointMake(0, top);
            // 3.设置内容视图的动画
            _loadingImageView.frame = CGRectMake((self.frame.size.width - CXLoadingImageSize) / 2.0,20 - CXLoadingImageSize + 24, CXLoadingImageSize, CXLoadingImageSize);
            _loadingImageView.alpha = 1.0;
            
            _loadingLabel.frame = CGRectMake(0, self.frame.size.height - 24, self.frame.size.width, 20);
            _loadingLabel.alpha = 1.0;
        } completion:^(BOOL finished) {
            // 执行loading状态
            _loadingImageView.image = _loadingImage;
            _loadingLabel.text = _refreshCongigure.refreshHeaderLoadingTitle;
            // 调用刷新事件
            if (_headerRefreshBlock != nil) {
                _headerRefreshBlock();
            } else if (_target != nil && _action != nil) {
                [_target performSelector:_action withObject:nil];
            }
        }];
    }
    
}

/*
 *  结束执行下拉刷新（成功）
 */
- (void)endRefreshing
{
    if (_refreshStateType == SMRefreshStateTypeLoading) {
        // 设置为普通状态
        _refreshStateType = SMRefreshStateTypeWillCloseLoading;
        // 设置视图的状态
        _loadingImageView.image =  _image;
        _loadingLabel.text = _refreshCongigure.refreshHeaderSuccessTitle;
        
        CGFloat top = -_scrollViewContentInset_y;
        // 执行动画
        [UIView animateWithDuration:.25 animations:^{
            [UIView setAnimationDelay:1];
            // 1.增加滚动区域
            self.scrollView.contentInset = UIEdgeInsetsMake(-top, 0, 0, 0);
            // 2.设置滚动位置
            _scrollView.contentOffset = CGPointMake(0, top);
            // 3.设置内容视图的动画
            _loadingImageView.frame = CGRectMake((self.frame.size.width - CXLoadingImageSize) / 2.0, 0, CXLoadingImageSize, CXLoadingImageSize);
            _loadingImageView.alpha = 0.0;
            
             _loadingLabel.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 20);
            _loadingLabel.alpha = 0.0;
        } completion:^(BOOL finished) {
            _refreshStateType = SMRefreshStateTypeNormal;
            // 执行loading状态
            _loadingLabel.text = _refreshCongigure.refreshHeaderTitle;
        }];
    }
}

/*
 *  结束执行下拉刷新（失败）
 */
- (void)endRefreshingError
{
    if (_refreshStateType == SMRefreshStateTypeLoading) {
        // 设置为普通状态
        _refreshStateType = SMRefreshStateTypeWillCloseLoading;
        // 设置视图的状态
        _loadingImageView.image =  _image;
        _loadingLabel.text = _refreshCongigure.refreshHeaderErrorTitle;
        
        CGFloat top = -_scrollViewContentInset_y;
        // 执行动画
        [UIView animateWithDuration:.25 animations:^{
            [UIView setAnimationDelay:1];
            // 1.增加滚动区域
            self.scrollView.contentInset = UIEdgeInsetsMake(-top, 0, 0, 0);
            // 2.设置滚动位置
            _scrollView.contentOffset = CGPointMake(0, top);
            // 3.设置内容视图的动画
            _loadingImageView.frame = CGRectMake((self.frame.size.width - CXLoadingImageSize) / 2.0, 0, CXLoadingImageSize, CXLoadingImageSize);
            _loadingImageView.alpha = 0.0;
            
            _loadingLabel.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 20);
            _loadingLabel.alpha = 0.0;
        } completion:^(BOOL finished) {
            _refreshStateType = SMRefreshStateTypeNormal;
            // 执行loading状态
            _loadingLabel.text = _refreshCongigure.refreshHeaderTitle;
        }];
    }
}


@end

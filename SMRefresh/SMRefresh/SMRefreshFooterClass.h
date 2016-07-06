//
//  SMRefreshFooterClass.h
//  SMRefresh
//
//  Created by 朱思明 on 15/11/19.
//  Copyright © 2015年 北京畅想未来科技有限公司 网址：http://cxwlbj.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
 *  距离底部加载师徒的高度
 */
#define Range_bottom_height 40



/*
 *  刷下block回调类型
 */
typedef void(^RefreshBlock) ();


typedef enum {
    SMRefreshFooterStateTypeNormal,
    SMRefreshFooterStateTypeLoading
} SMRefreshFooterStateType;

@interface SMRefreshFooterClass : NSObject
{
    // 标识当前是有存在观察者
    BOOL _haveKVO;
}
// 加载更多状态
@property (nonatomic, assign) SMRefreshFooterStateType refreshMoreStateType;
// 所添加的对象类
@property (nonatomic, weak) UIScrollView *scrollView;
// 触发刷新时候调用的block
@property (nonatomic, copy)  RefreshBlock footerRefreshBlock;
// 设置出发事件调用对象
@property (nonatomic, weak) id target;
// 设置触发事件调用的方法
@property (nonatomic, assign) SEL action;

/*
 *  创建懒加载更多类
 */
+ (SMRefreshFooterClass *)footer;

/*
 *  结束执行上拉加载更多
 */
- (void)endMoreRefreshing;

@end

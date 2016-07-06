//
//  SMRefreshContextConfiger.m
//  SMRefresh
//
//  Created by 朱思明 on 15/11/18.
//  Copyright © 2015年 北京畅想未来科技有限公司 网址：http://cxwlbj.com. All rights reserved.
//

#import "SMRefreshConfigure.h"

static SMRefreshConfigure *configure = nil;

@implementation SMRefreshConfigure

/*
 *  重写初始化方法
 */
- (instancetype)init
{
    self = [super init];
    if (self) {
        // 1.获取默认配置信息
        // 获取文件路径
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SMRefreshConfigure" ofType:@"plist"];
        // 获取文件内容
        NSDictionary *refreshConfigure = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        // 2.把配置信息内容设置为自身默认属性
        _refreshImageName = refreshConfigure[@"SMRefreshImageName"];
        _refreshLoadimageNames = refreshConfigure[@"SMRefreshLoadingImageNames"];
        _refreshHeaderTitle = refreshConfigure[@"SMRefreshHeaderTitle"];
        _refreshHeaderAlertTitle = refreshConfigure[@"SMRefreshHeaderAlertTitle"];
        _refreshHeaderLoadingTitle = refreshConfigure[@"SMRefreshHeaderLoadingTitle"];
        _refreshHeaderSuccessTitle = refreshConfigure[@"SMRefreshHeaderLoadingSuccessTitle"];
        _refreshHeaderErrorTitle = refreshConfigure[@"SMRefreshHeaderLoadingErrorTitle"];
        
    }
    return self;
}

/*
 *  把该类设计成单利模式
 */
+ (SMRefreshConfigure *)shareSMRefreshConfigure
{
    if (configure == nil) {
        @synchronized(self) {
            configure = [[SMRefreshConfigure alloc] init];
        }
    }
    
    return configure;
}
@end

//
//  SMRefreshContextConfiger.h
//  SMRefresh
//
//  Created by 朱思明 on 15/11/18.
//  Copyright © 2015年 北京畅想未来科技有限公司 网址：http://cxwlbj.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 获取SMRefresh.bundle下的图片
//NSString *const SMRefreshBundleName = @"SMRefresh.bundle";
#define SMRefreshBundleName @"SMRefresh.bundle"
#define SMRefreshImagePathWithImageName(imageName) [SMRefreshBundleName stringByAppendingPathComponent:imageName]
#define SMRefreshImageWithImageName(imageName) [UIImage imageNamed:SMRefreshImagePathWithImageName(imageName)]


@interface SMRefreshConfigure : NSObject


//    1.配置刷新图片
@property (nonatomic, strong) NSString *refreshImageName;
//    2.配置刷新内容的动态图片：图片名字数组
@property (nonatomic, strong) NSArray *refreshLoadimageNames;
//    3.配置下拉时文本内容
@property (nonatomic, strong) NSString *refreshHeaderTitle;
//    4.配置提示可以刷新信息
@property (nonatomic, strong) NSString *refreshHeaderAlertTitle;
//    5.配置正在刷新时文本内容
@property (nonatomic, strong) NSString *refreshHeaderLoadingTitle;
//    6.配置刷新成功文本内容
@property (nonatomic, strong) NSString *refreshHeaderSuccessTitle;
//    7.配置刷新失败时文本内容
@property (nonatomic, strong) NSString *refreshHeaderErrorTitle;

/*
 *  把该类设计成单利模式
 */
+ (SMRefreshConfigure *)shareSMRefreshConfigure;
@end

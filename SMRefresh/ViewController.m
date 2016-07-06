//
//  ViewController.m
//  SMRefresh
//
//  Created by 朱思明 on 16/7/6.
//  Copyright © 2016年 朱思明. All rights reserved.
//

#import "ViewController.h"
#import "SMRefresh.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 1.创建表视图
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    // 2.添加下拉刷新事件
    [_tableView addHeaderRefreshWithTarget:self action:@selector(headerRefresh)];
    [_tableView addFooterMoreWithTarget:self action:@selector(footerMore)];
}

// 开始下拉刷新
- (void)headerRefresh
{
    NSLog(@"开始下拉刷新");
    
    [_tableView performSelector:@selector(headerEndRefreshing) withObject:nil afterDelay:4];
}

// 开始伤啦加载更多
- (void)footerMore
{
    NSLog(@"开始上拉加载更多");
    
    [_tableView performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:4];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"row:%ld",indexPath.row];
    return cell;
}

@end

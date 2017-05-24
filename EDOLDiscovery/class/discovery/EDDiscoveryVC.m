//
//  EDDiscovery.m
//  EDOLDiscovery
//
//  Created by song on 16/12/24.
//  Copyright © 2016年 song. All rights reserved.
//

#import "EDDiscoveryVC.h"
#import "EDChosenCell.h"
#import "EDChosenView.h"
#import "EDSearchChosenVC.h"
#import "EDChosenListVC.h"

@interface EDDiscoveryVC ()<UITableViewDataSource,UITableViewDelegate,UIPopoverPresentationControllerDelegate>
{
    UITableView    *_tableView;
    NSMutableArray *_dataSource;
}

@end

@implementation EDDiscoveryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavRightItem];
    [self initTableView];
    [self initTestDatas];
}

- (void)searchBtnClick:(UIButton *)sender{
    EDSearchChosenVC *ctrller = [[EDSearchChosenVC alloc] init];
    ctrller.hidesBottomBarWhenPushed = YES;
    ctrller.navColor = [UIColor whiteColor];
    [self.navigationController pushViewController:ctrller animated:NO];
}

- (void)setNavRightItem
{
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 20, 44, 44)];
    searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    searchBtn.backgroundColor = CLEARCOLOR;
    [searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.titleLabel.font = ICONFONT(20);
    [searchBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [searchBtn setTitleColor:COLOR_333 forState:UIControlStateNormal];
    [searchBtn setTitle:searchIcon forState:UIControlStateNormal];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ControllerView_HEIGHT-49)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self initTableViewHeader];
}

- (void)initTestDatas{
    _dataSource = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 4; i++) {
        EDChosenModel *tmp = [[EDChosenModel alloc] init];
        [_dataSource addObject:tmp];
    }
    
    [_tableView reloadData];
}

- (void)initTableViewHeader{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    CGFloat leftM = (SCREEN_WIDTH-160*2)/3;
    
    for (int i = 0; i < 2; i++) {
        EDChosenView *choseView = [[EDChosenView alloc] initWithFrame:CGRectMake(leftM+160*i+leftM*i, 20, 160, 90)];
        choseView.model = [EDChosenModel new];
        [headerView addSubview:choseView];
    }
    
    UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, headerView.bottom-1, SCREEN_WIDTH, 1)];
    lineImg.backgroundColor = LINECOLOR;
    [headerView addSubview:lineImg];
    
    _tableView.tableHeaderView = headerView;
}

#pragma mark-
#pragma mark- UIPopoverPresentationContrllerDelegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

#pragma mark-
#pragma mark- TestPopOverPresentationCtrlDelegate
- (void)didSelectWithIndex:(NSInteger)index{
    EDSearchChosenVC *ctrller = [[EDSearchChosenVC alloc] init];
    ctrller.hidesBottomBarWhenPushed = YES;
    ctrller.navColor = [UIColor whiteColor];
    [self.navigationController pushViewController:ctrller animated:NO];
}

#pragma mark -----
#pragma mark --------UITableViewDelegate && UITableViewDataSource--------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 96;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"EDChosenCell";

    EDChosenCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ EDChosenCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.model = _dataSource[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    EDChosenListVC *ctrller = [[EDChosenListVC alloc] init];
    ctrller.hidesBottomBarWhenPushed = YES;
    ctrller.hasBackArrow = YES;
    [ctrller setNavTitle:@"校园周刊"];
    [self.navigationController pushViewController:ctrller animated:YES];

}

@end

//
//  EDCollectVC.m
//  EDOLDiscovery
//
//  Created by song on 17/1/7.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDCollectVC.h"
#import "EDMyCollectCell.h"
#import "EDNewsDetailVC.h"
@interface EDCollectVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *contentTable;
    NSMutableArray *dataSource;
    NSInteger     currentPage;
}
@end

@implementation EDCollectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noDataImage     = @"nocollect";
    self.noDataTip       = @"原来你是一个空虚的人~";
    self.loadingTip      = @"开车中~";
    self.showLoadingView = YES;
    
    dataSource = [NSMutableArray new];
    [self setLikeNavTitle:@"收藏"];
    
    
    [self createSubView];
    [self getDatas];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [contentTable.mj_header beginRefreshing];
}

-(void)createSubView
{
    dataSource   = [NSMutableArray new];
    contentTable = [[UITableView alloc]initWithFrame:CGRectMake(0,0, self.view.width, self.view.height) style:UITableViewStylePlain];
    EDDriveManHeaderView *header  = [EDDriveManHeaderView headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    contentTable.mj_header = header;
    contentTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    contentTable.mj_footer.hidden = YES;
    contentTable.backgroundColor = CLEARCOLOR;
    contentTable.separatorStyle  = UITableViewCellSeparatorStyleNone;
    contentTable.delegate   = self;
    contentTable.dataSource = self;
    contentTable.tableFooterView = [UIView new];
    
    [self.view addSubview:contentTable];
}
-(void)refreshData
{
    currentPage = 0;
    [self getDatas];
}

-(void)loadMoreData
{
    currentPage++;
    [self getDatas];
}
-(void)getDatas
{
    NSDictionary *paramDic = @{@"start":@(currentPage * 10)};
    [[HttpRequestManager manager] GET:Aricl_favoritesList parameters:paramDic success:^(NSURLSessionDataTask * task,id responseObject)
     {
         [contentTable.mj_header endRefreshing];
         [contentTable.mj_footer endRefreshing];
         
         NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         
         if ([[dic objectForKey:@"rescode"] integerValue] == 200) {
             NSArray *dataList = [NetDataCommon arrayWithNetData:dic[@"data"]];
             //列表
             if (currentPage == 0) {
                 [dataSource removeAllObjects];
             }
             for (NSDictionary *dic in dataList) {
                 EDMyCollectModel *model = [[EDMyCollectModel alloc]initWithDic:dic];
                 [dataSource addObject:model];
             }
             
             [UIView animateWithDuration:2 animations:^{
                 if (dataSource.count > 0) {
                     self.showNoDataView = NO;
                     self.showLoadingView = NO;
                 }else{
                     self.showNoDataView  = YES;
                     self.showLoadingView = NO;
                     
                     
                 }
             }];

             contentTable.mj_footer.hidden = dataSource.count<10;
             [contentTable reloadData];
             
         }else{
             
             [APPServant makeToast:self.view title:[NetDataCommon stringFromDic:dic forKey:@"msg"] position:74];

         }
     }failure:^(NSURLSessionDataTask * task,NSError *errpr)
     {
         NSLog(@"failuer");
         [contentTable.mj_header endRefreshing];
         [contentTable.mj_footer endRefreshing];
         [APPServant makeToast:KeyWindow title:NETWOTK_ERROR_STATUS position:74];

     }];
}

//删除收藏
-(void)deleteCollect:(EDMyCollectModel *)cmodel
{
    NSDictionary *paramDic = @{
                               @"favoritesId":cmodel.cId
                               };
    [[HttpRequestManager manager] GET:Aricl_favoritesDelete parameters:paramDic success:^(NSURLSessionDataTask * task,id responseObject)
     {
         NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         
         if ([[dic objectForKey:@"rescode"] integerValue] == 200) {
             [APPServant makeToast:self.view title:[NetDataCommon stringFromDic:dic forKey:@"msg"] position:74];
             
             [UIView animateWithDuration:2 animations:^{
                 if (dataSource.count > 0) {
                     self.showNoDataView = NO;
                 }else{
                     self.showNoDataView  = YES;
                     
                 }
             }];
             contentTable.mj_footer.hidden = dataSource.count<10;
         }else{
             
             [APPServant makeToast:self.view title:[NetDataCommon stringFromDic:dic forKey:@"msg"] position:74];
             
         }
     }failure:^(NSURLSessionDataTask * task,NSError *errpr)
     {
         NSLog(@"failuer");
         [APPServant makeToast:KeyWindow title:NETWOTK_ERROR_STATUS position:74];
         
     }];
}

#pragma mark -----
#pragma mark --------UITableViewDelegate && UITableViewDataSource--------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EDMyCollectModel *model = [dataSource objectAtIndex:indexPath.row];
    return model.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"%@ident",NSStringFromClass(self.class)];
    EDMyCollectCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[EDMyCollectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = 0;
    }
    EDMyCollectModel *model = dataSource[indexPath.row];
    cell.model              = model;
    return cell;
}
     
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    EDMyCollectModel *selModel = dataSource[indexPath.row];
    EDNewsDetailVC *nextVC     = [EDNewsDetailVC new];
    nextVC.infoId              = selModel.infoId;
    nextVC.hasBackArrow        = YES;
    nextVC.hasLickNav          = YES;
    nextVC.diffTheme           = YES;

    [self.navigationController pushViewController:nextVC animated:YES];
//    [APPServant presentController:nextVC animate:YES];
    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.row <dataSource.count) {
            EDMyCollectModel *dmodel = [dataSource objectAtIndex:indexPath.row];
            [self deleteCollect:dmodel];
            
            [dataSource removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

        }

        
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


@end

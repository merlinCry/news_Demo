//
//  EDWTFVC.m
//  EDOLDiscovery
//
//  Created by song on 2017/4/26.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDWTFVC.h"
#import "EDHomeFunModel.h"
#import "EDAnimateFooterView.h"
#import "EDHomeFunCell.h"
#import "EDNewsDetailVC.h"
@interface EDWTFVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView           *contentTable;
@property(nonatomic,strong)NSMutableArray        *dataSource;

@end

@implementation EDWTFVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.contentTable];
    [self loadNewData];
}
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}
-(UITableView *)contentTable
{
    if (!_contentTable) {
        _contentTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64 - 49 - 40)];
        _contentTable.backgroundColor = CLEARCOLOR;
        _contentTable.delegate        = self;
        _contentTable.dataSource      = self;
        _contentTable.separatorStyle  = UITableViewCellSeparatorStyleNone;
        
        EDDriveManHeaderView *header  = [EDDriveManHeaderView headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        header.lastUpdatedTimeLabel.hidden = YES;
        _contentTable.mj_header = header;
        
        EDAnimateFooterView *footer = [EDAnimateFooterView footerWithRefreshingTarget:self refreshingAction:@selector(loadOldData)];
        
        _contentTable.mj_footer = footer;
        _contentTable.mj_footer.hidden = YES;
    }
    return _contentTable;
}

//向上翻页请求新的
-(void)loadNewData
{
//    self.pageIndex = 0;
    [self requestData:0];
}
//向下翻页请求旧的
-(void)loadOldData
{
    self.pageIndex++;
    NSInteger start = self.pageIndex * 10;
    [self requestData:start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -----
#pragma mark --------UITableViewDelegate && UITableViewDataSource--------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.dataSource.count) {
        EDHomeFunModel *model = self.dataSource[indexPath.row];
        return  model.cellHeight;
    }
    return   0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"EDHomeFunCellIdentifier";
    EDHomeFunCell *cell = (EDHomeFunCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[EDHomeFunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    if (indexPath.row < self.dataSource.count) {
        EDHomeFunModel *model = self.dataSource[indexPath.row];
        cell.model             = model;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row > self.dataSource.count - 1) {
        return;
    }
    
    EDHomeFunModel *model = self.dataSource[indexPath.row];
    EDNewsDetailVC *nextVC    = [EDNewsDetailVC new];
    nextVC.backArrowColor     = WHITECOLOR;
    nextVC.infoId             = model.infoId;
    nextVC.hasBackArrow       = YES;
    nextVC.diffTheme          = YES;
    nextVC.hidesBottomBarWhenPushed = YES;
    [APPServant pushToController:nextVC animate:YES];
}
-(void)requestData:(NSInteger)start
{
    NSDictionary *paramDic = @{
                               @"channelId":self.cateModel.cateId,
                               @"start":@(start)
                               };
    self.showLoadingView = YES;
    [[HttpRequestManager manager] POST:HOMEAricl_List_URL parameters:paramDic success:^(NSURLSessionDataTask * task,id responseObject)
     {
         self.showLoadingView = NO;
         [_contentTable.mj_header endRefreshing];
         [_contentTable.mj_footer endRefreshing];
         NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         if ([[dic objectForKey:@"code"] integerValue] == 200) {

             NSArray *dataArr = [NetDataCommon arrayWithNetData:dic[@"data"]];
             NSString *msgStr = [NetDataCommon stringFromDic:dic forKey:@"msg"];
             NSMutableArray *pageDataArr = [NSMutableArray new];
             for (NSInteger i = 0; i<dataArr.count; i++) {
                 EDHomeFunModel *model = [[EDHomeFunModel alloc]initWithDic:dataArr[i]];
                 [pageDataArr addObject:model];
             }
             
             if (start == 0) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:ED_Home_DataRefresh object:msgStr];
                 [self.dataSource insertObjects:pageDataArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, pageDataArr.count)]];
                 
             }else{
                 [self.dataSource addObjectsFromArray:pageDataArr];
             }
            
             //去重复
             NSOrderedSet *set = [NSOrderedSet orderedSetWithArray:self.dataSource];
             self.dataSource = [NSMutableArray arrayWithArray:set.array];
             if (self.dataSource.count >= 10) {
                 _contentTable.mj_footer.hidden = NO;
             }
             [self.contentTable reloadData];
             
         }else{
             [APPServant makeToast:KeyWindow title:[NetDataCommon stringFromDic:dic forKey:@"msg"] position:74];
             
         }
         
     }failure:^(NSURLSessionDataTask * task,NSError *errpr)
     {
         [APPServant makeToast:KeyWindow title:NETWOTK_ERROR_STATUS position:74];
         self.showLoadingView = NO;
         [_contentTable.mj_header endRefreshing];
         [_contentTable.mj_footer endRefreshing];
     }];
    
}

@end

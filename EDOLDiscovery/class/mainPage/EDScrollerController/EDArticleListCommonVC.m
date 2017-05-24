//
//  EDArticleListCommonVC.m
//  EDOLDiscovery
//
//  Created by song on 2017/4/26.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDArticleListCommonVC.h"
#import "EDAnimateFooterView.h"
#import "EDHCommonCell.h"
#import "EDNewsDetailVC.h"
@interface EDArticleListCommonVC ()<UITableViewDelegate,UITableViewDataSource,EDHCommonCellDelegate,UIPopoverPresentationControllerDelegate>

@property(nonatomic,strong)UITableView           *contentTable;
@property(nonatomic,strong)NSMutableArray        *dataSource;

@end

@implementation EDArticleListCommonVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor randomColor];
    
    [self.view addSubview:self.contentTable];
    [self loadNewData];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
-(void)configPopMenu
{
    self.popMenuVC.modalPresentationStyle = UIModalPresentationPopover;
    self.popMenuVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionRight;
    self.popMenuVC.popoverPresentationController.backgroundColor = MAINCOLOR;
    self.popMenuVC.popoverPresentationController.delegate = self;
}
-(EDPopMenuVC *)popMenuVC
{
    if (!_popMenuVC) {
        _popMenuVC = [EDPopMenuVC new];
    }
    return _popMenuVC;
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
-(void)requestData:(NSInteger)start
{
    NSDictionary *paramDic = @{
                               @"channelId":_cateModel.cateId,
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
             NSArray *dataArr =[NetDataCommon arrayWithNetData:dic[@"data"]];
             NSString *msgStr = [NetDataCommon stringFromDic:dic forKey:@"msg"];
             
             NSMutableArray *pageDataArr = [NSMutableArray new];
             for (NSInteger i = 0; i<dataArr.count; i++) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:ED_Home_DataRefresh object:msgStr];
                 EDHomeNewsModel *model = [[EDHomeNewsModel alloc]initWithDic:dataArr[i]];
                 [pageDataArr addObject:model];
             }
             if (self.pageIndex == 0) {
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
         NSLog(@"failuer");
         [APPServant makeToast:KeyWindow title:NETWOTK_ERROR_STATUS position:74];
         [_contentTable.mj_header endRefreshing];
         [_contentTable.mj_footer endRefreshing];
         self.showLoadingView = NO;

     }];
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
        EDHomeNewsModel *model = self.dataSource[indexPath.row];
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
    static NSString *cellIdentifier = @"EDHCommonViewIdentifier";
    EDHCommonCell *cell = (EDHCommonCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[EDHCommonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    if (indexPath.row < self.dataSource.count) {
        EDHomeNewsModel *model = self.dataSource[indexPath.row];
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
    EDHCommonCell *cell = (EDHCommonCell *)[tableView cellForRowAtIndexPath:indexPath];
    EDHomeNewsModel *model = self.dataSource[indexPath.row];
    model.hasRead          = YES;
    cell.read              = model.hasRead;
    
    //push到详情
    EDNewsDetailVC *nextVC    = [EDNewsDetailVC new];
    nextVC.backArrowColor     = WHITECOLOR;
    nextVC.infoId             = model.infoId;
    nextVC.hasBackArrow       = YES;
    nextVC.diffTheme          = YES;
    nextVC.hidesBottomBarWhenPushed = YES;
    [APPServant pushToController:nextVC animate:YES];
}

#pragma EDHCommonCellDelegate
//删除一个cell
-(void)edHCommonCell:(EDHCommonCell *)cell didDelete:(EDHomeNewsModel *)model
{
    [self.dataSource removeObject:model];
    NSIndexPath *indexPath = [self.contentTable indexPathForCell:cell];
    [self.contentTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self deleteModel:model];
}
//管理员删除
-(void)edHCommonCell:(EDHCommonCell *)cell didRemove:(EDHomeNewsModel *)model
{
    [self.dataSource removeObject:model];
    NSIndexPath *indexPath = [self.contentTable indexPathForCell:cell];
    [self.contentTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self adminRemoveModel:model];
}
-(void)edHCommonCell:(EDHCommonCell *)cell sourceView:(UIView *)sourceView model:(EDHomeNewsModel *)model
{
    [self configPopMenu];
    self.popMenuVC.popoverPresentationController.sourceView = sourceView;
    self.popMenuVC.popoverPresentationController.sourceRect = sourceView.bounds;
    NSMutableArray *titleArr = [NSMutableArray new];
    [titleArr addObject:@"不喜欢"];
    CGSize menuSize = CGSizeMake(74, 30);
    if ([APPServant isLogin] && [APPServant servant].user.superAdmin) {
        [titleArr addObject:@"删  除"];
         menuSize = CGSizeMake(74, 60);

    }
    self.popMenuVC.dataSource       = titleArr;
    _popMenuVC.preferredContentSize = menuSize;
    __weak __typeof(self)weakSelf = self;
    _popMenuVC.selectBlack = ^(NSInteger index) {
        if (index == 0) {
            [weakSelf edHCommonCell:cell didDelete:model];
        }else if(index == 1){
            [weakSelf edHCommonCell:cell didRemove:model];
        }
    };
    [self presentViewController:self.popMenuVC animated:YES completion:nil];
}

//删除数据源缓存中的model
-(void)deleteModel:(EDHomeNewsModel *)model
{
//    [[EDHomeDataManager shareInstance] removeModel:model withKey:_cateModel.cateId];
    //server统计
    NSDictionary *dicParam = @{@"infoId":model.infoId};
    [[HttpRequestManager manager] GET:EDUnlike_URL parameters:dicParam success:^(NSURLSessionDataTask * task,id responseObject)
     {
         NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         if ([[dic objectForKey:@"rescode"] integerValue] == 200) {
             
         }
     }failure:^(NSURLSessionDataTask * task,NSError *errpr)
     {
         NSLog(@"failuer");
     }];
}
//管理员删除
-(void)adminRemoveModel:(EDHomeNewsModel *)model
{
//    [[EDHomeDataManager shareInstance] removeModel:model withKey:_cateModel.cateId];
    
    NSDictionary *dicParam = @{@"infoId":model.infoId};
    [[HttpRequestManager manager] GET:EDAdminDelete_URL parameters:dicParam success:^(NSURLSessionDataTask * task,id responseObject)
     {
         NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         if ([[dic objectForKey:@"rescode"] integerValue] == 200) {
             
         }
     }failure:^(NSURLSessionDataTask * task,NSError *errpr)
     {
         NSLog(@"failuer");
     }];
}


#pragma mark
#pragma UIPopoverPresentationControllerDelegate
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}

@end

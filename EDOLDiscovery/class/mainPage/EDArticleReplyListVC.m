//
//  EDArticleReplyListVC.m
//  EDOLDiscovery
//
//  Created by song on 2017/4/15.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDArticleReplyListVC.h"
#import "EDArticleReplyCell.h"
#import "EDReplyBar.h"
#import "EDAnimateFooterView.h"
@interface EDArticleReplyListVC ()<UITableViewDelegate,UITableViewDataSource,EDArticleReplyCellDelegate,EDReplyBarDelegate>
{
    EDReplyBar     *bottomBar;
    
    //被回复model
    EDArticleReplyModel *targetModel;
    
    NSInteger  page;
}

@property(nonatomic,strong)UITableView    *contentTable;
@property(nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation EDArticleReplyListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getCommentInfo];
    [self createBottomBar];

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
        CGFloat  top = self.hasLickNav?64:0;
        _contentTable = [[UITableView alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, SCREEN_HEIGHT -  64 - 50) style:UITableViewStyleGrouped];
        _contentTable.delegate        = self;
        _contentTable.dataSource      = self;
        _contentTable.separatorStyle  = UITableViewCellSeparatorStyleNone;
        EDDriveManHeaderView *header  = [EDDriveManHeaderView headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        header.lastUpdatedTimeLabel.hidden = YES;
        _contentTable.mj_header = header;
        
        if (self.dataSource.count >= 10) {
            EDAnimateFooterView *footer = [EDAnimateFooterView footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
            _contentTable.mj_footer = footer;
        }

        [self.view addSubview:_contentTable];
        
        _replyModel.type = ReplyType_Top;
        UIView * headerView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _replyModel.cellHeight)];
        headerView.backgroundColor = WHITECOLOR;
        _contentTable.tableHeaderView = headerView;
        
        EDArticleReplyCell *mainReply = [[EDArticleReplyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headerCellIdentifer"];
        mainReply.frame = CGRectMake(0, 0, headerView.width, _replyModel.cellHeight);
        mainReply.model = _replyModel;
        mainReply.delegate = self;
        [headerView addSubview:mainReply];
    }
    return _contentTable;
}
-(void)createBottomBar
{
    bottomBar= [[EDReplyBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
    bottomBar.bottom   = self.hasLickNav?self.view.height:self.view.height - 64;
    bottomBar.delegate = self;
    [bottomBar listReplyModel];
    [self.view addSubview:bottomBar];
}
-(void)refreshData
{
    page = 0;
    [self getCommentInfo];
}
-(void)loadMore
{
    page++;
    [self getCommentInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取评论信息
-(void)getCommentInfo
{
    self.showLoadingView = YES;
    NSDictionary *paramDic = @{@"parentCommentId":_replyModel.commentId,
                               @"commentType":@"2",
                               @"start":@(page * 10)
                               };
    [[HttpRequestManager manager] GET:EDCommentInfo_URL parameters:paramDic success:^(NSURLSessionDataTask * task,id responseObject)
     {
         self.showLoadingView = NO;
         [self.contentTable.mj_footer endRefreshing];
         [self.contentTable.mj_header endRefreshing];

         NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         NSLog(@"获取成功:%@",dic);
         if ([[dic objectForKey:@"rescode"] integerValue] == 200) {
             NSDictionary *resDic = [NetDataCommon dictionaryFromDic:dic forKey:@"data"];
             if (page == 0) {
                 _replyModel = [[EDArticleReplyModel alloc]initWithDic:resDic];
                 targetModel    = _replyModel;
                 [self.dataSource removeAllObjects];
             }else{
                 NSArray *repList = [NetDataCommon arrayWithNetData:resDic[@"list"]];
                 for (NSDictionary *ndic in repList) {
                     EDArticleReplyModel *nModel = [[EDArticleReplyModel alloc]initWithDic:ndic];
                     [_replyModel.replyList addObject:nModel];
                 }
             }
             //更新dataSource
             [self manageDataSource];
             [self.contentTable reloadData];
         }
     }failure:^(NSURLSessionDataTask * task,NSError *errpr)
     {
         self.showLoadingView = NO;
         [self.contentTable.mj_footer endRefreshing];
         [self.contentTable.mj_header endRefreshing];
         NSLog(@"failuer");
     }];
}

-(void)manageDataSource
{
    [self.dataSource addObjectsFromArray:_replyModel.replyList];
    //遍历每个子评论的评论加入dataSource
    for (EDArticleReplyModel *model in _replyModel.replyList) {
        [self.dataSource addObjectsFromArray:[model listSubReply]];
    }
    
}

#pragma mark -----
#pragma mark --------UITableViewDelegate && UITableViewDataSource--------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EDArticleReplyModel *model = self.dataSource[indexPath.row];
    return model.cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.dataSource.count > 0) {
        return 40;
        
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    headerView.backgroundColor = View_BACKGROUND_COLOR;
    
    UILabel *tipLabel = LABEL(FONT(12), COLOR_999);
    tipLabel.frame = CGRectMake(0, 10, SCREEN_WIDTH, 30);
    tipLabel.backgroundColor = WHITECOLOR;
    tipLabel.text  =  @"  全部回复";
    [headerView addSubview:tipLabel];
    
    if ([APPServant servant].nightShift) {
        tipLabel.backgroundColor   = UIColorFromRGB(0x262626);
        
    }
    return headerView;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"EDArticleReplyCellIdent";
    EDArticleReplyCell *cell = (EDArticleReplyCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[EDArticleReplyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    
    EDArticleReplyModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //回复子评论
    EDArticleReplyModel *model = self.dataSource[indexPath.row];
    [self replyComment:model];
}

#pragma mark
#pragma mark EDArticleReplyCellDelegate
-(void)replyComment:(EDArticleReplyModel *)model
{
    targetModel = model;
    //弹出回复框
    [bottomBar popReply];
}


#pragma mark
#pragma mark EDReplyBarDelegate
-(void)edReplyBar:(EDReplyBar *)view addcomment:(NSString *)commentText
{
    if (ISEmpty(commentText)) {
        return;
    }
    NSString *commentTextBase64 = [EDOLTool base64EncodeString:commentText];
    NSDictionary *paramDic = @{
                               @"infoId":targetModel.infoId,
                               @"commentType":@(2),
                               @"content":commentTextBase64,
                               @"parentCommentId":targetModel.commentId,
                               @"parentUserId":targetModel.userId,
                               };
    [EDHud show];
    [[HttpRequestManager manager] GET:EDListAddComment parameters:paramDic success:^(NSURLSessionDataTask * task,id responseObject)
     {
         [EDHud dismiss];
         NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         NSLog(@"获取成功:%@",dic);
         if ([[dic objectForKey:@"code"] integerValue] == 200) {
             //添加成功 insert到0一个    刷新列表
             NSDictionary *dataDic = [NetDataCommon dictionaryFromDic:dic forKey:@"data"];
             EDArticleReplyModel *model = [[EDArticleReplyModel alloc]initWithDic:dataDic];
             if (![targetModel.commentId isEqualToString:_replyModel.commentId]) {
                 model.replyForName         = targetModel.nickname;
             }
             [targetModel.replyList addObject:model];
             [self.dataSource insertObject:model atIndex:0];
             [self.contentTable reloadData];
             //滚动到第一个评论
             [self.contentTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
             
         }else{
             NSString *msg = [NetDataCommon stringFromDic:dic forKey:@"msg"];
             [APPServant makeToast:self.view title:msg position:50];
         }
         [self resetReplyModel];
     }failure:^(NSURLSessionDataTask * task,NSError *errpr)
     {
         [EDHud dismiss];
         NSLog(@"failuer");
         [self resetReplyModel];
     }];
}

-(void)resetReplyModel
{
    targetModel = _replyModel;
}

@end

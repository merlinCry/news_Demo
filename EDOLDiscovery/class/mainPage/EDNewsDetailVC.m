//
//  EDNewsDetailVC.m
//  EDOLDiscovery
//
//  Created by song on 16/12/27.
//  Copyright © 2016年 song. All rights reserved.
//

#import "EDNewsDetailVC.h"
#import "HTMLConstructor.h"
#import "EDPhotoBrower.h"
#import "NSData+Base64Additions.h"
#import "EDReplyBar.h"
#import "EDArticleReplyCell.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImageView+WebCache.h"
#import "APPShareManager.h"
#import "WXApi.h"
#import "EDArticleReplyListVC.h"
#import "VideoInfo.h"
#import <TencentOpenAPI/QQApiInterface.h>

typedef  NS_ENUM(NSInteger,BrowseStyle) {
    BrowseStyleArtical = 0,//默认浏览详情
    BrowseStyleReply,
};
@interface EDNewsDetailVC ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource,EDReplyBarDelegate,EDArticleReplyCellDelegate>
{
    UITableView *contentTable;
    NSMutableArray *photoArr;
    NSMutableArray *videoArr;
    EDPhotoBrower  *brower;
    EDReplyBar     *bottomBar;
    NSInteger      currentIndex;
    
    NSInteger      totalCount;
    BOOL           hasCollected;
    NSMutableArray *commontDataSource;
    
    EDHomeNewsModel *newsDetailModel;
    
    //暂时直跳一次
    BOOL   canGoForward;
    
    UIView *noCommentView;
    
    //上次文章内容浏览的位置(浏览详情模式下有效)
    CGFloat  lastScrollPosition;
    
    //浏览模式
    BrowseStyle  lookStyle;
    
}

@end

@implementation EDNewsDetailVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    canGoForward = YES;
    commontDataSource = [NSMutableArray new];
    self.showLoadingView = YES;
    self.loadingTip      = @"心急看不了好姿势";

    [self createTableView];
    [self addHeaderWebView];
    [self getDetailData];
    [self createBottomBar];
    brower = [[EDPhotoBrower alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChange) name:ED_UserInfo_Change object:nil];
    [self setNavTitle:@"校园老司机"];
    [self checkTheme];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController  resetBackground];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.needFullScreenGes = YES;

}

-(void)createBottomBar
{
    bottomBar= [[EDReplyBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
    bottomBar.bottom = self.hasLickNav?self.view.height:self.view.height - 64;
    bottomBar.delegate = self;
    [self.view addSubview:bottomBar];
}

-(void)createTableView
{
    CGFloat  top = self.hasLickNav?64:0;
    contentTable = [[UITableView alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, SCREEN_HEIGHT -  64 - 50) style:UITableViewStyleGrouped];
    contentTable.delegate   = self;
    contentTable.dataSource = self;
    contentTable.alpha      = 0;
    contentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    EDDriveManHeaderView *header  = [EDDriveManHeaderView headerWithRefreshingTarget:self refreshingAction:@selector(refreshComment)];
    header.lastUpdatedTimeLabel.hidden = YES;
    contentTable.mj_header = header;
    
    contentTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    contentTable.sectionFooterHeight = 0;
    contentTable.sectionHeaderHeight = 0;
    contentTable.backgroundColor     = CLEARCOLOR;
    
    noCommentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    contentTable.tableFooterView = noCommentView;
    UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    paddingView.backgroundColor = View_BACKGROUND_COLOR;
    if ([APPServant servant].nightShift) {
        paddingView.backgroundColor = BLACKCOLOR;
    }
    [noCommentView addSubview:paddingView];
    

    
    UIImageView *shafa = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, 200, 200)];
    shafa.centerX = SCREEN_WIDTH/2;
    shafa.backgroundColor = CLEARCOLOR;
    shafa.image = [UIImage imageNamed:@"nocomment"];
    [noCommentView addSubview:shafa];
    UILabel *noCommentTip = LABEL(FONT(16), COLOR_666);
    noCommentTip.frame    = CGRectMake(0, shafa.bottom + 20, SCREEN_WIDTH, 16);
    noCommentTip.textAlignment = NSTextAlignmentCenter;
    noCommentTip.text = @"趁还没人评论，赶紧抢车位~";
    [noCommentView addSubview:noCommentTip];
    
    UILabel *tipLabel = LABEL(FONT(12), COLOR_999);
    tipLabel.frame = CGRectMake(0, 20, 100, 14);
    tipLabel.text  =  @"  最新评论";
    [noCommentView addSubview:tipLabel];
    
    
    [self.view addSubview:contentTable];
    
}

-(void)refreshComment
{
    currentIndex = 0;
    [self getCommentList];
}
-(void)loadMore
{
    currentIndex++;
    [self getCommentList];
}
-(void)addHeaderWebView
{
    _webView =[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 200)];
    _webView.scrollView.scrollEnabled                = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.scalesPageToFit = YES;
    _webView.delegate        = self;
    //监听webview内容高度
    [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];

    
    NSString *userAgent=[[[UIWebView new] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"] stringByAppendingString:@"com.ndol.discovery.webkit"];
    NSDictionary *infoAgentDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",userAgent],@"UserAgent",nil];
    [USER_DEFAULT registerDefaults:infoAgentDic];
    contentTable.tableHeaderView = _webView;
    
//    [self.view addSubview:_webView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)removeCaches
//{
//    [[NSURLCache  sharedURLCache ]removeAllCachedResponses];
//    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
//        if([[cookie domain] isEqualToString:URLADDRESS]) {
//            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
//        }
//    }
//}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *key = request.mainDocumentURL.relativePath;
    NSString *requestString = [request.mainDocumentURL.query stringByRemovingPercentEncoding];
    NSDictionary *paramDic = [EDOLTool paramterInQueryString:requestString];
    
    if([key containsString:@"browse_img"]){
        //浏览图片
        [self browseAllImage:paramDic];
        return NO;
    }
    //不支持内部跳转
    if (canGoForward) {
        canGoForward = NO;
        return YES;
    }
    return NO;
}
 
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.showLoadingView = NO;
   [UIView animateWithDuration:0.25 animations:^{
       contentTable.alpha = 1;
       
   }];
    
    //set图片资源
    for (NSInteger i =0;i< photoArr.count;i++) {
        ImageInfo *img   = photoArr[i];
        NSString *aId = [img.ref substringWithRange:NSMakeRange(4, img.ref.length -7)];
        NSString *javascript = [NSString stringWithFormat:
                                @"reSetImage('%@','%@');",aId,img.img];
        [_webView stringByEvaluatingJavaScriptFromString:javascript];
        
    }
    //set视频资源
    for (NSInteger i = 0; videoArr.count; i++) {
        VideoInfo *aVideo = videoArr[i];
        NSString *aId = [aVideo.ref substringWithRange:NSMakeRange(4, aVideo.ref.length -7)];
        NSString *javascript = [NSString stringWithFormat:
                                @"reSetImage('%@','%@');",aId,aVideo.url_mp4];
        [_webView stringByEvaluatingJavaScriptFromString:javascript];
    }
    
//    for (NSInteger i =0;i< photoArr.count;i++) {
//        ImageInfo *img   = photoArr[i];
//        img.index        = i;
//        img.cachedImage  = [UIImage imageWithData:[self getImageData:i]];
//        
//        FLAnimatedImageView *tmpBtn = [[FLAnimatedImageView alloc]initWithFrame:[self getImageFrame:i]];
//        tmpBtn.contentMode = UIViewContentModeScaleAspectFit;
//        tmpBtn.tag       = i+99;
//        [tmpBtn sd_setImageWithURL:[NSURL URLWithString:img.img]];
//        tmpBtn.backgroundColor = CLEARCOLOR;
//        UITapGestureRecognizer *imageTapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(testBtnAction:)];
//        [tmpBtn addGestureRecognizer:imageTapGes];
//        tmpBtn.userInteractionEnabled = YES;
//        [_webView addSubview:tmpBtn];
//        
//    }
//    for (NSInteger i =0;i< photoArr.count;i++) {
//        ImageInfo *img   = photoArr[i];
//        [EDOLTool  downLoadImage:img.img complate:^(NSString *source, UIImage *image) {
//            dispatch_sync(dispatch_get_main_queue(), ^{
//                
//                NSString *javascript = [NSString stringWithFormat:
//                                        @"reSetImage('%@','%@');",img.ref,source];
//                [_webView stringByEvaluatingJavaScriptFromString:javascript];
//
//            });
//            
//        }];
//        
//    }

}

//监听webView高度变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGFloat webViewHeight = [self.webView.scrollView contentSize].height;
        self.webView.height = webViewHeight;
//        if (SYS_VERSION < 10.0) {
            //ios10以前这里要重新赋值一下，不然table的header高度不会改变。
            contentTable.tableHeaderView = _webView;
//        }
        [contentTable reloadData];
    }
}


//获取文章
-(void)getDetailData
{
    NSDictionary *paramDic = @{@"infoId":_infoId};
    [[HttpRequestManager manager] GET:HOMEAricl_Detail_URL parameters:paramDic success:^(NSURLSessionDataTask * task,id responseObject)
     {
//         self.showLoadingView = NO;
         NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         NSLog(@"获取成功:%@",dic);
         if ([[dic objectForKey:@"code"] integerValue] == 200) {
             NSDictionary *dataDic = [NetDataCommon dictionaryFromDic:dic forKey:@"data"];
             newsDetailModel = [[EDHomeNewsModel alloc]initWithDic:dataDic];
             [self handleDetailData:newsDetailModel];
             //获取评论
             [self getCommentList];
         }else{
             NSString *msg = [NetDataCommon stringFromDic:dic forKey:@"msg"];
             [APPServant makeToast:self.view title:msg position:50];
             
         }
     }failure:^(NSURLSessionDataTask * task,NSError *errpr)
     {
         NSLog(@"failuer");
     }];
}

//获取评论列表
-(void)getCommentList
{
    NSDictionary *paramDic = @{@"infoId":_infoId,
                               @"commentType":@(1),
                               @"start":@(currentIndex * 10)
                               };
    [[HttpRequestManager manager] GET:EDListComment parameters:paramDic success:^(NSURLSessionDataTask * task,id responseObject)
     {
         [contentTable.mj_footer endRefreshing];
         [contentTable.mj_header endRefreshing];

         NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         NSLog(@"获取成功:%@",dic);
         if ([[dic objectForKey:@"code"] integerValue] == 200) {
             NSDictionary *dataDic = [NetDataCommon dictionaryFromDic:dic forKey:@"data"];
             NSArray *list = [NetDataCommon arrayWithNetData:dataDic[@"list"]];
             totalCount    = [[NetDataCommon stringFromDic:dataDic forKey:@"infoCommentCount"] integerValue];
             hasCollected    = [[NetDataCommon stringFromDic:dataDic forKey:@"collected"] boolValue];

             if (currentIndex == 0) {
                 [commontDataSource removeAllObjects];
             }
             for (NSDictionary *modelDic in list) {
                 EDArticleReplyModel *model = [[EDArticleReplyModel alloc]initWithDic:modelDic];
                 model.infoId = _infoId;
                 model.type   = ReplyType_Group;
                 [commontDataSource addObject:model];
             }
             bottomBar.commentCount = totalCount;
             bottomBar.hasCollected = hasCollected;
            
             contentTable.mj_footer.hidden = commontDataSource.count < 10;
             
             if (commontDataSource.count >0) {
                 contentTable.tableFooterView = [UIView new];
             }
             [contentTable reloadData];
         }else{
             NSString *msg = [NetDataCommon stringFromDic:dic forKey:@"msg"];
             [APPServant makeToast:self.view title:msg position:50];
         }
     }failure:^(NSURLSessionDataTask * task,NSError *errpr)
     {
         NSLog(@"failuer");
     }];
}


//提交评论
-(void)addComment:(NSString *)commentText
{
    if (ISEmpty(commentText)) {
        return;
        
    }
    NSString *commentTextBase64 = [EDOLTool base64EncodeString:commentText];
    NSDictionary *paramDic = @{@"infoId":_infoId,
                               @"commentType":@(1),
                               @"content":commentTextBase64
                               };
    [EDHud show];
    [[HttpRequestManager manager] GET:EDListAddComment parameters:paramDic success:^(NSURLSessionDataTask * task,id responseObject)
     {
         [EDHud dismiss];
         NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         NSLog(@"获取成功:%@",dic);
         if ([[dic objectForKey:@"code"] integerValue] == 200) {
             //添加成功 insert0一个    刷新列表
             NSDictionary *dataDic = [NetDataCommon dictionaryFromDic:dic forKey:@"data"];
             EDArticleReplyModel *model = [[EDArticleReplyModel alloc]initWithDic:dataDic];
             model.infoId = _infoId;
             [commontDataSource insertObject:model atIndex:0];
             
             contentTable.tableFooterView = [UIView new];
             [contentTable reloadData];
             totalCount++;
             bottomBar.commentCount = totalCount;
             
             //滚动到第一个评论
             [contentTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//             [self refreshComment];
             
         }else{
             NSString *msg = [NetDataCommon stringFromDic:dic forKey:@"msg"];
             [APPServant makeToast:self.view title:msg position:50];
         }
     }failure:^(NSURLSessionDataTask * task,NSError *errpr)
     {
         [EDHud dismiss];
         NSLog(@"failuer");
     }];
}
-(void)handleDetailData:(EDHomeNewsModel *)newsDetail
{
    if (!photoArr) {
        photoArr = [NSMutableArray new];
    }
    [photoArr removeAllObjects];
    
    if (NOTEmpty(newsDetail.imageList)) {
        for (ImageInfo *aphoto in newsDetail.imageList) {
            [photoArr addObject:aphoto];
        }
    }
    
    if (NOTEmpty(newsDetail.videoList)) {
        if (!videoArr) {
            videoArr = [NSMutableArray new];
        }
        [videoArr removeAllObjects];
        [videoArr addObjectsFromArray:newsDetail.videoList];
    }
    
    NSString *htmlStr = [HTMLConstructor htmlForNewsDetail:newsDetail];
    if (NOTEmpty(htmlStr)) {
        [self.webView loadHTMLString:htmlStr baseURL:nil];
    }
}



#pragma mark -----
#pragma mark --------UITableViewDelegate && UITableViewDataSource--------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EDArticleReplyModel *model = commontDataSource[indexPath.row];
    return model.cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return commontDataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (commontDataSource.count > 0) {
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
    tipLabel.text  =  @"  最新评论";
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
    
    EDArticleReplyModel *model = commontDataSource[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


-(void)dealloc
{
    [_webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}


//浏览所有图片
-(void)browseAllImage:(NSDictionary *)paramDic
{
    NSInteger index      =  [paramDic[@"index"] integerValue];
//    NSString *rectString = [NetDataCommon stringFromDic:paramDic forKey:@"frame"];
//    CGRect   imgFrame       = CGRectFromString(rectString);
    CGRect   imgFrame       = [self getImageFrame:index];

    UIImageView *tmpView    = [[UIImageView alloc]initWithFrame:imgFrame];
    

    tmpView.image    = [UIImage imageWithData:[self getImageData:index]];
    tmpView.backgroundColor = CLEARCOLOR;
    
    if (!brower) {
        brower = [[EDPhotoBrower alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    brower.photoArr  = [NSArray arrayWithArray:photoArr];
    brower.startView = tmpView;
    [brower show:_webView imgIndex:index];

}

//从webview上获取图片
-(NSData *)getImageData:(NSInteger)index
{
    NSString *javascript = [NSString stringWithFormat:
                            @"getImageData(%ld);", (long)index];
    NSString *stringData = [_webView stringByEvaluatingJavaScriptFromString:javascript];
    if (stringData.length < 22) {
        return [NSData new];
    }
    stringData = [stringData substringFromIndex:22]; // strip the string "data:image/png:base64,"
    NSData *imgdata  = [NSData decodeWebSafeBase64ForString:stringData];
    return imgdata;
}
//获取webView上面图片的frame
-(CGRect)getImageFrame:(NSInteger)index
{
    NSString *javascript = [NSString stringWithFormat:
                            @"getImageRect(%ld);", (long)index];
    NSString *stringFrame = [_webView stringByEvaluatingJavaScriptFromString:javascript];
    CGRect   imgFrame      = CGRectFromString(stringFrame);

    return imgFrame;
}


-(void)testBtnAction:(UITapGestureRecognizer *)sender
{
    NSInteger index  = sender.view.tag - 99;
    UIImageView *tmpView    = [[UIImageView alloc]initWithFrame:[self getImageFrame:index]];
    tmpView.image    = [UIImage imageWithData:[self getImageData:index]];
    tmpView.backgroundColor = CLEARCOLOR;
    
    brower.photoArr  = [NSArray arrayWithArray:photoArr];
    brower.startView = tmpView;
    [brower show:_webView imgIndex:(sender.view.tag - 99)];
}


#pragma mark  EDReplyBarDelegate
//新增评论
-(void)edReplyBar:(EDReplyBar *)view addcomment:(NSString *)commentText
{
    [self addComment:commentText];
}
//分享
-(void)edReplyBarShare:(EDReplyBar *)view
{
    NSMutableArray *platArr = @[].mutableCopy;
    if ([WXApi isWXAppInstalled]) {
        [platArr addObject:@(UMSocialPlatformType_WechatSession)];
        [platArr addObject:@(UMSocialPlatformType_WechatTimeLine)];
    }
    if ([QQApiInterface isQQInstalled]) {
        [platArr addObject:@(UMSocialPlatformType_QQ)];
        [platArr addObject:@(UMSocialPlatformType_Qzone)];
    }
    
    [APPShareManager setSharePlatForms:platArr];
    
    APPShareObject *shareObj = [APPShareObject new];
    //标题
    shareObj.shareTitle = newsDetailModel.title;
    //内容
    shareObj.shareDesc  = @"快来看";
    
    NSRange  startRange = [newsDetailModel.content rangeOfString:@"<p>"];
    NSRange  endRange   = [newsDetailModel.content rangeOfString:@"</p>"];
    if (startRange.location != NSNotFound  && endRange.location != NSNotFound) {
        NSRange  range      = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location- startRange.length);
        NSString *desc = [newsDetailModel.content substringWithRange:range];
        if (NOTEmpty(desc)) {
            if (desc.length > 30) {
                desc = [desc substringToIndex:30];
            }
            shareObj.shareDesc  = desc;
        }

    }
    
    shareObj.shareImage = [UIImage imageNamed:@"driving00000"];
    if (newsDetailModel.imageList.count > 0) {
        ImageInfo *imgInfo  = newsDetailModel.imageList[0];
        NSString *imgLink   = imgInfo.img;
        if ([imgLink rangeOfString:@"https"].location != NSNotFound) {
            shareObj.shareImage = imgLink;
        }
    }
    
//    NSString *link      = [NSString stringWithFormat:@"%@?userId=%@&channelId=%@&infoId=%@",EDShare_URL,USERID,newsDetailModel.channelId,_infoId];
    NSString *link      = [NSString stringWithFormat:@"%@?infoId=%@",EDShare_URL,_infoId];
    shareObj.shareLink  = link;
    [APPShareManager showShareMenuInWindow:shareObj];
}
-(void)edReplyBar:(EDReplyBar *)view jumpToComment:(BOOL)jumped
{
    if (jumped) {
        if (NOTEmpty(commontDataSource)) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [contentTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }else{
            [contentTable scrollRectToVisible:CGRectMake(0, contentTable.contentSize.height - 100, SCREEN_WIDTH, 100) animated:YES];

        }

//        lookStyle = BrowseStyleReply;
    }else{
//       [UIView animateWithDuration:0.26 animations:^{
//           contentTable.contentOffset = CGPointMake(0, 0);
//
//       }];
        [contentTable scrollRectToVisible:CGRectMake(0, lastScrollPosition, SCREEN_WIDTH, 100) animated:YES];
//        lookStyle = BrowseStyleArtical;

    }
}
//收藏
-(void)edReplyBarCollect:(EDReplyBar *)view
{
    if (ISEmpty(newsDetailModel)) {
        return;
    }
    NSDictionary *paramDic = @{
                               @"infoId":newsDetailModel.infoId,
                               @"channelId":newsDetailModel.channelId
                               };
    [[HttpRequestManager manager] GET:Aricl_favoritesAdd parameters:paramDic success:^(NSURLSessionDataTask * task,id responseObject)
     {
         NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         NSLog(@"获取成功:%@",dic);
         if ([[dic objectForKey:@"code"] integerValue] == 200) {
             //收藏成功
             
         }else{
             NSString *msg = [NetDataCommon stringFromDic:dic forKey:@"msg"];
             [APPServant makeToast:self.view title:msg position:50];
         }
     }failure:^(NSURLSessionDataTask * task,NSError *errpr)
     {
         NSLog(@"failuer");
     }];
}
//取消收藏(直接调删除收藏接口)
-(void)edReplyBarCancelCollect:(EDReplyBar *)view
{
    if (ISEmpty(newsDetailModel)) {
        return;
    }
    NSDictionary *paramDic = @{
                               @"infoId":newsDetailModel.infoId
                               };
    [[HttpRequestManager manager] GET:Aricl_favoritesCancel parameters:paramDic success:^(NSURLSessionDataTask * task,id responseObject)
     {
         NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         
         if ([[dic objectForKey:@"rescode"] integerValue] == 200) {
//             [APPServant makeToast:self.view title:[NetDataCommon stringFromDic:dic forKey:@"msg"] position:74];
             
         }
     }failure:^(NSURLSessionDataTask * task,NSError *errpr)
     {
         NSLog(@"failuer");
         [APPServant makeToast:KeyWindow title:NETWOTK_ERROR_STATUS position:74];
         
     }];
}

-(void)loginStatusChange
{
    [self refreshComment];
}


#pragma mark
#pragma scrollviewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //判断评论cell是否显示出来
    if (scrollView.contentOffset.y + contentTable.height >= _webView.height) {
        [bottomBar setBtnToReplyStyle:YES];
        lookStyle = BrowseStyleReply;
    }else{
        [bottomBar setBtnToReplyStyle:NO];
        lookStyle = BrowseStyleArtical;

    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (lookStyle == BrowseStyleArtical) {
        lastScrollPosition = scrollView.contentOffset.y;
    }

}

-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    lastScrollPosition = 0;
    [bottomBar setBtnToReplyStyle:NO];

}

#pragma mark
#pragma mark EDArticleReplyCellDelegate
-(void)replyComment:(EDArticleReplyModel *)model
{
    //跳转评论详情
    EDArticleReplyListVC *replyList = [EDArticleReplyListVC new];
    replyList.replyModel = model;
    replyList.hasBackArrow    = YES;
    replyList.hasLickNav      = self.hasLickNav;
    replyList.diffTheme       = YES;
//    [APPServant pushToController:replyList animate:YES];
    [self.navigationController pushViewController:replyList animated:YES];
}

-(void)checkTheme
{
    if ([APPServant servant].nightShift) {
        noCommentView.backgroundColor = UIColorFromRGB(0x262626);
    }else{
        noCommentView.backgroundColor =WHITECOLOR;

    }
    
}
@end

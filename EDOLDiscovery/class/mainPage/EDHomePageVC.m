//
//  EDHomePageVC.m
//  EDOLDiscovery
//
//  Created by song on 16/12/24.
//  Copyright © 2016年 song. All rights reserved.
//

#import "EDHomePageVC.h"
#import "EDNewsDetailVC.h"
#import "EDHomePageCell.h"
#import "EDScrollMenu.h"
#import "EDLoginViewController.h"
#import "EDRegistViewController.h"
#import "PersonalCenterVC.h"
#import "EDAllCateGoryVC.h"
#import "EDHud.h"

static CGFloat const MenuHeight = 40;
@interface EDHomePageVC ()<UICollectionViewDelegate,UICollectionViewDataSource,EDHomePageCellDelegate,EDScrollMenuDelegate,EDUserCenterMenuDelegate>
{
    UICollectionView *contentView;
    NSMutableArray   *cateMenuArr;
    EDScrollMenu     *topMenu;
    CGFloat  preOffsetX;
    
    //重新加载按钮
    UIButton *reloadBtn;
    
    UIView  *tipView;
    UILabel *tipLabel;
}

@end

@implementation EDHomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self configNav];
    cateMenuArr = [NSMutableArray new];
    
    [self createCollection];
    [self createTipView];
    [self createMenu];

    //先显示缓存数据
    [self showDiskCacheData];
    
    [self refreshCategorys];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChange) name:ED_UserInfo_Change object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataHaveNew:) name:ED_Home_DataRefresh object:nil];
    
    [self createReloadBtn];

}
-(void)showDiskCacheData
{
    NSArray *cacheCateArr = [EDHomeDataManager shareInstance].cateDiskCache;
    if (NOTEmpty(cacheCateArr)) {
        cateMenuArr =  [NSMutableArray arrayWithArray:cacheCateArr];
        topMenu.dataSource = cateMenuArr;
        [contentView reloadData];
    }
}

//无网情况下，手动重载
-(void)createReloadBtn
{
    reloadBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2 - 30, 100, 44)];
    reloadBtn.centerX = SCREEN_WIDTH/2;
    reloadBtn.layer.cornerRadius = 5;
    reloadBtn.hidden  = YES;
    reloadBtn.backgroundColor = MAINCOLOR;
    reloadBtn.titleLabel.font = FONT(15);
    [reloadBtn setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
    [reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
    [reloadBtn addTarget:self action:@selector(reloadAll) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reloadBtn];
}
-(void)reloadAll
{
    reloadBtn.hidden  = YES;
    [self refreshCategorys];
}


//-(void)configNav
//{
//    UIImageView *logoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 133, 44)];
//    logoView.image = [UIImage imageNamed:@"logo"];
//    [self setNavTitleView:logoView];
//}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshHeadIcon];
    
//    [topMenu setSelectindex:0];


}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createMenu
{
    topMenu = [[EDScrollMenu alloc]initWithFrame:CGRectMake(0, 0, self.view.width, MenuHeight)];
    topMenu.delegate = self;
    topMenu.backgroundColor = WHITECOLOR;
    [self.view addSubview:topMenu];
}

-(void)createTipView
{
    tipView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 30)];
    tipView.backgroundColor = MAINCOLOR;
    tipView.alpha = 0.8;
    
    tipLabel = LABEL(FONT(14), BLACKCOLOR);
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.frame = CGRectMake(0, 0, tipView.width, tipView.height);
    tipLabel.text  = @"已为您推荐x条内容";
    [tipView addSubview:tipLabel];
    
    [self.view addSubview:tipView];
}

//获取分类
-(void)getCateGorys
{
    NSDictionary *paramDic = @{};
    self.showLoadingView = YES;

    [[HttpRequestManager manager] GET:HOMECategory_URL parameters:paramDic success:^(NSURLSessionDataTask * task,id responseObject)
     {
         NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         self.showLoadingView = NO;
         NSLog(@"获取成功:%@",dic);
         if ([[dic objectForKey:@"code"] integerValue] == 200) {
             reloadBtn.hidden     = YES;

             NSArray *dataArr = [NetDataCommon arrayWithNetData:dic[@"data"]];
             //将频道缓存到本地disk
             if (NOTEmpty(dataArr) && [dataArr isKindOfClass:[NSArray class]]) {
                 [EDOLTool saveToNSUserDefaults:dataArr forKey:ED_CateGory_CacheKey];
             }
             
             [cateMenuArr removeAllObjects];
             [[APPServant servant].allAPPCategorys removeAllObjects];
             
             for (NSDictionary *modelDic in dataArr) {
                 EDCateGoryModel *model = [[EDCateGoryModel alloc]initWithDic:modelDic];
                 //将所有频道缓存(内存)
                 [[APPServant servant].allAPPCategorys addObject:model];
             }

             if (ED_ISLogin) {
                 //获取服务端的返回当中已选择的，如果没有，则取前五个
                 for (EDCateGoryModel *tmodel in [APPServant servant].allAPPCategorys) {
                     if (tmodel.selected) {
                         [cateMenuArr addObject:tmodel];
                     }
                 }

                 
             }else{
                 //将本地缓存的“已选择频道ids”与返回数据比较，从返回数据总筛选出已选择。
                 NSString *cateString  = [EDOLTool readFromNSUserDefaults:ED_CateGory_CacheKey_UN];
                 if (NOTEmpty(cateString)) {
                     NSArray *diskCacheIdsArr = [cateString  componentsSeparatedByString:@"@"];
                     if (NOTEmpty(diskCacheIdsArr)) {
                         for (int i = 0; i<diskCacheIdsArr.count; i++) {
                             NSString *cId = diskCacheIdsArr[i];
                             for (EDCateGoryModel *tmodel in [APPServant servant].allAPPCategorys) {
                                 if ([tmodel.cateId isEqualToString:cId]) {
                                     tmodel.selected = YES;
                                     [cateMenuArr addObject:tmodel];
                                 }
                             }
                         }
                     }
                 }

             }
             
             //为空则取前五个
             if (cateMenuArr.count == 0) {
                 for (NSInteger i = 0; i<[APPServant servant].allAPPCategorys.count;i++)
                 {
                     EDCateGoryModel *model = [APPServant servant].allAPPCategorys[i];
                     model.selected = YES;
                     [cateMenuArr addObject:model];
                     //最多五个
                     if (i==4)break;
                 }
             }

             
             topMenu.dataSource = cateMenuArr;
             [contentView reloadData];

         }
     }failure:^(NSURLSessionDataTask * task,NSError *errpr)
     {
         self.showLoadingView = NO;
         reloadBtn.hidden     = NO;
         NSLog(@"failuer");
     }];
}

-(void)createCollection
{
    CGFloat  itemHeight = self.view.height - MenuHeight - 64;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize                    = CGSizeMake(self.view.width, itemHeight);
    layout.minimumLineSpacing          = 0;
    layout.minimumInteritemSpacing     = 0;
    layout.sectionInset                = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.scrollDirection             = UICollectionViewScrollDirectionHorizontal;
    
    contentView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, MenuHeight,self.view.width,itemHeight) collectionViewLayout:layout];
    contentView.backgroundColor = CLEARCOLOR;
    contentView.delegate      = self;
    contentView.dataSource    = self;
    contentView.scrollsToTop  = NO;
    contentView.pagingEnabled = YES;
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.bounces = NO;
    [contentView registerClass:[EDHomePageCell class] forCellWithReuseIdentifier:@"EDHomePageCommonCellIdent"];
    [contentView registerClass:[EDHomePageCell class] forCellWithReuseIdentifier:@"EDHomePageFunnyCellIdent"];

    [self.view addSubview:contentView];
    
}

#pragma mark
#pragma uicollectionview
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return cateMenuArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EDCateGoryModel *cateModel  = cateMenuArr[indexPath.row];
    if (cateModel.viewType == HomeViewTypeTopic) {
        EDHomePageCell *cell = [contentView dequeueReusableCellWithReuseIdentifier:@"EDHomePageFunnyCellIdent" forIndexPath:indexPath];
        cell.delegate               = self;
        return cell;


    }else{
        EDHomePageCell *cell        = [contentView dequeueReusableCellWithReuseIdentifier:@"EDHomePageCommonCellIdent" forIndexPath:indexPath];
        cell.delegate               = self;
        return cell;

    
    }
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    EDHomePageCell *disCell = (EDHomePageCell *)cell;
    EDCateGoryModel *cateModel  = cateMenuArr[indexPath.row];
    disCell.cateModel              = cateModel;
}

//-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    EDHomePageCell *disCell = (EDHomePageCell *)cell;
//    EDCateGoryModel *cateModel  = cateMenuArr[indexPath.row];
//    disCell.cateModel              = cateModel;
//}

#pragma mark
#pragma mark scrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //计算当前位置
    NSInteger index =  scrollView.contentOffset.x/scrollView.width;
    [topMenu setSelectindex:index];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //记录其实位置(用来判断滚动方向)
    preOffsetX = scrollView.contentOffset.x;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat   offsetX     = scrollView.contentOffset.x;
    CGFloat   viewW       = self.view.width;
    CGFloat   direction   = scrollView.contentOffset.x - preOffsetX;
    NSInteger fromIndex   = topMenu.selectindex;
    NSInteger toIndex     = 0;
    
//    CGFloat floorIndex = floor(offsetX/viewW);
//    CGFloat progress = offsetX/viewW-floorIndex;
    CGFloat progress = fabs(offsetX - fromIndex*viewW)/viewW;
    if (direction >= 0) {
        //向右  前
         toIndex     = fromIndex + 1;
    }else{
       //像左  后
         toIndex     = fromIndex - 1;
//         progress    = 1.0 - progress;
        
    }

//    NSLog(@"%ld -- %ld ->%f",(long)fromIndex,(long)toIndex,progress);
    //改变菜单进度位置
    
    [topMenu transitionFromIndex:fromIndex toIndex:toIndex progress:progress];
}

-(void)backBtPressed
{
    PersonalCenterVC *pVC = [PersonalCenterVC new];
    pVC.delegate  = self;
    pVC.view.backgroundColor = CLEARCOLOR;
    EDBaseNavigationController *nextVC = [[EDBaseNavigationController alloc]initWithRootViewController:pVC];
    nextVC.definesPresentationContext = YES;
    nextVC.view.backgroundColor   = CLEARCOLOR;
    nextVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [nextVC setNavigationBarHidden:YES animated:NO];
    [self presentViewController:nextVC animated:NO completion:^{
        [pVC show];
    }];
    
}


#pragma mark
#pragma mark EDScrollMenuDelegate

-(void)edScrollMenu:(EDScrollMenu *)menu didselectAtIndex:(NSInteger)index model:(EDCateGoryModel *)model
{
    [contentView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
//    [self getDataWithCateModel:model];
}
//加号
-(void)edScrollMenuAdd:(EDScrollMenu *)menu
{
    
    EDAllCateGoryVC *regVC = [EDAllCateGoryVC new];
    regVC.definesPresentationContext = YES;
    regVC.view.backgroundColor   = CLEARCOLOR;
    regVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:regVC animated:YES completion:nil];
    regVC.BackAction = ^(id param){

//        if ([APPServant isLogin]) {
//            //请求网络刷新
//            [self refreshCategorys];
//            
//        }else{
            //刷新(无需再请求  [APPServant servant].allAPPCategorys 已经包含所有)
            [cateMenuArr removeAllObjects];
            NSMutableArray *allCateArr = [APPServant servant].allAPPCategorys;
            for (EDCateGoryModel *amodel in allCateArr)
            {
                if (amodel.selected) {
                    [cateMenuArr addObject:amodel];
                }
                
            }
            //刷新菜单
            topMenu.dataSource = cateMenuArr;
            //刷新内容
            [contentView reloadData];
//        }
       
    };
}

-(void)getDataWithCateModel:(EDCateGoryModel *)model
{
    
}
#pragma mark
#pragma mark EDUserCenterMenuDelegate

-(void)dismissedWithOperation:(EDUserCenterDisOption)option
{
    if (option == EDUserCenterDisOption_None){
        [self refreshHeadIcon];

    }else if (option == EDUserCenterDisOption_Login) {

        EDLoginViewController *loginVC = [EDLoginViewController new];
        loginVC.view.backgroundColor = CLEARCOLOR;
        EDBaseNavigationController *nextVC = [[EDBaseNavigationController alloc]initWithRootViewController:loginVC];
        nextVC.definesPresentationContext = YES;
        nextVC.view.backgroundColor = CLEARCOLOR;
        nextVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [nextVC setNavigationBarHidden:YES animated:NO];
        [self presentViewController:nextVC animated:YES completion:nil];
        
    }else if(option == EDUserCenterDisOption_Register){
        EDRegistViewController *regVC = [EDRegistViewController new];
        regVC.view.backgroundColor = CLEARCOLOR;
        EDBaseNavigationController *nextVC = [[EDBaseNavigationController alloc]initWithRootViewController:regVC];
        nextVC.definesPresentationContext = YES;
        nextVC.view.backgroundColor = CLEARCOLOR;
        nextVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [nextVC setNavigationBarHidden:YES animated:NO];
        
        [self presentViewController:nextVC animated:YES completion:nil];
    }
}


-(void)refreshHeadIcon
{
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    leftBtn.adjustsImageWhenHighlighted = NO;
    leftBtn.backgroundColor = CLEARCOLOR;
    leftBtn.layer.cornerRadius = 15;
    leftBtn.layer.masksToBounds = YES;
    [leftBtn addTarget:self action:@selector(backBtPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    if (NOTEmpty([APPServant servant].user)) {
        NSString *headUrl = [APPServant servant].user.mHeadIcon;
        [leftBtn sd_setImageWithURL:[NSURL URLWithString:headUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_userhead"]];

    }else{
//        [self setBackIcon:peopleIcon color:COLOR_333 fontSize:22];
        [leftBtn setImage:[UIImage imageNamed:@"default_userhead"] forState:UIControlStateNormal];
        
    }
}

-(void)refreshCategorys
{
    [self getCateGorys];
    
}

#pragma notifaction Fun
-(void)loginStatusChange
{
    [self refreshHeadIcon];
    [self refreshCategorys];
}
-(void)dataHaveNew:(NSNotification *) notif
{
//    NSString  *tipStr = @"您刷新的太快啦，休息一会吧";
//    if ([notif.object integerValue] > 0) {
//        tipStr = [NSString stringWithFormat:@"已为您推荐%@条新内容",notif.object];
//    }
    tipLabel.text = notif.object;
    [UIView animateWithDuration:0.5 animations:^{
        tipView.top = 40;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.4 animations:^{
                tipView.top = 10;
            }];
        });

    }];
}

@end

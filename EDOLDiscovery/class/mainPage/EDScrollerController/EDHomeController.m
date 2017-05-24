//
//  EDHomeController.m
//  EDOLDiscovery
//
//  Created by song on 2017/4/25.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDHomeController.h"
#import "EDScrollMenu.h"
#import "EDAllCateGoryVC.h"
#import "EDHomeVCHelpper.h"

@interface EDHomeController ()<EDScrollMenuDelegate>
{
    CGFloat preOffsetX;
    UIView  *tipView;
    UILabel *tipLabel;
}
@property(nonatomic,strong)NSMutableArray *cateMenuArr;
@property(nonatomic,strong)EDScrollMenu   *topMenu;

@end

@implementation EDHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.extendedLayoutIncludesOpaqueBars     = YES;
    [self createTipView];
    [self.view addSubview:self.topMenu];
    [self getCateGorys];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataHaveNew:) name:ED_Home_DataRefresh object:nil];

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
-(EDScrollMenu *)topMenu
{
    if (!_topMenu) {
        _topMenu = [[EDScrollMenu alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
        _topMenu.delegate = self;
        _topMenu.backgroundColor = WHITECOLOR;
    }
    return _topMenu;
}
-(NSMutableArray *)cateMenuArr
{
    if (!_cateMenuArr) {
        _cateMenuArr = [NSMutableArray new];
    }
    return _cateMenuArr;
}
-(void)configNav
{
    UIImageView *logoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 133, 44)];
    logoView.image = [UIImage imageNamed:@"logo"];
    [self setNavTitleView:logoView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 获取分类
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
             
             NSArray *dataArr = [NetDataCommon arrayWithNetData:dic[@"data"]];
             //将频道缓存到本地disk
             if (NOTEmpty(dataArr) && [dataArr isKindOfClass:[NSArray class]]) {
                 [EDOLTool saveToNSUserDefaults:dataArr forKey:ED_CateGory_CacheKey];
             }
             
             [self.cateMenuArr removeAllObjects];
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
                         [self.cateMenuArr addObject:tmodel];
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
                                     [self.cateMenuArr addObject:tmodel];
                                 }
                             }
                         }
                     }
                 }
                 
             }
             
             //为空则取前五个
             if (self.cateMenuArr.count == 0) {
                 for (NSInteger i = 0; i<[APPServant servant].allAPPCategorys.count;i++)
                 {
                     EDCateGoryModel *model = [APPServant servant].allAPPCategorys[i];
                     model.selected = YES;
                     [self.cateMenuArr addObject:model];
                     //最多五个
                     if (i==4)break;
                 }
             }
             
             
             self.topMenu.dataSource = self.cateMenuArr;
//             刷新列表
             self.viewControllers = [EDHomeVCHelpper collectViewControllers:self.cateMenuArr];
             [self reloadViewControllers];
         }
     }failure:^(NSURLSessionDataTask * task,NSError *errpr)
     {
         self.showLoadingView = NO;
         NSLog(@"failuer");
     }];
}
#pragma mark
#pragma mark EDScrollMenuDelegate

-(void)edScrollMenu:(EDScrollMenu *)menu didselectAtIndex:(NSInteger)index model:(EDCateGoryModel *)model
{
   //滚动到指定VC
    self.selectedIndex = index;
}
//加号
-(void)edScrollMenuAdd:(EDScrollMenu *)menu
{
    EDAllCateGoryVC *regVC = [EDAllCateGoryVC new];
    regVC.definesPresentationContext = YES;
    regVC.view.backgroundColor   = CLEARCOLOR;
    regVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self.tabBarController presentViewController:regVC animated:YES completion:nil];
    regVC.BackAction = ^(id param){
        //刷新(无需再请求  [APPServant servant].allAPPCategorys 已经包含所有)
        [self.cateMenuArr removeAllObjects];
        NSMutableArray *allCateArr = [APPServant servant].allAPPCategorys;
        for (EDCateGoryModel *amodel in allCateArr)
        {
            if (amodel.selected) {
                [self.cateMenuArr addObject:amodel];
            }
            
        }
        //刷新菜单
        self.topMenu.dataSource = self.cateMenuArr;
        
        //刷新列表
        self.viewControllers = [EDHomeVCHelpper collectViewControllers:self.cateMenuArr];
        [self reloadViewControllers];
    };
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //计算当前位置
    [super scrollViewDidEndDecelerating:scrollView];
    NSInteger index =  scrollView.contentOffset.x/scrollView.width;
    [self.topMenu setSelectindex:index];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //记录起始位置(用来判断滚动方向)
    preOffsetX = scrollView.contentOffset.x;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat   offsetX     = scrollView.contentOffset.x;
    CGFloat   viewW       = self.view.width;
    CGFloat   direction   = scrollView.contentOffset.x - preOffsetX;
    NSInteger fromIndex   = self.topMenu.selectindex;
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
    
    [self.topMenu transitionFromIndex:fromIndex toIndex:toIndex progress:progress];
}


-(void)dataHaveNew:(NSNotification *) notif
{
    tipLabel.text = notif.object;
    [UIView animateWithDuration:0.5 animations:^{
        tipView.top = 40;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.4 animations:^{
                tipView.top = 10;
            }];
        });
        
    }];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

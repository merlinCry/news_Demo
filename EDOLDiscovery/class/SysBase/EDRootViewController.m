//
//  EDRootViewController.m
//  EDOLDiscovery
//
//  Created by song on 16/12/24.
//  Copyright © 2016年 song. All rights reserved.
//

#import "EDRootViewController.h"
@interface EDRootViewController ()<UIGestureRecognizerDelegate>

@property(nonatomic,strong)UIView *edTransitionView;
@property(nonatomic,assign)CGFloat centerMaxX;

@end

@implementation EDRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WHITECOLOR;
    [self configTabbar];
//    self.tabBar.hidden = YES;
//    _centerMaxX = SCREEN_WIDTH*3/2-80.0f;
//    if (_slideMenu) {
//        [self addTransition];
//    }
    
}
-(void)configTabbar
{
    [self.tabBar setBackgroundImage:[UIImage imageWithColor:WHITECOLOR size:CGSizeMake(SCREEN_WIDTH, 49)]];
    [self.tabBar setShadowImage:[UIImage imageWithColor:LINECOLOR size:CGSizeMake(SCREEN_WIDTH, 0.5)]];
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:COLOR_666, NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:  [NSDictionary dictionaryWithObjectsAndKeys:COLOR_666,NSForegroundColorAttributeName, nil]forState:UIControlStateSelected];

}
-(void)setBadge:(NSString *)badgeValue atIndex:(NSInteger)index
{
    if (index < self.tabBar.items.count) {
        UITabBarItem *item = (UITabBarItem *)self.tabBar.items[index];
        item.badgeValue = badgeValue;
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_slideMenu) {
        [self addGestureForMTransitionView];

    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark
#pragma mark 侧滑菜单部分


-(void)addTransition{
    for (UIView *tmp in self.view.subviews) {
        
        [tmp removeFromSuperview];
        
        [self.EDtransitionView addSubview:tmp];
    }
    //添加侧滑vc
    [self addLeftMenu];
    [self.view addSubview:self.EDtransitionView];
}
-(void)addLeftMenu
{
    _leftMenuVC = [EDLeftMenuViewController new];
    _leftMenuVC.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    [self.view addSubview:_leftMenuVC.view];
    [_leftMenuVC didMoveToParentViewController:self];
    
}
-(UIView *)EDtransitionView{
    if (_edTransitionView ==nil) {
        _edTransitionView = [[UIView alloc]initWithFrame:self.view.bounds];
        _edTransitionView.backgroundColor = CLEARCOLOR;
    }
    return _edTransitionView;
}


-(void)openLeftMenu
{
    if (!_slideMenu)return;
    
    CGPoint center = self.edTransitionView.center;
    center.x = _centerMaxX;
    [UIView animateWithDuration:0.15f animations:^{
        self.edTransitionView.center = center;

    } completion:^(BOOL finished) {
        //关闭子view响应
        [self mTransitionSubViewsEnable:NO];
        [_leftMenuVC menuDidOpened];
    }];
    
}

-(void)closeLeftMenu
{
    CGPoint center = self.edTransitionView.center;
    center.x = SCREEN_WIDTH/2;
    [UIView animateWithDuration:0.15f animations:^{
        self.edTransitionView.center = center;
    } completion:^(BOOL finished) {
        //打开子view响应
        [self mTransitionSubViewsEnable:YES];
        [_leftMenuVC menuDidClosed];

    }];
}

#pragma mark 拖动手势动作
-(void)panAction:(UIPanGestureRecognizer*)pan{
    CGPoint location = [pan translationInView:pan.view.superview];
    CGPoint center   = _edTransitionView.center;
    
    if (pan.state==UIGestureRecognizerStateEnded) {
        if (center.x<_centerMaxX*0.5+SCREEN_WIDTH*0.25){
            [self closeLeftMenu];
        }else{
            [self openLeftMenu];
        }
    }else if(pan.state==UIGestureRecognizerStateChanged){
        
        if (location.x<0) {//向左滑
            center.x = center.x+location.x<=SCREEN_WIDTH/2? SCREEN_WIDTH/2 : center.x+location.x;
        }else{
            center.x = center.x+location.x>=_centerMaxX? _centerMaxX : center.x+location.x;
        }
        
        self.edTransitionView.center = center;
        [pan setTranslation:CGPointMake(0, 0) inView:pan.view.superview];
    }
}

-(void)mTransitionSubViewsEnable:(BOOL)enable
{
    for (UIView *tmp in self.edTransitionView.subviews) {
        tmp.userInteractionEnabled = enable;
    }
    if (enable) {
        [self.edTransitionView removeGestureRecognizer:_tapGes];
    }else{
        [self.edTransitionView addGestureRecognizer:_tapGes];
    }
}

#pragma mark 添加手势
-(void)addGestureForMTransitionView
{
    _panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [_edTransitionView addGestureRecognizer:_panGes];
    _panGes.delegate = self;
    //这个手势要系统的滑动返回手势不响应的时候才执行
    [_panGes requireGestureRecognizerToFail:[self screenEdgePanGestureRecognizer]];
    
    
    _tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeLeftMenu)];
    
}

//获取首页nav的手势
- (UIScreenEdgePanGestureRecognizer *)screenEdgePanGestureRecognizer
{
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = nil;
    if (self.viewControllers.count > 0) {
        EDBaseNavigationController *homeNav = [self.viewControllers objectAtIndex:0];
        for (UIGestureRecognizer *recognizer in homeNav.view.gestureRecognizers){
            if ([recognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
                screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)recognizer;
                break;
            }
        }
    }

    return screenEdgePanGestureRecognizer;
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == _panGes) {
        CGPoint location = [_panGes locationInView:_panGes.view];
        
        if (location.x <= 50) {
            return YES;
        }
        return NO;
        
    }

    return YES;
}

@end

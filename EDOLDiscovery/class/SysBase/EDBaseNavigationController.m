//
//  EDBaseNavigationController.m
//  EDOLDiscovery
//
//  Created by song on 16/12/24.
//  Copyright © 2016年 song. All rights reserved.
//

#import "EDBaseNavigationController.h"

@implementation UINavigationController (UINavigationControllerCategory)

-(void)resetBackground
{
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]
                            forBarPosition:UIBarPositionAny
                                barMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];
}

@end

@interface EDBaseNavigationController ()
{
    UIPanGestureRecognizer * fullScreenGes;
}
@end

@implementation EDBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
    
    [self  resetBackground];
    //自定义全屏返回手势
    id target = self.interactivePopGestureRecognizer.delegate;
    SEL handler = NSSelectorFromString(@"handleNavigationTransition:");
    //  获取添加系统边缘触发手势的View
    UIView *targetView = self.interactivePopGestureRecognizer.view;
    
    //  创建pan手势 作用范围是全屏
    fullScreenGes = [[UIPanGestureRecognizer alloc]initWithTarget:target action:handler];
    fullScreenGes.delegate = (id)self;
    [targetView addGestureRecognizer:fullScreenGes];
    fullScreenGes.enabled = NO;
    
    self.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [self.interactivePopGestureRecognizer setEnabled:YES];

}
-(void)setFullScreenBackGes:(BOOL)fullScreenBackGes
{
    _fullScreenBackGes    = fullScreenBackGes;
    fullScreenGes.enabled = _fullScreenBackGes;
    self.interactivePopGestureRecognizer.enabled = !fullScreenBackGes;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == fullScreenGes) {
        if (self.viewControllers.count == 1){
            return NO;

        }else{
            return YES;
        }
    }
    return YES;
}


@end

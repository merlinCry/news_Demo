//
//  EDScrollerController.m
//  EDScrollerViewContainer
//
//  Created by song on 2017/4/25.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDScrollerController.h"
@interface EDScrollerController ()<UIScrollViewDelegate>

@end

@implementation EDScrollerController
@synthesize selectedIndex = _selectedIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WHITECOLOR;
    [self.view addSubview:self.containerView];
    [self reloadViewControllers];
}

-(void)reloadViewControllers
{
  //删掉所有子vc
    for (UIViewController *subVC in self.childViewControllers) {
        [self uninstallController:subVC];
    }
  //调整scroller内尺寸
    self.containerView.contentSize = CGSizeMake(self.view.width * _viewControllers.count, self.view.height);
  //显示第一个VC
    self.selectedIndex = 0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(UIScrollView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,40, self.view.width, self.view.height - 40)];
//        _containerView.contentInset = UIEdgeInsetsMake(104, 0, 0, 0);
        _containerView.showsHorizontalScrollIndicator = NO;
        _containerView.bounces         = NO;
        _containerView.pagingEnabled   = YES;
        _containerView.delegate        = self;
        _containerView.backgroundColor = CLEARCOLOR;
    }
    return _containerView;
}
-(void)setViewControllers:(NSArray *)viewControllers
{
    _viewControllers = viewControllers;
}
-(NSUInteger)selectedIndex
{
    return _selectedIndex;
}

-(void)setSelectedIndex:(NSUInteger)selectedIndex
{
    if (selectedIndex >= self.viewControllers.count) {
        return;
    }
    _selectedIndex = selectedIndex;
    //跳转到指定viewController
    if (self.containerView.contentOffset.x != _selectedIndex * self.containerView.width) {
        CGSize size = self.containerView.frame.size;
        [self.containerView scrollRectToVisible:CGRectMake(size.width*_selectedIndex, 0, size.width, size.height) animated:YES];
    }
    
    self.selectedViewController = self.viewControllers[_selectedIndex];
    if ([self.childViewControllers containsObject:self.selectedViewController]) {
        [self.selectedViewController viewDidAppear:YES];
    }else{
        [self installController:self.selectedViewController atIndex:_selectedIndex];

    }
}

//添加一个子viewcontroller
-(void)installController:(UIViewController *)controller atIndex:(NSInteger)index
{
    [self addChildViewController:controller];
    controller.view.frame = CGRectMake(self.containerView.width*index, 0, self.containerView.width, self.containerView.height);
    [self.containerView addSubview:controller.view];
    [controller didMoveToParentViewController:self];
}

//去掉一个子viewcontroller
-(void)uninstallController:(UIViewController *)controler
{
    [controler willMoveToParentViewController:nil];
    [controler.view removeFromSuperview];
    [controler removeFromParentViewController];
}
#pragma mark
#pragma UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index    = scrollView.contentOffset.x/self.containerView.width;
    self.selectedIndex = index;
}


//-(void)transitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL))completion
//{
//    
//}
@end

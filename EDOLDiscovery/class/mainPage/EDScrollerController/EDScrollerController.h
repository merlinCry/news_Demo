//
//  EDScrollerController.h
//  EDScrollerViewContainer
//
//  Created by song on 2017/4/25.
//  Copyright © 2017年 song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EDScrollerController : EDBaseViewController

@property (nonatomic, strong)UIScrollView * _Nonnull containerView;

/**
 *   subViewControllers
 */
@property (nonatomic, strong)NSArray * _Nullable viewControllers;

@property(nullable, nonatomic, assign)UIViewController *selectedViewController;
@property(nonatomic) NSUInteger selectedIndex;

//当viewControllers发生改变的时候要调一下reload
-(void)reloadViewControllers;

-(void)scrollViewDidEndDecelerating:(UIScrollView *_Nonnull)scrollView;
@end

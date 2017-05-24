//
//  EDRootViewController.h
//  EDOLDiscovery
//
//  Created by song on 16/12/24.
//  Copyright © 2016年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDBaseNavigationController.h"
#import "EDLeftMenuViewController.h"

@interface EDRootViewController : UITabBarController

@property (nonatomic, strong) EDLeftMenuViewController *leftMenuVC;
@property (nonatomic, strong) UIPanGestureRecognizer   *panGes;
@property (nonatomic, strong) UITapGestureRecognizer   *tapGes;
@property (nonatomic, assign) BOOL slideMenu;


-(void)openLeftMenu;

-(void)closeLeftMenu;

-(void)setBadge:(NSString *)badgeValue atIndex:(NSInteger)index;

@end

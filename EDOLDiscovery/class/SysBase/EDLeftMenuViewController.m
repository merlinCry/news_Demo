//
//  EDLeftMenuViewController.m
//  EDOLDiscovery
//
//  Created by song on 16/12/27.
//  Copyright © 2016年 song. All rights reserved.
//

#import "EDLeftMenuViewController.h"
#import "EDNewsDetailVC.h"
@interface EDLeftMenuViewController ()

@end

@implementation EDLeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    btn.backgroundColor = MAINCOLOR;
    [btn addTarget:self action:@selector(testPush) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)testPush
{
    EDNewsDetailVC *nextVC = [EDNewsDetailVC new];
    nextVC.hasBackArrow    = YES;
    [APPServant pushToController:nextVC animate:NO];
    
    EDRootViewController *rootVC = [APPServant servant].rootTabbarVC;
    [rootVC closeLeftMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)menuDidOpened
{
    
}


-(void)menuDidClosed
{
    
    
}
@end

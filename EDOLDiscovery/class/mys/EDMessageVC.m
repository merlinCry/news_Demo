//
//  EDMessageVC.m
//  EDOLDiscovery
//
//  Created by song on 17/1/7.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDMessageVC.h"

@interface EDMessageVC ()

@end

@implementation EDMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLikeNavTitle:@"消息通知"];

    self.noDataImage     = @"nomessage";
    self.noDataTip       = @"没有新的消息哟~";
    self.loadingTip      = @"开车中";
    self.showLoadingView = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.showNoDataView  = YES;
        self.showLoadingView = NO;
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

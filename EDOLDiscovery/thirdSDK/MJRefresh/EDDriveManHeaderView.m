//
//  EDDriveManHeaderView.m
//  EDOLDiscovery
//
//  Created by song on 17/1/3.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDDriveManHeaderView.h"

@implementation EDDriveManHeaderView

#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 0; i<60; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"driving000%02ld@2x",(long)i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 9; i< 60; i = i+10) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"driving000%02ld@2x", (unsigned long)i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
}


-(void)placeSubviews
{
    [super placeSubviews];
    self.stateLabel.hidden = YES;
    self.gifView.mj_w = 85;
//    CGFloat textWidth = [self.stateLabel.text sizeWithAttributes:@{NSFontAttributeName:self.stateLabel.font}].width;
//    self.stateLabel.width = textWidth;
//
//    CGFloat left = (self.width - (85 + textWidth))/2;
//    self.gifView.mj_x  = left - 20;
//    self.stateLabel.left = self.gifView.right+20;
    
    
    self.gifView.centerX = self.width/2;
}
@end

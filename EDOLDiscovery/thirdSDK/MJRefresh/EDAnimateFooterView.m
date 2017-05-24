//
//  EDAnimateFooterView.m
//  EDOLDiscovery
//
//  Created by song on 17/1/18.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDAnimateFooterView.h"

@implementation EDAnimateFooterView

- (void)prepare
{
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 0; i<3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"wheelsmall%03ld@2x",(long)i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 0; i< 3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"wheelsmall%03ld", (unsigned long)i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    self.gifView.animationDuration = 0.4;
}

//调整位置
-(void)placeSubviews
{
    [super placeSubviews];
    CGFloat textWidth = [self.stateLabel.text sizeWithAttributes:@{NSFontAttributeName:self.stateLabel.font}].width;
//        self.stateLabel.width = textWidth;
    //
    //    CGFloat left = (self.width - (85 + textWidth))/2;
    //    self.gifView.mj_x  = left - 20;
    //    self.stateLabel.left = self.gifView.right+20;
    
//    self.stateLabel.backgroundColor = MAINCOLOR;
    self.stateLabel.textColor = COLOR_999;
    self.stateLabel.font =  FONT_Light(14);
    NSString *tipStr     = [NSString stringWithFormat:@"    %@",self.stateLabel.text];
    self.stateLabel.text = tipStr;
    self.gifView.contentMode = UIViewContentModeScaleAspectFit;
    self.gifView.frame = CGRectMake(0, 0, 24, 24);
    self.gifView.centerY = self.height/2;
    self.gifView.right = (self.width - textWidth)/2 + 5;
}
@end

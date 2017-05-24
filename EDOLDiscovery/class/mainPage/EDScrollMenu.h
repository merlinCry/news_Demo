//
//  EDScrollMenu.h
//  EDOLDiscovery
//
//  Created by song on 17/1/4.
//  Copyright © 2017年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDCateGoryModel.h"

@class EDScrollMenu;
@protocol EDScrollMenuDelegate <NSObject>

@optional
//点击频道
-(void)edScrollMenu:(EDScrollMenu *)menu didselectAtIndex:(NSInteger)index model:(EDCateGoryModel *)model;
//添加频道
-(void)edScrollMenuAdd:(EDScrollMenu *)menu;


@end
@interface EDScrollMenu : EDBaseView

@property (nonatomic, assign)NSInteger selectindex;


/**
 *   dataSource
 */
@property (nonatomic, strong)NSMutableArray *dataSource;

/**
 *   buttons
 */
@property (nonatomic, strong)NSMutableArray *buttonsArr;

@property (nonatomic, assign)id<EDScrollMenuDelegate> delegate;

- (void)transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress;

@end

//
//  EDHRecommendCell.h
//  EDOLDiscovery
//
//  Created by song on 17/1/3.
//  Copyright © 2017年 song. All rights reserved.
//首页分类默认cell


#import <UIKit/UIKit.h>
#import "EDHomeNewsModel.h"
@class EDHCommonCell;
@protocol EDHCommonCellDelegate <NSObject>
@optional
//不喜欢
-(void)edHCommonCell:(EDHCommonCell *)cell didDelete:(EDHomeNewsModel *)model;
//管理员删除
-(void)edHCommonCell:(EDHCommonCell *)cell didRemove:(EDHomeNewsModel *)model;
-(void)edHCommonCell:(EDHCommonCell *)cell sourceView:(UIView *)sourceView model:(EDHomeNewsModel *)model;


@end

@interface EDHCommonCell : EDBaseTableViewCell
@property (nonatomic, assign)id<EDHCommonCellDelegate> delegate;
@property (nonatomic, strong)EDHomeNewsModel *model;

@property (nonatomic, assign)BOOL read;


@end

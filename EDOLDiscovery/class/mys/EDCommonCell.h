//
//  EDCommonCell.h
//  EDOLDiscovery
//
//  Created by song on 17/1/7.
//  Copyright © 2017年 song. All rights reserved.
//  类似设置页面使用

#import <UIKit/UIKit.h>

@interface EDCommonCell : EDBaseTableViewCell


@property (nonatomic, strong)UIImageView *iconView;
@property (nonatomic, strong)UILabel *nameLab;
@property (nonatomic, strong)UILabel *detailLab;
@property (nonatomic, strong)UIView  *rightView;

@property (nonatomic, assign)BOOL    bigIcon;

@end

//
//  EDHomeFunCell.h
//  EDOLDiscovery
//
//  Created by song on 17/1/4.
//  Copyright © 2017年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDHomeFunModel.h"
//@class EDHomeFunCell;
//@protocol EDHomeFunCellDelegate <NSObject>
//
//@optional
////赞
//-(void)edHomeFunCell:(EDHomeFunCell *)cell zanAction:(EDHomeFunModel *)model;
//
////赞
//-(void)edHomeFunCell:(EDHomeFunCell *)cell collectAction:(EDHomeFunModel *)model;
//
//@end

@interface EDHomeFunCell : EDBaseTableViewCell


@property (nonatomic, strong)EDHomeFunModel *model;

//@property (nonatomic, assign)id<EDHomeFunCellDelegate> delegate;

@end

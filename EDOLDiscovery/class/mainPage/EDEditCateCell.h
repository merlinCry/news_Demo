//
//  EDEditCateCell.h
//  EDOLDiscovery
//
//  Created by song on 17/1/7.
//  Copyright © 2017年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDCateGoryModel.h"
@class EDEditCateCell;

@protocol  EDEditCateCellDelegate <NSObject>

@optional
-(void)edEditCateCell:(EDEditCateCell *)cell deleteAtModel:(EDCateGoryModel *)model;

@end

@interface EDEditCateCell : UICollectionViewCell

@property (nonatomic, strong)EDCateGoryModel *model;


@property (nonatomic, assign)id<EDEditCateCellDelegate> delegate;

@end

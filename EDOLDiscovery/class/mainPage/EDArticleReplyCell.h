//
//  EDArticleReplyCell.h
//  EDOLDiscovery
//
//  Created by song on 17/1/13.
//  Copyright © 2017年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDArticleReplyModel.h"
@class EDArticleReplyCell;
@protocol EDArticleReplyCellDelegate <NSObject>

@optional
-(void)replyComment:(EDArticleReplyModel *)model;

@end

@interface EDArticleReplyCell : EDBaseTableViewCell

@property (nonatomic, strong)EDArticleReplyModel *model;

@property (nonatomic, weak)id<EDArticleReplyCellDelegate> delegate;

@end

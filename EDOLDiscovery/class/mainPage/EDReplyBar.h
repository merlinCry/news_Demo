//
//  EDReplyBar.h
//  EDOLDiscovery
//
//  Created by song on 17/1/13.
//  Copyright © 2017年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EDReplyBar;
@protocol EDReplyBarDelegate <NSObject>

@optional
-(void)edReplyBar:(EDReplyBar *)view addcomment:(NSString *)commentText;
//收藏
-(void)edReplyBarCollect:(EDReplyBar *)view;
//取消收藏
-(void)edReplyBarCancelCollect:(EDReplyBar *)view;

-(void)edReplyBar:(EDReplyBar *)view jumpToComment:(BOOL)jumped;

//分享
-(void)edReplyBarShare:(EDReplyBar *)view;

//赞
-(void)edReplyBarZan:(EDReplyBar *)view;

@end

@interface EDReplyBar : EDBaseView<UITextViewDelegate,UITextFieldDelegate>
@property (nonatomic, assign)NSInteger commentCount;
@property (nonatomic, assign)BOOL hasCollected;



@property (nonatomic, assign)id<EDReplyBarDelegate> delegate;

//改变评论按钮显示状态
-(void)setBtnToReplyStyle:(BOOL)reply;

//品论列表使用的风格
-(void)listReplyModel;

//弹出回复框
-(void)popReply;
@end

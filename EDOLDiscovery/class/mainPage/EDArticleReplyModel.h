//
//  EDArticleReplyModel.h
//  EDOLDiscovery
//
//  Created by song on 17/1/13.
//  Copyright © 2017年 song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYTextContainer.h"

typedef NS_ENUM(NSInteger,ReplyType) {
    ReplyType_default = 0,//默认不显示子品论
    ReplyType_Top     = 1,//作为主品论
    ReplyType_Group   = 2,//带两条子品论

};

@interface EDArticleReplyModel : NSObject


@property (nonatomic, strong)TYTextContainer *textContainer;

@property (nonatomic, strong)NSString *infoId;
@property (nonatomic, strong)NSString *commentId;
@property (nonatomic, strong)NSString *userId;
@property (nonatomic, strong)NSString *nickname;
//这条品论是回复的那个评论(回复文章为空)
@property (nonatomic, strong)NSString *replyForName;
@property (nonatomic, strong)NSString *headerIcon;
@property (nonatomic, strong)NSString *commentReplyUpVoteCount;
@property (nonatomic, strong)NSString *content;
@property (nonatomic, strong)NSString *commentTime;
//回复列表
@property (nonatomic, strong)NSMutableArray *replyList;
//是否赞过
@property (nonatomic, assign)BOOL upVoted;



@property (nonatomic, assign)CGFloat cellHeight;
//作为子评论时候的高度(只有用户名和文字)
@property (nonatomic, assign)CGFloat heightAsSubReply;

//自己的所有子评论高度
@property (nonatomic, assign)CGFloat totalReplyHeight;
//品论样式
@property (nonatomic, assign)ReplyType type;


-(instancetype)initWithDic:(NSDictionary *)dic;


-(NSArray *)listSubReply;
@end

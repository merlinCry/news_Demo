//
//  EDArticleReplyModel.m
//  EDOLDiscovery
//
//  Created by song on 17/1/13.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDArticleReplyModel.h"

@implementation EDArticleReplyModel


-(instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _commentId = [NetDataCommon stringFromDic:dic forKey:@"commentId"];
        _userId    = [NetDataCommon stringFromDic:dic forKey:@"userId"];
        _infoId    = [NetDataCommon stringFromDic:dic forKey:@"infoId"];
        NSString *nicknameb64 = [NetDataCommon stringFromDic:dic forKey:@"nickname"];
        _nickname = [EDOLTool base64decodeString:nicknameb64];
        _headerIcon = [NetDataCommon stringFromDic:dic forKey:@"headerIcon"];
        _commentReplyUpVoteCount = [NetDataCommon stringFromDic:dic forKey:@"commentReplyUpVoteCount"];
        _content = [EDOLTool base64decodeString:[NetDataCommon stringFromDic:dic forKey:@"content"]];
        _commentTime = [NetDataCommon stringFromDic:dic forKey:@"commentTime"];
        _upVoted = [[NetDataCommon stringFromDic:dic forKey:@"upVoted"]boolValue];
        if (NOTEmpty(_content)) {
            _textContainer = [self creatTextContainer:_content];

        }
       
        NSArray *list = [NetDataCommon arrayWithNetData:dic[@"list"]];
        _replyList    = [NSMutableArray new];
        for (NSDictionary *rdic in list) {
            EDArticleReplyModel *aReply = [[EDArticleReplyModel alloc]initWithDic:rdic];
            [_replyList addObject:aReply];
        }
    }
    return self;
}


- (TYTextContainer *)creatTextContainer:(NSString *)text
{
    // 属性文本生成器
    TYTextContainer *textContainer = [[TYTextContainer alloc]init];
    textContainer.text = text;
    textContainer.linesSpacing = 2;
    textContainer = [textContainer createTextContainerWithTextWidth:SCREEN_WIDTH - 70];
    return textContainer;
}

-(CGFloat)cellHeight
{
    CGFloat height = _textContainer.textHeight + 70;
    switch (_type) {
        case ReplyType_Top:
        {
            height += 40;

        }
            break;
        case ReplyType_Group:
        {
            if (_replyList.count > 0) {
                height += self.totalReplyHeight;
            }
            
        }
            break;
            
        default:
            break;
    }

    return height;
}

-(CGFloat)heightAsSubReply
{
    CGFloat height = 0;
    //拼接文字，计算高度
    CGFloat maxWidth   = SCREEN_WIDTH - 110;
    NSString *text     = [NSString stringWithFormat:@"%@: ,%@",_nickname,_content];
    CGFloat textHeight =  [text boundingRectWithSize:CGSizeMake(maxWidth, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT(15)} context:nil].size.height;
    height += textHeight;
    
    return height;
}

-(CGFloat)totalReplyHeight
{
    CGFloat height = 0;
    if (_replyList.count > 0) {
        height += 20;//上下边距
        for (EDArticleReplyModel *rmodel in _replyList) {
            height += rmodel.heightAsSubReply;
            height += 5;
        }
        height -= 5;
    }
    return height;
}


-(NSArray *)listSubReply
{
    NSMutableArray *arr = [NSMutableArray new];
    if (_replyList.count > 0) {
        for (EDArticleReplyModel *sModel in _replyList) {
            sModel.replyForName = self.nickname;
            [arr addObject:sModel];
            [arr addObjectsFromArray:[sModel listSubReply]];
        }
    }
    return arr;
}
@end

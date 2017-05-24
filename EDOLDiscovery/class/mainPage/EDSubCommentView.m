
//
//  EDSubCommentView.m
//  EDOLDiscovery
//
//  Created by song on 2017/4/17.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDSubCommentView.h"
#import "EDArticleReplyModel.h"
@implementation EDSubCommentView

-(void)setDataSource:(NSMutableArray *)dataSource
{
    _dataSource = dataSource;
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    for (EDArticleReplyModel *model in _dataSource) {
        NSString *text = [NSString stringWithFormat:@"%@: %@",model.nickname,model.content];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:text attributes:@{NSFontAttributeName:FONT(15),NSForegroundColorAttributeName:UIColorFromRGB(0x3F3F3F)}];
        [attr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x4990E2) range:[text rangeOfString:model.nickname]];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 0, model.heightAsSubReply)];
        label.numberOfLines = 0;
        label.attributedText = attr;
        [self addSubview:label];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat  top = 10;
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            subView.width = self.width - 20;
            subView.top   = top;
            top = subView.bottom;
        }
    }
    
}
@end

//
//  EDReplyBar.m
//  EDOLDiscovery
//
//  Created by song on 17/1/13.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDReplyBar.h"

@implementation EDReplyBar
{
    UIView      *topLine;
    UITextField *inputLabel;
    UIButton    *replyCount;
    UIButton    *collectBtn;
    UIButton    *shareBtn;
    UIButton    *zanBtn;

    
    UIView      *commontView;
    UITextView  *inputView;
    UIButton    *commitBtn;
    UIView      *blackBack;
    
    //记录上次点击收藏按钮的时间戳
    NSInteger lastTapCollectBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createInputContent];
        [self createSubviews];
        
        //注册键盘显示与消失的通知观察者
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

-(void)createSubviews
{
    blackBack = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    blackBack.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    UITapGestureRecognizer *blackTapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [blackBack addGestureRecognizer:blackTapGes];

    zanBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    zanBtn.hidden = YES;
    zanBtn.right = self.width;
    zanBtn.titleLabel.font = ICONFONT(24);
    UIImage *zanNor = [UIImage iconWithInfo:TBCityIconInfoMake(zanIcon, 24, COLOR_666)];
    UIImage *zanSel = [UIImage imageNamed:@"zanBorder"];
    [zanBtn setImage:zanNor forState:UIControlStateNormal];
    [zanBtn setImage:zanSel forState:UIControlStateSelected];
    [zanBtn addTarget:self action:@selector(zanAction:) forControlEvents:UIControlEventTouchUpInside];
    
    shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    shareBtn.right = self.width;
    shareBtn.titleLabel.font = ICONFONT(24);
    [shareBtn setTitle:shareIcon forState:UIControlStateNormal];
    [shareBtn setTitleColor:COLOR_333 forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];

    
    collectBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    collectBtn.right = shareBtn.left;
    collectBtn.adjustsImageWhenHighlighted = NO;
    collectBtn.titleLabel.font = ICONFONT(24);
//    [collectBtn setTitle:collectIcon forState:UIControlStateNormal];
//    [collectBtn setTitle:collectfillIcon forState:UIControlStateSelected];
    UIImage *collNor = [UIImage iconWithInfo:TBCityIconInfoMake(collectIcon, 24, COLOR_666)];
    UIImage *colSel  = [UIImage imageNamed:@"collectBorder"];
    [collectBtn setImage:collNor forState:UIControlStateNormal];
    [collectBtn setImage:colSel forState:UIControlStateSelected];
    

    [collectBtn setTitleColor:COLOR_333 forState:UIControlStateNormal];
    [collectBtn addTarget:self action:@selector(collectionAction:) forControlEvents:UIControlEventTouchUpInside];
    
    replyCount = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 50)];
    replyCount.right = collectBtn.left;
    replyCount.titleLabel.font = FONT(16);
    [replyCount setTitleColor:COLOR_333 forState:UIControlStateNormal];
    [replyCount setTitleColor:COLOR_333 forState:UIControlStateSelected];
    [replyCount addTarget:self action:@selector(jumpToComment:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *reImage = [UIImage iconWithInfo:TBCityIconInfoMake(commentIcon, 24, COLOR_333)];
    UIImage *reImageSel = [UIImage iconWithInfo:TBCityIconInfoMake(articleIcon, 24, COLOR_333)];
    [replyCount setImage:reImage forState:UIControlStateNormal];
    [replyCount setImage:reImageSel forState:UIControlStateSelected];
    
    inputLabel = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, replyCount.left - 10, 30)];
    inputLabel.backgroundColor = WHITECOLOR;
    inputLabel.layer.cornerRadius = 15;
    inputLabel.layer.masksToBounds = YES;
    inputLabel.layer.borderWidth = 1;
    inputLabel.layer.borderColor = LINECOLOR.CGColor;
    inputLabel.placeholder = @"    请把你的节操留下";
    inputLabel.font = FONT_Light(14);
    inputLabel.textColor = COLOR_999;
    inputLabel.inputAccessoryView = commontView;
    inputLabel.delegate = self;
    
//    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesAction:)];
//    [inputLabel addGestureRecognizer:tapGes];
    
    topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 1)];
    topLine.backgroundColor = LINECOLOR;
    [self addSubview:topLine];
    
    [self addSubview:zanBtn];
    [self addSubview:shareBtn];
    [self addSubview:collectBtn];
    [self addSubview:replyCount];
    [self addSubview:inputLabel];

}

-(void)createInputContent
{
    commontView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 156)];
    commontView.backgroundColor = UIColorFromRGB(0xFAFAFA);
    inputView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, commontView.width - 20, 90)];
    inputView.placeholderColor = COLOR_999;
    inputView.placeholder      = @"请把你的节操留下";
    inputView.layer.cornerRadius = 6;
    inputView.layer.masksToBounds = YES;
    inputView.layer.borderColor = COLOR_DDD.CGColor;
    inputView.layer.borderWidth = 1;
    inputView.font = FONT_Light(16);
    inputView.textColor = COLOR_333;
    inputView.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
    [commontView addSubview:inputView];
    
    
    commitBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, inputView.bottom + 10, 85, 33)];
    commitBtn.right = inputView.right;
    commitBtn.backgroundColor = MAINCOLOR;
    commitBtn.layer.cornerRadius  = 6;
    commitBtn.layer.masksToBounds = YES;
    commitBtn.layer.borderWidth   = 1;
    commitBtn.layer.borderColor   = COLOR_999.CGColor;
    commitBtn.titleLabel.font     = FONT(14);
    [commitBtn setTitleColor:COLOR_666 forState:UIControlStateNormal];
    [commitBtn setTitle:@"发表" forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(makeComment:) forControlEvents:UIControlEventTouchUpInside];
    [commontView addSubview:commitBtn];
    
    
}

//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    
//}


-(void)setCommentCount:(NSInteger)commentCount
{
    _commentCount = commentCount;
    [replyCount setTitle:[NSString stringWithFormat:@"%ld",(long)_commentCount] forState:UIControlStateNormal];
    [replyCount setTitle:@"原文" forState:UIControlStateSelected];

}

-(void)setHasCollected:(BOOL)hasCollected
{
    _hasCollected       = hasCollected;
    collectBtn.selected = _hasCollected;
    
}

//-(void)tapGesAction:(UITapGestureRecognizer *)ges
//{
//    
//
//}

- (void)keyboardWasShown:(NSNotification *) notif
{
    if (inputLabel.isFirstResponder) {
        [inputView becomeFirstResponder];
        
        [KeyWindow addSubview:blackBack];
    }

}

- (void)keyboardWasHidden:(NSNotification *) notif
{
    [blackBack removeFromSuperview];
}

-(void)dealloc
{
    //移除键盘显示与消失的通知观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)makeComment:(UIButton *)sender
{
    if (ISEmpty(inputView.text)) {
        [APPServant makeToast:KeyWindow title:@"评论不能为空!" position:74];

        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(edReplyBar:addcomment:)]) {
        [_delegate edReplyBar:self addcomment:inputView.text];

        [KeyWindow endEditing:YES];
    }
    inputView.text = @"";

}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([APPServant isLogin]) {
        return YES;
    }else{
      //登陆
        [APPServant popLoginVCWithInfo:@"请先登录哦!"];
      return NO;
    }
}

-(void)collectionAction:(UIButton *)sender
{
    //限制按钮点击间隔2s
    NSInteger  currentTimeInterval = [[NSDate date] timeIntervalSince1970];
    if (currentTimeInterval - lastTapCollectBtn < 2) {
        return;
    }
    lastTapCollectBtn = currentTimeInterval;

    APPLOGINCHECK;

    if (collectBtn.selected) {
//        [APPServant makeToast:KeyWindow title:@"已取消收藏" position:74];
        if (_delegate && [_delegate respondsToSelector:@selector(edReplyBarCancelCollect:)]) {
            [_delegate edReplyBarCancelCollect:self];
            UMMobClick(@"detail_btn_bar_collect_cancel");
        }
        
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(edReplyBarCollect:)]) {
            [_delegate edReplyBarCollect:self];
            UMMobClick(@"detail_btn_bar_collect");
        }
    }

    
    collectBtn.selected = !collectBtn.selected;

    //收藏动画
    [collectBtn.layer addAnimation:[self zanAnimation] forKey:@"coll_animation"];

}

-(void)shareAction:(UIButton *)sender
{
//    APPLOGINCHECK; 分享不需要登录
    if (_delegate && [_delegate respondsToSelector:@selector(edReplyBarShare:)]) {
        [_delegate edReplyBarShare:self];
    }
}

-(void)zanAction:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(edReplyBarZan:)]) {
        [_delegate edReplyBarZan:self];
    }
}
-(void)jumpToComment:(UIButton *)sender
{
//    replyCount.selected = !replyCount.selected;
    if ([_delegate respondsToSelector:@selector(edReplyBar:jumpToComment:)]) {
        [_delegate edReplyBar:self jumpToComment:!replyCount.selected];
        UMMobClick(@"detail_btn_bar_reply");
    }
}

-(void)dismiss
{
    [KeyWindow endEditing:YES];
}

-(void)setBtnToReplyStyle:(BOOL)reply
{
    if (replyCount.selected == reply) {
        return;
    }
    replyCount.selected = reply;
}

-(CAKeyframeAnimation *)zanAnimation
{
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    keyAnima.keyPath=@"transform.scale";
    keyAnima.values=@[@1,@1.2,@1];
    keyAnima.duration=0.4;
    keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return keyAnima;
}


#pragma theme
-(void)themeCheck
{
    //重灾区 --!
    if ([APPServant servant].nightShift) {
        self.backgroundColor = COLOR_555;
        commontView.backgroundColor = UIColorFromRGB(0x262626);
        inputView.backgroundColor   = UIColorFromRGB(0x3F3F3F);
        inputLabel.backgroundColor  = UIColorFromRGB(0xBBBBBB);
        topLine.backgroundColor     = CLEARCOLOR;
        [replyCount setTitleColor:UIColorFromRGB(0xBBBBBB) forState:UIControlStateNormal];
        [shareBtn setTitleColor:UIColorFromRGB(0xBBBBBB) forState:UIControlStateNormal];
        UIImage *collNor = [UIImage iconWithInfo:TBCityIconInfoMake(collectIcon, 24, UIColorFromRGB(0xBBBBBB))];
        [collectBtn setImage:collNor forState:UIControlStateNormal];
        UIImage *reImage = [UIImage iconWithInfo:TBCityIconInfoMake(commentIcon, 24, UIColorFromRGB(0xBBBBBB))];
        [replyCount setImage:reImage forState:UIControlStateNormal];
    }else{
        self.backgroundColor = UIColorFromRGB(0xFAFAFA);
        commontView.backgroundColor = UIColorFromRGB(0xFAFAFA);
        inputView.backgroundColor   = WHITECOLOR;
        inputLabel.backgroundColor  = WHITECOLOR;
        topLine.backgroundColor = LINECOLOR;
        [replyCount setTitleColor:COLOR_333 forState:UIControlStateNormal];
        [shareBtn setTitleColor:COLOR_333 forState:UIControlStateNormal];
        UIImage *collNor = [UIImage iconWithInfo:TBCityIconInfoMake(collectIcon, 24, COLOR_666)];
        [collectBtn setImage:collNor forState:UIControlStateNormal];
        UIImage *reImage = [UIImage iconWithInfo:TBCityIconInfoMake(commentIcon, 24, COLOR_333)];
        [replyCount setImage:reImage forState:UIControlStateNormal];
    }
}


-(void)listReplyModel
{
    replyCount.hidden = YES;
    collectBtn.hidden = YES;
    shareBtn.hidden   = YES;
    zanBtn.hidden     = NO;
    inputLabel.width  = zanBtn.left - 10;
}

-(void)popReply
{
    [inputLabel becomeFirstResponder];
}
@end

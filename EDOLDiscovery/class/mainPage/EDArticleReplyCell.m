//
//  EDArticleReplyCell.m
//  EDOLDiscovery
//
//  Created by song on 17/1/13.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDArticleReplyCell.h"
#import "TYAttributedLabel.h"
#import "EDRoundImageView.h"
#import "EDSubCommentView.h"

@implementation EDArticleReplyCell
{
    EDRoundImageView *headIcon;
    UILabel          *userName;
    TYAttributedLabel *contentText;
    UILabel           *timeLabel;
    UIButton          *zanBtn;
    
    UIButton          *replyBtn;
    
    EDSubCommentView  *subCommentView;//子评论
    UIView            *bottomView;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}


-(void)createSubViews
{
    headIcon = [[EDRoundImageView alloc]init];
    userName = LABEL(FONT_Light(16), COLOR_666);
    //赞
    zanBtn   = [UIButton new];
    zanBtn.titleLabel.font = FONT_Light(14);
    [zanBtn setTitleColor:COLOR_666 forState:UIControlStateNormal];
    [zanBtn setTitleColor:COLOR_666 forState:UIControlStateSelected];

    UIImage *zanImageNor = [UIImage iconWithInfo:TBCityIconInfoMake(zanIcon, 14, COLOR_333)];
    UIImage *zanImageSel = [UIImage iconWithInfo:TBCityIconInfoMake(zanFillIcon, 14, COLOR_333)];

    zanBtn.adjustsImageWhenHighlighted = NO;
    [zanBtn setImage:zanImageNor forState:UIControlStateNormal];
    [zanBtn setImage:zanImageSel forState:UIControlStateSelected];
    [zanBtn addTarget:self action:@selector(zanAction:) forControlEvents:UIControlEventTouchUpInside];
    //回复
    replyBtn = [UIButton new];
    replyBtn.titleLabel.font = FONT_Light(14);
    [replyBtn setTitleColor:COLOR_666 forState:UIControlStateNormal];
    [replyBtn setTitle:@"回复" forState:UIControlStateNormal];
    [replyBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    contentText = [[TYAttributedLabel alloc]init];
    contentText.backgroundColor = CLEARCOLOR;
    
    timeLabel   = LABEL(FONT_Light(12), COLOR_999);
    
    [self.contentView addSubview:headIcon];
    [self.contentView addSubview:userName];
    [self.contentView addSubview:zanBtn];
    [self.contentView addSubview:replyBtn];
    [self.contentView addSubview:contentText];
    [self.contentView addSubview:timeLabel];
    [self createBottomView];
    [self createSubCommentView];
}
-(void)createSubCommentView
{
    subCommentView = [EDSubCommentView new];
    subCommentView.hidden = YES;
    subCommentView.backgroundColor = UIColorFromRGB(0xF8F8F8);
    [self.contentView addSubview:subCommentView];
}
-(void)createBottomView
{
    bottomView = [UIView new];
    bottomView.hidden = YES;
    bottomView.backgroundColor = WHITECOLOR;
    //大赞
    UIButton *bigZanBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 40)];
    UIImage *zanImageNor = [UIImage iconWithInfo:TBCityIconInfoMake(zanIcon, 20, COLOR_333)];
    UIImage *zanImageSel = [UIImage iconWithInfo:TBCityIconInfoMake(zanFillIcon, 20, COLOR_333)];
    [bigZanBtn setImage:zanImageNor forState:UIControlStateNormal];
    [bigZanBtn setImage:zanImageSel forState:UIControlStateSelected];
    [bigZanBtn setTitleColor:COLOR_333 forState:UIControlStateNormal];
    bigZanBtn.titleLabel.font = FONT(16);
    [bigZanBtn setTitle:@"999+" forState:UIControlStateNormal];
    [bottomView addSubview:bigZanBtn];
    
    //大回复
    UIButton *bigRepBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 40)];
    [bigRepBtn setTitleColor:COLOR_333 forState:UIControlStateNormal];
    bigRepBtn.titleLabel.font = FONT(16);
    [bigRepBtn setTitle:@"回复TA" forState:UIControlStateNormal];
    [bigRepBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];

    [bottomView addSubview:bigZanBtn];
    [bottomView addSubview:bigRepBtn];
    
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    topLine.backgroundColor = LINECOLOR;
    [bottomView addSubview:topLine];
    UIView *middleLine = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, 0.5, 40)];
    middleLine.backgroundColor = LINECOLOR;
    [bottomView addSubview:middleLine];
    
    [self.contentView addSubview:bottomView];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.height = self.height - 1;
    
    headIcon.frame = CGRectMake(10, 10, 32, 32);
    userName.frame = CGRectMake(headIcon.right + 18, 10, self.width - 100, 17);
    
    replyBtn.frame = CGRectMake(0, 0, 30, 17);
    replyBtn.right   = self.width - 10;
    replyBtn.centerY = userName.centerY;
    
    zanBtn.frame   = CGRectMake(0, 0, 44, 30);
    zanBtn.right   = replyBtn.left - 8;
    zanBtn.centerY = replyBtn.centerY;
    
    contentText.frame = CGRectMake(userName.left, userName.bottom + 8, self.width - 70, _model.textContainer.textHeight);
    timeLabel.frame  = CGRectMake(userName.left, contentText.bottom + 6, 200, 14);
    
    bottomView.frame  = CGRectMake(0, 0, self.width, 40);
    bottomView.bottom = self.height;
    
    subCommentView.frame = CGRectMake(contentText.left, timeLabel.bottom, contentText.width, _model.totalReplyHeight);
}


-(void)setModel:(EDArticleReplyModel *)model
{
    _model = model;
    [headIcon sd_setImageWithURL:[NSURL URLWithString:_model.headerIcon] placeholderImage:[UIImage imageNamed:@"default_userhead"]];
    if (NOTEmpty(_model.replyForName)) {
        userName.text = [NSString stringWithFormat:@"%@ 回复 %@",_model.nickname,_model.replyForName];
    }else{
        userName.text = _model.nickname;

    }
    
    [zanBtn setTitle:_model.commentReplyUpVoteCount forState:UIControlStateNormal];
    [zanBtn setTitle:_model.commentReplyUpVoteCount forState:UIControlStateSelected];

    zanBtn.selected = _model.upVoted;
    contentText.text = _model.textContainer.text;
    timeLabel.text = _model.commentTime;
    
    switch (_model.type) {
        case ReplyType_Top:
        {
            zanBtn.hidden     = YES;
            replyBtn.hidden   = YES;
            bottomView.hidden = NO;
        }
            break;
        case ReplyType_Group:
        {
            bottomView.hidden = YES;
            subCommentView.hidden = NO;
            subCommentView.dataSource = _model.replyList;
        }
            break;
            
        default:
            break;
    }
    

}
//赞
-(void)zanAction:(UIButton *)sender
{
    //判断已赞过
    if (zanBtn.selected) {
        [APPServant makeToast:KeyWindow title:@"已赞过" position:74];
        return;
    }
    UMMobClick(@"detail_btn_zan");

    //赞动画
    [zanBtn.layer addAnimation:[self zanAnimation] forKey:@"zan_animation"];

    
    //先把评论加上去
    NSInteger count = [_model.commentReplyUpVoteCount integerValue] + 1;
    _model.commentReplyUpVoteCount = [NSString stringWithFormat:@"%ld",(long)count];
    zanBtn.selected = YES;
    _model.upVoted = YES;
    [zanBtn setTitle:_model.commentReplyUpVoteCount forState:UIControlStateNormal];
    [zanBtn setTitle:_model.commentReplyUpVoteCount forState:UIControlStateSelected];

    //只有登录才调接口
    if (![APPServant isLogin]) {
        return;
    }
    
    NSDictionary *paramDic = @{@"infoId":_model.infoId,
                               @"commentId":_model.commentId,
                               @"voteInfoType":@(2),//1文章，2评论
                               @"voteType":@(1)     //1赞，2踩
                               };
    [[HttpRequestManager manager] GET:EDCommentZan parameters:paramDic success:^(NSURLSessionDataTask * task,id responseObject)
     {
         NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         NSLog(@"获取成功:%@",dic);
         if ([[dic objectForKey:@"code"] integerValue] == 200) {
                //赞成功

         }else{
             NSString *msg = [NetDataCommon stringFromDic:dic forKey:@"msg"];
             [APPServant makeToast:KeyWindow title:msg position:74];

         }
     }failure:^(NSURLSessionDataTask * task,NSError *errpr)
     {
         NSLog(@"failuer");
     }];
}

-(CAKeyframeAnimation *)zanAnimation
{
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    keyAnima.keyPath=@"transform.scale";
    keyAnima.values=@[@1,@1.3,@1];
    keyAnima.duration=0.4;
    keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return keyAnima;
}


-(void)replyAction:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(replyComment:)]) {
        [_delegate replyComment:_model];
    }
}

#pragma theme
-(void)themeCheck
{
    [super themeCheck];
    if ([APPServant servant].nightShift) {
        contentText.textColor = COLOR_A9;
        
    }else{
        contentText.textColor = COLOR_333;
        
    }
}
@end

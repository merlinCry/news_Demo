//
//  EDHomeFunCell.m
//  EDOLDiscovery
//
//  Created by song on 17/1/4.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDHomeFunCell.h"
#import "TYAttributedLabel.h"
#import "EDPhotoBrower.h"
@interface EDHomeFunCell ()
{
    TYAttributedLabel *textLabel;//标题
    TYAttributedLabel *content;  //内容
    UIView *imageContainer;
    UIView *bottomBar;
    
    UIButton *zanBtn;
    UIButton *commentBtn;
    UIButton *collectBtn;
    UIButton *shareBtn;
    
    EDPhotoBrower *brower;
    
    UILabel *tagTipLabel;
}

@end

@implementation EDHomeFunCell

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
    textLabel = [TYAttributedLabel new];
    textLabel.font = FONT_Light(16);
    textLabel.textColor = T_TITLE_COLOR;
    textLabel.numberOfLines = 4;
    textLabel.linesSpacing  = 1;
    textLabel.characterSpacing = 1;
    textLabel.backgroundColor = CLEARCOLOR;
    [self.contentView addSubview:textLabel];
 
    content = [TYAttributedLabel new];
    content.font      = FONT_Light(15);
    content.textColor = T_TITLE_COLOR;
    content.numberOfLines = 4;
    content.linesSpacing  = 1;
    content.characterSpacing = 1;
    content.hidden = YES;
    content.backgroundColor = CLEARCOLOR;
    [self.contentView addSubview:content];
    
    imageContainer = [UIView new];
    imageContainer.backgroundColor = CLEARCOLOR;
    [self.contentView addSubview:imageContainer];
    
    tagTipLabel = LABEL(FONT_Light(12),COLOR_333);
    tagTipLabel.textAlignment = NSTextAlignmentCenter;
    tagTipLabel.backgroundColor = MAINCOLOR;
    tagTipLabel.text = @"动图";
    tagTipLabel.hidden = YES;
    [self.contentView addSubview:tagTipLabel];
    
    bottomBar = [UIView new];
    bottomBar.backgroundColor = CLEARCOLOR;
    [self.contentView addSubview:bottomBar];
    
    
    //按钮
    zanBtn = [UIButton new];
    zanBtn.titleLabel.font = FONT_Light(18);
    zanBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [zanBtn setTitleColor:COLOR_666 forState:UIControlStateNormal];
    UIImage *zanNor = [UIImage iconWithInfo:TBCityIconInfoMake(zanIcon, 20, COLOR_666)];
//    UIImage *zanSel = [UIImage iconWithInfo:TBCityIconInfoMake(zanFillIcon, 20, MAINCOLOR)];
    UIImage *zanSel = [UIImage imageNamed:@"zanBorder"];

    [zanBtn setImage:zanNor forState:UIControlStateNormal];
    zanBtn.adjustsImageWhenHighlighted = NO;
    [zanBtn setImage:zanSel forState:UIControlStateSelected];
    [zanBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:zanBtn];
    
    //评论
    commentBtn = [UIButton new];
    commentBtn.adjustsImageWhenHighlighted = NO;
    commentBtn.titleLabel.font = FONT_Light(18);
    commentBtn.titleEdgeInsets = UIEdgeInsetsMake(-1, 1, 0, 0);
    commentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [commentBtn setTitleColor:COLOR_666 forState:UIControlStateNormal];
    UIImage *commentImg = [UIImage iconWithInfo:TBCityIconInfoMake(commentIcon, 20, COLOR_666)];
    [commentBtn setImage:commentImg forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:commentBtn];
    
    //收藏
    collectBtn = [UIButton new];
    collectBtn.right = shareBtn.left;
    collectBtn.titleLabel.font = ICONFONT(22);
//    [collectBtn setTitle:collectIcon forState:UIControlStateNormal];
//    [collectBtn setTitle:collectfillIcon forState:UIControlStateSelected];
    UIImage *collNor = [UIImage iconWithInfo:TBCityIconInfoMake(collectIcon, 22, COLOR_666)];
    UIImage *colSel  = [UIImage imageNamed:@"collectBorder"];
    [collectBtn setImage:collNor forState:UIControlStateNormal];
    [collectBtn setImage:colSel forState:UIControlStateSelected];

    [collectBtn setTitleColor:COLOR_333 forState:UIControlStateNormal];
    [collectBtn setTitleColor:MAINCOLOR forState:UIControlStateSelected];

    [collectBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:collectBtn];

//    //分享
//    shareBtn = [UIButton new];
//    shareBtn.titleLabel.font = ICONFONT(20);
//    [shareBtn setTitle:shareIcon forState:UIControlStateNormal];
//    [shareBtn setTitleColor:COLOR_333 forState:UIControlStateNormal];
//    [shareBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:shareBtn];
    
    
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.height = self.height - 0.5;
    //标题
    textLabel.frame = CGRectMake(18, 18, self.contentView.width - 36, _model.textContainer.textHeight);
    //内容（没有图片的时候展示）
    content.frame   = CGRectMake(18, textLabel.bottom + 5, self.contentView.width - 36,_model.contentContainer.textHeight);
    imageContainer.frame = CGRectMake(18, textLabel.bottom + 5, _model.imageContainerSize.width, _model.imageContainerSize.height);
    tagTipLabel.frame = CGRectMake(0, 0, 36, 20);
    tagTipLabel.right = imageContainer.right;
    tagTipLabel.bottom = imageContainer.bottom;
    
    bottomBar.frame = CGRectMake(0, 0, self.contentView.width, 40);
    bottomBar.bottom =self.contentView.height;
    
    
    zanBtn.frame     = CGRectMake(18, 7.5, 60, 25);
    commentBtn.frame = CGRectMake(zanBtn.right + 20, 7.5, 60, 25);
    
//    shareBtn.frame = CGRectMake(0, 7.5, 25, 25);
//    shareBtn.right = self.width - 18;
    
//    collectBtn.frame = CGRectMake(0, 7.5, 25, 25);
//    collectBtn.right = self.width - 56;
    
    collectBtn.frame = CGRectMake(0, 7.5, 25, 25);
    collectBtn.right = self.width - 18;

}



-(void)setModel:(EDHomeFunModel *)model
{
    _model = model;
    textLabel.text = _model.textContainer.text;
    content.text   = _model.contentContainer.text;
    
    zanBtn.selected = _model.upVoted;
    [zanBtn setTitle:_model.upVoteCount forState:UIControlStateNormal];
    [zanBtn setTitle:_model.upVoteCount forState:UIControlStateSelected];

    [commentBtn setTitle:_model.commentCount forState:UIControlStateNormal];
    collectBtn.selected = _model.collected;
    
    //图片部分
    [self handelImage];
    
}

-(void)handelImage
{
    tagTipLabel.hidden = YES;
    for (UIView *view in imageContainer.subviews) {
        [view  removeFromSuperview];
    }
    
    content.hidden = YES;
    if (ISEmpty(_model.imageList)) {
        content.hidden = NO;
        return;
    }
    
    
    CGFloat picSize = (SCREEN_WIDTH - 18*2 - 8*2)/3;
    if (_model.imageList.count == 1) {
        EDBaseImageView *imageView = [[EDBaseImageView alloc]initWithFrame:CGRectZero];
        imageView.tag = 100;
        imageView.size = _model.imageContainerSize;
        ImageInfo *imgInfo = _model.imageList[0];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imgInfo.img] placeholderImage:[UIImage imageNamed:@"default_tem_one"]];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesAction:)];
        [imageView addGestureRecognizer:tapGes];
        [imageContainer addSubview:imageView];
        tagTipLabel.hidden = !imgInfo.isGif;
        
    }else if(_model.imageList.count == 4 ){
        
        for (NSInteger i = 0; i<_model.imageList.count; i++) {
            CGFloat x = (i%2) * (picSize + 8);
            CGFloat y = (i/2) * (picSize + 8);
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, picSize, picSize)];
            imageView.tag = 100 + i;
            imageView.userInteractionEnabled = YES;
            ImageInfo *imgInfo = _model.imageList[i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imgInfo.img] placeholderImage:[UIImage imageNamed:@"default_tem_small"]];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesAction:)];
            [imageView addGestureRecognizer:tapGes];
            [imageContainer addSubview:imageView];
        }
        
    }else{
        //九宫格
        for (NSInteger i = 0; i<_model.imageList.count; i++) {
            CGFloat x = (i%3) * (picSize + 8);
            CGFloat y = (i/3) * (picSize + 8);
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, picSize, picSize)];
            imageView.tag = 100 + i;
            imageView.userInteractionEnabled = YES;
            ImageInfo *imgInfo = _model.imageList[i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imgInfo.img] placeholderImage:[UIImage imageNamed:@"default_tem_small"]];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesAction:)];
            [imageView addGestureRecognizer:tapGes];
            [imageContainer addSubview:imageView];
        }
    }
        
}

-(void)btnAction:(UIButton *)sender
{
    if ([sender isEqual:zanBtn]) {
        [self zanArticl];
        
    }else if([sender isEqual:commentBtn]){
        
    }else if([sender isEqual:collectBtn]){
        [self collectArticl];
    }else if([sender isEqual:shareBtn]){
        
    }
}

//点击图片
-(void)tapGesAction:(UITapGestureRecognizer *)ges
{
    UIImageView *touchImageView = (UIImageView *)ges.view;
    UIImageView *startView = [UIImageView new];
    startView.clipsToBounds = YES;
    startView.contentMode = UIViewContentModeScaleAspectFill;
    startView.frame = touchImageView.frame;
    startView.image = touchImageView.image;
    
    
    if (!brower) {
        brower = [[EDPhotoBrower alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    brower.photoArr  = [NSArray arrayWithArray:_model.imageList];
    brower.startView = startView;
    [brower show:imageContainer imgIndex:touchImageView.tag - 100];
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

//赞帖子
-(void)zanArticl
{
    //判断已赞过
    if (zanBtn.selected) {
        [APPServant makeToast:KeyWindow title:@"已赞过" position:74];
        return;
    }
    UMMobClick(@"detail_btn_gaoxiao_zan");
    //赞动画
    [zanBtn.layer addAnimation:[self zanAnimation] forKey:@"zan_animation"];
    //先把评论加上去
    NSInteger count = [_model.upVoteCount integerValue] + 1;
    _model.upVoteCount = [NSString stringWithFormat:@"%ld",(long)count];
    zanBtn.selected = YES;
    _model.upVoted  = YES;
    [zanBtn setTitle:_model.upVoteCount forState:UIControlStateNormal];
    [zanBtn setTitle:_model.upVoteCount forState:UIControlStateSelected];

    //只有登录才调接口
    if (![APPServant isLogin]) {
        return;
    }
    
    NSDictionary *paramDic = @{
                               @"infoId":_model.infoId,
                               @"voteInfoType":@(1),//1文章，2评论
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

//收藏
-(void)collectArticl
{
    APPLOGINCHECK;
    if (collectBtn.selected) {
//        [APPServant makeToast:KeyWindow title:@"已收藏过" position:74];
//        return;
        [self cancelCollectAction];
    }else{
        [self collectAction];
    }
    //赞动画
    [collectBtn.layer addAnimation:[self zanAnimation] forKey:@"collect_animation"];
}
-(void)collectAction
{
    UMMobClick(@"detail_btn_gaoxiao_collect");
    collectBtn.selected    = YES;
    NSDictionary *paramDic = @{
                               @"infoId":_model.infoId,
                               @"channelId":_model.channelId
                               };
    [[HttpRequestManager manager] GET:Aricl_favoritesAdd parameters:paramDic success:^(NSURLSessionDataTask * task,id responseObject)
     {
         NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         NSLog(@"获取成功:%@",dic);
         if ([[dic objectForKey:@"code"] integerValue] == 200) {
             //收藏成功
             
         }else{
             NSString *msg = [NetDataCommon stringFromDic:dic forKey:@"msg"];
             [APPServant makeToast:KeyWindow title:msg position:74];
             
         }
     }failure:^(NSURLSessionDataTask * task,NSError *errpr)
     {
         NSLog(@"failuer");
     }];
}
-(void)cancelCollectAction
{
    UMMobClick(@"detail_btn_bar_collect_cancel");
    collectBtn.selected    = NO;
    NSDictionary *paramDic = @{
                               @"infoId":_model.infoId
                               };
    [[HttpRequestManager manager] GET:Aricl_favoritesCancel parameters:paramDic success:^(NSURLSessionDataTask * task,id responseObject)
     {
         NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         
         if ([[dic objectForKey:@"rescode"] integerValue] == 200) {
             //             [APPServant makeToast:self.view title:[NetDataCommon stringFromDic:dic forKey:@"msg"] position:74];
             
         }
     }failure:^(NSURLSessionDataTask * task,NSError *errpr)
     {
         NSLog(@"failuer");
         [APPServant makeToast:KeyWindow title:NETWOTK_ERROR_STATUS position:74];
         
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

#pragma theme
-(void)themeCheck
{
    [super themeCheck];
    textLabel.textColor = T_TITLE_COLOR;
    content.textColor   = T_TITLE_COLOR;

}

@end

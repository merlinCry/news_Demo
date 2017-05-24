//
//  EDHud.m
//  EDOLDiscovery
//
//  Created by song on 17/1/17.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDHud.h"
@interface EDHud()
{
    UIView *contentView;
    UIButton *closeBtn;
    UILabel  *tipLabel;
    
}
@property(nonatomic,strong)UIImageView *animateImageView;

@end
@implementation EDHud

+(instancetype)shareInstance
{
    static dispatch_once_t once;
    
    static EDHud *sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [[EDHud alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        sharedInstance.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        [sharedInstance createSubViews];
    });
    
    return sharedInstance;
}

-(void)createSubViews
{
    contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 70)];
    contentView.center = CGPointMake(self.width/2, self.height/2 - 20);
    contentView.backgroundColor = WHITECOLOR;
    contentView.layer.cornerRadius = 10;
    contentView.layer.masksToBounds = YES;
    [self addSubview:contentView];
    
    
    closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, -2, 30, 30)];
    closeBtn.backgroundColor = CLEARCOLOR;
    [closeBtn setTitleColor:COLOR_999 forState:UIControlStateNormal];
    closeBtn.right = contentView.width+2;
//    closeBtn.layer.cornerRadius  = 18;
//    closeBtn.layer.masksToBounds = YES;
    closeBtn.titleLabel.font = ICONFONT(14);
    closeBtn.adjustsImageWhenHighlighted = YES;
    [closeBtn setTitle:closeIcon forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:closeBtn];
    
    tipLabel = LABEL(FONT_Light(16), COLOR_999);
    tipLabel.frame = CGRectMake(0, 0, 70, 20);
    tipLabel.left  = contentView.width/2 + 6;
    tipLabel.centerY = contentView.height/2;
    tipLabel.text = @"加载中...";
    [contentView addSubview:tipLabel];
    
    _animateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 0, 50, 50)];
    _animateImageView.centerY = contentView.height/2;
    NSMutableArray *tmpArr = [NSMutableArray new];
    for (NSUInteger i = 0; i<50; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"music_000%02ld",(long)i]];
        [tmpArr addObject:image];
    }
    _animateImageView.animationImages = tmpArr;
    _animateImageView.animationRepeatCount = 999;

    _animateImageView.backgroundColor = CLEARCOLOR;
    [contentView addSubview:_animateImageView];
    
}

+(void)setLoadingImages:(NSArray *)imageArr
{
    EDHud *hud = [EDHud shareInstance];

    if (NOTEmpty(imageArr)) {
        NSMutableArray *tmpArr = [NSMutableArray new];
        for (NSString *imgName in imageArr) {
            UIImage *image = [UIImage imageNamed:imgName];
            [tmpArr addObject:image];
        }
        hud.animateImageView.animationRepeatCount = MAXFLOAT;
        hud.animateImageView.animationImages = tmpArr;

    }

}

+(void)show
{
    EDHud *hud = [EDHud shareInstance];
    [KeyWindow addSubview:hud];
    [hud.animateImageView startAnimating];
}

+(void)dismiss
{
    EDHud *hud = [EDHud shareInstance];
    [hud.animateImageView stopAnimating];
    [hud removeFromSuperview];
}

-(void)btnAction:(UIButton *)sender
{
    [self removeFromSuperview];
}


@end

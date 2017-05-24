//
//  EDMainColorBtn.m
//  EDOLDiscovery
//
//  Created by song on 17/1/6.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDMainColorBtn.h"

@implementation EDMainColorBtn
{
    UIView *shadow;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

-(void)createSubViews
{
    //登录按钮
    CGRect btnFrame = self.bounds;
    shadow = [[UIView alloc] initWithFrame:CGRectMake(2, 0, btnFrame.size.width - 4, btnFrame.size.height)];
    shadow.backgroundColor     = MAINCOLOR;
    shadow.layer.shadowColor   = MAINCOLOR.CGColor;
    shadow.layer.shadowRadius  = 4;
    shadow.layer.shadowOffset  = CGSizeMake(-1, 2);
    shadow.layer.shadowOpacity = 1;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(3, 2, btnFrame.size.width - 6, btnFrame.size.height-2) cornerRadius:4];
    shadow.layer.shadowPath    = path.CGPath;
    [self addSubview:shadow];
    
    _contentBtn = [[UIButton alloc]initWithFrame:btnFrame];
    _contentBtn.backgroundColor = MAINCOLOR;
    _contentBtn.titleLabel.font = FONT_Light(16);
    [_contentBtn setTitleColor:COLOR_666 forState:UIControlStateNormal];
    _contentBtn.adjustsImageWhenHighlighted = NO;
    _contentBtn.layer.borderColor = COLOR_666.CGColor;
    _contentBtn.layer.borderWidth   = 1;
    _contentBtn.layer.cornerRadius  = 4;
    _contentBtn.layer.masksToBounds = YES;

    [self addSubview:_contentBtn];
}

-(void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    
    _contentBtn.backgroundColor = _tintColor;
    shadow.backgroundColor      = _tintColor;
    shadow.layer.shadowColor    = _tintColor.CGColor;
}

@end

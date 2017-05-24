//
//  EDRegisterStepView.m
//  EDOLDiscovery
//
//  Created by song on 17/1/6.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDRegisterStepView.h"

@implementation EDRegisterStepView
{
    UILabel *titleL;
    UILabel *titleM;
    UILabel *titleR;
    
    UIView  *lineL;
    UIView  *lineR;

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
    titleL = LABEL(FONT_Light(11), COLOR_333);
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.frame   = CGRectMake(0, 0, 18, 18);
    titleL.centerX = 30;
    titleL.layer.cornerRadius  = 9;
    titleL.layer.masksToBounds = YES;
    titleL.text = @"1";

    titleM = LABEL(FONT_Light(11), COLOR_333);
    titleM.textAlignment = NSTextAlignmentCenter;
    titleM.frame = CGRectMake(0, 0, 18, 18);
    titleM.centerX = self.width/2;
    titleM.layer.cornerRadius  = 9;
    titleM.layer.masksToBounds = YES;
    titleM.text = @"2";


    titleR = LABEL(FONT_Light(11), COLOR_333);
    titleR.textAlignment = NSTextAlignmentCenter;
    titleR.frame = CGRectMake(0, 0, 18, 18);
    titleR.centerX = self.width - 30;
    titleR.layer.cornerRadius  = 9;
    titleR.layer.masksToBounds = YES;
    titleR.text = @"3";

    CGFloat lineW = titleM.centerX - titleL.centerX;
    lineL = [[UIView alloc]initWithFrame:CGRectMake(titleL.centerX, 0, lineW, 5)];
    lineL.backgroundColor = COLOR_EEE;
    lineL.centerY = titleL.centerY;
    
    lineR = [[UIView alloc]initWithFrame:CGRectMake(titleM.centerX, 0, lineW, 5)];
    lineR.backgroundColor = COLOR_EEE;
    lineR.centerY = titleL.centerY;
    
    
    CGFloat textTop = titleL.bottom + 7;
    _textL = LABEL(FONT_Light(14), T_TITLE_COLOR);
    _textL.textAlignment   = NSTextAlignmentCenter;
    _textL.frame = CGRectMake(0, textTop, 60, 18);
    
    _textM = LABEL(FONT_Light(14), T_TITLE_COLOR);
    _textM.textAlignment   = NSTextAlignmentCenter;
    _textM.frame = CGRectMake(0, textTop, 70, 18);
    _textM.centerX = titleM.centerX;

    _textR = LABEL(FONT_Light(14), T_TITLE_COLOR);
    _textR.textAlignment   = NSTextAlignmentCenter;
    _textR.frame = CGRectMake(0, textTop, 60, 18);
    _textR.right = self.width;
    
    [self addSubview:lineL];
    [self addSubview:lineR];
    [self addSubview:titleL];
    [self addSubview:titleM];
    [self addSubview:titleR];
    
    [self addSubview:_textL];
    [self addSubview:_textM];
    [self addSubview:_textR];

}


-(void)setStep:(RegisterStep)step
{
    _step = step;
    switch (step) {
        case RegisterStep_L:
        {
            titleL.backgroundColor = MAINCOLOR;
            titleM.backgroundColor = COLOR_EEE;
            titleR.backgroundColor = COLOR_EEE;
            lineL.backgroundColor  = COLOR_EEE;
            lineR.backgroundColor  = COLOR_EEE;

        }
            break;
        case RegisterStep_M:
        {
            titleL.backgroundColor = MAINCOLOR;
            titleM.backgroundColor = MAINCOLOR;
            titleR.backgroundColor = COLOR_EEE;
            lineL.backgroundColor  = MAINCOLOR;
            lineR.backgroundColor  = COLOR_EEE;
        }
            break;
        case RegisterStep_R:
        {
            titleL.backgroundColor = MAINCOLOR;
            titleM.backgroundColor = MAINCOLOR;
            titleR.backgroundColor = MAINCOLOR;
            lineL.backgroundColor  = MAINCOLOR;
            lineR.backgroundColor  = MAINCOLOR;
        }
            break;
            
        default:
            break;
    }
}

@end

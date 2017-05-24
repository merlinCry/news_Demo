//
//  EDIConBtn.m
//  EDOLDiscovery
//
//  Created by song on 17/1/6.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDIConBtn.h"
@interface EDIConBtn ()
{
    UILabel     *imageLabel;
    UILabel     *backgroundLabel;
    UILabel     *titleLable;
    
}

@end

@implementation EDIConBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self createSubViews];
    }
    return self;
}

-(void)createSubViews
{
    //default font  40    color   333
    backgroundLabel = LABEL(ICONFONT(40), COLOR_333);
    backgroundLabel.textAlignment  = NSTextAlignmentCenter;
    backgroundLabel.userInteractionEnabled = YES;
    
    imageLabel      = LABEL(ICONFONT(20), COLOR_666);
    imageLabel.textAlignment  = NSTextAlignmentCenter;
    imageLabel.userInteractionEnabled = YES;

    titleLable      = LABEL(FONT_Light(14), COLOR_333);
    titleLable.textAlignment  = NSTextAlignmentCenter;
    titleLable.userInteractionEnabled = YES;

    [self addSubview:backgroundLabel];
    [self addSubview:imageLabel];
    [self addSubview:titleLable];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
   //默认纵向排列
    backgroundLabel.frame = CGRectMake(0, 0, self.width, self.width);
    
    imageLabel.frame      = CGRectMake(0, 0, self.width, self.width);
    
    titleLable.hidden     = YES;
    if (NOTEmpty(_title)) {
        titleLable.hidden = NO;
        titleLable.frame      = CGRectMake(0, backgroundLabel.bottom + 5, self.width, 16);

    }
    //横向 待续.....
}

-(void)setImageText:(NSString *)imageText
{
    _imageText      = imageText;
    imageLabel.text = _imageText;
}

-(void)setBackgroundImageText:(NSString *)backgroundImageText
{
    _backgroundImageText = backgroundImageText;
    backgroundLabel.text = _backgroundImageText;
}

-(void)setTitle:(NSString *)title
{
    _title          = title;
    titleLable.text = _title;
    
}
-(void)setImageFontSize:(CGFloat)imageFontSize
{
    _imageFontSize = imageFontSize;
    imageLabel.font = ICONFONT(_imageFontSize);
}

-(void)setBackFontSize:(CGFloat)backFontSize
{
    _backFontSize = backFontSize;
    backgroundLabel.font = ICONFONT(_backFontSize);
    
}

-(void)setImageColor:(UIColor *)imageColor
{
    _imageColor = imageColor;
    imageLabel.textColor = _imageColor;
    
}

-(void)setBackgroundImageColor:(UIColor *)backgroundImageColor
{
    _backgroundImageColor = backgroundImageColor;
    backgroundLabel.textColor = _backgroundImageColor;
}


-(void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    titleLable.textColor = _titleColor;
    
}

@end

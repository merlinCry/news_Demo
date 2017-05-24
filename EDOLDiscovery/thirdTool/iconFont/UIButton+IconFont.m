//
//  UIButton+IconFont.m
//  SaleForIos
//
//  Created by bianjianfeng on 16/12/17.
//
//

#import "UIButton+IconFont.h"

#pragma mark - 字体名称
NSString * const iconFontName = @"bsi";

@implementation UIButton (IconFont)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (void)setTitleFontSize:(CGFloat)size {
    self.titleLabel.font = [UIFont fontWithName:iconFontName size:size];
}

- (void)setTitleIconFontTitle:(NSString *)title
                    titleSize:(CGFloat)size
                  normalColor:(UIColor *)titleNormalColor
                selectedColor:(UIColor *)selectedColor
{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleFontSize:size];
    [self setTitleColor:titleNormalColor forState:UIControlStateNormal];
    [self setTitleColor:selectedColor forState:UIControlStateSelected];
}

@end

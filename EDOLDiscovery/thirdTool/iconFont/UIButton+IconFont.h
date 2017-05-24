//
//  UIButton+IconFont.h
//  SaleForIos
//
//  Created by bianjianfeng on 16/12/17.
//
//

#import <UIKit/UIKit.h>

extern NSString * const iconFontName;

@interface UIButton (IconFont)

- (void)setTitleFontSize:(CGFloat)size;


- (void)setTitleIconFontTitle:(NSString *)title
                    titleSize:(CGFloat)size
                  normalColor:(UIColor *)titleNormalColor
                selectedColor:(UIColor *)selectedColor;

@end

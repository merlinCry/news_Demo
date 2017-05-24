//
//  UIButton+ED.m
//  EDOLDiscovery
//
//  Created by song on 16/12/24.
//  Copyright © 2016年 song. All rights reserved.
//

#import "UIButton+ED.h"

@implementation UIButton (ED)

-(void)setNormalTitle:(NSString *)title titleColor:(UIColor *)color
{
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateNormal];
}
-(void)setSelectTitle:(NSString *)title
           titleColor:(UIColor *)color
{
    [self setTitleColor:color forState:UIControlStateSelected];
    [self setTitle:title      forState:UIControlStateSelected];
}

@end

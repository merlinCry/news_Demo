//
//  UIColor+ED.m
//  EDOLDiscovery
//
//  Created by song on 17/1/3.
//  Copyright © 2017年 song. All rights reserved.
//

#import "UIColor+ED.h"

@implementation UIColor (ED)

+ (UIColor*)randomColor
{
    
    CGFloat red   = (arc4random() %256/256.0);
    
    CGFloat blue  = (arc4random() %256/256.0);
    
    CGFloat green = (arc4random() %256/256.0);
    
    UIColor*color = [UIColor colorWithRed:red green:blue blue:green alpha:1];
    
    return color;
    
}

@end

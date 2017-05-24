//
//  EDPlaceholderTextField.m
//  EDOLDiscovery
//
//  Created by fang Zhou on 2017/4/27.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDPlaceholderTextField.h"

@implementation EDPlaceholderTextField

- (void)drawPlaceholderInRect:(CGRect)rect{
    if (!_placeholderColor) {
        return;
    }
    [_placeholderColor setFill];
    
    if (!_placeholderFont) {
        return;
    }
    
    [[self placeholder] drawInRect:rect withAttributes:@{NSFontAttributeName:_placeholderFont,NSForegroundColorAttributeName:_placeholderColor}];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds{
    CGFloat leftSpace = self.leftView?(bounds.origin.x+self.leftView.right+10) :(bounds.origin.x+25);
    
    if (_leftNotSpace) {
        leftSpace = self.leftView?(bounds.origin.x+self.leftView.right) :(bounds.origin.x+25);
    }
    
    CGRect inset = CGRectMake(leftSpace, bounds.origin.y+2, bounds.size.width-50, bounds.size.height-8);//更好理解些
    return inset;
}

@end

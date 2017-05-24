//
//  UIImage+ED.h
//  EDOLDiscovery
//
//  Created by song on 16/12/24.
//  Copyright © 2016年 song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ED)
+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

//需要夜间模式的image
+ (UIImage *)n_imageNamed:(NSString *)name;

@end

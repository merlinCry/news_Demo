//
//  EDHud.h
//  EDOLDiscovery
//
//  Created by song on 17/1/17.
//  Copyright © 2017年 song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EDHud : UIView
+(instancetype)shareInstance;

+(void)setLoadingImages:(NSArray *)imageArr;

+(void)show;

+(void)dismiss;
@end

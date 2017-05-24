//
//  EDEvaluateView.h
//  EDOLDiscovery
//
//  Created by Zhoufang on 17/3/27.
//  Copyright © 2017年 song. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, EDEViewTag) {
    edEvaluate = 0,
};

@interface EDEvaluateView : UIView

+ (void)showViewWithTag:(EDEViewTag)edETag;
+ (BOOL)checkNeedEvaluate;

@end

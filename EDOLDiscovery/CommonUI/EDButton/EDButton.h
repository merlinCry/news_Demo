//
//  EDButton.h
//  EDOLDiscovery
//
//  Created by song on 17/1/5.
//  Copyright © 2017年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
//方向只title的位置
typedef NS_ENUM(NSInteger,EDButtonStyle) {
    EDButtonStyleRight = 0,//默认 title右
    EDButtonStyleUP,
    EDButtonStyleLeft,
    EDButtonStyleDown,
    
};

@interface EDButton : UIButton


@property (nonatomic, assign)EDButtonStyle style;

@end

//
//  EDIConBtn.h
//  EDOLDiscovery
//
//  Created by song on 17/1/6.
//  Copyright © 2017年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,EDIconButtonStyle) {
   EDIconButtonStyle_V = 0,//纵向排列
   EDIconButtonStyle_H,    //横向排列
};

@interface EDIConBtn : UIView

@property (nonatomic, strong)NSString *imageText;
@property (nonatomic, strong)NSString *backgroundImageText;
@property (nonatomic, strong)NSString *title;


@property (nonatomic, strong)UIColor *imageColor;
@property (nonatomic, strong)UIColor *backgroundImageColor;
@property (nonatomic, strong)UIColor *titleColor;


@property (nonatomic, assign)CGFloat imageFontSize;
@property (nonatomic, assign)CGFloat backFontSize;


@property (nonatomic, assign)EDIconButtonStyle style;


@end

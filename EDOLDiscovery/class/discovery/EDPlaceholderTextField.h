//
//  EDPlaceholderTextField.h
//  EDOLDiscovery
//
//  Created by fang Zhou on 2017/4/27.
//  Copyright © 2017年 song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EDPlaceholderTextField : UITextField

@property (nonatomic,strong) UIColor *placeholderColor;
@property (nonatomic,strong) UIFont  *placeholderFont;

@property (nonatomic,assign) BOOL     leftNotSpace;

@end

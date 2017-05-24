//
//  EDVerifyCodeView.h
//  EDOLDiscovery
//
//  Created by song on 17/1/12.
//  Copyright © 2017年 song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EDVerifyCodeView : UIView


@property (nonatomic, strong)UITextField *linkTextField;

//1:注册;2:重置密码;3:短信验证码登录
@property (nonatomic, assign)NSInteger codeType;
@end

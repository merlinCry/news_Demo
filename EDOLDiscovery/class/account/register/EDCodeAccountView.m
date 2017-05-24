//
//  EDCodeAccountView.m
//  EDOLDiscovery
//
//  Created by song on 17/1/6.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDCodeAccountView.h"
#import "EDVerifyCodeView.h"

@interface EDCodeAccountView ()
{
    UIView           *contentView;
    UITextField      *account;
    UITextField      *password;
    EDVerifyCodeView *codeView;
}

@end
@implementation EDCodeAccountView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews
{
    contentView = [[UIView alloc]initWithFrame:self.bounds];
    contentView.layer.cornerRadius  = 4;
    contentView.layer.masksToBounds = YES;
    contentView.layer.borderColor   = UIColorFromRGB(0xDDDDDD).CGColor;
    contentView.layer.borderWidth   = 1;
    contentView.backgroundColor     = UIColorFromRGB(0xDDDDDD);
    [self addSubview:contentView];
    
    
    account = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height/2)];
    account.backgroundColor = WHITECOLOR;
    account.textColor   = COLOR_333;
    account.placeholder = @"手机号";
    account.font        = FONT_Light(14);
    account.keyboardType = UIKeyboardTypeNumberPad;
    
    UIImageView *accLeft = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    accLeft.backgroundColor = CLEARCOLOR;
    accLeft.contentMode = UIViewContentModeScaleAspectFit;
    
    UIImage *limg = [UIImage iconWithInfo:TBCityIconInfoMake(mobileIcon, 20, COLOR_333)];
    accLeft.image = limg;
    account.leftView = accLeft;
    account.leftViewMode = UITextFieldViewModeAlways;
    [contentView addSubview:account];
    
    
    password = [[UITextField alloc]initWithFrame:CGRectMake(0, self.height/2+1, self.width, self.height/2 - 1)];
    password.backgroundColor = WHITECOLOR;
    password.textColor       = COLOR_333;
    password.placeholder     = @"验证码";
    password.font            = FONT_Light(14);
    password.keyboardType = UIKeyboardTypeNumberPad;
    
    
    UIImageView *pwdLeft = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    pwdLeft.backgroundColor = CLEARCOLOR;
    pwdLeft.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *pimg = [UIImage iconWithInfo:TBCityIconInfoMake(codeIcon, 20, COLOR_333)];
    pwdLeft.image         = pimg;
    password.leftView     = pwdLeft;
    password.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *rightView     = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, password.height)];
    rightView.backgroundColor = WHITECOLOR;
    
    codeView = [[EDVerifyCodeView alloc]initWithFrame:CGRectMake(12, (rightView.height - 34)/2, 100, 34)];
    codeView.linkTextField = account;
    [rightView addSubview:codeView];
    password.rightView     = rightView;
    password.rightViewMode = UITextFieldViewModeAlways;
    
    [contentView addSubview:password];
    
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    codeView.codeType = _codeType;
    
}

-(NSString *)getAccount
{
    return account.text;
}

-(NSString *)getVerifyCode
{
    return  password.text;
}

-(void)becomeFirstResponder
{
    [account becomeFirstResponder];
}

@end

//
//  EDAccountView.m
//  EDOLDiscovery
//
//  Created by song on 17/1/5.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDAccountView.h"
@interface EDAccountView ()
{
    UIView *contentView;
    UITextField  *account;
    UITextField  *password;
}

@end

@implementation EDAccountView

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
    account.placeholder = @"手机号/8天账号";
    account.font        = FONT_Light(14);
    
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
    password.placeholder     = @"密码";
    password.font            = FONT_Light(14);
    password.secureTextEntry = YES;

    UIImageView *pwdLeft = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    pwdLeft.backgroundColor = CLEARCOLOR;
    pwdLeft.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *pimg = [UIImage iconWithInfo:TBCityIconInfoMake(secretIcon, 20, COLOR_333)];
    pwdLeft.image         = pimg;
    password.leftView     = pwdLeft;
    password.leftViewMode = UITextFieldViewModeAlways;
    [contentView addSubview:password];
}


-(NSString *)getAccount
{
    return account.text;
}

-(NSString *)getPwd
{
    return password.text;
}

-(void)becomeFirstResponder
{
    [account becomeFirstResponder];
}
@end

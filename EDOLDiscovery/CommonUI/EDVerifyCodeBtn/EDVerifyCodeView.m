//
//  EDVerifyCodeView.m
//  EDOLDiscovery
//
//  Created by song on 17/1/12.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDVerifyCodeView.h"
static  CGFloat const kDefaultCountdownTimeValue = 60;

@implementation EDVerifyCodeView
{
    UIButton *contentBtn;
    NSTimer *countdownTimer; //计时器
    CGFloat secneds;//剩余秒数
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        secneds = kDefaultCountdownTimeValue;
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = COLOR_666.CGColor;
        self.layer.borderWidth = 1;
        self.clipsToBounds = YES;
        [self createBtn];
        [self resetVerifyButtonStatus];
    }
    return self;
}
-(void)createBtn
{
    contentBtn = [[UIButton alloc]initWithFrame:self.bounds];
    contentBtn.backgroundColor = CLEARCOLOR;
    contentBtn.titleLabel.font = FONT_Light(14);
    [contentBtn setTitleColor:COLOR_666 forState:UIControlStateNormal];
    [contentBtn addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:contentBtn];
}

/**
 *  开始倒计时
 *
 *  @since 2.3.8
 */
- (void)startCountdown
{
    countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countSec) userInfo:nil repeats:YES];
    contentBtn.enabled = NO;
    
}

/**
 *  倒计时
 **/
- (void)countSec
{
    secneds--;
    if (secneds > 0) {
        NSString *time = [NSString stringWithFormat:@"还剩(%ld)秒",(long)secneds];
        [contentBtn setTitle:time forState:UIControlStateNormal];
    }else {
        [self stopCountdown];
    }
}

/**
 *  停止倒计时
 *
 *  @since 2.3.8
 */
- (void)stopCountdown
{
    [self resetVerifyButtonStatus];
    secneds = kDefaultCountdownTimeValue;
    if (countdownTimer) {
        [countdownTimer invalidate];
        countdownTimer = nil;
    }
}

/**
 *  恢复验证码按钮状态
 *
 *  @since 2.3.8
 */
- (void)resetVerifyButtonStatus
{
    [contentBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    contentBtn.enabled = YES;
}

-(void)getCode:(UIButton *)sender
{
    if (ISEmpty(_linkTextField.text)) {
        [APPServant makeToast:KeyWindow title:@"请填写手机号" position:50];

        return;
    }
    if (![EDOLTool checkMobile:_linkTextField.text]){
        [APPServant makeToast:KeyWindow title:@"请填写正确手机号" position:50];

        return;

    };

    NSDictionary *paramDic = @{
                               @"mobile":_linkTextField.text,
                               @"type":@(_codeType)
                               };

    [EDHud show];
    [[HttpRequestManager manager] GET:IdentifyCode_URL parameters:paramDic success:^(NSURLSessionDataTask * task,id responseObject)
     {
         [EDHud dismiss];
         NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         NSLog(@"获取成功:%@",dic);
         if ([[dic objectForKey:@"code"] integerValue] == 200) {
             [self startCountdown];
             [APPServant makeToast:KeyWindow title:@"接头暗号已发送" position:50];

         }else{
             [APPServant makeToast:KeyWindow title:[dic objectForKey:@"msg"] position:50];

         }
     }failure:^(NSURLSessionDataTask * task,NSError *errpr)
     {
         [EDHud dismiss];
         [APPServant makeToast:KeyWindow title:NETWOTK_ERROR_STATUS position:50];
         NSLog(@"failuer");
     }];
}


@end

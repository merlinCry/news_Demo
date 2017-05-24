//
//  EDLoginViewController.m
//  EDOLDiscovery
//
//  Created by song on 17/1/5.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDLoginViewController.h"
#import "EDAccountView.h"
#import "EDIConBtn.h"
#import "EDMainColorBtn.h"
#import "EDRegistViewController.h"
#import "EDCodeLoginVC.h"
#import "TYAttributedLabel.h"
//#import <UMSocialCore/UMSocialCore.h>

@interface EDLoginViewController ()
{
    EDAccountView *accountView;
}

@end

@implementation EDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //模糊背景
    BOOL night = [APPServant servant].nightShift;
    
    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:night?UIBlurEffectStyleDark:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *backView = [[UIVisualEffectView alloc]initWithEffect:beffect];
    backView.frame = self.view.bounds;
    backView.contentView.backgroundColor = View_BACKGROUND_COLOR_Blur;
    [self.view addSubview:backView];
    
    [self createSubViews];
    
    UITapGestureRecognizer *dismissKeyBoardType = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissTap:)];
    [self.view addGestureRecognizer:dismissKeyBoardType];
    

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (accountView) {
        [accountView becomeFirstResponder];
    }
    
    if (NOTEmpty(_loginTip)) {
        [APPServant makeToast:self.view title:_loginTip position:74];
    }
}
-(void)createSubViews
{
    [self addCloseBtn];
    [self addSlogonView];
    [self addAccountView];
    [self addLoginBtn];
    [self addBottom];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark
#pragma mark UI

-(void)addCloseBtn
{
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44, 44)];
    closeBtn.right = self.view.width ;
    [closeBtn setTitle:closeIcon forState:UIControlStateNormal];
    [closeBtn setTitleColor:COLOR_999 forState:UIControlStateNormal];
    [closeBtn  setTitleFontSize:20];
    [self.view addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)addSlogonView
{
    UIImageView *slogonView = [[UIImageView alloc]initWithFrame:CGRectMake(0,144, 250, 40)];
    slogonView.backgroundColor = CLEARCOLOR;
    slogonView.centerX = self.view.width/2;
    slogonView.image = [UIImage n_imageNamed:@"slogon"];
    [self.view  addSubview:slogonView];
    
}

-(void)addAccountView
{
    
    accountView = [[EDAccountView alloc]initWithFrame:CGRectMake(30, 210, SCREEN_WIDTH - 60, 90)];
    [self.view addSubview:accountView];
}

-(void)addLoginBtn
{
    //登录按钮
    CGRect btnFrame = CGRectMake(accountView.left, accountView.bottom + 12, accountView.width, 45);
    EDMainColorBtn *loginBtn = [[EDMainColorBtn alloc]initWithFrame:btnFrame];
    [loginBtn.contentBtn setTitle:@"登  录" forState:UIControlStateNormal];
    [loginBtn.contentBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.contentBtn.tag = 111;
    [self.view addSubview:loginBtn];
    
    UIButton *verifyCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, loginBtn.bottom + 15, 80, 18)];
    verifyCodeBtn.centerX = self.view.width/4 + 10;
    verifyCodeBtn.backgroundColor = CLEARCOLOR;
    [verifyCodeBtn setTitleColor:T_TITLE_COLOR forState:UIControlStateNormal];
    verifyCodeBtn.titleLabel.font = FONT_Light(14);
    [verifyCodeBtn setTitle:@"验证码登录" forState:UIControlStateNormal];
    [verifyCodeBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    verifyCodeBtn.tag = 222;
    [self.view addSubview:verifyCodeBtn];
    
    UIButton *forgetCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, loginBtn.bottom + 15, 80, 18)];
    forgetCodeBtn.centerX = self.view.width *3/4 - 10;
    forgetCodeBtn.backgroundColor = CLEARCOLOR;
    [forgetCodeBtn setTitleColor:T_TITLE_COLOR forState:UIControlStateNormal];
    forgetCodeBtn.titleLabel.font = FONT_Light(14);
    [forgetCodeBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetCodeBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    forgetCodeBtn.tag = 333;
    [self.view addSubview:forgetCodeBtn];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(self.view.width/2, loginBtn.bottom + 17, 1, 16)];
    line.backgroundColor = COLOR_666;
    [self.view addSubview:line];
    
    CGRect wFrame = CGRectMake(0, accountView.bottom + 150, 88, 88);
    EDIConBtn *weChatLogin = [[EDIConBtn alloc]initWithFrame:wFrame];
    weChatLogin.centerX = self.view.width/2;
    weChatLogin.backFontSize = 88;
    weChatLogin.backgroundImageText = circleFillIcon;
    weChatLogin.imageFontSize = 45;
    weChatLogin.imageText     = wechatIcon;
    weChatLogin.imageColor    = WHITECOLOR;
    weChatLogin.backgroundImageColor = UIColorFromRGB(0xA7E668);
    weChatLogin.title         = @"微信登录";
    weChatLogin.hidden = YES;
    
    weChatLogin.backgroundColor = CLEARCOLOR;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(weChatLoginAction:)];
    [weChatLogin addGestureRecognizer:tapGes];
    [self.view addSubview:weChatLogin];
    
}

-(void)addBottom
{
    UIImageView *bottomImage = [[UIImageView alloc]initWithFrame:CGRectMake(80, 0, 44, 52)];
    bottomImage.bottom = self.view.height;
    bottomImage.backgroundColor = CLEARCOLOR;
    bottomImage.image  = [UIImage imageNamed:@"logonnotice"];
    [self.view addSubview:bottomImage];
    
    UILabel *tipLabel = LABEL(FONT_Light(14), T_TITLE_COLOR);
    tipLabel.frame    = CGRectMake(bottomImage.right + 10, 0, 180, 18);
    tipLabel.centerY  = bottomImage.centerY + 5;
//    tipLabel.text     = @"无证不能驾驶，注册一个吧~";
//    tipLabel.userInteractionEnabled = YES;
    [self.view addSubview:tipLabel];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:@"无证不能驾驶，注册一个吧~"];
    [attrStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(7, 2)];
    tipLabel.attributedText = attrStr;
    
    UIView *invisable = [[UIView alloc]initWithFrame:CGRectMake(bottomImage.right + 110, tipLabel.top - 5, 30, 30)];
    invisable.backgroundColor = CLEARCOLOR;
    [self.view addSubview:invisable];
    //点击可以跳转注册
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToRegister:)];
    [invisable addGestureRecognizer:tapGes];
    
}

-(void)goToRegister:(UITapGestureRecognizer *)tapGes
{
    EDRegistViewController *regVC = [EDRegistViewController new];
    regVC.view.backgroundColor = CLEARCOLOR;
    EDBaseNavigationController *nextVC = [[EDBaseNavigationController alloc]initWithRootViewController:regVC];
    nextVC.definesPresentationContext = YES;
    nextVC.view.backgroundColor = CLEARCOLOR;
    nextVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [nextVC setNavigationBarHidden:YES animated:NO];
    
    [self presentViewController:nextVC animated:YES completion:nil];
}

#pragma mark
#pragma mark Action
-(void)closeAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dismissTap:(UITapGestureRecognizer *)ges
{
    [self.view.window endEditing:YES];
}


-(void)loginAction:(UIButton *)sender
{
    if (sender.tag == 111) {

        [self login8dolAccount];
    }else if(sender.tag == 222){
        //跳转验证码登陆
        EDCodeLoginVC *regVC = [EDCodeLoginVC new];
        regVC.view.backgroundColor = CLEARCOLOR;
        [self.navigationController pushViewController:regVC animated:YES];
    
    }else if(sender.tag == 333){
        EDRegistViewController *regVC = [EDRegistViewController new];
        regVC.isFindPassWord = YES;
        regVC.view.backgroundColor = CLEARCOLOR;
        [self.navigationController pushViewController:regVC animated:YES];
    }
}

-(void)weChatLoginAction:(UITapGestureRecognizer *)ges
{
//    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
//        if (error) {
//            
//        } else {
//            UMSocialUserInfoResponse *resp = result;
//            
//            // 授权信息
//            NSLog(@"Wechat uid: %@", resp.uid);
//            NSLog(@"Wechat openid: %@", resp.openid);
//            NSLog(@"Wechat accessToken: %@", resp.accessToken);
//            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
//            NSLog(@"Wechat expiration: %@", resp.expiration);
//            
//            // 用户信息
//            NSLog(@"Wechat name: %@", resp.name);
//            NSLog(@"Wechat iconurl: %@", resp.iconurl);
//            NSLog(@"Wechat gender: %@", resp.gender);
//            
//            // 第三方平台SDK源数据
//            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
//        }
//    }];
}
-(void)login8dolAccount
{
    NSString *account = [accountView getAccount];
    NSString *pwd     = [accountView getPwd];
    
    if (ISEmpty(account)) {
        [APPServant makeToast:self.view title:@"请输入账号" position:50];
        return;
    }
    if (ISEmpty(pwd)) {
        [APPServant makeToast:self.view title:@"请输入密码" position:50];
        return;
    }
    
    [EDHud show];
    [APPServant loginWithAccout:account password:pwd complate:^(BOOL isSuccess) {
        if (isSuccess) {
            [self dismissViewControllerAnimated:YES completion:^{

            }];
            
        }
        [EDHud dismiss];
    }];
}


@end

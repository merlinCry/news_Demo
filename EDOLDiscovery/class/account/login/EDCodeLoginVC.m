//
//  EDCodeLoginVC.m
//  EDOLDiscovery
//
//  Created by song on 17/1/6.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDCodeLoginVC.h"
#import "EDCodeAccountView.h"
#import "EDMainColorBtn.h"
#import "EDIConBtn.h"
@interface EDCodeLoginVC ()
{
    EDCodeAccountView  *codeAccountView;
}
@end

@implementation EDCodeLoginVC

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)createSubViews
{
    [self addCloseBtn];
    [self addSlogonView];
    [self addAccountView];
    [self addLoginBtn];
    [self addBottom];
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
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44, 44)];
    [backBtn setTitle:arrowLeft forState:UIControlStateNormal];
    [backBtn setTitleColor:COLOR_999 forState:UIControlStateNormal];
    [backBtn  setTitleFontSize:20];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtPressed) forControlEvents:UIControlEventTouchUpInside];
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
    
    codeAccountView = [[EDCodeAccountView alloc]initWithFrame:CGRectMake(30, 210, SCREEN_WIDTH - 60, 90)];
    codeAccountView.codeType = 3;
    [self.view addSubview:codeAccountView];
}

-(void)addLoginBtn
{
    //登录按钮
    CGRect btnFrame = CGRectMake(codeAccountView.left, codeAccountView.bottom + 12, codeAccountView.width, 45);
    EDMainColorBtn *loginBtn = [[EDMainColorBtn alloc]initWithFrame:btnFrame];
    [loginBtn.contentBtn setTitle:@"登  录" forState:UIControlStateNormal];
    [loginBtn.contentBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.tag = 111;
    [self.view addSubview:loginBtn];
    
    
    CGRect wFrame = CGRectMake(0, codeAccountView.bottom + 150, 88, 88);
    EDIConBtn *weChatLogin = [[EDIConBtn alloc]initWithFrame:wFrame];
    weChatLogin.centerX = self.view.width/2;
    weChatLogin.backFontSize = 88;
    weChatLogin.backgroundImageText = circleFillIcon;
    weChatLogin.imageFontSize = 45;
    weChatLogin.imageText     = wechatIcon;
    weChatLogin.imageColor    = WHITECOLOR;
    weChatLogin.backgroundImageColor = UIColorFromRGB(0xA7E668);
    weChatLogin.title         = @"微信登录";
    weChatLogin.hidden        = YES;
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
    tipLabel.frame    = CGRectMake(bottomImage.right + 10, 0, 180, 16);
    tipLabel.centerY  = bottomImage.centerY + 5;
    tipLabel.text     = @"无证不能驾驶，注册一个吧~";
    [self.view addSubview:tipLabel];
    
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
  //验证码登录
    NSString *mobile = [codeAccountView getAccount];
    NSString *smsCode   = [codeAccountView getVerifyCode];
    if (ISEmpty(mobile)) {
        [APPServant makeToast:self.view title:@"请输入账号" position:50];
        return;
    }
    if (ISEmpty(smsCode)) {
        [APPServant makeToast:self.view title:@"请输入验证码" position:50];
        return;
    }
    
    UMMobClick(@"edol_code_login");
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile",smsCode,@"smsCode", nil];
    [EDHud show];
    [[HttpRequestManager manager] GET:SmsCodeLogin_URL parameters:paramDic success:^(NSURLSessionDataTask * task,id responseObject)
     {
          [EDHud dismiss];
         NSDictionary *dataDic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         NSLog(@"获取成功:%@",dataDic);
         NSInteger rescode = [[dataDic objectForKey:@"code"] integerValue];
         
         if (rescode == 200) {
             NSDictionary *data = [NSDictionary dictionaryWithDictionary:[dataDic objectForKey:@"data"]];
             if (NOTEmpty(data)) {
                 //保存用户信息
                 UserInfo *aUser = [UserInfo parseInfoFromDic:data];
                 [APPServant servant].user = aUser;
                 [EDOLTool saveToNSUserDefaults:data forKey:ED_LoginMark];
                 //发送用户信息改变通知
                 [[NSNotificationCenter defaultCenter] postNotificationName:ED_UserInfo_Change object:nil];
                 
                 [self dismissViewControllerAnimated:YES completion:nil];
             }
         }else{
             [APPServant makeToast:self.view title:[dataDic objectForKey:@"msg"] position:50];


         }
     }failure:^(NSURLSessionDataTask * task,NSError *errpr)
     {
         [EDHud dismiss];
         NSLog(@"failuer");
         [APPServant makeToast:KeyWindow title:NETWOTK_ERROR_STATUS position:50];

     }];
}

-(void)weChatLoginAction:(UITapGestureRecognizer *)ges
{
    
}

@end

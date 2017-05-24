//
//  EDRegistViewController.m
//  EDOLDiscovery
//
//  Created by song on 17/1/5.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDRegistViewController.h"
#import "EDRegisterStepView.h"
#import "EDCodeAccountView.h"
#import "EDMainColorBtn.h"
#import "FLAnimatedImageView.h"

@interface EDRegistViewController ()<UIScrollViewDelegate>
{
    EDRegisterStepView *stepView;
    UIButton *cusBackBtn;
    UIScrollView  *middScroll;
    
    
    EDCodeAccountView  *codeAccountView;
    
    UITextField *pwdField;
    
    UIImageView *carView;
    
    
}

@end

@implementation EDRegistViewController

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
    
    [codeAccountView becomeFirstResponder];
}

#pragma mark
#pragma mark UI

-(void)createSubViews
{
    [self addStepView];
    [self addCloseBtn];
    
    [self addmidScroll];
    [self addAccountView];
    [self addPassCodeView];
    [self addCarView];
    [self addNextButton];

}
-(void)backBtPressed
{
    [self.view.window endEditing:YES];

    switch (stepView.step) {
        case RegisterStep_L:
        {
            [super backBtPressed];
        }
            break;
        case RegisterStep_M:
        {
            stepView.step = RegisterStep_L;
            [UIView animateWithDuration:0.3 animations:^{
                middScroll.contentOffset = CGPointMake(0, 0);
                
            }completion:^(BOOL finished) {
                cusBackBtn.hidden = YES;

                if (_isFindPassWord) {
                    cusBackBtn.hidden = NO;
                }
                
            }];
        }
            break;
        case RegisterStep_R:
        {
            stepView.step = RegisterStep_M;
            [UIView animateWithDuration:0.3 animations:^{
                middScroll.contentOffset = CGPointMake(self.view.width, 0);
                
            }];
        }
            break;
            
        default:
            break;
    }
}

-(void)addCloseBtn
{
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44, 44)];
    closeBtn.right = self.view.width ;
    [closeBtn setTitle:closeIcon forState:UIControlStateNormal];
    [closeBtn setTitleColor:COLOR_999 forState:UIControlStateNormal];
    [closeBtn  setTitleFontSize:20];
    [self.view addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cusBackBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44, 44)];
    [cusBackBtn setTitle:arrowLeft forState:UIControlStateNormal];
    [cusBackBtn setTitleColor:COLOR_999 forState:UIControlStateNormal];
    [cusBackBtn  setTitleFontSize:20];
    cusBackBtn.hidden = YES;
    if (_isFindPassWord) {
        cusBackBtn.hidden = NO;
    }
    [self.view addSubview:cusBackBtn];
    [cusBackBtn addTarget:self action:@selector(backBtPressed) forControlEvents:UIControlEventTouchUpInside];
        
    
}
-(void)addStepView
{
    stepView = [[EDRegisterStepView alloc]initWithFrame:CGRectMake(30, 100, SCREEN_WIDTH - 60, 20)];
    stepView.backgroundColor = CLEARCOLOR;
    stepView.step = RegisterStep_L;
    stepView.textL.text = @"手机注册";
    stepView.textM.text = @"设置密码";
    stepView.textR.text = @"注册成功";
    if (_isFindPassWord) {
        stepView.textL.text = @"手机号码";
        stepView.textM.text = @"设置新密码";
        stepView.textR.text = @"设置成功";
    }

    [self.view addSubview:stepView];
}


-(void)addmidScroll
{
    middScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 200, self.view.width, 300)];
    middScroll.backgroundColor = CLEARCOLOR;
    middScroll.contentSize     = CGSizeMake(self.view.width * 3, 300);
    middScroll.showsHorizontalScrollIndicator = NO;
    middScroll.pagingEnabled = YES;
    middScroll.scrollEnabled = NO;
    middScroll.delegate      = self;
    middScroll.userInteractionEnabled = YES;
    [self.view addSubview:middScroll];
}
-(void)addAccountView
{
    codeAccountView = [[EDCodeAccountView alloc]initWithFrame:CGRectMake(30, 10, SCREEN_WIDTH - 60, 90)];
    //1注册  2找回密码
    codeAccountView.codeType = _isFindPassWord?2:1;

    [middScroll addSubview:codeAccountView];
}
-(void)addPassCodeView
{
    pwdField = [[UITextField alloc]initWithFrame:CGRectMake(self.view.width + 30, 10, self.view.width - 60, 45)];
    pwdField.layer.cornerRadius  = 4;
    pwdField.layer.masksToBounds = YES;
    pwdField.layer.borderColor   = UIColorFromRGB(0xDDDDDD).CGColor;
    pwdField.layer.borderWidth   = 1;
    pwdField.backgroundColor = WHITECOLOR;
    pwdField.textColor   = COLOR_333;
    pwdField.placeholder = @"请输入密码";
    pwdField.font        = FONT_Light(14);
    pwdField.secureTextEntry = YES;
    
    UIImageView *accLeft = [[UIImageView alloc]initWithFrame:CGRectMake(0, 210, 40, 20)];
    accLeft.backgroundColor = CLEARCOLOR;
    accLeft.contentMode = UIViewContentModeScaleAspectFit;
    
    UIImage *limg = [UIImage iconWithInfo:TBCityIconInfoMake(codeIcon, 20, COLOR_333)];
    accLeft.image         = limg;
    pwdField.leftView     = accLeft;
    pwdField.leftViewMode = UITextFieldViewModeAlways;
    [middScroll  addSubview:pwdField];
}
-(void)addCarView
{
    carView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 120, 120)];
    carView.centerX = self.view.width * 2.5;
    carView.backgroundColor =CLEARCOLOR;
    carView.image = [UIImage imageNamed:@"registerComplateCar"];
    [middScroll addSubview:carView];
    
    UILabel *tipLabel = LABEL(FONT_Light(18), COLOR_666);
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.frame = CGRectMake(self.view.width*2, carView.bottom + 5, self.view.width, 18);
    tipLabel.text = @"来不及解释了，快上车~";
    [middScroll addSubview:tipLabel];
}
-(void)addNextButton
{
    CGRect btn1Frame = CGRectMake(30, codeAccountView.bottom + 12, codeAccountView.width, 45);
    EDMainColorBtn *nextBtn1 = [self getANextButton:btn1Frame];
    [middScroll addSubview:nextBtn1];
    
    CGRect btn2Frame = CGRectMake(self.view.width + 30,pwdField.bottom + 12, codeAccountView.width, 45);
    EDMainColorBtn *nextBtn2 = [self getANextButton:btn2Frame];
    [middScroll addSubview:nextBtn2];
    
    CGRect btn3Frame = CGRectMake(self.view.width*2 + 30,carView.bottom + 50,self.view.width - 60, 45);
    EDMainColorBtn *nextBtn3 = [self getANextButton:btn3Frame];
    [nextBtn3.contentBtn setTitle:@"完  成" forState:UIControlStateNormal];
    [middScroll addSubview:nextBtn3];
    
}

-(EDMainColorBtn *)getANextButton:(CGRect)frame
{
    EDMainColorBtn *nextBtn = [[EDMainColorBtn alloc]initWithFrame:frame];
    [nextBtn.contentBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn.contentBtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    return nextBtn;
}

#pragma mark
#pragma mark Action

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dismissTap:(UITapGestureRecognizer *)ges
{
    [self.view.window endEditing:YES];
}

-(void)closeAction:(UIButton *)sender
{
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)nextAction:(EDMainColorBtn *)sender
{
    switch (stepView.step) {
        case RegisterStep_L:
        {
            if (ISEmpty([codeAccountView getAccount])) {
                [APPServant makeToast:self.view title:@"请填写手机号" position:50];

                return;
            }
            if (![EDOLTool checkMobile:[codeAccountView getAccount]]){
                [APPServant makeToast:KeyWindow title:@"请填写正确手机号" position:50];
                return;
                
            };
            
            if (ISEmpty([codeAccountView getVerifyCode])) {
                [APPServant makeToast:self.view title:@"请填写验证码" position:50];

                return;
            }
            [self.view.window endEditing:YES];
            stepView.step = RegisterStep_M;
            [UIView animateWithDuration:0.3 animations:^{
                middScroll.contentOffset = CGPointMake(self.view.width, 0);

            }completion:^(BOOL finished) {
                cusBackBtn.hidden = NO;
                
            }];
        }
            break;
        case RegisterStep_M:
        {
            if (ISEmpty(pwdField.text)) {
                [APPServant makeToast:self.view title:@"请填写密码" position:50];

                return;
            }
            if (_isFindPassWord) {
                //重置密码
                [self resetPasswd];
            }else{
                //注册
                [self finalRegister];
                
            }

        }
            break;
        case RegisterStep_R:
        {
            [self.view.window endEditing:YES];
            //完成  直接消失
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
            break;
            
        default:
            break;
    }
}

//注册
-(void)finalRegister
{
    NSString *mobile        = [codeAccountView getAccount];
    NSString *smsCode       = [codeAccountView getVerifyCode];
    NSString *pwd           = [EDOLTool MD5String:pwdField.text];

    NSMutableDictionary *reqDataDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile",
                                        pwd,@"password",
                                    smsCode,@"smsCode",
                                       nil];
    
    [reqDataDic setObject:@(ClientCode) forKey:@"loginSource"];
    [EDHud show];
    UMMobClick(@"edol_register");
    [[HttpRequestManager manager] GET:EDRegister_URL parameters:reqDataDic success:^(NSURLSessionDataTask * task,id responseObject)
     {
         [EDHud dismiss];

         NSDictionary *dataDic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         NSLog(@"获取成功:%@",dataDic);
         NSInteger rescode = [[dataDic objectForKey:@"rescode"] integerValue];
         if (rescode == 200) {
             //滚动到完成
             [self.view.window endEditing:YES];
             stepView.step = RegisterStep_R;
             [UIView animateWithDuration:0.3 animations:^{
                 middScroll.contentOffset = CGPointMake(self.view.width*2, 0);
                 
             }completion:^(BOOL finished) {
                 cusBackBtn.hidden = NO;
                 
             }];
             //注册成功 登陆一下
             [APPServant loginWithAccout:mobile password:pwdField.text complate:^(BOOL isSuccess) {
                 if (isSuccess) {

                 }
                 
             }];
             
             
             
         }else{
             [APPServant makeToast:KeyWindow title:[dataDic objectForKey:@"msg"] position:50];

         }
         
     }failure:^(NSURLSessionDataTask * task,NSError *errpr)
     {
         [EDHud dismiss];
         NSLog(@"failuer");
         [APPServant makeToast:KeyWindow title:NETWOTK_ERROR_STATUS position:50];

     }];
}

//找回密码
-(void)resetPasswd
{
    NSString *mobile        = [codeAccountView getAccount];
    NSString *smsCode       = [codeAccountView getVerifyCode];
    NSString *pwd           = [EDOLTool MD5String:pwdField.text];
    
    NSMutableDictionary *reqDataDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile",
                                       pwd,@"password",
                                       smsCode,@"smsCode",
                                       nil];
    UMMobClick(@"edol_findPwd");
    [reqDataDic setObject:@(ClientCode) forKey:@"loginSource"];
    [EDHud show];
    [[HttpRequestManager manager] GET:EDResetPwd parameters:reqDataDic success:^(NSURLSessionDataTask * task,id responseObject)
     {
         [EDHud dismiss];
         NSDictionary *dataDic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         NSLog(@"获取成功:%@",dataDic);
         NSInteger rescode = [[dataDic objectForKey:@"rescode"] integerValue];
         if (rescode == 200) {
             //找回成功 走下登陆流程
             [APPServant loginWithAccout:mobile password:pwdField.text complate:^(BOOL isSuccess) {
                 if (isSuccess) {
                     //滚动到完成
                     [self.view.window endEditing:YES];
                     stepView.step = RegisterStep_R;
                     [UIView animateWithDuration:0.3 animations:^{
                         middScroll.contentOffset = CGPointMake(self.view.width*2, 0);
                         
                     }completion:^(BOOL finished) {
                         cusBackBtn.hidden = NO;
                         
                     }];
                 }
                 
             }];
             
             
             
         }else{
             [APPServant makeToast:KeyWindow title:[dataDic objectForKey:@"msg"] position:50];

         }
         
     }failure:^(NSURLSessionDataTask * task,NSError *errpr)
     {
         [EDHud dismiss];
         NSLog(@"failuer");
         [APPServant makeToast:KeyWindow title:NETWOTK_ERROR_STATUS position:50];
     }];
}
@end

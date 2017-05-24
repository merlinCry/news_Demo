//
//  APPAlertView.m
//  EDOLDiscovery
//
//  Created by song on 17/1/9.
//  Copyright © 2017年 song. All rights reserved.
//

#import "APPInputPopView.h"
#import "EDButton.h"
#import "EDMainColorBtn.h"

@interface APPInputPopView ()<UITextFieldDelegate>
{
    UIView   *blackBackView;
    
    UIView *backView;
    UIView *contentView;

    UIButton    *closeBtn;
    EDMainColorBtn    *commitBtn;
    
    UIView *cycleBg;
}

@end

@implementation APPInputPopView
//创建基础控件
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tapDismiss = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tapDismiss];
        
        [self initSubViews];
        
    }
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    return self;
}

-(void)initSubViews
{
    self.backgroundColor = CLEARCOLOR;
    
    blackBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    blackBackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
//    blackBackView.alpha           = 0;
    [self addSubview:blackBackView];
    
    backView    = [[UIView alloc]initWithFrame:CGRectMake(0, 175, 262, 250)];
    backView.centerX = self.width/2;
    backView.backgroundColor = CLEARCOLOR;
    
    //262 250
    contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 46, backView.width, backView.height - 46)];
    contentView.backgroundColor = WHITECOLOR;
    contentView.layer.cornerRadius  = 8;
    contentView.layer.masksToBounds = YES;

    
    cycleBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 92, 92)];
    cycleBg.centerX             = contentView.width/2;
    cycleBg.backgroundColor     = WHITECOLOR;
    cycleBg.layer.cornerRadius  = cycleBg.width/2;
    cycleBg.layer.masksToBounds = YES;
    
    //图片
    _iconLabel  = LABEL(ICONFONT(50), COLOR_333);
    _iconLabel.textAlignment = NSTextAlignmentCenter;
    _iconLabel.frame   = CGRectMake(0, 0, 50, 50);
    _iconLabel.center               = CGPointMake(cycleBg.width/2, cycleBg.width/2);
    _iconLabel.backgroundColor     = CLEARCOLOR;
    _iconLabel.layer.cornerRadius  = _iconLabel.width/2;
    _iconLabel.layer.masksToBounds = YES;
    _iconLabel.textColor           = COLOR_333;
    UIView *yelloView = [[UIView alloc]initWithFrame:CGRectMake(_iconLabel.left+2, _iconLabel.top+2, _iconLabel.width - 1, _iconLabel.height - 1)];
    yelloView.backgroundColor = MAINCOLOR;
    yelloView.layer.cornerRadius  = yelloView.width/2;
    yelloView.layer.masksToBounds = YES;
    
    [cycleBg addSubview:yelloView];
    [cycleBg addSubview:_iconLabel];
    [backView addSubview:contentView];
    [backView addSubview:cycleBg];
    [self addSubview:backView];

    //关闭按钮
    closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 34, 34)];
    closeBtn.right = contentView.width ;
    [closeBtn setTitle:closeIcon forState:UIControlStateNormal];
    [closeBtn setTitleColor:COLOR_999 forState:UIControlStateNormal];
    [closeBtn  setTitleFontSize:18];
    [closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];

    //title
    _titleLab = LABEL(FONT_Light(21), COLOR_333);
    _titleLab.frame = CGRectMake(0, 45, contentView.width, 24);
    _titleLab.textAlignment = NSTextAlignmentCenter;

    //输入框
    _inputText = [[UITextField alloc]initWithFrame:CGRectMake(18, 88, contentView.width - 36, 38)];
    _inputText.layer.cornerRadius  = 4;
    _inputText.layer.masksToBounds = YES;
    _inputText.layer.borderColor   = COLOR_DDD.CGColor;
    _inputText.layer.borderWidth   = 1;
    _inputText.font = FONT_Light(14);
    _inputText.textColor   = COLOR_999;
    _inputText.delegate    = self;
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 38)];
    leftView.backgroundColor = CLEARCOLOR;
    _inputText.leftView = leftView;
    _inputText.leftViewMode = UITextFieldViewModeAlways;
    
    //确定按钮
    CGRect btnFrame = CGRectMake(18, 140,_inputText.width, 38);
    commitBtn = [[EDMainColorBtn alloc]initWithFrame:btnFrame];
    [commitBtn.contentBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn.contentBtn addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [contentView addSubview:closeBtn];
    [contentView addSubview:_titleLab];
    [contentView addSubview:_inputText];
    [contentView addSubview:commitBtn];
    
}

//填充数据
+(void)showWithTitle:(NSString *)title
                icon:(NSString *)icon
    inputPlaceHolder:(NSString *)placeHolder
         commitTitle:(NSString *)commitTitle
     completionBlock:(APPInputPopViewCompletionBlock)completion
{
    APPInputPopView *popView =  [[APPInputPopView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    popView.titleLab.text= title;
    popView.inputText.placeholder = placeHolder;
    popView.iconLabel.text = icon;
    popView.completionBlock = completion;
    [popView show];
}


//展示在window上
-(void)show
{
    [KeyWindow addSubview:self];
    [backView.layer addAnimation:[self showAlertAnimation] forKey:@"showAlert"];
    [UIView animateWithDuration:.3 animations:^{
        blackBackView.alpha = 1;
    }];
}

//消失
-(void)dismiss
{
    [self removeFromSuperview];
}

-(void)closeAction:(UIButton *)sender
{
//    [backView.layer addAnimation:[self dismissAlertAnimation] forKey:@"dismissAlert"];
    if (_completionBlock) {
        _completionBlock(YES,nil);
    }
    [self dismiss];
}

-(void)commitAction:(UIButton *)sender
{
    if (ISEmpty(_inputText.text)) {
        [APPServant makeToast:KeyWindow title:@"修改能容不能为空!" position:74];

        return;
    }
    if (_completionBlock) {
        _completionBlock(NO,_inputText.text);
    }
    [self dismiss];
}

//动画
- (CAKeyframeAnimation *)showAlertAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)]];
    animation.keyTimes = @[ @0, @0.5, @1 ];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = .3;
    return animation;
}

- (CAKeyframeAnimation *)dismissAlertAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1)]];
    animation.keyTimes = @[ @0, @0.5, @1 ];
    animation.fillMode = kCAFillModeRemoved;
    animation.duration = .2;
    return animation;
}

- (void)keyboardWillShown:(NSNotification*)notification
{
    [UIView animateWithDuration:.35 animations:^(void){
        backView.top = 100;

     } completion:nil];
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    [UIView animateWithDuration:.35  animations:^(void){
        backView.top = 175;

     } completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_inputText resignFirstResponder];
    return YES;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

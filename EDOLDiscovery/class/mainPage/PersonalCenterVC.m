//
//  PersonalCenterView.m
//  EDOLDiscovery
//
//  Created by song on 16/12/26.
//  Copyright © 2016年 song. All rights reserved.
//

#import "PersonalCenterVC.h"
#import "EDButton.h"
#import "EDSettionViewController.h"

#import "EDModiffyUserInfoVC.h"
#import "EDChooseSchoolVC.h"
#import "EDModiffyUserInfoVC.h"
#import "EDAdviceVC.h"
#import "EDCollectVC.h"
#import "EDMessageVC.h"
#import "EDLoginViewController.h"
@interface PersonalCenterVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView             *backView;
    UIView             *rightBlackView;
    UIVisualEffectView *menuView;
    CGRect hiddFrame;
    CGRect showFrame;
    UITapGestureRecognizer *backTapGes;
    UIPanGestureRecognizer *panGes;
    
    UITableView *contentTable;
    
    UIImageView *slogonView;
    UIView      *headerView;
    
    UIButton *headeIcon;//头像
    UILabel  *userName;
    
    EDButton *loginIcon;//登陆  登陆后变为收藏
    EDButton *regisIcon;//注册  登陆后变为消息
    
    NSArray *dataSource;
    
    UIView   *accView;
    UISwitch *onOff;//夜间模式开关
    
    UIColor  *commonColor;//颜色
}

@end

@implementation PersonalCenterVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = CLEARCOLOR;
    commonColor = COLOR_333;
    CGFloat  viewWidth = SCREEN_WIDTH*2/3;
    hiddFrame = CGRectMake(-viewWidth, 0,viewWidth , self.view.height);
    showFrame = CGRectMake(0, 0, viewWidth, self.view.height);
    
    [self createSubViews];
    
    
    UISwipeGestureRecognizer *swipeGes = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    swipeGes.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeGes];
    
    onOff = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    onOff.on = [APPServant servant].nightShift;
    onOff.onTintColor = MAINCOLOR;
    onOff.transform = CGAffineTransformMakeScale(0.75, 0.75);
    [onOff addTarget:self action:@selector(modelChangedAction:) forControlEvents:UIControlEventValueChanged];

    accView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 52, 32)];
    accView.backgroundColor = CLEARCOLOR;
    accView.userInteractionEnabled = YES;
    [accView addSubview:onOff];

    [self checkTheme];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadContent];
}
-(void)createSubViews
{
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    backView.alpha = 0;
    [self.view addSubview:backView];
    
    rightBlackView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2/3, 0, SCREEN_WIDTH/3, SCREEN_HEIGHT)];
    rightBlackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    rightBlackView.hidden = YES;
    
    [self.view addSubview:rightBlackView];
    
    backTapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [rightBlackView addGestureRecognizer:backTapGes];
    
    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    menuView = [[UIVisualEffectView alloc]initWithEffect:beffect];
    menuView.frame = hiddFrame;
    menuView.contentView.backgroundColor = COLOR(250, 250, 250, 0.7);
    [self.view addSubview:menuView];
    
    [self fileMenuView];
    
    
}

-(void)reloadContent
{
    if ([APPServant isLogin]) {
        dataSource = @[
                       @{@"icon":dayNightIcon,@"title":@"夜间模式"},
                       @{@"icon":modifUserInfoIcon,@"title":@"修改资料"},
//                       @{@"icon":schoolIcon,@"title":@"选择学校"},
                       @{@"icon":adjuestIcon,@"title":@"意见反馈"},
                       @{@"icon":settingIcon,@"title":@"设置"},
                       ];
    }else{
        dataSource = @[
                       @{@"icon":dayNightIcon,@"title":@"夜间模式"},
                       //@{@"icon":schoolIcon,@"title":@"选择学校"},
                       @{@"icon":settingIcon,@"title":@"设置"},
                       ];
    }
    [self reloadHeader];
    [contentTable reloadData];

}

-(void)reloadHeader
{
    if ([APPServant isLogin]) {
        UserInfo *user = [APPServant servant].user;
        
        [headeIcon sd_setImageWithURL:[NSURL URLWithString:user.mHeadIcon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_userhead"]];
        if (NOTEmpty(user.mNickname)) {
            userName.text = user.mNickname;
        }else{
            userName.text = user.mMobile;
            
        }
        
        [loginIcon setTitle:@"收藏" forState:UIControlStateNormal];
        UIImage *loginImg = [UIImage iconWithInfo:TBCityIconInfoMake(collectC, 50, commonColor)];
        [loginIcon setImage:loginImg forState:UIControlStateNormal];
        
        [regisIcon setTitle:@"消息" forState:UIControlStateNormal];
        UIImage *regisImg = [UIImage iconWithInfo:TBCityIconInfoMake(messageC, 50, commonColor)];
        [regisIcon setImage:regisImg forState:UIControlStateNormal];
        
    }else{
        [headeIcon setImage:[UIImage imageNamed:@"default_userhead"] forState:UIControlStateNormal];
        userName.text = @"未登录";
        
        [loginIcon setTitle:@"登录" forState:UIControlStateNormal];
        UIImage *loginImg = [UIImage iconWithInfo:TBCityIconInfoMake(loginC, 50, commonColor)];
        [loginIcon setImage:loginImg forState:UIControlStateNormal];
        
        [regisIcon setTitle:@"注册" forState:UIControlStateNormal];
        UIImage *regisImg = [UIImage iconWithInfo:TBCityIconInfoMake(logonC, 50, commonColor)];
        [regisIcon setImage:regisImg forState:UIControlStateNormal];
    }
    
    userName.textColor = commonColor;
    [regisIcon setTitleColor:commonColor forState:UIControlStateNormal];
    [loginIcon setTitleColor:commonColor forState:UIControlStateNormal];
}

-(void)fileMenuView
{

    contentTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, menuView.width, menuView.height - 70)];
    contentTable.backgroundColor = CLEARCOLOR;
    contentTable.delegate        = self;
    contentTable.dataSource      = self;
    contentTable.separatorStyle  = UITableViewCellSeparatorStyleNone;
    //    contentTable.scrollEnabled   = NO;
    
    [menuView.contentView  addSubview:contentTable];
    
    slogonView = [[UIImageView alloc]initWithFrame:CGRectMake(0, menuView.height - 60, 200, 32)];
    slogonView.backgroundColor = CLEARCOLOR;
    slogonView.centerX = menuView.width/2;
    slogonView.image = [UIImage imageNamed:@"slogon"];
    [menuView.contentView  addSubview:slogonView];
    
    [self addHeader];
}

-(void)addHeader
{
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, menuView.width, 260)];
    headerView.backgroundColor = CLEARCOLOR;
    [menuView.contentView addSubview:headerView];
    contentTable.tableHeaderView = headerView;
    //头像
    headeIcon       = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    headeIcon.center = CGPointMake(menuView.width/2, 85);
    headeIcon.layer.cornerRadius  = headeIcon.width/2;
    headeIcon.layer.masksToBounds = YES;
    headeIcon.adjustsImageWhenHighlighted = NO;
    [headeIcon addTarget:self action:@selector(headAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [headerView addSubview:headeIcon];
    
    userName = LABEL(FONT_Light(16), commonColor);
    userName.frame = CGRectMake(0, headeIcon.bottom + 10, menuView.width, 18);
    userName.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:userName];
    
    //登陆
    loginIcon = [[EDButton alloc]initWithFrame:CGRectMake(40, userName.bottom + 20, 50, 65)];
    loginIcon.style = EDButtonStyleDown;
    loginIcon.titleLabel.font = FONT_Light(16);
    [headerView addSubview:loginIcon];
    [loginIcon addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //注册
    regisIcon = [[EDButton alloc]initWithFrame:CGRectMake(menuView.width-90, userName.bottom + 20, 50, 65)];
    regisIcon.style = EDButtonStyleDown;
    regisIcon.titleLabel.font = FONT_Light(16);
    [headerView addSubview:regisIcon];
    [regisIcon addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)show
{
    [UIView animateWithDuration:0.3 animations:^{
        menuView.frame = showFrame;
        backView.alpha = 1;
    }completion:^(BOOL finished) {
        backView.hidden = YES;
        rightBlackView.hidden = NO;
    }];
}

-(void)dismiss
{
    [self dismissWithOption:EDUserCenterDisOption_None];
    
}

-(void)dismissWithOption:(EDUserCenterDisOption)option
{
    backView.hidden = NO;
    rightBlackView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        menuView.frame = hiddFrame;
        backView.alpha = 0;
        
    } completion:^(BOOL finished) {

        [self dismissViewControllerAnimated:NO completion:^{
            if (_delegate && [_delegate respondsToSelector:@selector(dismissedWithOperation:)]) {
                [_delegate dismissedWithOperation:option];
            }
        }];
    }];
}

#pragma mark -----
#pragma mark --------UITableViewDelegate && UITableViewDataSource--------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = CLEARCOLOR;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (dataSource.count > indexPath.row) {
        NSDictionary *dataDic = dataSource[indexPath.row];
        NSString *title = dataDic[@"title"];
        NSString *icon  = dataDic[@"icon"];
        UIImage *iconImg= [UIImage iconWithInfo:TBCityIconInfoMake(icon, 25, commonColor)];
        cell.imageView.image = iconImg;
        cell.textLabel.text = title;
        cell.textLabel.textColor = commonColor;
        cell.textLabel.font      = FONT_Light(17);
        cell.textLabel.backgroundColor = CLEARCOLOR;
        if (indexPath.row == 0) {
            cell.accessoryView = accView;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([APPServant servant].user) {
        switch (indexPath.row) {
            case 1:
            {
                [self modiffyInfo];
            }
                break;
//            case 1:
//            {
//                [self chooseSchool];
//            }
//                break;
            case 2:
            {
                [self compainAndAdvice];
            }
                break;
            case 3:
            {
                [self goToSetting];

            }
                break;
                
            default:
                break;
        }
        
    }else{
//        if (indexPath.row == 0) {
//            //选择学校
//            [self chooseSchool];
//        }else if(indexPath.row == 1){
//            //设置
//            [self goToSetting];
//        }
        if (indexPath.row == 1) {
            //设置
            [self goToSetting];
        }
    }
}

//修改资料
-(void)modiffyInfo
{
    EDModiffyUserInfoVC *ctrl = [EDModiffyUserInfoVC new];
    [ctrl setNavTitle:@"修改资料"];
    ctrl.hasBackArrow   = YES;
    ctrl.hasLickNav     = YES;
    ctrl.backArrowColor = COLOR_333;
    [self.navigationController pushViewController:ctrl animated:YES];
}
//选择学校
-(void)chooseSchool
{
    EDChooseSchoolVC *ctrl = [EDChooseSchoolVC new];
    [ctrl setNavTitle:@"选择学校"];
    ctrl.hasBackArrow   = YES;
    ctrl.hasLickNav     = YES;
    ctrl.backArrowColor = COLOR_333;
    [self.navigationController pushViewController:ctrl animated:YES];
}
//意见反馈
-(void)compainAndAdvice
{
    EDAdviceVC *ctrl = [EDAdviceVC new];
    [ctrl setNavTitle:@"意见反馈"];
    ctrl.hasBackArrow   = YES;
    ctrl.hasLickNav     = YES;
    ctrl.diffTheme      = YES;
    ctrl.backArrowColor = COLOR_333;
    [self.navigationController pushViewController:ctrl animated:YES];
}
//设置
-(void)goToSetting
{
    EDSettionViewController *settingVC = [EDSettionViewController new];
    [settingVC setNavTitle:@"设置"];
    settingVC.hasBackArrow   = YES;
    settingVC.hasLickNav     = YES;
    settingVC.diffTheme      = YES;
    settingVC.backArrowColor = COLOR_333;
    [self.navigationController pushViewController:settingVC animated:YES];
    
}

-(void)loginAction:(UIButton *)sender
{
    if ([APPServant servant].user) {
        //收藏
        EDCollectVC *ctrlVC = [EDCollectVC new];
        ctrlVC.hasBackArrow   = YES;
        ctrlVC.hasLickNav     = YES;
        ctrlVC.backArrowColor = COLOR_333;
        [self.navigationController pushViewController:ctrlVC animated:YES];
    }else{
        //登录
        [self dismissWithOption:EDUserCenterDisOption_Login];
        
//        EDLoginViewController *loginVC = [EDLoginViewController new];
//        loginVC.view.backgroundColor = CLEARCOLOR;
//        EDBaseNavigationController *nextVC = [[EDBaseNavigationController alloc]initWithRootViewController:loginVC];
//        nextVC.definesPresentationContext = YES;
//        nextVC.view.backgroundColor = CLEARCOLOR;
//        nextVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//        [nextVC setNavigationBarHidden:YES animated:NO];
//        [self presentViewController:nextVC animated:YES completion:nil];

    }
    
}

-(void)registerAction:(UIButton *)sender
{
    if ([APPServant servant].user) {
        //消息
        EDMessageVC *ctrlVC = [EDMessageVC new];
        ctrlVC.hasBackArrow   = YES;
        ctrlVC.hasLickNav     = YES;
        ctrlVC.backArrowColor = COLOR_333;
        [self.navigationController pushViewController:ctrlVC animated:YES];
    }else{
        //注册
       [self dismissWithOption:EDUserCenterDisOption_Register];
        
    }
    
}

//点击头像操作
-(void)headAction:(UIButton *)sender
{
    if ([APPServant servant].user) {
        //修改资料
         [self modiffyInfo];
        
    }else{
        //登陆
        [self dismissWithOption:EDUserCenterDisOption_Login];
    }
    
    
}


-(void)modelChangedAction:(UISwitch *)sender
{
    [APPServant servant].nightShift = sender.isOn;
    [self checkTheme];
}

-(void)checkTheme
{
    [UIView animateWithDuration:0.5 animations:^{
        if ([APPServant servant].nightShift) {
            menuView.contentView.backgroundColor = UIColorFromRGBA(0x2E2E2E,0.7);
            menuView.effect   = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            commonColor = COLOR_999;
            slogonView.image = [UIImage imageNamed:@"slogonN"];
            
        }else{
            menuView.contentView.backgroundColor = COLOR(250, 250, 250, 0.7);
            menuView.effect   = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            commonColor = COLOR_333;
            slogonView.image = [UIImage imageNamed:@"slogon"];
            
        }
    }];
    [self reloadHeader];
    [contentTable reloadData];
    
    
}
@end

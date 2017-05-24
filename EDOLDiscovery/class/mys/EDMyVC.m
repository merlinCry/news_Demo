//
//  EDMyVC.m
//  EDOLDiscovery
//
//  Created by song on 16/12/24.
//  Copyright © 2016年 song. All rights reserved.
//

#import "EDMyVC.h"
#import "EDLoginViewController.h"
#import "EDRegistViewController.h"
#import "EDSettionViewController.h"
#import "EDModiffyUserInfoVC.h"
#import "EDAdviceVC.h"
#import "EDCollectVC.h"
#import "EDMessageVC.h"

@interface EDMyVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView        *_tableView;
    NSArray            *_sectionArr;
    UIColor            *commonColor;//颜色

    UIView             *accView;
    UISwitch           *onOff;//夜间模式开关
    UIVisualEffectView *menuView;
    UIImageView        *slogonView;
    UIView             *headerView;
    UIView             *headerHasLoginView;
    
    UIButton           *headeIcon;//头像
    UILabel            *userName;
    UILabel            *userTipLab;

}

@end

@implementation EDMyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"个人中心"];
    
    commonColor = COLOR_333;
    
    [self createSubViews];
    
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initDataSource];
    [self reloadHeader];
}

-(void)createSubViews
{
    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    menuView = [[UIVisualEffectView alloc]initWithEffect:beffect];
    menuView.frame = CGRectMake(0, 0, SCREEN_WIDTH,ControllerView_HEIGHT-49);
    menuView.contentView.backgroundColor = COLOR(250, 250, 250, 0.7);
    [self.view addSubview:menuView];
    
    [self initTableView];
}

- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, menuView.height-60) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = UIColorFromRGB(0xFAFAFA);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorInset = UIEdgeInsetsMake(0,0, 0, 0);
    [menuView.contentView addSubview:_tableView];
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    slogonView = [[UIImageView alloc]initWithFrame:CGRectMake(0, menuView.height - 60, 200, 32)];
    slogonView.backgroundColor = CLEARCOLOR;
    slogonView.centerX = self.view.width/2;
    slogonView.image = [UIImage imageNamed:@"slogon"];
    [menuView.contentView  addSubview:slogonView];
    
    [self initHeaderView];
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
    [_tableView reloadData];
}

-(void)reloadHeader
{
    if (headerHasLoginView) {
        for (UIView *tm in headerHasLoginView.subviews) {
            [tm removeFromSuperview];
        }
        [headerHasLoginView removeFromSuperview];
    }
    
    if ([APPServant isLogin]) {
        UserInfo *user = [APPServant servant].user;
        
        [headeIcon sd_setImageWithURL:[NSURL URLWithString:user.mHeadIcon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_userhead"]];
        if (NOTEmpty(user.mNickname)) {
            userName.text = user.mNickname;
        }else{
            userName.text = user.mMobile;
        }
        userTipLab.hidden = YES;
        headerView.height = 240;
        
       
        [self initHeadHasLoginView];
        
    }else{
        [headeIcon setImage:[UIImage imageNamed:@"default_userhead"] forState:UIControlStateNormal];
        userName.text = @"未登录";
        userTipLab.text = @"请先登录";
        userTipLab.hidden = NO;
        headerView.height = 100;
    }
    
    _tableView.tableHeaderView = headerView;
    
    userName.textColor = commonColor;
}

- (void)initHeaderView
{
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 100)];
    headerView.backgroundColor = [UIColor whiteColor];
    //头像
    headeIcon       = [[UIButton alloc]initWithFrame:CGRectMake(22, 22, 60, 60)];
    headeIcon.layer.cornerRadius  = headeIcon.width/2;
    headeIcon.layer.masksToBounds = YES;
    headeIcon.adjustsImageWhenHighlighted = NO;
    [headeIcon addTarget:self action:@selector(headAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:headeIcon];
    
    userName = LABEL(FONT_Light(18), commonColor);
    userName.frame = CGRectMake(92,30, headerView.width-120, 18);
    [headerView addSubview:userName];
    
    userTipLab = LABEL(FONT_Light(14), commonColor);
    userTipLab.frame = CGRectMake(92,57, userName.width, 17);
    userTipLab.textColor = UIColorFromRGB(0x999999);
    [headerView addSubview:userTipLab];
}

//已登录头操作
- (void)initHeadHasLoginView{
    headerHasLoginView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 140)];
    headerHasLoginView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *splitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    splitView.backgroundColor = UIColorFromRGB(0xFAFAFA);
    [headerHasLoginView addSubview:splitView];
    
    CGFloat eachWidht = 60;
    CGFloat eachMargin = SCREEN_WIDTH / 3;
    NSArray *colorArr = @[UIColorFromRGB(0xFFC532),UIColorFromRGB(0x68C4FB),UIColorFromRGB(0xFF8686)];
    NSArray *titleArr = @[modifUserInfoIcon,collectIcon,commentIcon];
    NSArray *tipArr   = @[@"修改资料",@"我的收藏",@"我的消息"];

    
    for (int i = 0; i < 3; i++) {
        UIButton *opearteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        opearteBtn.frame     = CGRectMake(eachMargin*i, 40, eachWidht, eachWidht);
        opearteBtn.center    = CGPointMake(eachMargin*i+eachMargin/2, eachWidht/2+40);
        opearteBtn.backgroundColor = colorArr[i];
        opearteBtn.clipsToBounds = YES;
        opearteBtn.layer.cornerRadius = eachWidht/2;
        opearteBtn.titleLabel.font = ICONFONT(26);
        [opearteBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
        [opearteBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        opearteBtn.tag = i;
        [opearteBtn addTarget:self action:@selector(opearteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerHasLoginView addSubview:opearteBtn];
        
        UILabel *tipLab = LABEL(FONT(14), UIColorFromRGB(0x666666));
        tipLab.text = tipArr[i];
        tipLab.frame = CGRectMake(opearteBtn.left, opearteBtn.bottom+8, opearteBtn.width, 17);
        tipLab.textAlignment = NSTextAlignmentCenter;
        [headerHasLoginView addSubview:tipLab];
    }
    [headerView addSubview:headerHasLoginView];
}

- (void)opearteBtnClick:(id)sender{
    UIButton *tmpBtm = (UIButton *)sender;
    if (tmpBtm.tag == 0) {
        [self modiffyInfo];
    }
    else if (1 == tmpBtm.tag){
        EDCollectVC *ctrlVC = [EDCollectVC new];
        ctrlVC.hasBackArrow   = YES;
        ctrlVC.hasLickNav     = YES;
        ctrlVC.backArrowColor = COLOR_333;
        ctrlVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctrlVC animated:YES];
    }
    else if (2 == tmpBtm.tag){
        //消息
        EDMessageVC *ctrlVC = [EDMessageVC new];
        ctrlVC.hasBackArrow   = YES;
        ctrlVC.hasLickNav     = YES;
        ctrlVC.backArrowColor = COLOR_333;
        ctrlVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctrlVC animated:YES];

    }
}

//点击头像操作
- (void)headAction:(UIButton *)sender
{
    if ([APPServant servant].user) {
        //修改资料
        [self modiffyInfo];
        
    }else{
        //登录
        EDLoginViewController *ctrl = [[EDLoginViewController alloc] init];
        ctrl.title = @"登录";
        [self.navigationController presentViewController:ctrl animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initDataSource{
    if ([APPServant isLogin]) {
        NSArray *sectionOne = @[
                       @{@"icon":adjuestIcon,@"title":@"意见反馈"}];
                       
        NSArray *sectionSec = @[
//                                @{@"icon":dayNightIcon,@"title":@"夜间模式"},
                                @{@"icon":settingIcon,@"title":@"设置"}
                                ];
        _sectionArr = @[sectionOne,sectionSec];
    }else{
        NSArray *sectionOne = @[
                                @{@"icon":loginM,@"title":@"登录"},
                                @{@"icon":logonM,@"title":@"注册"}];
        
        NSArray *sectionSec = @[
//                                @{@"icon":dayNightIcon,@"title":@"夜间模式"},
                                @{@"icon":settingIcon,@"title":@"设置"}
                                ];
        _sectionArr = @[sectionOne,sectionSec];
    }

    [_tableView reloadData];
}


#pragma mark -----
#pragma mark --------UITableViewDelegate && UITableViewDataSource--------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionIndexArr = _sectionArr[section];
    return sectionIndexArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sectionArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSArray *sectionIndexArr = _sectionArr[indexPath.section];
    if (sectionIndexArr.count > indexPath.row) {
        NSDictionary *dataDic = sectionIndexArr[indexPath.row];
        NSString *title = dataDic[@"title"];
        NSString *icon  = dataDic[@"icon"];
        UIImage *iconImg= [UIImage iconWithInfo:TBCityIconInfoMake(icon, 25, commonColor)];
        cell.imageView.image = iconImg;
        cell.textLabel.text = title;
        cell.textLabel.textColor = commonColor;
        cell.textLabel.font      = FONT_Light(17);
        cell.textLabel.backgroundColor = CLEARCOLOR;
//        if (indexPath.row == 0 && 1 == indexPath.section) {
//            cell.accessoryView = accView;
//        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([APPServant servant].user) {
        
        if (0 == indexPath.section) {
            [self compainAndAdvice];
        }
        else{
            [self goToSetting];
        }
    }else{
        
        if (0 == indexPath.section) {
            if (0 == indexPath.row) {
                EDLoginViewController *ctrl = [[EDLoginViewController alloc] init];
                ctrl.title = @"登录";
                [self.navigationController presentViewController:ctrl animated:YES completion:nil];
            }
            else{
                EDRegistViewController *ctrl = [[EDRegistViewController alloc] init];
                ctrl.title = @"注册";
                [self.navigationController presentViewController:ctrl animated:YES completion:nil];
            }
        }
        else{
            if (indexPath.row == 0) {
                //设置
                [self goToSetting];
            }
        }
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    head.backgroundColor = CLEARCOLOR;
    return head;
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
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
}

//修改资料
-(void)modiffyInfo
{
    EDModiffyUserInfoVC *ctrl = [EDModiffyUserInfoVC new];
    [ctrl setNavTitle:@"修改资料"];
    ctrl.hasBackArrow   = YES;
    ctrl.hasLickNav     = YES;
    ctrl.backArrowColor = COLOR_333;
    ctrl.hidesBottomBarWhenPushed = YES;
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
    ctrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
}

@end

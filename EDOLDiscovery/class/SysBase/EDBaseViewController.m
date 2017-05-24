//
//  EDBaseViewController.m
//  EDOLDiscovery
//
//  Created by song on 16/12/24.
//  Copyright © 2016年 song. All rights reserved.
//

#import "EDBaseViewController.h"

@interface EDBaseViewController ()
@property(strong,nonatomic)UIButton *navBackButton;
@property(strong,nonatomic)UIButton *navRightButton;
@property(strong,nonatomic)UILabel  *navTitleLabel;

@property(strong,nonatomic)NSString *navTopTitle;
@property(strong,nonatomic)UIView   *likeNavBar;
@property(strong,nonatomic)UILabel  *likeNavTitleLab;

@property(strong,nonatomic)UIView      *loadingTipView;
@property(strong,nonatomic)UIImageView *bgloadingView;
@property(strong,nonatomic)UILabel     *loadingTipLabel;



@property(strong,nonatomic)UIView      *noDataTipView;
@property(strong,nonatomic)UIImageView *nodataImageView;
@property(strong,nonatomic)UILabel     *nodaTipLabel;



@end

@implementation EDBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.view.backgroundColor = View_BACKGROUND_COLOR;
    if (_hasLickNav) {
//        [self createLikeNav];
    }
    
    if (!NOTEmpty(_navTopTitle)){
        [self configNav];
    }

    if (self.hasBackArrow) {
        [self createBackArrow];
    }
    
    [self createTipViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChanged) name:ED_DayNight_Changed object:nil];
}

-(void)configNav
{
    UIImageView *logoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 133, 44)];
    logoView.image = [UIImage imageNamed:@"logo"];
    [self setNavTitleView:logoView];
}

-(void)createTipViews
{
    //loading
    _loadingTipView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 300)];
    _loadingTipView.backgroundColor = CLEARCOLOR;
    _loadingTipView.center  = CGPointMake(self.view.width/2, self.view.height/2 - 50);
    [self.view addSubview:_loadingTipView];
    
    _bgloadingView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 64, 64)];
    _bgloadingView.center = CGPointMake(_loadingTipView.width/2 - 5,100);
    _bgloadingView.backgroundColor = CLEARCOLOR;
    //    bgloadingView.image  = [UIImage imageNamed:imageStr];
    [_loadingTipView addSubview:_bgloadingView];
    NSMutableArray *tmpArr = [NSMutableArray new];
    for (NSUInteger i = 0; i<3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"wheel%03ld",(long)i]];
        [tmpArr addObject:image];
    }
    _bgloadingView.animationImages   = tmpArr;
    _bgloadingView.animationDuration = 0.4;
//    [_bgloadingView startAnimating];
    _loadingTipLabel = LABEL(FONT(14),COLOR_999);
    _loadingTipLabel.frame = CGRectMake(0, _bgloadingView.bottom+ 5, _loadingTipView.width, 20);
    _loadingTipLabel.textAlignment = NSTextAlignmentCenter;
    _loadingTipLabel.text  = @"心急看不了好姿势";
    [_loadingTipView addSubview:_loadingTipLabel];
    _loadingTipView.hidden = YES;
    
    //noData
    _noDataTipView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 300)];
    _noDataTipView.backgroundColor = CLEARCOLOR;
    _noDataTipView.center  = CGPointMake(self.view.width/2, self.view.height/2 - 50);
    [self.view addSubview:_noDataTipView];
    
     _nodataImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    _nodataImageView.backgroundColor = CLEARCOLOR;
    _nodataImageView.image  = [UIImage imageNamed:_noDataImage];
    [_noDataTipView addSubview:_nodataImageView];
    
     _nodaTipLabel = LABEL(FONT(14),COLOR_999);
    _nodaTipLabel.frame = CGRectMake(0, _nodataImageView.bottom+ 5, _loadingTipView.width, 20);
    _nodaTipLabel.textAlignment = NSTextAlignmentCenter;
    _nodaTipLabel.text  = _noDataTip;
    [_noDataTipView addSubview:_nodaTipLabel];
    _noDataTipView.hidden = YES;
}
-(void)createLikeNav
{
    _likeNavBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    _likeNavBar.backgroundColor = MAINCOLOR;
    _likeNavBar.userInteractionEnabled = YES;
    
    _likeNavTitleLab       = LABEL(FONT(18), COLOR_333);
    _likeNavTitleLab.frame = CGRectMake(0, 27, 200, 30);
    _likeNavTitleLab.centerX = _likeNavBar.width/2;
    _likeNavTitleLab.textAlignment = NSTextAlignmentCenter;
    [_likeNavBar addSubview:_likeNavTitleLab];
    
    UIButton *likeBackBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 20, 44, 44)];
    likeBackBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    likeBackBtn.backgroundColor = CLEARCOLOR;
    [likeBackBtn addTarget:self action:@selector(backBtPressed) forControlEvents:UIControlEventTouchUpInside];
    likeBackBtn.titleLabel.font = ICONFONT(25);
    [likeBackBtn setTitleColor:COLOR_333 forState:UIControlStateNormal];
    [likeBackBtn setTitle:arrowLeft forState:UIControlStateNormal];
    [_likeNavBar addSubview:likeBackBtn];
    
    [self.view addSubview:_likeNavBar];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *pageTitle = self.title;
    [MobClick beginLogPageView:pageTitle];
    
    UIImage *navBgImg = _navColor ? [UIImage imageWithColor:_navColor] : [UIImage imageWithColor:MAINCOLOR];

    [self.navigationController.navigationBar setBackgroundImage:navBgImg
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    //注册键盘显示与消失的通知观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSString *pageTitle = self.title;
    [MobClick endLogPageView:pageTitle];

    [self.navigationController  resetBackground];

    //移除键盘显示与消失的通知观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.needFullScreenGes = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  返回事件
 */
-(void)backBtPressed
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

/**
 *  右侧按钮触发事件
 */
- (void)rightBtnPressed{}

//键盘弹出、落下
- (void) keyboardWasShown:(NSNotification *) notif{}

- (void) keyboardWasHidden:(NSNotification *) notif{}

-(void)createBackArrow
{
    if (_hasBackArrow) {
        if (!_backArrowColor) {
            _backArrowColor = COLOR_333;
        }
        [self setBackIcon:arrowLeft color:_backArrowColor fontSize:25];
        
        if (_hasLickNav) {

        }
    }
}

-(void)setNavRightTitle:(NSString *)navRightTitle
{
    _navRightTitle = navRightTitle;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.navRightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)setBackIcon:(NSString *)text color:(UIColor *)col fontSize:(CGFloat)size
{
    [self.navBackButton setTitle:text forState:UIControlStateNormal];
    [self.navBackButton setTitleFontSize:size];
    [self.navBackButton setTitleColor:col forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.navBackButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

-(void)setRightIcon:(NSString *)text color:(UIColor *)col fontSize:(CGFloat)size
{
    [self.navRightButton setTitle:text forState:UIControlStateNormal];
    [self.navRightButton setTitleFontSize:size];
    [self.navRightButton setTitleColor:col forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.navRightButton];
    self.navigationItem.rightBarButtonItem = rightItem;

}


-(void)setBackIcon:(NSString *)imageName
{
    [self.navBackButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.navBackButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)setRightIcon:(NSString *)imageName
{
    [self.navRightButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.navRightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}


-(void)setNavTitleView:(UIView *)view
{
    [self.navigationItem setTitleView:view];
    
}

-(void)setNavTitle:(NSString *)text
{
    _navTopTitle = text;
    if (NOTEmpty(_navTopTitle)) {
        [self.navigationItem setTitleView:self.navTitleLabel];
        _navTitleLabel.text = text;

    }
}

#pragma getters
-(UIButton *)navBackButton
{
    if (!_navBackButton) {
        _navBackButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        _navBackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _navBackButton.adjustsImageWhenHighlighted = NO;
        _navBackButton.titleEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 0);
        _navBackButton.backgroundColor = CLEARCOLOR;
        [_navBackButton addTarget:self action:@selector(backBtPressed) forControlEvents:UIControlEventTouchUpInside];
    }

    return _navBackButton;
}

-(UIButton *)navRightButton
{
    if (!_navRightButton) {
        _navRightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        _navRightButton.adjustsImageWhenHighlighted = NO;
        _navRightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [_navRightButton setTitle:_navRightTitle forState:UIControlStateNormal];
        [_navRightButton setTitleColor:MAINCOLOR forState:UIControlStateNormal];
        [_navRightButton addTarget:self action:@selector(rightBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    }

    return _navRightButton;
}

-(UILabel *)navTitleLabel
{
    if (!_navTitleLabel) {
        _navTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH - 150, 44)];
        _navTitleLabel.backgroundColor = CLEARCOLOR;
        _navTitleLabel.textAlignment = NSTextAlignmentCenter;
        _navTitleLabel.font = FONT(19);
        _navTitleLabel.textColor = COLOR_333;
    }
    return _navTitleLabel;
}


-(void)setLikeNavTitle:(NSString *)title
{
    _likeNavTitleLab.text = title;
}

-(void)setShowNoDataView:(BOOL)showNoDataView
{
    _showNoDataView = showNoDataView;
    _noDataTipView.hidden = !_showNoDataView;
    
}

-(void)setShowLoadingView:(BOOL)showLoadingView
{
    _showLoadingView = showLoadingView;
    _loadingTipView.hidden = !_showLoadingView;
    if (showLoadingView) {
        [_bgloadingView startAnimating];

    }else{
        [_bgloadingView stopAnimating];

    }
}

-(void)setLoadingTip:(NSString *)loadingTip
{
    _loadingTip = loadingTip;
    _loadingTipLabel.text = loadingTip;
}

-(void)setNoDataTip:(NSString *)noDataTip
{
    _noDataTip = noDataTip;
    _nodaTipLabel.text =noDataTip;
    
}

-(void)setNoDataImage:(NSString *)noDataImage
{
    _noDataImage = noDataImage;
    _nodataImageView.image = [UIImage imageNamed:noDataImage];
}

-(void)setNeedFullScreenGes:(BOOL)needFullScreenGes
{
    _needFullScreenGes = needFullScreenGes;
    EDBaseNavigationController *nav = (EDBaseNavigationController *)self.navigationController;
    nav.fullScreenBackGes = _needFullScreenGes;

}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


#pragma theme
-(void)themeChanged
{
    if (!_diffTheme) {
        return;
    }
    self.view.backgroundColor = View_BACKGROUND_COLOR;

}
-(void)checkTheme
{

}
@end

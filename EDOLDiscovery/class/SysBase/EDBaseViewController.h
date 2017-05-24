//
//  EDBaseViewController.h
//  EDOLDiscovery
//
//  Created by song on 16/12/24.
//  Copyright © 2016年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDDriveManHeaderView.h"
typedef void (^BackRefreshBlock)(id param);

@interface EDBaseViewController : UIViewController
@property (nonatomic,strong)BackRefreshBlock BackAction;
@property (nonatomic,assign)BOOL             hasBackArrow;
@property (strong,nonatomic)NSString        *navRightTitle;


//是否有自定义导航栏
@property (nonatomic,assign)BOOL             hasLickNav;

@property (nonatomic,strong)UIColor         *backArrowColor;

@property (nonatomic,strong)NSString         *loadingTip;
@property (nonatomic,strong)NSString         *noDataTip;
@property (nonatomic,strong)NSString         *noDataImage;

@property (nonatomic,assign)BOOL             showLoadingView;
@property (nonatomic,assign)BOOL             showNoDataView;
@property (nonatomic,assign)BOOL             diffTheme;//是否区分主题

@property (nonatomic,strong)UIColor          *navColor;


@property (nonatomic, assign)BOOL needFullScreenGes;

- (void)keyboardWasShown:(NSNotification *) notif;
- (void)keyboardWasHidden:(NSNotification *) notif;

- (void)backBtPressed;
- (void)rightBtnPressed;

-(void)setBackIcon:(NSString *)text color:(UIColor *)col fontSize:(CGFloat)size;
-(void)setRightIcon:(NSString *)text color:(UIColor *)col fontSize:(CGFloat)size;


-(void)setBackIcon:(NSString *)imageName;
-(void)setRightIcon:(NSString *)imageName;


-(void)setNavTitleView:(UIView *)view;
-(void)setNavTitle:(NSString *)text;


-(void)setLikeNavTitle:(NSString *)title;

-(void)themeChanged;
-(void)checkTheme;
@end

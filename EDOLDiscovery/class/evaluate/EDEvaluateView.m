//
//  EDEvaluateView.m
//  EDOLDiscovery
//
//  Created by Zhoufang on 17/3/27.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDEvaluateView.h"

@interface EDEvaluateView ()
{
    UIView *eBgView;
    UITapGestureRecognizer *dismissGesture;
    EDEViewTag edTag;
}

@end

@implementation EDEvaluateView

+ (void)showViewWithTag:(EDEViewTag)edETag{
    
    EDEvaluateView *eView = [[EDEvaluateView alloc] initWithEDETag:edETag];
    [eView showView];
}

- (void)showView{
    [KeyWindow endEditing:YES];
    [KeyWindow setUserInteractionEnabled:YES];
    [KeyWindow addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        eBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }];
}

- (void)dismissView{
    
    if (edEvaluate == edTag) {
        [self noteEvaluate];
    }
    
    if (self) {
        [self removeFromSuperview];
    }
}

- (instancetype)initWithEDETag:(EDEViewTag)tag{
    self = [super init];
    if (self) {
        edTag = tag;
        self.frame = [UIScreen mainScreen].bounds;
        
        eBgView = [[UIView alloc] initWithFrame:self.bounds];
        
        dismissGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
        [eBgView addGestureRecognizer:dismissGesture];
        [self addSubview:eBgView];
        
        if (edEvaluate == tag) {
            [self initRateContentViews];
        }
    }
    return self;
}

/**
 *初始化评价视图
 */
- (void)initRateContentViews{
    CGFloat gW  = 280;
    CGFloat gH = 284;
    
    UIView *gradeView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-gW)/2, 0, gW, gH)];
    gradeView.contentMode = UIViewContentModeScaleAspectFill;
    gradeView.center  = CGPointMake(SCREEN_WIDTH/2, (ControllerView_HEIGHT)/2+20);
    gradeView.clipsToBounds = YES;
    gradeView.layer.cornerRadius = 10.f;
    gradeView.backgroundColor = UIColorFromRGB(0XFFFFFF);
    [self addSubview:gradeView];
    
    UIView *cycleBg = [[UIView alloc]initWithFrame:CGRectMake(0, gradeView.top-46, 92, 92)];
    cycleBg.centerX             = SCREEN_WIDTH/2;
    cycleBg.backgroundColor     = WHITECOLOR;
    cycleBg.layer.cornerRadius  = cycleBg.width/2;
    cycleBg.layer.masksToBounds = YES;
    [self addSubview:cycleBg];
    
    UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(24, 10,44, 70)];
    headImg.contentMode = UIViewContentModeScaleToFill;
    headImg.userInteractionEnabled = YES;
    headImg.image = [[UIImage imageNamed:@"evaluate_chicken"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    [cycleBg addSubview:headImg];
    
    UILabel *titleLab = LABEL(FONT(21), UIColorFromRGB(0x333333));
    titleLab.backgroundColor = [UIColor whiteColor];
    titleLab.text = @"给小司鸡加油！";
    titleLab.frame = CGRectMake(gradeView.left, cycleBg.bottom+5, gradeView.width, 23);
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLab];
    
    UILabel *detailLab = LABEL(FONT(14), UIColorFromRGB(0x999999));
    detailLab.frame = CGRectMake(0,86, gradeView.width, 17);
    detailLab.text = @"开车开累了，求鼓励！";
    detailLab.textAlignment = NSTextAlignmentCenter;
    [gradeView addSubview:detailLab];
    
    CGFloat beginTop  = detailLab.bottom+20;
    CGFloat btnHeight = (gradeView.height-beginTop)/3;
    NSArray *titleArr = @[@"比心求赞",@"吐槽一下",@"残忍拒绝"];
    NSArray *colorArr = @[UIColorFromRGB(0XFF4A00),UIColorFromRGB(0X999999),UIColorFromRGB(0X999999)];
    
    for (int i = 0; i < 3; i++) {
        
        UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(12,beginTop+btnHeight*i, gradeView.width-24, 1)];
        lineImg.backgroundColor = UIColorFromRGB(0XEEEEEE);
        [gradeView addSubview:lineImg];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame     = CGRectMake(0, lineImg.bottom, gradeView.width, btnHeight);
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [btn setTitleColor:colorArr[i] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(edBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = FONT(16);
        [gradeView addSubview:btn];
    }
}

- (void)edBtnClick:(id)sender{
    UIButton *tmpBtn = (UIButton *)sender;
    
    if (tmpBtn.tag == 0 || tmpBtn.tag == 1) {
        [self rushToRate];
    }
    
    [self dismissView];
}

- (void)rushToRate
{
    if (IOS7_OR_LATER) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1193481895&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];
    }
    else
    {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1193481895"]];
    }
}

- (void)noteEvaluate{
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    [USER_DEFAULT setObject:version forKey:@"edol_lastEvaluateVersion"];
    [USER_DEFAULT setInteger:1 forKey:@"edol_canbeEvaluate"];
    [USER_DEFAULT synchronize];
}

+ (BOOL)checkNeedEvaluate{
    
    NSString *oldVersion         = [USER_DEFAULT objectForKey:@"edol_lastEvaluateVersion"];
    NSString *version            = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    
    NSInteger canbeRate          = [USER_DEFAULT integerForKey:@"edol_canbeEvaluate"]; //0,可以评分 1，不再提醒
    if (1 == canbeRate) {
        return ![oldVersion isEqualToString:version] ? YES : NO;
    }
    else{
        return YES;
    }
}

@end


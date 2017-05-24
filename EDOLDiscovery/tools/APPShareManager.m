//
//  APPShareManager.m
//  EDOLDiscovery
//
//  Created by song on 17/2/15.
//  Copyright © 2017年 song. All rights reserved.
//

#import "APPShareManager.h"

@implementation APPShareObject
@end


@interface APPShareManager ()

/**
 *   分享平台
 */
@property (nonatomic, strong)NSArray *platForms;


@property (nonatomic, strong)UIView *contentView;


@property (nonatomic, strong)UIView *blackMaskView;

@property (nonatomic, strong)UIView *actionView;

@property (nonatomic, strong)UIScrollView *iconScrollView;

@property (nonatomic,strong)APPShareObject *sObject;

@end

@implementation APPShareManager
+ (instancetype)manager
{
    static APPShareManager *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
        [instance createShareViews];
    });
    return instance;
}

-(void)createShareViews
{
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _contentView.backgroundColor = CLEARCOLOR;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [_contentView addGestureRecognizer:tapGes];
    _blackMaskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _blackMaskView.alpha = 0;
    _blackMaskView.backgroundColor = BLACKMASK_COLOR;
    [_contentView addSubview:_blackMaskView];
    
    _actionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    _actionView.top = _contentView.height;
    _actionView.backgroundColor = WHITECOLOR;
    [_contentView addSubview:_actionView];
    
    UILabel *titleLabel = LABEL(FONT(16), COLOR_666);
    titleLabel.frame = CGRectMake(0, 16, _actionView.width, 18);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"分享至";
    [_actionView addSubview:titleLabel];
    
    _iconScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 100)];
    _iconScrollView.showsHorizontalScrollIndicator = NO;
    _iconScrollView.backgroundColor = CLEARCOLOR;
    _iconScrollView.contentSize     = _iconScrollView.frame.size;
    [_actionView addSubview:_iconScrollView];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, _actionView.width, 50)];
    cancelBtn.bottom = _actionView.height;
    cancelBtn.backgroundColor = CLEARCOLOR;
    cancelBtn.titleLabel.font = FONT(16);
    [cancelBtn setTitleColor:COLOR_666 forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_actionView addSubview:cancelBtn];
    
}
+(void)setSharePlatForms:(NSArray *)platForms
{
    [APPShareManager manager].platForms = platForms;
    for (UIView *view in [APPShareManager manager].iconScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i<platForms.count; i++) {
        NSNumber *number = platForms[i];
        UIButton *btn = [self buttonWithType:number.integerValue];
        btn.center    = CGPointMake(30 + 100*i +35, 50);
        [[APPShareManager manager].iconScrollView addSubview:btn];
    }
    
    [APPShareManager manager].iconScrollView.contentSize = CGSizeMake(platForms.count * 100 + 30, 100);
    
}
+(UIButton *)buttonWithType:(NSInteger)type
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
    btn.tag = type;
    btn.layer.cornerRadius = 35;
    btn.layer.masksToBounds = YES;
    btn.titleLabel.font = ICONFONT(45);
    btn.adjustsImageWhenHighlighted = NO;
    [btn addTarget:[APPShareManager manager] action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    switch (type) {
        case UMSocialPlatformType_WechatSession:
        {//微信
            btn.backgroundColor = UIColorFromRGB(0xA8E06F);
            [btn setTitle:wechatIcon forState:UIControlStateNormal];
        }
            break;
        case UMSocialPlatformType_WechatTimeLine:
        {//微信朋友圈
            btn.backgroundColor = UIColorFromRGB(0xEA96D1);
            [btn setTitle:friendCircleIocn forState:UIControlStateNormal];

        }
            break;
        case UMSocialPlatformType_QQ:
        {//qq
            btn.backgroundColor = UIColorFromRGB(0xFF8F7F);
            [btn setTitle:qqIcon forState:UIControlStateNormal];

        }
            break;
        case UMSocialPlatformType_Qzone:
        {//qq空间
            btn.backgroundColor = UIColorFromRGB(0xFFC453);
            [btn setTitle:qzoneIcon forState:UIControlStateNormal];
            
        }
            
            break;
            
        default:
            break;
    }

    return btn;
}

-(void)shareAction:(UIButton *)sender
{
    UMSocialPlatformType type = (UMSocialPlatformType)sender.tag;
    [self shareWebPageToPlatformType:type];
    [self dismiss];
    
    
}
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:_sObject.shareTitle descr:_sObject.shareDesc thumImage:_sObject.shareImage];
    //设置网页地址
    shareObject.webpageUrl = _sObject.shareLink;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
//        [self alertWithError:error];
    }];
}


+ (void)showShareMenuInWindow:(APPShareObject *)sObject
{
    if (!sObject) {
        return;
    }
    [APPShareManager manager].sObject = sObject;
    [APPShareManager manager].iconScrollView.contentOffset = CGPointMake(0, 0);
    [KeyWindow addSubview:[APPShareManager manager].contentView];
    [UIView animateWithDuration:0.2 animations:^{
        [APPShareManager manager].blackMaskView.alpha = 1;
        [APPShareManager manager].actionView.bottom = SCREEN_HEIGHT;
    }];
}

-(void)dismiss
{
    [UIView animateWithDuration:0.2 animations:^{
        [APPShareManager manager].blackMaskView.alpha = 0;
        [APPShareManager manager].actionView.top = SCREEN_HEIGHT;
        
    } completion:^(BOOL finished) {
        [[APPShareManager manager].contentView removeFromSuperview];

    }];
}
@end

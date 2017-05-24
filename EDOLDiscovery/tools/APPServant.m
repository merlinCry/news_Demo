//
//  EDServant.m
//  EDOLDiscovery
//
//  Created by song on 16/12/24.
//  Copyright © 2016年 song. All rights reserved.
//

#import "APPServant.h"
#import "EDLoginViewController.h"
#import "EDPushModel.h"
#import "EDNewsDetailVC.h"
@implementation APPServant
+(instancetype)servant
{
    
    static dispatch_once_t once;
    
    static id sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
    
}

+(EDBaseNavigationController *)getCurrentNavigationVC
{
    return [[APPServant servant].rootTabbarVC selectedViewController];
}

+(EDBaseViewController *)getCurrentViewController
{
    EDBaseNavigationController *nav = [[APPServant servant].rootTabbarVC selectedViewController];
    EDBaseViewController *topVC =  (EDBaseViewController *)nav.topViewController;
    return topVC;
}
//用tabbarController中当前显示的navCtrl 去push
+(void)pushToController:(EDBaseViewController *)ctrl animate:(BOOL)animate
{
    [[APPServant getCurrentNavigationVC] pushViewController:ctrl animated:animate];
}

+(void)presentController:(EDBaseViewController *)ctrl animate:(BOOL)animate
{
    [[APPServant getCurrentNavigationVC] presentViewController:ctrl animated:animate completion:nil];
}

+(BOOL)isLogin
{
    BOOL res = NO;
    UserInfo *releaseUser = [APPServant servant].user;
    if (NOTEmpty(releaseUser)&&NOTEmpty(releaseUser.mId) && NOTEmpty(releaseUser.mVerifyCode)) {
        res = YES;
    }
    return res;
}

+(void)loginWithAccout:(NSString *)account password:(NSString *)pwd complate:(void (^)(BOOL))block
{
    if (ISEmpty(account)) {
        block(NO);
        return;
    }
    if (ISEmpty(pwd)) {
        block(NO);
        return;
    }
    UMMobClick(@"edol_login");
    
    NSMutableDictionary *reqDataDic_8dol = [NSMutableDictionary dictionaryWithObjectsAndKeys:account,@"mobile",[EDOLTool MD5String:pwd],@"password", nil];
    [reqDataDic_8dol setObject:@(ClientCode) forKey:@"loginSource"];

    [[HttpRequestManager manager] GET:Login_URL parameters:reqDataDic_8dol success:^(NSURLSessionDataTask * task,id responseObject)
     {
         NSDictionary *dataDic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         NSLog(@"获取成功:%@",dataDic);
         NSInteger rescode = [[dataDic objectForKey:@"rescode"] integerValue];
         
         if (rescode == 200) {
             NSDictionary *data = [NSDictionary dictionaryWithDictionary:[dataDic objectForKey:@"data"]];
             if (NOTEmpty(data)) {
                 //保存下用户信息
                 UserInfo *aUser = [UserInfo parseInfoFromDic:data];
                 [APPServant servant].user = aUser;
                 [aUser updateDiskCache];
                  if (block) {
                      block(YES);
                  }

                 //发送用户信息改变通知
                 [[NSNotificationCenter defaultCenter] postNotificationName:ED_UserInfo_Change object:nil];
                 
             }
         }else{
             [APPServant makeToast:KeyWindow title:[dataDic objectForKey:@"msg"] position:74];

             if (block) {
                 block(NO);
             }
         }
     }failure:^(NSURLSessionDataTask * task,NSError *errpr)
     {
         if (block) {
             block(NO);
         }
         NSLog(@"failuer");
         [APPServant makeToast:KeyWindow title:NETWOTK_ERROR_STATUS position:74];
     }];
    
    
}

+(void)activeUserToken:(void (^)(void))block
{

    NSDictionary *reqDataDic = [NSDictionary dictionaryWithObjectsAndKeys:VERIFYCODE,@"token",nil];
    [[HttpRequestManager manager] GET:ActivateUserToken parameters:reqDataDic success:^(NSURLSessionDataTask * task,id responseObject)
     {
         NSDictionary *dataDic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         if ([[dataDic objectForKey:@"rescode"] integerValue] == 200) {

                 NSString *token = [NetDataCommon stringFromDic:dataDic forKey:@"data"];
                 if (NOTEmpty(token)) {
                     //替换token
                     UserInfo *aUser = [APPServant servant].user;
                     aUser.mVerifyCode = token;
                     [aUser updateDiskCache];
                     
                     if (block) {
                         block();
                     }

                 }
         }else{
             //激活token失败,清除旧的登陆信息,重新登录
             [APPServant logOut];
             [APPServant popLoginVCWithInfo:@"您的登录信息已失效,请重新登陆"];
            
         }
     }failure:^(NSURLSessionDataTask * task,NSError *errpr)
     {
         NSLog(@"failuer");
     }];
}

-(void)loadUpApp
{
    [self initTheme];
    [self releaseFrozenUser];
    [self asyncInit];
}
-(void)initTheme
{
    BOOL isNightShift;
    NSString *theme = [EDOLTool readFromNSUserDefaults:ED_SkinStyle];
    if (ISEmpty(theme)) {
        isNightShift =  NO;
    }
    isNightShift = [theme isEqualToString:@"night"];
    
    self.nightShift = isNightShift;
}
//每次app打开 激活一下token
-(void)releaseFrozenUser
{
    NSDictionary *infoDic = [EDOLTool readFromNSUserDefaults:ED_LoginMark];
    if (NOTEmpty(infoDic)) {
        UserInfo *releaseUser = [UserInfo parseInfoFromDic:infoDic];
        [APPServant servant].user = releaseUser;
        if (NOTEmpty(releaseUser.mId) && NOTEmpty(releaseUser.mVerifyCode)) {
            [APPServant activeUserToken:^{
                
            }] ;
        }
    }
}

+(void)upLoadImageToAli:(UIImage *)image  scale:(CGFloat)scale completionBlock:(void (^)(BOOL, id))block
{
    NSString *timestamp = [NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSince1970]];
    NSString *yourKey   =  [NSString stringWithFormat:@"upload/user/%@_%@_iosHead.jpeg",USERID,timestamp];
    [APPServant postImageToAli:image scale:scale path:yourKey completionBlock:^(BOOL isSuccess, id param) {
        if (block) {
            block(isSuccess,param);
        }
    }];
}

+(void)postImageToAli:(UIImage *)image
                scale:(CGFloat)scale
                 path:(NSString *)path
      completionBlock:(void(^)(BOOL isSuccess, id param))block
{
    NSString *endpoint   = @"https://oss-cn-hangzhou.aliyuncs.com";
    NSString *accessKey  = @"dttWknoWt3hM1CcS";
    NSString *secretKey  = @"zGxNntp9aBM8fdXDkaCJD4Zba7Kthh";
    NSString *bucketName = @"8dol-static-img";

    NSString *imgUrl = [@"http://static2.8dol.com/" stringByAppendingString:path];
    NSData *imgData  = UIImageJPEGRepresentation(image, scale);
    if (ISEmpty(imgData)) {
        if (block) {
            block(NO,@"");
        }
        return;
    }
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:accessKey secretKey:secretKey];
    
    OSSClient *client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName    = bucketName;
    put.objectKey     = path;
    //文件格式
    put.contentType   = @"image/jpeg";
    //二进制数据
    put.uploadingData = imgData;
    //md5过后的二进制数据
    put.contentMd5 = [OSSUtil base64Md5ForData:imgData];
    
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    OSSTask * putTask = [client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"upload object success!");
            if (block) {
                block(YES,imgUrl);
            }
            
        } else {
            NSLog(@"upload object failed, error: %@" , task.error);
            if (block) {
                block(NO,@"");
            }
        }
        
        return nil;
    }];
}


-(NSMutableArray *)allAPPCategorys
{
    if (!_allAPPCategorys) {
        _allAPPCategorys = [NSMutableArray new];
    }
    return _allAPPCategorys;
}


+(void)popLoginVCWithInfo:(NSString *)info
{
    EDLoginViewController *loginVC = [EDLoginViewController new];
    loginVC.loginTip = info;
    loginVC.view.backgroundColor = CLEARCOLOR;
    EDBaseNavigationController *nextVC = [[EDBaseNavigationController alloc]initWithRootViewController:loginVC];
    nextVC.definesPresentationContext = YES;
    nextVC.view.backgroundColor = CLEARCOLOR;
    nextVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [nextVC setNavigationBarHidden:YES animated:NO];
    [[APPServant getCurrentViewController] presentViewController:nextVC animated:YES completion:nil];
}

+(void)logOut
{
    //清空本地存储信息
    [EDOLTool deleteFromNSUserDefaults:ED_LoginMark];
    [APPServant servant].user = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:ED_UserInfo_Change object:nil];
}

+(void)makeToast:(UIView *)view title:(NSString *)title position:(CGFloat)top
{
    if (ISEmpty(title)) {
        return;
    }
    UILabel *tipLabel = LABEL(FONT(16), UIColorFromRGB(0x8B572A));
    tipLabel.text = title;
    tipLabel.backgroundColor = MAINCOLOR;
    tipLabel.alpha = 0;
    tipLabel.textAlignment   = NSTextAlignmentCenter;
    CGFloat  titleWidth = [title sizeWithAttributes:@{NSFontAttributeName:FONT(16)}].width;
    tipLabel.frame    = CGRectMake(0, -46, titleWidth + 40, 40);
    tipLabel.centerX = view.width/2;
    tipLabel.layer.cornerRadius  = 20;
    tipLabel.layer.masksToBounds = YES;
    
    [view addSubview:tipLabel];
    
    [UIView animateWithDuration:0.3 animations:^{
        tipLabel.top = top;
        tipLabel.alpha = 1;

    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:1.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            tipLabel.alpha = 0;
            tipLabel.bottom = 0;
            
        } completion:^(BOOL finished) {
            [tipLabel removeFromSuperview];
        }];
    }];
    
}
-(void)setNightShift:(BOOL)nightShift
{
    _nightShift = nightShift;
    [[NSNotificationCenter defaultCenter] postNotificationName:ED_DayNight_Changed object:nil];
    //保存到本地
    [EDOLTool saveToNSUserDefaults:_nightShift?@"night":@"day" forKey:ED_SkinStyle];
}


//异步初始化hud所需图片
-(void)asyncInit
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [EDHud shareInstance];
    });
    
}


+(void)handleRemoteNotification:(NSDictionary *)dic alert:(BOOL)alert
{
    EDPushModel *message = [[EDPushModel alloc]initWithDic:dic];
    if (alert) {
        //此时app在前台，弹出一个提示框等待用户选择
        UIAlertController *alertview = [UIAlertController alertControllerWithTitle:@"热点资讯" message:message.content preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //取消啥也不干
        }];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去看看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //跳转文章详情
            [APPServant goToArticl:message];
        }];
        
        [alertview addAction:cancelAction];
        [alertview addAction:okAction];
        
        [[APPServant getCurrentViewController] presentViewController:alertview animated:YES completion:nil];
        
    }else{
        [APPServant goToArticl:message];
    }
    
}

+(void)goToArticl:(EDPushModel *)message
{
    //解析收到的数据
    if ([message.push_code  isEqualToString:@"WEB_SITE"]) {
        //跳转h5页面
        EDWebiewController *nextVC = [EDWebiewController new];
        nextVC.url = message.actionLinkUrl;
        nextVC.backArrowColor     = WHITECOLOR;
        nextVC.hasBackArrow       = YES;
        [APPServant pushToController:nextVC animate:YES];
        
    }else if([message.push_code isEqualToString:@"topic"]){
        //跳转文章详情
        EDNewsDetailVC *nextVC    = [EDNewsDetailVC new];
        nextVC.backArrowColor     = COLOR_333;
        nextVC.infoId             = message.topic_id;
        nextVC.hasBackArrow       = YES;
        nextVC.diffTheme          = YES;
        
        [APPServant pushToController:nextVC animate:YES];
    }
}

+(void)setBadge:(NSString *)badge atIndex:(NSInteger)index
{
    [[APPServant servant].rootTabbarVC setBadge:badge atIndex:index];
}
@end

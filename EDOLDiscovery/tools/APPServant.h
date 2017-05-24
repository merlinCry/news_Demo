//
//  EDServant.h
//  EDOLDiscovery
//
//  Created by song on 16/12/24.
//  Copyright © 2016年 song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AliyunOSSiOS/OSSService.h>
#import "EDRootViewController.h"

#define USERID     [APPServant servant].user.mId?:@""
#define VERIFYCODE [APPServant servant].user.mVerifyCode?:@""

@interface APPServant : NSObject
+(instancetype)servant;

/**
 *   user
 */
@property (nonatomic, strong)UserInfo *user;
//夜间模式
@property (nonatomic, assign)BOOL nightShift;


/**
 *   user
 */
@property (nonatomic, strong)EDRootViewController *rootTabbarVC;


//首页的所有分类 存储
@property (nonatomic, strong)NSMutableArray *allAPPCategorys;

+(EDBaseNavigationController *)getCurrentNavigationVC;
+(EDBaseViewController *)getCurrentViewController;

+(void)pushToController:(EDBaseViewController *)ctrl animate:(BOOL)animate;
+(void)presentController:(EDBaseViewController *)ctrl animate:(BOOL)animate;


+(BOOL)isLogin;

//登录
+ (void)loginWithAccout:(NSString *)account password:(NSString *)pwd  complate:(void(^)(BOOL isSuccess))block;

//退出登录
+(void)logOut;
+(void)activeUserToken:(void(^)(void))block;

//上传头像到阿里云
+(void)upLoadImageToAli:(UIImage *)image
                  scale:(CGFloat)scale
        completionBlock:(void(^)(BOOL isSuccess, id param))block;

//上传普通图片
+(void)postImageToAli:(UIImage *)image
                  scale:(CGFloat)scale
                 path:(NSString *)path
        completionBlock:(void(^)(BOOL isSuccess, id param))block;


+(void)popLoginVCWithInfo:(NSString *)info;

+(void)makeToast:(UIView *)view title:(NSString *)title position:(CGFloat)top;

//初始化一些东西(如：存在userDefault里面的user和主题)
-(void)loadUpApp;
-(void)releaseFrozenUser;

//处理远程通知
+(void)handleRemoteNotification:(NSDictionary *)dic alert:(BOOL)alert;


+(void)setBadge:(NSString *)badge atIndex:(NSInteger)index;
@end

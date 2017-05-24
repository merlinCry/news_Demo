//
//  AppDelegate.m
//  EDOLDiscovery
//
//  Created by song on 16/12/23.
//  Copyright © 2016年 song. All rights reserved.
//

#import "AppDelegate.h"
#import "EDDiscoveryVC.h"
#import "EDFocusVC.h"
#import "EDMyVC.h"
#import "TBCityIconFont.h"
#import "APPLaunchView.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialQQHandler.h"
#import "EDEvaluateView.h"
#import "EDHomeController.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif


#define UMAppkey     @"5876f27b1061d24cb8001964"
#define JPushAppkey  @"0c69ee13f9da36d61d1b41c2"
static BOOL  isProduction = NO;
static NSString  *channel = @"App Store";
@interface AppDelegate ()<JPUSHRegisterDelegate>


@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //初始化数据
    [[APPServant servant] loadUpApp];
    
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    [self initViewControllers];
    
    [_window makeKeyAndVisible];
    
    //初始化第三方sdk
    [self initThirdSDK:launchOptions];
    
//    [APPLaunchView makeLaunchView];
    
    return YES;
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED > 100000
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

#endif

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    if ([EDEvaluateView checkNeedEvaluate]) {
        [EDEvaluateView showViewWithTag:edEvaluate];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {}

- (void)applicationWillTerminate:(UIApplication *)application {}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window
{
    //仅支持竖屏
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark-
#pragma mark 推送相关

-(void)initJpush:(NSDictionary *)launchOptions
{
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    
    [JPUSHService setupWithOption:launchOptions appKey:JPushAppkey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
}


-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
//    NSString* token = [[[[deviceToken description]
//                         stringByReplacingOccurrencesOfString: @"<" withString: @""]
//                        stringByReplacingOccurrencesOfString: @">" withString: @""]
//                       stringByReplacingOccurrencesOfString: @" " withString: @""];
//    NSLog(@"%@deviceToken=========================>>>>",token);
    [JPUSHService registerDeviceToken:deviceToken];

}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);

}


#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
//应用在前台收到通知调这个方法
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
//    UNNotificationRequest *request = notification.request; // 收到推送的请求
//    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
//    NSNumber *badge            = content.badge;  // 推送消息的角标
//    NSString *body             = content.body;    // 推送消息体
//    UNNotificationSound *sound = content.sound;  // 推送消息的声音
//    NSString *subtitle         = content.subtitle;  // 推送消息的副标题
//    NSString *title            = content.title;  // 推送消息的标题
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [APPServant handleRemoteNotification:userInfo alert:YES];
        NSLog(@"iOS10 前台收到远程通知");
        
    }
    else {
        // 判断为本地通知
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}
//点击横幅后调用这个方法
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [APPServant   handleRemoteNotification:userInfo alert:NO];
        NSLog(@"iOS10 收到远程通知");
    }
    else {
        // 判断为本地通知

    }
    completionHandler();  // 系统要求执行这个方法
}
#endif

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"iOS7及以上系统，收到通知");
    [JPUSHService handleRemoteNotification:userInfo];
    [APPServant   handleRemoteNotification:userInfo alert:NO];

    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSLog(@"iOS6及以下系统，收到通知");
    [JPUSHService handleRemoteNotification:userInfo];
    [APPServant   handleRemoteNotification:userInfo alert:NO];

}


#pragma mark-
#pragma mark  customFunctions
/**
 * 注册第三方服务
 */
-(void)initThirdSDK:(NSDictionary *)launchOptions
{
    //iconFont
    [TBCityIconFont setFontName:@"bsi"];
    
    //友盟统计
    [self umengTrack];

    //友盟分享
    [self umengShare];
    
    //jpush
    [self initJpush:launchOptions];
    //百度地图
    //AliHotFix
    
    
}

- (void)umengTrack {
    [MobClick setLogEnabled:YES];
    UMConfigInstance.appKey    = UMAppkey;
    //    UMConfigInstance.channelId = @"App Store";//默认
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    //加密日志
    [MobClick setEncryptEnabled:YES];
    //测试
//    [MobClick setLogEnabled:YES];
    [MobClick startWithConfigure:UMConfigInstance];
}
-(void)umengShare
{
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
    
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMAppkey];
    
    // 获取友盟social版本号
    NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx9643219d54647df3" appSecret:@"5ab83fc0b0db16621ea74f65e776b101" redirectURL:@""];
    
    //设置分享到QQ互联的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105887921"  appSecret:@"5TW3MtftZ7tvYYne" redirectURL:@""];
}

//监听网络状态
//- (void)monitorNetWorkStatus
//{
//    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
//    
//    [manager startMonitoring];
//}
//
//- (void)stopMonitorNetWorkStatus
//{
//    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
//    [manager stopMonitoring];
//}

-(void)initViewControllers
{
    EDRootViewController *rootVC = [[EDRootViewController alloc]init];
    [APPServant servant].rootTabbarVC  = rootVC;
    
//    EDHomePageVC *firstVC = [EDHomePageVC new];
//    //有主题区分
//    firstVC.diffTheme     = YES;
//    firstVC.hasBackArrow  = YES;
    
    EDHomeController *firstVC = [EDHomeController new];
    EDBaseNavigationController *homeVC = [[EDBaseNavigationController alloc]initWithRootViewController:firstVC];
    homeVC.title = @"首页";
    homeVC.tabBarItem.image = [[UIImage imageNamed:@"tab_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_home_light"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    EDBaseNavigationController *discoveryVC = [[EDBaseNavigationController alloc]initWithRootViewController:[EDDiscoveryVC new]];
    discoveryVC.title = @"精选";
    discoveryVC.tabBarItem.image = [[UIImage imageNamed:@"tab_chosen"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    discoveryVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_chosen_light"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    EDBaseNavigationController *focusVC = [[EDBaseNavigationController alloc]initWithRootViewController:[EDFocusVC new]];
    focusVC.title = @"话题";
    focusVC.tabBarItem.image = [[UIImage imageNamed:@"tab_topic"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    focusVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_topic_light"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    EDBaseNavigationController *mysVC = [[EDBaseNavigationController alloc]initWithRootViewController:[EDMyVC new]];
    mysVC.title = @"我的";
    mysVC.tabBarItem.image = [[UIImage imageNamed:@"tab_mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mysVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_mine_light"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    rootVC.viewControllers = @[homeVC,discoveryVC,focusVC,mysVC];

    _window.rootViewController = rootVC;
    
}

@end

//
//  HttpRequestManager.m
//  SaleForIos
//
//  Created by bianjianfeng on 16/6/29.
//
//

#import "HttpRequestManager.h"

static CGFloat const RequestTimeoutInterval = 25.f;

@implementation HttpRequestManager


+ (HttpRequestManager *)manager
{
    static HttpRequestManager *sharedHttpRequestManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedHttpRequestManagerInstance = [[self alloc] init];
    });
    return sharedHttpRequestManagerInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

/**
 *  请求https安全策略
 *
 *  @since 2.5.1
 */
- (AFSecurityPolicy *)setHttpsRequestSecurityPolicy
{
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"8dol.cer" ofType:nil];
//    NSData  *certData = [NSData dataWithContentsOfFile:cerPath];
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//    securityPolicy.pinnedCertificates = @[certData];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    return securityPolicy;
}


- (void)GET:(NSString *)URLString
 parameters:(NSDictionary *)parameters
    success:(void (^)(NSURLSessionDataTask *, id))success
    failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    [self requestMethod:@"GET" url:URLString parameters:parameters success:success failure:failure];
}

- (void)GET:(NSString *)URLString
 parameters:(NSDictionary *)parameters
    cookies:(NSArray *)cookies
    success:(void (^)(NSURLSessionDataTask * task, id responseObject))success
    failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure
{
    [self requestMethod:@"GET" url:URLString parameters:parameters cookies:(NSArray *)cookies withOutUserInfo:NO  success:success failure:failure];
}

- (void)POST:(NSString *)URLString
  parameters:(NSDictionary *)parameters
     success:(void (^)(NSURLSessionDataTask *, id))success
     failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    [self requestMethod:@"POST" url:URLString parameters:parameters success:success failure:failure];
}

- (void)PUT:(NSString *)URLString
 parameters:(NSDictionary *)parameters
    success:(void (^)(NSURLSessionDataTask *, id))success
    failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    [self requestMethod:@"PUT" url:URLString parameters:parameters success:success failure:failure];
}

- (void)GET:(NSString *)URLString
 parameters:(NSDictionary *)parameters
withOutUserInfo:(BOOL)withOutUserInfo
    success:(void (^)(NSURLSessionDataTask * task, id responseObject))success
    failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure
{
    [self requestMethod:@"GET" url:URLString parameters:parameters cookies:nil withOutUserInfo:withOutUserInfo success:success failure:failure];
}

- (void)requestMethod:(NSString *)method
                  url:(NSString *)urlStr
           parameters:(NSDictionary *)parameters
              success:(void (^)(NSURLSessionDataTask *, id))success
              failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    [self requestMethod:method url:urlStr parameters:parameters cookies:nil withOutUserInfo:NO success:success failure:failure];
}

- (void)requestMethod:(NSString *)method
                  url:(NSString *)urlStr
           parameters:(NSDictionary *)parameters
      withOutUserInfo:(BOOL)withOutUserInfo
              success:(void (^)(NSURLSessionDataTask *, id))success
              failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    [self requestMethod:method url:urlStr parameters:parameters cookies:nil withOutUserInfo:withOutUserInfo success:success failure:failure];
}

- (void)requestMethod:(NSString *)method
                  url:(NSString *)urlStr
           parameters:(NSDictionary *)parameters
              cookies:(NSArray *)cookies
      withOutUserInfo:(BOOL)withOutUserInfo
              success:(void (^)(NSURLSessionDataTask *, id))success
              failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    
    NSMutableDictionary *reqDataDic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if (!withOutUserInfo) {
//APP Default Params
        
        NSString *version = [NSString stringWithFormat:@"CAMPUS_IOS_%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
        [reqDataDic setObject:version forKey:@"appVersion"];
        [reqDataDic setObject:[EDOLTool get_Idfa] forKey:@"deviceNo"];
        [reqDataDic setObject:[EDOLTool get_IpAddress] forKey:@"ip"];
        NSString *deviceName = [NSString stringWithFormat:@"%@",[EDOLTool iphoneType]];
        deviceName = [deviceName stringByReplacingOccurrencesOfString:@" " withString:@""];
        [reqDataDic setObject:deviceName forKey:@"deviceName"];
        
        if ([APPServant servant].user) {
            [reqDataDic setObject:USERID forKey:@"userId"];
            [reqDataDic setObject:VERIFYCODE forKey:@"verifyCode"];
        }

    }
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer = [[AFHTTPResponseSerializer alloc]init];
    
    //#warning HTTPS SSL INVALIDCER
    manger.securityPolicy  = [self setHttpsRequestSecurityPolicy];
    
    [manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manger.requestSerializer.timeoutInterval = RequestTimeoutInterval;
    [manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    if (NOTEmpty(cookies)) {
        NSDictionary *fieldDic = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
        for (NSString *key in fieldDic.allKeys) {
            [manger.requestSerializer setValue:fieldDic[key] forHTTPHeaderField:key];
        }
    }

    [EDOLTool printRequestString:urlStr paramters:reqDataDic];
    if ([method isEqualToString:@"GET"]) {
        [manger GET:urlStr parameters:reqDataDic progress:nil success:^(NSURLSessionDataTask * task, id responseObject) {
//            if (![self checkUserTokenIsLegal:responseObject]) return ;
            success(task,responseObject);
            
        } failure:^(NSURLSessionDataTask * task, NSError * error) {
            failure(task,error);
        }];
    }else if ([method isEqualToString:@"POST"]) {
        [manger POST:urlStr parameters:reqDataDic progress:nil success:^(NSURLSessionDataTask * task, id  responseObject) {
//            if (![self checkUserTokenIsLegal:responseObject]) return ;
            success(task,responseObject);
        } failure:^(NSURLSessionDataTask * task, NSError * error) {
            failure(task,error);
        }];
    }else if ([method isEqualToString:@"PUT"]) {
        [manger PUT:urlStr parameters:reqDataDic success:^(NSURLSessionDataTask * task, id  responseObject) {
//            if (![self checkUserTokenIsLegal:responseObject]) return ;
            success(task,responseObject);
        } failure:^(NSURLSessionDataTask * task, NSError * error) {
            failure(task,error);
        }];
    }
    
}

/**
 *  检测请求操作是否合法
 *
 *  @param response 返回参数
 *
 *  @return 是否合法
 *
 *  @since 2.5.1
 */
//- (BOOL)checkUserTokenIsLegal:(id)response
//{
//    NSDictionary *resDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
//
//    NSInteger rescode = [[NetDataCommon stringFromDic:resDic forKey:@"rescode"] integerValue];
//    if (rescode == 9401) {
//        NSString *errorMsg = [NetDataCommon stringFromDic:resDic forKey:@"msg"];
//        if (ISEmpty(errorMsg)) {
//            errorMsg = @"您的账号可能存在问题，请重新登录";
//        }
//        /**
//         *  登录信息异常取消当前所有请求
//         *
//         *  @since 2.5.1
//         */
//        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        [manager.operationQueue cancelAllOperations];
//        
//        [PXAlertView dismissAllAlertView];
//
//        [EDOLTool signOut];
//
//        [PXAlertView showAlertWithTitle:ALERT_TITLE message:errorMsg cancelTitle:ALERT_OK completion:^(BOOL cancelled) {
//            
//            AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//#warning 需要重新登陆
//            //登录页面不弹出
//
//        }];
//        return NO;
//    }
//    return YES;
//}


@end

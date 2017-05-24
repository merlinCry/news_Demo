//
//  HttpRequestManager.h
//  SaleForIos
//
//  Created by bianjianfeng on 16/6/29.
//
//

#import <Foundation/Foundation.h>

@interface HttpRequestManager : NSObject


+ (HttpRequestManager *)manager;


- (void)GET:(NSString *)URLString
 parameters:(NSDictionary *)parameters
    success:(void (^)(NSURLSessionDataTask * task, id responseObject))success
    failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;

- (void)POST:(NSString *)URLString
 parameters:(NSDictionary *)parameters
     success:(void (^)(NSURLSessionDataTask * task, id responseObject))success
     failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;

- (void)PUT:(NSString *)URLString
 parameters:(NSDictionary *)parameters
    success:(void (^)(NSURLSessionDataTask * task, id responseObject))success
    failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure;

- (void)GET:(NSString *)URLString
 parameters:(NSDictionary *)parameters
    cookies:(NSArray *)cookies
    success:(void (^)(NSURLSessionDataTask * task, id responseObject))success
    failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;


- (void)GET:(NSString *)URLString
 parameters:(NSDictionary *)parameters
    withOutUserInfo:(BOOL)withOutUserInfo
    success:(void (^)(NSURLSessionDataTask * task, id responseObject))success
    failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;


@end

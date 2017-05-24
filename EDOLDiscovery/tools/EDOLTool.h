//
//  EDOLTool.h
//  EDOLDiscovery
//
//  Created by song on 16/12/24.
//  Copyright © 2016年 song. All rights reserved.
//

#import <Foundation/Foundation.h>

BOOL NOTEmpty(id object);
BOOL ISEmpty(id object);

@interface EDOLTool : NSObject

+(id)defaultMyUtil;

/**
 *  @return 设备id
 *
 *  @since 2015-08-31
 */
+(NSString *)get_Idfa;

/**
 获取设备名称
 */
+ (NSString *)deviceName;


/**
 *  获取ip
 *
 *  @return ip地址
 *
 *  @since 2015-08-31
 */
+(NSString *)get_IpAddress;

//手机款式
+ (NSString *)iphoneType;
/**
 *  md5加密
 *
 *  @param aString 明文
 *
 *  @return 加密过的string
 *
 *  @since 2015-08-31
 */
+(NSString*)MD5String:(NSString *)aString;


//log接口日志
+(void)printRequestString:(NSString *)urlStr paramters:(NSDictionary *)paramtersDic;

//判断包含emoji
+ (BOOL)stringContainsEmoji:(NSString *)string;

/**
 去除小数点后无效的0
 */
+ (NSString *)deleteUnUsedZero:(NSString *)stringFloat;



//NSUserDefaults存储
+(id)readFromNSUserDefaults:(NSString *)key;

+(void)saveToNSUserDefaults:(id)data  forKey:(NSString *)key;

+(void)deleteFromNSUserDefaults:(NSString *)key;


//keyChain存储
+(id)readFromKeyChain:(NSString *)key;

+(void)saveToKeyChain:(id)data  forKey:(NSString *)key;

+(void)deleteFromKeyChain:(NSString *)key;


//FMDB存储


//本地目录存储
+(NSString *)homeDirectory;
+(NSString *)documentDirectory;
+(NSString *)tmpDirectory;

+(BOOL)createDirectoryAtDocument:(NSString *)dire;


+(BOOL)saveToDocment:(NSString *)fileName content:(NSData *)content;

+(BOOL)saveToTmp:(NSString *)fileName content:(NSData *)content;

+(NSData *)readFromDocment:(NSString *)fileName;

//获取document下的非隐藏文件列表
+(NSArray *)listAllFilesInDocument;


//从连接获取参数
+(NSDictionary *)paramterInQueryString:(NSString *)query;

//检查手机号格式
+(BOOL)checkMobile:(NSString *)mobile;

+(NSString *)base64EncodeString:(NSString *)string;

+(NSString *)base64decodeString:(NSString *)string;

//下载图片path是图片在本地的路径
+(void)downLoadImage:(NSString *)imgUrl  complate:(void(^)(NSString *source,UIImage *image))block;

@end

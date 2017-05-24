//
//  EDOLTool.m
//  EDOLDiscovery
//
//  Created by song on 16/12/24.
//  Copyright © 2016年 song. All rights reserved.
//

#import "EDOLTool.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <CommonCrypto/CommonDigest.h>
#import <AdSupport/AdSupport.h>
#import "KeychainIDFA.h"
#import <sys/utsname.h>

BOOL NOTEmpty(id object)
{
    if ([object isKindOfClass:[NSNull class]]) {
        return NO;
        
    }else if ([object isKindOfClass:[NSString class]]) {
        //string去掉空格的长度大于零
        NSString *temp = [object stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (temp.length > 0){
            return YES;
        }
    }else if ([object isKindOfClass:[NSArray class]]) {
        //数组元素大于0

        if (((NSArray *)object).count > 0){
            return YES;
        }
    }else if ([object isKindOfClass:[NSDictionary class]]) {
        //字典元素个数大于0

        if (((NSDictionary *)object).allKeys.count > 0){
            return YES;
        }
    }else if (object) {
        return YES;
    }
    return NO;
}

BOOL ISEmpty(id object)
{
    return !(NOTEmpty(object));
}

@implementation EDOLTool


+(NSString *)get_IpAddress
{
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    NSString *wifiAddress = nil;
    NSString *cellAddress = nil;
    
    // retrieve the current interfaces - returns 0 on success
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            sa_family_t sa_type = temp_addr->ifa_addr->sa_family;
            if(sa_type == AF_INET || sa_type == AF_INET6) {
                NSString *name = [NSString stringWithUTF8String:temp_addr->ifa_name];
                
                NSString *addr;
                if(sa_type == AF_INET6) {
                    char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN)];
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)temp_addr->ifa_addr;
                    addr = [NSString stringWithUTF8String:inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)];
                }else {
                    addr = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
                
                //NSLog(@"NAME: \"%@\" addr: %@", name, addr); // see for yourself
                
                if([name isEqualToString:@"en0"])
                    // Interface is the wifi connection on the iPhone
                    wifiAddress = addr;
                else
                    if([name isEqualToString:@"pdp_ip0"])
                        // Interface is the cell connection on the iPhone
                        cellAddress = addr;
                
            }
            temp_addr = temp_addr->ifa_next;
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    NSString *addr = wifiAddress ? wifiAddress : cellAddress;
    return addr ? addr : @"0.0.0.0";
}

+(NSString*)MD5String:(NSString *)aString
{
    NSString *toStr = [NSString stringWithFormat:@"%@",aString];
    
    const char *cStr = [toStr UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result);
    
    return [[[NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]] substringWithRange:NSMakeRange(0,32)] lowercaseString];
}

+(id)defaultMyUtil
{
    
    static dispatch_once_t once;
    
    static id sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
    
}

+(NSString *)get_Idfa
{
    NSString *idfa = @"";
    if (IOS10_OR_LATER) {
        NSString *tmpstr = [KeychainIDFA IDFA];
        if (NOTEmpty(tmpstr)) {
            idfa = tmpstr;
        }
        
    }else{
        idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }
    
    return idfa;
    
}

/**
 获取设备名称
 */
+ (NSString *)deviceName
{
    return [[UIDevice currentDevice] name];
}


+(void)printRequestString:(NSString *)urlStr paramters:(NSDictionary *)paramtersDic
{
    
    if (ISEmpty(urlStr) || ISEmpty(paramtersDic)) {
        return;
    }
    
    NSLog(@"当前为%@环境==",[URLADDRESS containsString:@"m.8dol.com"]?@"线上":@"测试");
    
    NSLog(@"接口====>  %@",urlStr);
    
    
    NSMutableString *urlPath = [NSMutableString stringWithFormat:@"%@?",urlStr];
    
    for (NSString *key in paramtersDic.allKeys) {
        NSString *pValue = [NetDataCommon stringFromDic:paramtersDic forKey:key];
        [urlPath appendFormat:@"&%@=%@",key,pValue];
    }
    
    NSLog(@"URL链接===>  %@",urlPath);
    
    
}

+ (NSString *)iphoneType
{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"]) return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"]) return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    
    return platform;
    
}


+ (BOOL)stringContainsEmoji:(NSString *)string
{
    if ([[[UIApplication sharedApplication]textInputMode].primaryLanguage isEqualToString:@"emoji"]) {
        return YES;
    }
    return NO;
}

+ (NSString *)deleteUnUsedZero:(NSString *)stringFloat
{
    const char *floatChars = [stringFloat UTF8String];
    NSUInteger length = [stringFloat length];
    NSUInteger zeroLength = 0;
    NSInteger i = length-1;
    for(; i>=0; i--)
    {
        if(floatChars[i] == '0'/*0x30*/) {
            zeroLength++;
        } else {
            if(floatChars[i] == '.')
                i--;
            break;
        }
    }
    NSString *returnString;
    if(i == -1) {
        returnString = @"0";
    } else {
        returnString = [stringFloat substringToIndex:i+1];
    }
    return returnString;

}


#pragma mark NSUserDefaults
+(id)readFromNSUserDefaults:(NSString *)key;
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return  [defaults objectForKey:key];
}

+(void)saveToNSUserDefaults:(id)data  forKey:(NSString *)key;
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:key];
    [defaults synchronize];
}

+(void)deleteFromNSUserDefaults:(NSString *)key;
{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}

#pragma mark keyChain

+(NSMutableDictionary *)getKeychainQuery:(NSString *)service
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                (id)kSecClassGenericPassword,(id)kSecClass,
                                service,(id)kSecAttrService,
                                service,(id)kSecAttrAccount,
                                (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
                                nil];
    return dic;
}


+(void)saveToKeyChain:(id)data forKey:(NSString *)key
{
    //获取参数字典，字典里面是一些基本配置信息(不是数据的存储字典，数据不存在这个字典中)
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    
    //删除里面原有的东西
    SecItemDelete((CFDictionaryRef) keychainQuery);
    
    //添加新数据
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}


+(id)readFromKeyChain:(NSString *)key
{
    id ret = nil;
    
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    
    CFDataRef keyData = NULL;
    
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        }
        @catch (NSException *exception) {
            NSLog(@"Unarchive of %@ failed: %@", key, exception);
        }
        @finally {
            
        }
    }
    
    if (keyData) CFRelease(keyData);
    
    return ret;
}


+(void)deleteFromKeyChain:(NSString *)key
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}


#pragma mark Document

+(NSString *)homeDirectory
{
    return NSHomeDirectory();
}
+(NSString *)documentDirectory
{
    return [[self homeDirectory] stringByAppendingPathComponent:@"Documents"];
}

+(NSString *)tmpDirectory
{
    return [[self homeDirectory] stringByAppendingPathComponent:@"tmp"];
}

+(BOOL)createDirectoryAtDocument:(NSString *)dire
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = [[self documentDirectory] stringByAppendingPathComponent:dire];
    
    return  [manager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
}

+(BOOL)saveToDocment:(NSString *)fileName content:(NSData *)content
{
    NSFileManager *manager  = [NSFileManager defaultManager];
    
    NSString *path = [[self documentDirectory] stringByAppendingPathComponent:fileName];
    return [manager createFileAtPath:path contents:content attributes:nil];
}

+(NSData *)readFromDocment:(NSString *)fileName
{
    NSFileManager *manager  = [NSFileManager defaultManager];
    
    NSString *path = [[self documentDirectory] stringByAppendingPathComponent:fileName];
    if ([manager fileExistsAtPath:path]) {
        return  [manager contentsAtPath:path];
    }
    return nil;
    
}

+(BOOL)saveToTmp:(NSString *)fileName content:(NSData *)content
{
    NSFileManager *manager  = [NSFileManager defaultManager];
    NSString *path = [[self tmpDirectory] stringByAppendingPathComponent:fileName];
    return [manager createFileAtPath:path contents:content attributes:nil];
    
}



+(NSArray *)listAllFilesInDocument
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSURL *bundleURL  = [NSURL URLWithString:[self documentDirectory]];
    NSArray *contents = [fileManager contentsOfDirectoryAtURL:bundleURL
                                   includingPropertiesForKeys:@[]
                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                        error:nil];
    
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pathExtension == 'png'"];
    //    for (NSURL *fileURL in [contents filteredArrayUsingPredicate:predicate]) {
    //        // 在目录中枚举 .png 文件
    //
    //        NSLog(@"%@",[fileURL.absoluteString lastPathComponent]);
    //    }
    return contents;
}


+(NSDictionary *)paramterInQueryString:(NSString *)query
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    NSArray *pars = [query componentsSeparatedByString:@"&"];
    for (NSString *str in pars) {
        NSArray *subArr = [str componentsSeparatedByString:@"="];
        
        if (subArr.count >= 2) {
            [dic setObject:subArr[1] forKey:subArr[0]];
        }
    }
    
    NSDictionary *resDic = [NSDictionary dictionaryWithDictionary:dic];
    return resDic;
}

+(BOOL)checkMobile:(NSString *)mobile
{

    NSString *tel = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    tel           = [tel stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSString *regex = @"^((13[0-9])|(14[0-9])|(15[0-9])|(17[0-9])|(18[0-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:tel];
    if (!isMatch) {
        return NO;
    }
    
    return YES;
    
}

+(NSString *)base64EncodeString:(NSString *)string
{
    if (ISEmpty(string)) {
        return @"";
    }
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}
+(NSString *)base64decodeString:(NSString *)string
{
    if (ISEmpty(string)) {
        return @"";
    }
    NSData *data = [[NSData alloc]initWithBase64EncodedString:string options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
}


+(void)downLoadImage:(NSString *)imgUrl complate:(void (^)(NSString *, UIImage *))block
{
    if (ISEmpty(imgUrl)) {
        return;
    }
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager.imageDownloader downloadImageWithURL:[NSURL URLWithString:imgUrl] options:SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        if (image) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSString *imgB64 = [UIImageJPEGRepresentation(image, 1.0) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                NSString *source = [NSString stringWithFormat:@"data:image/png;base64,%@", imgB64];
//               NSString *encodeStr = [source stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];

                if (block) {
                    block(source,image);
                }
            });
        }
    }];
    
}
@end

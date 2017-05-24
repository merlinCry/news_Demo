//
//  NetDataCommon.h
//  V5Iphone
//
//  Created by zhu on 11-10-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetDataCommon : NSObject {
    
}

/**
 解决从Number类型转NSString类型发生的精度丢失，并去除掉无效的0
 */
+ (NSString *)priceDecimalStringFromDic:(NSDictionary *)aDic forKey:(NSString *)aKey;


+(NSDictionary *)dictionaryFromDic:(NSDictionary *)aDic forKey:(NSString *)aKey;

/**
 *  解析字典，将字典内所有的value都转成string类型（防止出现NULL/nil）
 *
 *  @param aDic 字典
 *  @param aKey key
 *
 *  @return value
 *
 *  @since 2015-06-24
 */
+(id) stringFromDic:(NSDictionary*)aDic forKey:(NSString*)aKey;

+(NSInteger)idFromDic:(NSDictionary*)aDic forKey:(NSString*)aKey;

+(id) moneyStringFromDic:(NSDictionary*)aDic forKey:(NSString*)aKey;

//小数先后保留一位
+(NSString *)priceStringFromDic:(NSDictionary *)aDic forKey:(NSString *)akey;

//小数先后保留2位
+(NSString *)priceStringFromDicV2:(NSDictionary *)aDic forKey:(NSString *)akey;
/**
 *  解析NSArray
 *
 *  @param arr 数组
*
 *  @since 2015-06-24
 */
+(NSArray*)arrayWithNetData:(NSArray*)arr;

/**
 *  解析字典（防止实体里存在两种相同意义的key）
 *
 *  @param aDic     字典
 *  @param aKey     主要key
 *  @param otherKey 副要key
 *  @since 2015-06-24
 */
+(id) stringFromDic:(NSDictionary*)aDic forKey:(NSString*)aKey orKey:(NSString*)otherKey;

@end

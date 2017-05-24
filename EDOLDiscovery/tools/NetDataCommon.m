//
//  NetDataCommon.m
//  V5Iphone
//
//  Created by zhu on 11-10-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "NetDataCommon.h"

@implementation NetDataCommon

/**
 解决从Number类型转NSString类型发生的精度丢失，并去除掉无效的0
 */
+ (NSString *)priceDecimalStringFromDic:(NSDictionary *)aDic forKey:(NSString *)aKey
{
    NSString *sourceStrng = [NetDataCommon stringFromDic:aDic forKey:aKey];
    double d            = [sourceStrng doubleValue];
    NSString *dStr      = [NSString stringWithFormat:@"%f", d];
    NSDecimalNumber *dn = [NSDecimalNumber decimalNumberWithString:dStr];
    return [dn stringValue];
}

+(NSInteger)idFromDic:(NSDictionary*)aDic forKey:(NSString*)aKey
{
    return [[NetDataCommon stringFromDic:aDic forKey:aKey]integerValue];
}
+(id) stringFromDic:(NSDictionary*)aDic forKey:(NSString*)aKey
{
    if (![aDic isKindOfClass:[NSDictionary class]]) {
        return @"";
    }
    if ([aDic isKindOfClass:[NSNull class]]) {
        return @"";
    }
    id value = [aDic objectForKey:aKey];
    
    if ([value isKindOfClass:[NSNull class]]) {
        return @"";
    }
    if(![value isKindOfClass:[NSString class]])
    {
        if ([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        }
        value = @"";
    }
    if ([value isEqualToString:@"null"]) {
        value = @"";
    }
    return value;
}

+(id) moneyStringFromDic:(NSDictionary*)aDic forKey:(NSString*)aKey
{
    NSString *string = [NetDataCommon stringFromDic:aDic forKey:aKey];
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:1 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:[string floatValue]];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

+(NSString *)priceStringFromDic:(NSDictionary *)aDic forKey:(NSString *)akey
{
    return  [NSString stringWithFormat:@"%.1f",[[NetDataCommon stringFromDic:aDic forKey:akey] doubleValue]];
}
+(NSString *)priceStringFromDicV2:(NSDictionary *)aDic forKey:(NSString *)akey
{
    return  [NSString stringWithFormat:@"%.2f",[[NetDataCommon stringFromDic:aDic forKey:akey] doubleValue]];
}

+(NSDictionary *)dictionaryFromDic:(NSDictionary *)aDic forKey:(NSString *)aKey
{
    if ([aDic isKindOfClass:[NSNull class]]) {
        return [NSDictionary new];
    }
    id value = [aDic objectForKey:aKey];
    if (![value isKindOfClass:[NSDictionary class]]) return [NSDictionary new];
    
    return value;
}


+(id) stringFromDic:(NSDictionary*)aDic forKey:(NSString*)aKey orKey:(NSString*)otherKey
{
    if ([aDic isKindOfClass:[NSNull class]]) {
        return @"";
    }
    id value = [aDic objectForKey:aKey];
    
    if (nil == value) {
        value = [NetDataCommon stringFromDic:aDic forKey:otherKey];
    }
    else
    {
        value = [NetDataCommon stringFromDic:aDic forKey:aKey];
    }
    
    return value;
}

+(NSArray*)arrayWithNetData:(NSArray*)arr
{
    if (![arr isKindOfClass:[NSArray class]] || !arr) {
        return [NSArray array];
    }
    if (!arr.count) {
        return arr;
    }
    NSMutableArray * tmpArr = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (int i = 0; i < arr.count; i++) {
        if ([[arr objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
            NSDictionary * dir = [arr objectAtIndex:i];
            
            NSArray * key = [dir allKeys];
            
            NSMutableArray * object = [[NSMutableArray alloc] initWithCapacity:key.count];
            
            for (int j = 0; j< key.count; j++) {
                if ([[dir objectForKey:[key objectAtIndex:j]] isKindOfClass:[NSNull class]]) {
                    [object addObject:@""];
                }
                else
                {
                    [object addObject:[dir objectForKey:[key objectAtIndex:j]]];
                }
            }
            NSMutableDictionary * tmpDir = [[NSMutableDictionary alloc] initWithObjects:object forKeys:key];
            
            [tmpArr addObject:tmpDir];
        }
        else if ([[arr objectAtIndex:i] isKindOfClass:[NSString class]])
        {
            NSString *object =[arr objectAtIndex:i];
            [tmpArr addObject:object];
        }
        else if ([[arr objectAtIndex:i] isKindOfClass:[NSNumber class]])
        {
            NSNumber *object =[arr objectAtIndex:i];
            [tmpArr addObject:object];
        }
        else if ([[arr objectAtIndex:i] isKindOfClass:[NSNull class]])
        {
            NSString *object = @"";
            [tmpArr addObject:object];
        }
    }
    
    return tmpArr;
}

@end

//
//  NSString+ED.m
//  EDOLDiscovery
//
//  Created by song on 17/2/6.
//  Copyright © 2017年 song. All rights reserved.
//

#import "NSString+ED.h"

@implementation NSString (ED)
//电话号码中间4位****显示
-(NSString *)mobileNumFormate
{
    if (self.length < 7) {
        return self;
    }
    NSMutableString *newStr = [NSMutableString stringWithString:self];
    NSRange range = NSMakeRange(3, 4);
    [newStr replaceCharactersInRange:range withString:@"****"];
    return newStr;
}

/**删除末尾的0*/
//- (NSString *) removeUnwantedZero
//{
//
//}

//去掉前后空格
- (NSString *)trimmedString
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];

}
//去掉指定字符串
-(NSString *)trimmSpecial:(NSString *)specal
{
    if (specal.length == 0) {
        return self;
    }
  return [self stringByReplacingOccurrencesOfString:specal withString:@""];

}
//去掉所有换行\r  \n   \t
-(NSString *)trimmRNT
{
    NSString *trim_R = [self stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    NSString *trim_N = [trim_R stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *trim_T = [trim_N stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    return trim_T;
}

//Base64编码
-(NSString *)base64Encode
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

//Base64解码
-(NSString *)base64Decode
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}
@end

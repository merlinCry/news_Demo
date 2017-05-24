//
//  NSString+ED.h
//  EDOLDiscovery
//
//  Created by song on 17/2/6.
//  Copyright © 2017年 song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ED)

//电话号码中间4位****显示
-(NSString *)mobileNumFormate;

/**删除末尾的0*/
//- (NSString *) removeUnwantedZero;

//去掉前后空格
- (NSString *)trimmedString;
//去掉指定字符串
-(NSString *)trimmSpecial:(NSString *)specal;
//去掉所有换行\r  \n   \t
-(NSString *)trimmRNT;

//Base64编码
-(NSString *)base64Encode;

//Base64解码
-(NSString *)base64Decode;


@end

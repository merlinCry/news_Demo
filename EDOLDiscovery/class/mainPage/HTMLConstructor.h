//
//  HTMLConstructor.h
//  EDOLDiscovery
//
//  Created by song on 16/12/27.
//  Copyright © 2016年 song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EDHomeNewsModel.h"
@interface HTMLConstructor : NSObject


+(NSString *)htmlBaseDocument;


//根据服务端返回数据拼接一个html页面
+(NSString *)htmlForNewsDetail:(EDHomeNewsModel *)newsDetail;

@end

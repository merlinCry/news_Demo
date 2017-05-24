//
//  VideoInfo.m
//  EDOLDiscovery
//
//  Created by song on 16/12/27.
//  Copyright © 2016年 song. All rights reserved.
//

#import "VideoInfo.h"

@implementation VideoInfo
-(instancetype)initWithInfo:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _ref      = [NetDataCommon stringFromDic:dic forKey:@""];
        _url_mp4  = [NetDataCommon stringFromDic:dic forKey:@""];
        
    }
    return self;
    
}


@end

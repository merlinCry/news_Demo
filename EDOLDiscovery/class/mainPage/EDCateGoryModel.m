//
//  EDCateGoryModel.m
//  EDOLDiscovery
//
//  Created by song on 16/12/30.
//  Copyright © 2016年 song. All rights reserved.
//

#import "EDCateGoryModel.h"

@implementation EDCateGoryModel

-(instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _cateId    = [NetDataCommon stringFromDic:dic forKey:@"channelId"];
        _cateName  = [NetDataCommon stringFromDic:dic forKey:@"name"];
        _aliasName = [NetDataCommon stringFromDic:dic forKey:@"aliasName"];
        _enAlias   = [NetDataCommon stringFromDic:dic forKey:@"enAlias"];
        _cateIcon  = [NetDataCommon stringFromDic:dic forKey:@"icon"];
        _selected  = [[NetDataCommon stringFromDic:dic forKey:@"selected"] boolValue];
        _viewType = HomeViewTypeDefault;
        
        if (NOTEmpty(_enAlias) && [_enAlias isEqualToString:@"gaoxiao"]) {
            _viewType = HomeViewTypeTopic;

        }
    }
    return self;
}

-(BOOL)editing
{
    //推荐分类不可编辑
    if ([_enAlias isEqualToString:@"tuijian"]) {
        return NO;
    }
    return _editing;
}

@end

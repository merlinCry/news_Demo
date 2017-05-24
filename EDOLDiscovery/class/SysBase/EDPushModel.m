//
//  EDPushModel.m
//  EDOLDiscovery
//
//  Created by song on 2017/4/6.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDPushModel.h"

@implementation EDPushModel
-(instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _push_code      = [NetDataCommon stringFromDic:dic forKey:@"push_code"];
        _content        = [NetDataCommon stringFromDic:dic forKey:@"content"];
        _forwardPageUrl = [NetDataCommon stringFromDic:dic forKey:@"forwardPageUrl"];
        NSArray *arr    = [_forwardPageUrl componentsSeparatedByString:@"&"];
        NSMutableDictionary *actionDic = [NSMutableDictionary new];
        for (NSString *vStr in arr) {
            NSArray *tmpArr = [vStr componentsSeparatedByString:@"="];
            if (tmpArr.count == 2) {
                NSString *key   = tmpArr[0];
                NSString *value = tmpArr[1];
                [actionDic setObject:value forKey:key];
            }
        }
        
        _topic_id      = [NetDataCommon stringFromDic:actionDic forKey:@"topic_id"];
        _actionLinkUrl = [NetDataCommon stringFromDic:actionDic forKey:@"actionLinkUrl"];

    }
    return self;
}
@end

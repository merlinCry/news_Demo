//
//  EDPushModel.h
//  EDOLDiscovery
//
//  Created by song on 2017/4/6.
//  Copyright © 2017年 song. All rights reserved.
//  接收推送model

#import <Foundation/Foundation.h>

@interface EDPushModel : NSObject

/**
 *   消息类型WEB_SITE 网页，topic 文章推送
 */
@property (nonatomic, strong)NSString *push_code;

/**
 *   消息描述
 */
@property (nonatomic, strong)NSString *content;
/**
 *   跳转action   forwardPageUrl:action=topic&topic_id=资讯的ID
 */
@property (nonatomic, strong)NSString *forwardPageUrl;


//文章id
@property (nonatomic, strong)NSString *topic_id;
//h5链接的url
@property (nonatomic, strong)NSString *actionLinkUrl;



-(instancetype)initWithDic:(NSDictionary *)dic;
@end

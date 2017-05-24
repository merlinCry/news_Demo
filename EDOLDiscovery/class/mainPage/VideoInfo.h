//
//  VideoInfo.h
//  EDOLDiscovery
//
//  Created by song on 16/12/27.
//  Copyright © 2016年 song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoInfo : NSObject


@property (nonatomic,retain)NSString *url_mp4;

@property(nonatomic,retain)NSString *ref;

- (instancetype)initWithInfo:(NSDictionary *)dic;


@end

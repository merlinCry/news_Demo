//
//  APPShareManager.h
//  EDOLDiscovery
//
//  Created by song on 17/2/15.
//  Copyright © 2017年 song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UShareUI/UShareUI.h>
@interface APPShareObject : NSObject

/**
 *   title
 */
@property (nonatomic, strong)NSString *shareTitle;

/**
 *   desc
 */
@property (nonatomic, strong)NSString *shareDesc;


/**
 *   link
 */
@property (nonatomic, strong)NSString *shareLink;

/**
 *   image(url,UIImage,NSData都可以)
 */
@property (nonatomic, strong)id shareImage;

@end

@interface APPShareManager : NSObject

+ (instancetype)manager;


+(void)setSharePlatForms:(NSArray *)platForms;

//+ (void)showShareMenuInWindow:(void(^)(UMSocialPlatformType platForm))block;
+ (void)showShareMenuInWindow:(APPShareObject *)sObject;

@end

//
//  EDMyCollectModel.h
//  EDOLDiscovery
//
//  Created by song on 17/1/11.
//  Copyright © 2017年 song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EDMyCollectModel : NSObject


@property (nonatomic, strong)NSString *cId;
@property (nonatomic, strong)NSString *infoId;
//INFO   FUNNY
@property (nonatomic, strong)NSString *campusFavoriteType;
@property (nonatomic, strong)NSString *favoriteTypeName;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *imgLink;
@property (nonatomic, strong)NSString *content;
@property (nonatomic, strong)NSString *createTime;

@property (nonatomic, assign)CGFloat cellHeight;
@property (nonatomic, assign)CGFloat textHeight;
@property (nonatomic, assign)CGFloat descHeight;


-(instancetype)initWithDic:(NSDictionary *)dic;

@end

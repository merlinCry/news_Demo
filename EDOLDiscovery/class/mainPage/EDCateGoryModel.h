//
//  EDCateGoryModel.h
//  EDOLDiscovery
//
//  Created by song on 16/12/30.
//  Copyright © 2016年 song. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,HomeViewType) {
     HomeViewTypeDefault = 0,//新闻形式  未标明类型的都是新闻形式
     HomeViewTypeTopic   = 1,//帖子形式
};


@interface EDCateGoryModel : NSObject

/**
 *   id
 */
@property (nonatomic, strong)NSString *cateId;
/**
 *   name
 */
@property (nonatomic, strong)NSString *cateName;

/**
 *   aliasName
 */
@property (nonatomic, strong)NSString *aliasName;

/**
 *   enAlias  唯一不变别名
 */
@property (nonatomic, strong)NSString *enAlias;

/**
 *   icon
 */
@property (nonatomic, strong)NSString *cateIcon;

/**
 *   selected
 */
@property (nonatomic, assign)BOOL selected;

/**
 *   editIng
 */
@property (nonatomic, assign)BOOL editing;
/**
 *  注释
 */
@property (nonatomic, assign)HomeViewType viewType;

-(instancetype)initWithDic:(NSDictionary *)dic;

@end

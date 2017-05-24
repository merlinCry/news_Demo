//
//  EDHomeDataManager.h
//  EDOLDiscovery
//
//  Created by song on 17/1/10.
//  Copyright © 2017年 song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EDHomeNewsModel.h"
typedef void(^HomeDataManagerCompletionBlock)(NSArray* dataArr);
typedef NS_ENUM(NSInteger,LoadDataOption) {
     LoadDataOption_Normal = 0,//普通获取
     LoadDataOption_Refresh,   //刷新数据
     LoadDataOption_More,      //加载更多 ,分页用
};

@interface EDHomeDataManager : NSObject

+(instancetype)shareInstance;
//@property(nonatomic,assign)NSInteger currentPage;
//取磁盘中缓存的分类
@property(nonatomic,strong)NSArray *cateDiskCache;
//取磁盘中缓存的推荐列表
@property(nonatomic,strong)NSArray *homeDiskCache;


/*
    key           对应频道分类id
    option        更新方式
    completion    返回数据
 
 */
-(void)getHomeData:(NSString *)key
        loadOption:(LoadDataOption)option
         pageIndex:(NSInteger)page
   completionBlock:(HomeDataManagerCompletionBlock)completion;


-(void)removeModel:(EDHomeNewsModel *)model withKey:(NSString *)key;
@end

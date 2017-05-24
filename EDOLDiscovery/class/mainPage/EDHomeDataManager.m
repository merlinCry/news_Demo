//
//  EDHomeDataManager.m
//  EDOLDiscovery
//
//  Created by song on 17/1/10.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDHomeDataManager.h"
#import "EDHomeNewsModel.h"
#import "EDCateGoryModel.h"
@interface EDHomeDataManager ()
{
}
//存储所有分类的数据  （缓存）
@property(nonatomic,strong)NSMutableDictionary *dataSourceDic;

@end

@implementation EDHomeDataManager

+(instancetype)shareInstance
{
    static dispatch_once_t once;
    
    static id sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
    
}

-(NSMutableDictionary *)dataSourceDic
{
    if (ISEmpty(_dataSourceDic)) {
        _dataSourceDic = [NSMutableDictionary new];
    }
    return _dataSourceDic;
}


//策略   根据key到_dataSourceDic 查找，有：直接返回，无：从server获取
//然后填入_dataSourceDic  返回数据
-(void)getHomeData:(NSString *)key
        loadOption:(LoadDataOption)option
         pageIndex:(NSInteger)page
   completionBlock:(HomeDataManagerCompletionBlock)completion
{
    if (ISEmpty(key)) {
        return;
    }
    switch (option) {
        case LoadDataOption_Normal:
        {
            //1 从缓存获取
            NSArray *dataArr = [self dataWithKey:key];
            if (NOTEmpty(dataArr)) {
                completion(dataArr);
                
            }else{
                //从server获取
                [self requestData:key withStartRow:0 callback:^(NSArray *param,NSDictionary *jsonData) {
                    //避免删掉dis缓存的老数据
                    if (ISEmpty(param)) {
                        return;
                    }
                    //加入缓存
                    [self updateData:param atKey:key];
                    
                    //缓存到本地磁盘(目前每次刷新只缓存推荐数据)
                    NSArray *newDataArr = [NetDataCommon arrayWithNetData:jsonData[@"data"]];
                    if ([@"1" isEqualToString:key] && [newDataArr isKindOfClass:[NSArray class]] && NOTEmpty(newDataArr)) {
                        [self updateDiskCache:newDataArr];
                    }
                    //返回数据
                    completion([self dataWithKey:key]);
                }];
            }
        }
            break;
        case LoadDataOption_Refresh:
        {
            [self requestData:key withStartRow:0 callback:^(NSArray *param,NSDictionary *jsonData) {
                //更新dataSource
//                [self insertData:param atKey:key];
                [self updateData:param atKey:key];
                
                //缓存到本地磁盘(目前每次刷新只缓存推荐数据)
                NSArray *newDataArr = [NetDataCommon arrayWithNetData:jsonData[@"data"]];
                if ([@"1" isEqualToString:key] && [newDataArr isKindOfClass:[NSArray class]] && NOTEmpty(newDataArr)) {
                    [self updateDiskCache:newDataArr];
                }
                
                //返回数据
                completion([self dataWithKey:key]);
                //下拉获取到新数据通知
                NSString *tipStr = [NetDataCommon stringFromDic:jsonData forKey:@"msg"];
                if (NOTEmpty(tipStr)) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:ED_Home_DataRefresh object:tipStr];

                }

            }];
        }
            break;
        case LoadDataOption_More:
        {
//            NSInteger startR = 0;
//            NSArray *dataArr = [self dataWithKey:key];
//            if (NOTEmpty(dataArr)) {
//                NSInteger pages = (dataArr.count - 1)/10 + 1;
//                startR = pages*10;
//            }
            NSInteger startR = page*10;
            [self requestData:key withStartRow:startR callback:^(NSArray *param,NSDictionary *jsonData) {
                //像缓存追加数据
                [self appendData:param atKey:key];
                //返回数据
                completion([self dataWithKey:key]);
            }];
        }
            break;
        default:
            break;
    }

}

-(void)requestData:(NSString *)key
      withStartRow:(NSInteger)start
          callback:(void(^)(NSArray *param,NSDictionary *jsonData))dataBack
{
    NSDictionary *paramDic = @{
                               @"channelId":key,
                               @"start":@(start)
                               };
    
    [[HttpRequestManager manager] POST:HOMEAricl_List_URL parameters:paramDic success:^(NSURLSessionDataTask * task,id responseObject)
     {
         NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         NSMutableArray *dataSource = [NSMutableArray new];
         if ([[dic objectForKey:@"code"] integerValue] == 200) {
             NSArray *dataArr =[NetDataCommon arrayWithNetData:dic[@"data"]];
             for (NSInteger i = 0; i<dataArr.count; i++) {
                 EDHomeNewsModel *model = [[EDHomeNewsModel alloc]initWithDic:dataArr[i]];
                 [dataSource addObject:model];
             }
             dataBack([NSArray arrayWithArray:dataSource],dic);

         }else{
             [APPServant makeToast:KeyWindow title:[NetDataCommon stringFromDic:dic forKey:@"msg"] position:74];
             dataBack([NSArray arrayWithArray:dataSource],nil);

         }
     }failure:^(NSURLSessionDataTask * task,NSError *errpr)
     {
         [APPServant makeToast:KeyWindow title:NETWOTK_ERROR_STATUS position:74];
         dataBack([NSArray new],nil);

     }];
}

#pragma mark
#pragma mark 数据仓库操作

//get
-(NSArray *)dataWithKey:(NSString *)key
{
    NSArray *dataArr = [self.dataSourceDic objectForKey:key];
    if (ISEmpty(dataArr)) {
        dataArr = [NSArray new];
    }
    return dataArr;
}

//refresh
-(void)updateData:(NSArray *)dataArr atKey:(NSString *)key
{
//    [self.dataSourceDic setObject:dataArr forKey:key];
    [self addDataSource:dataArr withKey:key];
}

//append
-(void)appendData:(NSArray *)dataArr atKey:(NSString *)key
{
    NSArray *oldArr = [self.dataSourceDic objectForKey:key];
    if (NOTEmpty(oldArr)) {
        NSMutableArray *newArr = [[NSMutableArray alloc]initWithArray:oldArr];
        [newArr addObjectsFromArray:dataArr];
        [self addDataSource:[NSArray arrayWithArray:newArr] withKey:key];
    }else{
        [self.dataSourceDic setObject:dataArr forKey:key];
        [self addDataSource:dataArr withKey:key];

    }
}

//insert在头部向上添加数据
-(void)insertData:(NSArray *)dataArr atKey:(NSString *)key
{
    NSMutableArray *newArr = [NSMutableArray new];
    [newArr addObjectsFromArray:dataArr];
    NSArray *oldArr = [self.dataSourceDic objectForKey:key];
    if (NOTEmpty(oldArr)) {
        [newArr addObjectsFromArray:oldArr];
    }
    [self addDataSource:newArr withKey:key];
}

//delete
-(void)deleteData:(NSArray *)dataArr atKey:(NSString *)key
{
    if ([self.dataSourceDic.allKeys containsObject:key]) {
        [self.dataSourceDic removeObjectForKey:key];
    }
}
//删除单个model
-(void)removeModel:(EDHomeNewsModel *)model withKey:(NSString *)key
{
    NSMutableArray *datas = [NSMutableArray arrayWithArray:[self dataWithKey:key]];
    if (ISEmpty(datas)) {
        return;
    }
    [datas removeObject:model];
    [self updateData:[NSArray arrayWithArray:datas] atKey:key];
}

//将数据源添加到缓存dic，并去重复
-(void)addDataSource:(NSArray *)dataArr withKey:(NSString *)key
{
    //去重复
    NSOrderedSet *set = [NSOrderedSet orderedSetWithArray:dataArr];
    NSArray *resArr   = set.array;
    //过滤一下置顶
    NSArray *finalArr = [self checkTop:resArr];
    [self.dataSourceDic setObject:finalArr forKey:key];

}
//将置顶放到第一个
-(NSArray *)checkTop:(NSArray *)parmArr
{
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:parmArr];
    for (NSInteger i = 0; i<tmpArr.count; i++) {
        EDHomeNewsModel *model = tmpArr[i];
        if (model.stickyTopFlag) {
            [tmpArr removeObject:model];
            [tmpArr insertObject:model atIndex:0];
            break;
        }
    }
    return [NSArray arrayWithArray:tmpArr];
}
//更新磁盘缓存
-(void)updateDiskCache:(NSArray *)jsonDataArr
{
    [EDOLTool saveToNSUserDefaults:jsonDataArr forKey:ED_CacheKey];
}


-(NSArray *)cateDiskCache
{
    NSArray *diskArr = [EDOLTool readFromNSUserDefaults:ED_CateGory_CacheKey];
    if (NOTEmpty(diskArr)) {
        NSMutableArray *tmpSource = [NSMutableArray new];
        for (NSInteger i = 0; i<diskArr.count; i++) {
            EDCateGoryModel *model = [[EDCateGoryModel alloc]initWithDic:diskArr[i]];
            [tmpSource addObject:model];
        }
        return [NSArray arrayWithArray:tmpSource];
    }
    return [NSArray new];
}

-(NSArray *)homeDiskCache
{
    NSArray *diskArr = [EDOLTool readFromNSUserDefaults:ED_CacheKey];
    if (NOTEmpty(diskArr)) {
        NSMutableArray *tmpSource = [NSMutableArray new];
        for (NSInteger i = 0; i<diskArr.count; i++) {
            EDHomeNewsModel *model = [[EDHomeNewsModel alloc]initWithDic:diskArr[i]];
            [tmpSource addObject:model];
        }
        return [NSArray arrayWithArray:tmpSource];
    }
    return [NSArray new];

}

@end

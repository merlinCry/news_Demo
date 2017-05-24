//
//  ImageInfo.h
//  EDOLDiscovery
//
//  Created by song on 16/12/27.
//  Copyright © 2016年 song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageInfo : NSObject

@property(nonatomic,strong)NSString *mid;
@property(nonatomic,strong)NSString *infoId;
@property(nonatomic,strong)NSString *img;


//占位符
@property(nonatomic,strong)NSString *ref;

//不一定有
@property(nonatomic,assign)NSInteger width;
@property(nonatomic,assign)NSInteger height;
@property(nonatomic,assign)NSInteger ratio;

/**
 *   图片缓存
 */
@property (nonatomic, strong)UIImage *cachedImage;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,assign)CGSize    size;

/**
 *  是否为gif
 */
@property (nonatomic, assign)BOOL isGif;
- (instancetype)initWithInfo:(NSDictionary *)dic;

@end

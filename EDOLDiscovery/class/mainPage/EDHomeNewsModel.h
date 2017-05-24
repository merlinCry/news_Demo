//
//  EDHomeNewsModel.h
//  EDOLDiscovery
//
//  Created by song on 16/12/26.
//  Copyright © 2016年 song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYTextContainer.h"

typedef NS_ENUM(NSInteger,EDHCommonCellStyle) {
    EDHCommonCellStyleOnelyText = 0, //只有文字
    EDHCommonCellStyleIMG1,          //一张图片,在中间
    EDHCommonCellStyleIMG3,          //三张图片
    EDHCommonCellStyleIMGRight,      //一张图片局右
};

@interface EDHomeNewsModel : NSObject

@property (nonatomic, strong)NSString *channelId;
@property (nonatomic, strong)NSString *infoId;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *author;//来源
@property (nonatomic, strong)NSString *content;
@property (nonatomic, strong)NSString *commentCount;

@property (nonatomic, strong)NSString *releaseTimeStr;
@property (nonatomic, strong)NSArray  *imageList;
@property (nonatomic, strong)NSArray  *videoList;


@property (nonatomic, strong)TYTextContainer *textContainer;


@property (nonatomic, assign)CGFloat cellHeight;
@property (nonatomic, assign)CGFloat textHeight;
@property (nonatomic, assign)CGFloat imageHeight;

@property (nonatomic, assign)BOOL    hasRead;
//置顶标志
@property (nonatomic, assign)BOOL    stickyTopFlag;


@property (nonatomic, assign)EDHCommonCellStyle cellStyle;


-(instancetype)initWithDic:(NSDictionary *)dic;

-(void)resetTextContainer;

@end

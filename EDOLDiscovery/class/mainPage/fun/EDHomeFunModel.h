//
//  EDHomeFunModel.h
//  EDOLDiscovery
//
//  Created by song on 17/1/4.
//  Copyright © 2017年 song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYTextContainer.h"
#import "ImageInfo.h"
typedef NS_ENUM(NSInteger,EDHomeFunStyle) {
    EDHomeFunStyle_justText = 0,//只有文字
    EDHomeFunStyle_Pic1Nor,     //1图  normal
    EDHomeFunStyle_Pic1Long,    //1图  长
    EDHomeFunStyle_Pics,        //多图
};

@interface EDHomeFunModel : NSObject

@property (nonatomic, strong)NSString *channelId;
@property (nonatomic, strong)NSString *infoId;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *content;

//title
@property (nonatomic, strong)TYTextContainer *textContainer;
//content
@property (nonatomic, strong)TYTextContainer *contentContainer;

@property (nonatomic, strong)NSString *commentCount;//品论数量
@property (nonatomic, strong)NSString *upVoteCount;//赞 数量
@property (nonatomic, assign)BOOL      upVoted; //是否赞过
@property (nonatomic, assign)BOOL      shared; //是否分享过
@property (nonatomic, assign)BOOL      collected; //是否收藏过



@property (nonatomic, assign)EDHomeFunStyle funStyle;

//图片列表
@property (nonatomic, strong)NSArray  *imageList;



@property (nonatomic, assign)CGFloat cellHeight;
@property (nonatomic, assign)CGFloat textHeight;//文字高度
@property (nonatomic, assign)CGSize  imageContainerSize; //图片高度



-(instancetype)initWithDic:(NSDictionary *)dic;

@end

//
//  EDMyCollectModel.m
//  EDOLDiscovery
//
//  Created by song on 17/1/11.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDMyCollectModel.h"

@implementation EDMyCollectModel


-(instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _cId    = [NetDataCommon stringFromDic:dic forKey:@"id"];
        _infoId = [NetDataCommon stringFromDic:dic forKey:@"infoId"];
        _campusFavoriteType = [NetDataCommon stringFromDic:dic forKey:@"campusFavoriteType"];
        _favoriteTypeName = [NetDataCommon stringFromDic:dic forKey:@"favoriteTypeName"];
        
        _title   = [NetDataCommon stringFromDic:dic forKey:@"title"];
        _content = [NetDataCommon stringFromDic:dic forKey:@"content"];
        if (NOTEmpty(_content)) {
          _content = [_content stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
          _content = [_content stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
        }
        _imgLink = [NetDataCommon stringFromDic:dic forKey:@"imgLink"];
        _createTime = [NetDataCommon stringFromDic:dic forKey:@"createTime"];
       
        //文字高度都为两行默认
        _textHeight = 40;
        _descHeight = 40;
        if ([_campusFavoriteType isEqualToString:@"FUNNY"]) {
            CGSize textSize =  CGSizeMake(SCREEN_WIDTH - 28, 70);
            //段子
            if (NOTEmpty(_title)) {
                //计算title高度最多70
                _textHeight =[_title
                              boundingRectWithSize:textSize
                              options:NSStringDrawingUsesLineFragmentOrigin
                              attributes:@{NSFontAttributeName:FONT(16)}
                              context:nil].size.height;
            }else{
                _textHeight = 0;
            }

            if (NOTEmpty(_imgLink)) {
                //此时图片高度140
                _cellHeight = 70 + _textHeight + 140;
            }else{
               //计算desc高度最多70
                if (NOTEmpty(_content)) {
                    _descHeight =[_content
                                  boundingRectWithSize:textSize
                                  options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:FONT_Light(16)}
                                  context:nil].size.height;
                }else{
                    _descHeight = 0;
                }

                _cellHeight = 50 + _textHeight + _descHeight;
            }
            
        }else{
            //咨询
            if (NOTEmpty(_imgLink)) {
                _cellHeight =  138;
                
            }else{
                _cellHeight = 70 + _textHeight;
                
            }
            
        }
    }
    return self;
}


@end

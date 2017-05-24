//
//  ImageInfo.m
//  EDOLDiscovery
//
//  Created by song on 16/12/27.
//  Copyright © 2016年 song. All rights reserved.
//

#import "ImageInfo.h"

@implementation ImageInfo


-(instancetype)initWithInfo:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _mid   = [NetDataCommon stringFromDic:dic forKey:@"id"];
        _infoId   = [NetDataCommon stringFromDic:dic forKey:@"infoId"];
        _img   = [NetDataCommon stringFromDic:dic forKey:@"imgLink"];
        _width = [[NetDataCommon stringFromDic:dic forKey:@"width"] floatValue];
        _height= [[NetDataCommon stringFromDic:dic forKey:@"heiht"] floatValue];
        _ratio = [[NetDataCommon stringFromDic:dic forKey:@"ratio"] floatValue];
        _ref   = [NetDataCommon stringFromDic:dic  forKey:@"ref"];

        if (NOTEmpty(_img)) {
            _isGif = [_img hasSuffix:@".gif"];
        }
    }
    return self;
    
}

-(void)setCachedImage:(UIImage *)cachedImage
{
    _cachedImage = cachedImage;
    _size        = _cachedImage.size;
    
}
@end

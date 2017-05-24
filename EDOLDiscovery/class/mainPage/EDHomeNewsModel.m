//
//  EDHomeNewsModel.m
//  EDOLDiscovery
//
//  Created by song on 16/12/26.
//  Copyright © 2016年 song. All rights reserved.
//

#import "EDHomeNewsModel.h"
#import "ImageInfo.h"
#import "VideoInfo.h"
#import "TYTextContainer.h"
@implementation EDHomeNewsModel
-(instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _channelId = [NetDataCommon stringFromDic:dic forKey:@"channelId"];
        _infoId    = [NetDataCommon stringFromDic:dic forKey:@"infoId"];
        _author    = [NetDataCommon stringFromDic:dic forKey:@"author"];
        _title     = [NetDataCommon stringFromDic:dic forKey:@"title"];
        _stickyTopFlag = [[NetDataCommon stringFromDic:dic forKey:@"stickyTopFlag"] boolValue];
        //去换行影响效率
//        if (NOTEmpty(_title)) {
//            _title = [_title trimmRNT];
//        }
//        NSString *tmpStr  = [NetDataCommon stringFromDic:dic forKey:@"content"];
//        NSString *noAStr =  [tmpStr stringByReplacingOccurrencesOfString:@"<a>" withString:@""];
//        _content = [noAStr stringByReplacingOccurrencesOfString:@"</a>" withString:@""];
        _content  = [NetDataCommon stringFromDic:dic forKey:@"content"];

        _releaseTimeStr = [NetDataCommon stringFromDic:dic forKey:@"releaseTime"];
        _commentCount = [NetDataCommon stringFromDic:dic forKey:@"commentCount"];
        
        //图片
        NSArray *imgArr = [NetDataCommon arrayWithNetData:dic[@"imageList"]];
        NSMutableArray *tmpList = [NSMutableArray new];
        for (NSDictionary *imgDic in imgArr) {
            ImageInfo *imgInfo = [[ImageInfo alloc]initWithInfo:imgDic];
            [tmpList addObject:imgInfo];
        }
        _imageList = [NSArray arrayWithArray:tmpList];
        //根据图片数量给cell划分类型
        if (_imageList.count == 0) {
            _cellStyle = EDHCommonCellStyleOnelyText;
            
        }else if(_imageList.count >0  && _imageList.count < 3){
            _cellStyle = EDHCommonCellStyleIMGRight;

        }else{
            _cellStyle = EDHCommonCellStyleIMG3;
            
        }
        
        
        //视频
        NSArray *videoArr = [NetDataCommon arrayWithNetData:dic[@"videoList"]];
        NSMutableArray *vList = [NSMutableArray new];
        for (NSDictionary *vDic in videoArr) {
            VideoInfo *vInfo = [[VideoInfo alloc]initWithInfo:vDic];
            [vList addObject:vInfo];
        }
        _videoList = [NSArray arrayWithArray:vList];
        
        
        [self resetTextContainer];

    }
    return self;
}

-(void)resetTextContainer
{
    // 属性文本生成器
    TYTextContainer *textContainer = [[TYTextContainer alloc]init];
    textContainer.text = _title;
    textContainer.font = FONT_Light(18);
    textContainer.linesSpacing     = 3;
    textContainer.characterSpacing = 0;
    
    CGFloat maxWidth = SCREEN_WIDTH - 24;
    if (_cellStyle == EDHCommonCellStyleIMGRight) {
        maxWidth = SCREEN_WIDTH - 150;
    }
    _textContainer = [textContainer createTextContainerWithTextWidth:maxWidth];
}

-(CGFloat)cellHeight
{
    CGFloat minHeight   = 72;
    CGFloat padding     = 10;
    CGFloat bottomHeiht = 40;
    CGFloat height    = padding;
    
    switch (_cellStyle) {
        case EDHCommonCellStyleOnelyText:
        {
            height += self.textHeight;
            height += bottomHeiht;
        }
            break;
        case EDHCommonCellStyleIMG1:
        {
            height += self.textHeight;
            if (NOTEmpty(_imageList)) {
                height += [self imageHeight];
            }
            height += bottomHeiht;
            
        }
            break;
        case EDHCommonCellStyleIMG3:
        {
            height += self.textHeight;
            if (NOTEmpty(_imageList)) {
                height += [self imageHeight];
            }
            height += bottomHeiht;
        }
            break;
        case EDHCommonCellStyleIMGRight:
        {
            return [self imageHeight] + 24;
        }
            break;
            
        default:
            break;
    }

    return MAX(height, minHeight);
}

-(CGFloat)textHeight
{
    return _textContainer.textHeight;
}

-(CGFloat)imageHeight
{
    CGFloat imgHieht = 0;
    switch (_cellStyle) {
        case EDHCommonCellStyleOnelyText:
        {
            imgHieht = 0;
        }
            break;
        case EDHCommonCellStyleIMG1:
        {
            imgHieht = (SCREEN_WIDTH - 20)/2;
            
        }
            break;
        case EDHCommonCellStyleIMG3:
        case EDHCommonCellStyleIMGRight:
        {
            CGFloat space   = 10;
            CGFloat scale   = 112/80.0f;
            CGFloat oneImgW = (SCREEN_WIDTH - space*4)/3;
            imgHieht        = oneImgW/scale;
            
        }
            break;
        default:
            break;
    }

    return imgHieht;
}

-(void)setCellStyle:(EDHCommonCellStyle)cellStyle
{
    _cellStyle = cellStyle;
    [self resetTextContainer];
}


//这里根据title来判断相等
-(BOOL)isEqual:(id)object
{
    EDHomeNewsModel *tModel = (EDHomeNewsModel *)object;
    return [self.title isEqualToString:tModel.title];
}

- (NSUInteger)hash {
    return [self.title hash];
}
@end

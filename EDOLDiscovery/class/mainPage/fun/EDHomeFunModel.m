//
//  EDHomeFunModel.m
//  EDOLDiscovery
//
//  Created by song on 17/1/4.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDHomeFunModel.h"
@implementation EDHomeFunModel
-(instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _channelId = [NetDataCommon stringFromDic:dic forKey:@"channelId"];
        _infoId    = [NetDataCommon stringFromDic:dic forKey:@"infoId"];
        _content   = [NetDataCommon stringFromDic:dic forKey:@"content"];
        _title     = [NetDataCommon stringFromDic:dic forKey:@"title"];
        _commentCount = [NetDataCommon stringFromDic:dic forKey:@"commentCount"];
        _upVoteCount = [NetDataCommon stringFromDic:dic forKey:@"upVoteCount"];
        _upVoted  = [[NetDataCommon stringFromDic:dic forKey:@"upVoted"] boolValue];
        _collected  = [[NetDataCommon stringFromDic:dic forKey:@"collected"]boolValue];
        NSArray *imgArr = [NetDataCommon arrayWithNetData:dic[@"imageList"]];
        NSMutableArray *tmpList = [NSMutableArray new];
        for (NSDictionary *imgDic in imgArr) {
            ImageInfo *imgInfo = [[ImageInfo alloc]initWithInfo:imgDic];
            [tmpList addObject:imgInfo];
        }
        _imageList = [NSArray arrayWithArray:tmpList];
        if (NOTEmpty(_title)) {
          _textContainer = [self creatTextContainer:_title];

        }
        
        if (NOTEmpty(_content)) {
            NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"<p>"];
            NSString *cleanStr = [[_content componentsSeparatedByCharactersInSet:doNotWant] componentsJoinedByString:@""];
            _contentContainer = [self creatTextContainer:cleanStr];
            
        }

    
        
        //根据图片数量给cell划分类型
        _funStyle = EDHomeFunStyle_justText;
        if(_imageList.count == 1){
            //暂不区分长图
            _funStyle = EDHomeFunStyle_Pic1Nor;

            
        }else if(_imageList.count > 1){
            //多图
            _funStyle = EDHomeFunStyle_Pics;
        }

    }
    return self;
}
- (TYTextContainer *)creatTextContainer:(NSString *)text
{
    // 属性文本生成器
    TYTextContainer *textContainer = [[TYTextContainer alloc]init];
    textContainer.text = text;
    textContainer.font = FONT_Light(16);
    textContainer.linesSpacing  = 1;
    textContainer.characterSpacing = 1;
    textContainer.numberOfLines = 4;
//    textContainer.lineBreakMode = NSLineBreakByCharWrapping;
    textContainer = [textContainer createTextContainerWithTextWidth:SCREEN_WIDTH - 36];
    return textContainer;
}



-(CGFloat)cellHeight
{
    CGFloat padding  = 18;
    CGFloat spaceing = 5;
    
    CGFloat height = 0;
    //上边距
    height += padding;
    //标题
    height += self.textHeight;
    
    if (NOTEmpty(_imageList)) {
        height += spaceing;
        //图片高度
        height += self.imageContainerSize.height;
    }else{
        height += spaceing;
        //图片高度
        height += self.contentContainer.textHeight;
    }

    
    //底部bar 45
    height += 40;
    
    return height;
}

-(CGFloat)textHeight
{
    return _textContainer.textHeight;
}

-(CGSize)imageContainerSize
{
    
    if (ISEmpty(_imageList)) {
        return CGSizeZero;
    }
    CGFloat picSize = (SCREEN_WIDTH - 18*2 - 8*2)/3;
    NSInteger rows  = (_imageList.count - 1)/3  + 1;
    CGSize size     = CGSizeZero;
    
    if (_imageList.count == 1) {
        size.width  = 224;
        size.height = 140;
    }else if(_imageList.count == 4 ){
        size.width  = 2 * picSize + 8;
        size.height = 2 * picSize + 8;
        
    }else{
        //九宫格
        size.width  = SCREEN_WIDTH - 36;
        size.height = rows * picSize + (rows-1)*8;
    }
    
    return size;
}

//这里根据title来判断相等
-(BOOL)isEqual:(id)object
{
    EDHomeFunModel *tModel = (EDHomeFunModel *)object;
    if (ISEmpty(tModel.title)) {
        return NO;
    }
    return [self.title isEqualToString:tModel.title];
}

- (NSUInteger)hash {
    return [self.title hash];
}
@end

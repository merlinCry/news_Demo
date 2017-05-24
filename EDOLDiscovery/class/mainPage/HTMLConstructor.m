//
//  HTMLConstructor.m
//  EDOLDiscovery
//
//  Created by song on 16/12/27.
//  Copyright © 2016年 song. All rights reserved.
//

#import "HTMLConstructor.h"
#import "ImageInfo.h"
#import "VideoInfo.h"

@implementation HTMLConstructor

+(NSString *)htmlBaseDocument
{
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"webViewHtml" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    if (NOTEmpty(appHtml)) {
        return appHtml;
    }
    return @"";
}


+(NSString *)htmlForNewsDetail:(EDHomeNewsModel *)newsDetail
{
//    NSDictionary *bodyDic    = [dataDic objectForKey:@"data"];
    //文字内容
    NSMutableString *bodyStr = [NSMutableString stringWithString:newsDetail.content];
    
    //拼接内容
    //主题
    NSString *titleStr  = newsDetail.title;//title
    NSString *sourceStr = newsDetail.author;//来源
    NSString *ptimeStr  = newsDetail.releaseTimeStr;//时间
    
    NSMutableString *allTitleStr =[NSMutableString stringWithString:@"<h2>artTitle</h2><h3>source&nbsp;&nbsp;&nbsp;&nbsp;time</h3>"];
    
    [allTitleStr replaceOccurrencesOfString:@"artTitle" withString:titleStr options:NSCaseInsensitiveSearch range:[allTitleStr rangeOfString:@"artTitle"]];
    [allTitleStr replaceOccurrencesOfString:@"source" withString:sourceStr options:NSCaseInsensitiveSearch range:[allTitleStr rangeOfString:@"source"]];
    [allTitleStr replaceOccurrencesOfString:@"time" withString:ptimeStr options:NSCaseInsensitiveSearch range:[allTitleStr rangeOfString:@"time"]];
    
    //图片和视频资源链接
    NSArray *imageArray = newsDetail.imageList;
    NSArray *videoArray = newsDetail.videoList;
    
    //视频处理
    if (NOTEmpty(videoArray)) {
        NSLog(@"这个新闻里面有音频");
        for (NSInteger i = 0; i<videoArray.count; i++) {
            VideoInfo *videoin = videoArray[i];
            NSRange range = [bodyStr rangeOfString:videoin.ref];
            if (range.location == NSNotFound) {
                continue;
            }
            NSString *aId = [videoin.ref substringWithRange:NSMakeRange(4, videoin.ref.length -7)];
            NSString *videoStr = [NSString stringWithFormat:@"<embed id = '%@' width = '100%%'  hspace='0.0' vspace='5' src='' onClick=imgClick(%ld) />",aId,(long)i];
            [bodyStr replaceOccurrencesOfString:videoin.ref withString:videoStr options:NSCaseInsensitiveSearch range:range];
        }
        
    }
    
    //图片处理(图片后加载)
    if (NOTEmpty(imageArray)) {
        NSLog(@"新闻内容里面有图片");
        
        for (NSInteger i = 0; i<imageArray.count; i++) {
            ImageInfo *info = imageArray[i];
            NSRange range = [bodyStr rangeOfString:info.ref];
            //判断是否有占位符
            if (range.location == NSNotFound) {
                continue;
            }
            
            NSString *aId = [info.ref substringWithRange:NSMakeRange(4, info.ref.length -7)];
            NSString *imageStr = [NSString stringWithFormat:@"<img id = '%@' src = '' width = '100%%'  hspace='0.0' vspace='5' onClick=imgClick(%ld)>",aId,(long)i];
            
            [bodyStr replaceOccurrencesOfString:info.ref withString:imageStr options:NSCaseInsensitiveSearch range:range];
            
        }

    }
//
    
    //html壳
    NSMutableString *finaAppHtml = [[NSMutableString alloc]initWithString:[HTMLConstructor htmlBaseDocument]];
    //处理夜间模式
    [self themeAbout:finaAppHtml];
    
    //标题与内容拼接起来
    NSString * str5 = [allTitleStr stringByAppendingString:bodyStr];
    
    //找到占位符
    NSRange range = [finaAppHtml rangeOfString:@"<p>mainnews</p>"];
    if (range.location == NSNotFound) {
        return @"";
    }
    //用内容替换占位符
    [finaAppHtml replaceOccurrencesOfString:@"<p>mainnews</p>" withString:str5 options:NSCaseInsensitiveSearch range:range];

    return [NSString stringWithString:finaAppHtml];
    
}
//处理夜间模式
+(void)themeAbout:(NSMutableString *)finaAppHtml
{
    //body背景
    NSRange colorRange = [finaAppHtml rangeOfString:@"/*back-color-body*/"];
    if (colorRange.location != NSNotFound) {
        NSRange  range = NSMakeRange(colorRange.location -3, 3);
        if ([APPServant servant].nightShift) {
            [finaAppHtml replaceCharactersInRange:range withString:@"262626"];
        }else{
            [finaAppHtml replaceCharactersInRange:range withString:@"FFF"];
            
        }
    }
    //统一设置body内文字颜色(适应文字不在p标签)
    NSRange bodyTRange = [finaAppHtml rangeOfString:@"/*text-color-body*/"];
    if (bodyTRange.location != NSNotFound) {
        NSRange  range = NSMakeRange(bodyTRange.location -3, 3);
        if ([APPServant servant].nightShift) {
            [finaAppHtml replaceCharactersInRange:range withString:@"666"];
        }else{
            [finaAppHtml replaceCharactersInRange:range withString:@"333"];
            
        }
    }
    //p文字颜色
    NSRange pRange = [finaAppHtml rangeOfString:@"/*text-color-p*/"];
    if (pRange.location != NSNotFound) {
        NSRange  range = NSMakeRange(pRange.location -3, 3);
        if ([APPServant servant].nightShift) {
            [finaAppHtml replaceCharactersInRange:range withString:@"666"];
        }else{
            [finaAppHtml replaceCharactersInRange:range withString:@"333"];
            
        }
    }
    
    //h2颜色
    NSRange h2Range = [finaAppHtml rangeOfString:@"/*text-color-h2*/"];
    if (h2Range.location != NSNotFound) {
        NSRange  range = NSMakeRange(h2Range.location -3, 3);
        if ([APPServant servant].nightShift) {
            [finaAppHtml replaceCharactersInRange:range withString:@"999"];
        }else{
            [finaAppHtml replaceCharactersInRange:range withString:@"000"];
            
        }
    }
}
@end

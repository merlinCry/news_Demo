//
//  EDPhotoCell.m
//  EDOLDiscovery
//
//  Created by song on 16/12/28.
//  Copyright © 2016年 song. All rights reserved.
//

#import "EDPhotoCell.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImageView+WebCache.h"
@implementation EDPhotoCell
{
    UIScrollView *contentScroll;
    FLAnimatedImageView  *imageView;
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CLEARCOLOR;
        self.contentView.backgroundColor = CLEARCOLOR;
        [self createSubViews];
    }
    return self;
}

-(void)createSubViews
{
    UITapGestureRecognizer  *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesAction:)];
    [self addGestureRecognizer:tapGes];
    
    contentScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    contentScroll.backgroundColor = CLEARCOLOR;
    contentScroll.contentSize = CGSizeMake(self.width, self.height);
    contentScroll.scrollsToTop = NO;
    contentScroll.showsHorizontalScrollIndicator = NO;
    contentScroll.bounces = NO;
    
//    contentScroll.multipleTouchEnabled   = YES;
    contentScroll.userInteractionEnabled = YES;
    contentScroll.maximumZoomScale     = 2;
    contentScroll.minimumZoomScale     = 0.5;
//    contentScroll.zoomScale            = 3;
    contentScroll.delegate             = self;
    
    
    imageView = [[FLAnimatedImageView alloc]initWithFrame:CGRectMake(0, 0, contentScroll.width, contentScroll.height)];
    imageView.backgroundColor = CLEARCOLOR;
    imageView.userInteractionEnabled = YES;
    [contentScroll addSubview:imageView];
    [self.contentView addSubview:contentScroll];
}

-(void)setPhoto:(ImageInfo *)photo
{
    _photo = photo;
    [imageView sd_setImageWithURL:[NSURL URLWithString:_photo.img] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        _photo.cachedImage = image;
        if (NOTEmpty(image)) {
            //调整图片尺寸
            [self addjuestImageSize:image.size];
        }
    }];
//    if (NOTEmpty(_photo.cachedImage)) {
//        imageView.image = _photo.cachedImage;
//        [self addjuestImageSize:_photo.size];
//
//    }else{
//
//    }

    
}


#pragma mark
#pragma mark scrollViewDelegate


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.width > scrollView.contentSize.width)?
    (scrollView.width - scrollView.contentSize.width)/2 : 0.0;
    
    CGFloat offsetY = (scrollView.height > scrollView.contentSize.height)?
    (scrollView.height - scrollView.contentSize.height)/2 : 0.0;
    
    imageView.center = CGPointMake(scrollView.contentSize.width/2 + offsetX,
                                          scrollView.contentSize.height/2 + offsetY);
}
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    //如果是横向的图 w > h  那么
}


-(void)addjuestImageSize:(CGSize)size
{
    //宽度100% 高度等比缩放
    CGFloat scal = size.width/size.height;
    
    imageView.size = CGSizeMake(self.width, self.width/scal);
    
    //调整contentSize
    contentScroll.contentSize = CGSizeMake(self.width, MAX(self.height, imageView.height));
    
    imageView.top = 0;
    //图片高度小于屏幕高度的时候,将图片居中
    if (imageView.height < self.height) {
        imageView.centerY = self.height/2;
    }
    
}

-(void)tapGesAction:(UITapGestureRecognizer *)ges
{
    if (contentScroll.zoomScale != 1) {
        [contentScroll setZoomScale:1 animated:YES];
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(edPhotoCellTaped:)]) {
        [_delegate edPhotoCellTaped:self];
        
    }
}

@end

//
//  APPLaunchView.m
//  EDOLDiscovery
//
//  Created by song on 17/1/9.
//  Copyright © 2017年 song. All rights reserved.
//

#import "APPLaunchView.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"

@interface APPLaunchView ()
{
    FLAnimatedImageView *contentViw;
}

@end

@implementation APPLaunchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews
{
//    CGFloat  scal = 667/375.0f;
//    FLAnimatedImageView *carView = [[FLAnimatedImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.width*scal)];
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"runingman.gif" withExtension:nil];
//    NSData *data1 = [NSData dataWithContentsOfURL:url];
//    FLAnimatedImage *animatedImage = [FLAnimatedImage animatedImageWithGIFData:data1];
//    carView.animatedImage = animatedImage;
//    [self addSubview:carView];
    UIImageView *animatImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    animatImageView.backgroundColor = MAINCOLOR;
    animatImageView.image = [UIImage imageNamed:@"launchImage"];
    [self addSubview:animatImageView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self launchComplate];
        
    });
}


+(void)makeLaunchView
{
    APPLaunchView *launchView = [[APPLaunchView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    launchView.backgroundColor = MAINCOLOR;
    
    [KeyWindow  addSubview:launchView];
    
}

- (void)launchComplate
{
    [UIView animateWithDuration:1. animations:^{
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(2, 2);
        self.transform = scaleTransform;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end

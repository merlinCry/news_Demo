//
//  EDBaseImageView.m
//  EDOLDiscovery
//
//  Created by song on 2017/4/1.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDBaseImageView.h"

@implementation EDBaseImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
//        _maskView.backgroundColor = MAINCOLOR;
        _maskView.hidden = YES;
        [self addSubview:_maskView];
        
        //添加主题通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChanged) name:ED_DayNight_Changed object:nil];
        [self themeChanged];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _maskView.frame = CGRectMake(0, 0, self.width, self.height);
}
-(void)themeChanged
{
    _maskView.hidden = ![APPServant servant].nightShift;
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

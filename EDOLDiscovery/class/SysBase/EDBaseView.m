//
//  EDBaseView.m
//  EDOLDiscovery
//
//  Created by song on 17/3/22.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDBaseView.h"

@implementation EDBaseView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChanged) name:ED_DayNight_Changed object:nil];

    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self themeCheck];
    
}

-(void)themeChanged
{
    [self themeCheck];
    
}

-(void)themeCheck
{
    [UIView animateWithDuration:0.2 animations:^{
        if ([APPServant servant].nightShift) {
            self.backgroundColor = UIColorFromRGB(0x2F2F2F);
            
        }else{
            self.backgroundColor = LINECOLOR;
        }
    }];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


@end

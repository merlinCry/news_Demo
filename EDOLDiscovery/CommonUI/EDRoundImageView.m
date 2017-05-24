//
//  EDRoundImageView.m
//  EDOLDiscovery
//
//  Created by song on 17/1/13.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDRoundImageView.h"

@implementation EDRoundImageView
{
    UIImageView *mask;
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        mask = [UIImageView new];
        mask.image = [UIImage imageNamed:@"headCycMask"];
//        UIImage *image = [UIImage iconWithInfo:TBCityIconInfoMake(mobileIcon, 20, WHITECOLOR)];
        [self addSubview:mask];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    mask.frame = self.bounds;
    mask.backgroundColor = CLEARCOLOR;
    
}


@end

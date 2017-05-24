//
//  EDChosenView.m
//  EDOLDiscovery
//
//  Created by fang Zhou on 2017/4/25.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDChosenView.h"

@interface EDChosenView ()
{
    UIImageView *bgImg;
    UIImageView *maskImg;
    UILabel     *titleLab;
    UILabel     *detailTitle;
}

@end

@implementation EDChosenView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews{
    
    bgImg = [[UIImageView alloc] init];
    bgImg.backgroundColor = CLEARCOLOR;
    
    maskImg = [[UIImageView alloc] init];
    maskImg.image = [UIImage imageNamed:@"homeCrazyMask"];
    
    titleLab = LABEL(FONT(18), UIColorFromRGB(0xFFFFFF));
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    detailTitle = LABEL(FONT(14), UIColorFromRGB(0xFFFFFF));
    detailTitle.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:bgImg];
    [self addSubview:maskImg];
    [self addSubview:titleLab];
    [self addSubview:detailTitle];
}

- (void)layoutSubviews{
    bgImg.frame = CGRectMake(0, 0, self.width, self.height);
    maskImg.frame = CGRectMake(-3, -3, self.width+6, self.height+6);
    titleLab.frame = CGRectMake(0, 22, self.width, 25);
    detailTitle.frame = CGRectMake(0, titleLab.bottom+1, self.width, 20);
}

- (void)setModel:(EDChosenModel *)model{
//    if (!model) {
//        return;
//    }
    _model = model;
    [bgImg sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"default_img_70"]];
    titleLab.text = @"校园惊奇时间薄";
    detailTitle.text = @"不恐怖不要钱";
}

@end

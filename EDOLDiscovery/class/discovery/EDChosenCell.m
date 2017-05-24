//
//  EDChosenCell.m
//  EDOLDiscovery
//
//  Created by Zhoufang on 17/4/25.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDChosenCell.h"

@interface EDChosenCell()
{
    UIImageView *leftImg;
    UILabel     *themeLab;
    UILabel     *detailLab;
    
    UIImageView *lineImg;
}

@end

@implementation EDChosenCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        leftImg = [UIImageView new];
        leftImg.contentMode = UIViewContentModeScaleAspectFill;
        leftImg.backgroundColor = CLEARCOLOR;
        leftImg.clipsToBounds   = YES;
        
        themeLab = LABEL(FONT(18), UIColorFromRGB(0x333333));
        
        detailLab = LABEL(FONT(14), UIColorFromRGB(0x999999));
        
        lineImg   = [[UIImageView alloc] init];
        lineImg.backgroundColor = LINECOLOR;
        
        [self.contentView addSubview:leftImg];
        [self.contentView addSubview:themeLab];
        [self.contentView addSubview:detailLab];
        [self.contentView addSubview:lineImg];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    leftImg.frame   = CGRectMake(17, 17, 60, 60);
    themeLab.frame  = CGRectMake(leftImg.right+9, 20, SCREEN_WIDTH-35-leftImg.right, 25);
    detailLab.frame = CGRectMake(themeLab.left, themeLab.bottom+8, themeLab.width, 20);
    lineImg.frame   = CGRectMake(leftImg.left, detailLab.bottom+23, SCREEN_WIDTH-leftImg.left*2, 1);
}

- (void)setModel:(EDChosenModel *)model{
//    if (!model) {
//        return;
//    }
    _model = model;
    [leftImg sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"default_img_70"]];
    themeLab.text  = @"深夜美食研究所";
    detailLab.text = @"我们不仅是美食搬运工，更是美味食物...";
}

@end

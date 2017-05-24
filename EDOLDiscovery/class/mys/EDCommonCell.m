//
//  EDCommonCell.m
//  EDOLDiscovery
//
//  Created by song on 17/1/7.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDCommonCell.h"

@implementation EDCommonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubView];
    }
    return self;
}

/*
 * 创建子视图
 */
-(void)createSubView
{
    _iconView = [UIImageView new];
    _iconView.backgroundColor = CLEARCOLOR;
    _nameLab  = LABEL(FONT_Light(16), T_TITLE_COLOR);
    
    _detailLab = LABEL(FONT_Light(16), T_TITLE_COLOR);
    _detailLab.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:_iconView];
    [self.contentView addSubview:_nameLab];
    [self.contentView addSubview:_detailLab];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.height = self.height - 1;
    
    CGFloat imgW = _bigIcon?30:20;
    _iconView.frame   = CGRectMake(16, 0, imgW, imgW);
    if (_bigIcon) {
        _iconView.layer.cornerRadius  = imgW/2;
        _iconView.layer.masksToBounds = YES;
    }
    _iconView.centerY = self.height/2;
    
    _nameLab.frame =  CGRectMake(_iconView.right + 10, 0, 150, 18);
    _nameLab.centerY = self.height/2;
    
    _detailLab.frame = CGRectMake(0, 0, 100, 18);
    _detailLab.right = self.width - 15;
    _detailLab.centerY = self.height/2;
    
}



@end

//
//  EDMyCollectCell.m
//  EDOLDiscovery
//
//  Created by song on 17/1/11.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDMyCollectCell.h"
#import "TYAttributedLabel.h"

@implementation EDMyCollectCell
{
    UILabel *cateIcon;
    UILabel *cateName;//2搞笑，1资讯
    
    UILabel     *timeLabel;
    UIImageView *leftImage;
    TYAttributedLabel     *text;//title
    UILabel     *desc;//内容

}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubviews];
        
    }
    return self;
}

-(void)createSubviews
{
    cateIcon  = LABEL(ICONFONT(26), T_ICON_COLOR);
    
    cateName  = LABEL(FONT(14), T_ICON_COLOR);
    
    timeLabel = LABEL(FONT(12), COLOR_999);
    timeLabel.textAlignment = NSTextAlignmentRight;
    
    leftImage = [UIImageView new];
    leftImage.contentMode = UIViewContentModeScaleAspectFill;
    leftImage.backgroundColor = CLEARCOLOR;
    leftImage.clipsToBounds   = YES;
    
    text      = [[TYAttributedLabel alloc]initWithFrame:CGRectZero];
    text.textColor = T_TITLE_COLOR;
    text.font = FONT(16);
    text.numberOfLines = 2;
    text.verticalAlignment = TYVerticalAlignmentTop;
    text.backgroundColor   = CLEARCOLOR;
    
    desc      = LABEL(FONT_Light(16), T_TITLE_COLOR);
    desc.numberOfLines = 2;
    
    [self.contentView addSubview:cateIcon];
    [self.contentView addSubview:cateName];
    [self.contentView addSubview:timeLabel];
    [self.contentView addSubview:leftImage];
    [self.contentView addSubview:text];
    [self.contentView addSubview:desc];

}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.height = self.height - 0.5;
    
    cateIcon.frame = CGRectMake(14, 14, 26, 26);
    
    cateName.frame   = CGRectMake(cateIcon.right + 7, 0, 150, 16);
    cateName.centerY = cateIcon.centerY;
    
    timeLabel.frame   = CGRectMake(0, 0, 150, 16);
    timeLabel.centerY = cateIcon.centerY;
    timeLabel.right   = self.width - 14;
    
    CGRect textFrame = CGRectMake(14, 47, self.width - 28, _model.textHeight);
    CGRect imgFrame  = CGRectMake(14, 47, 70, 70);
    CGRect descFrame = CGRectMake(14, CGRectGetMaxY(textFrame), self.width - 28, _model.descHeight);
    if (NOTEmpty(_model.imgLink)) {
        textFrame    =  CGRectMake(95, 47, self.width - 110,_model.textHeight);
        if ([_model.campusFavoriteType isEqualToString:@"FUNNY"]) {
            textFrame = CGRectMake(14, 47, self.width - 28, _model.textHeight);
            imgFrame  = CGRectMake(14, CGRectGetMaxY(textFrame)+5, 224, 140);
        }
    }
    
    leftImage.frame  = imgFrame;
    text.frame       = textFrame;
    desc.frame       = descFrame;
    
}

-(void)setModel:(EDMyCollectModel *)model
{
    _model           = model;
    cateIcon.text    = newsC;

    cateName.text    = _model.favoriteTypeName;
    timeLabel.text   = _model.createTime;
    leftImage.hidden = YES;
    desc.hidden      = YES;
    text.hidden      = YES;
    desc.hidden      = YES;
    if ([model.campusFavoriteType isEqualToString:@"FUNNY"]) {
        cateIcon.text  = textcutC;
        if (ISEmpty(_model.imgLink) && NOTEmpty(_model.content)) {
            desc.hidden      = NO;
            desc.text        = _model.content;

        }
    }
    
    if (NOTEmpty(_model.imgLink)) {
        leftImage.hidden = NO;
        [leftImage sd_setImageWithURL:[NSURL URLWithString:_model.imgLink] placeholderImage:[UIImage imageNamed:@"default_img_70"]];
    }
    
    if (NOTEmpty(_model.title)) {
        text.text        = _model.title;
        text.hidden      = NO;
    }

}
@end

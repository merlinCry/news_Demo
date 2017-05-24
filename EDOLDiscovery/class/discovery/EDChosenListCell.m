//
//  EDChosenListCell.m
//  EDOLDiscovery
//
//  Created by fang Zhou on 2017/4/27.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDChosenListCell.h"
#import "TYAttributedLabel.h"

@interface EDChosenListCell()
{
    EDBaseImageView *leftImg;
    TYAttributedLabel  *textLabel;
    UILabel *fromLab;
}

@end

@implementation EDChosenListCell

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
        self.backgroundColor = CLEARCOLOR;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        textLabel = [[TYAttributedLabel alloc]init];
        textLabel.font = FONT(18);
        textLabel.textColor = COLOR_333;
        textLabel.linesSpacing  = 3;
        textLabel.numberOfLines = 2;
        textLabel.characterSpacing = 0;
        textLabel.backgroundColor = CLEARCOLOR;
        
        fromLab     = LABEL(FONT_Light(12), COLOR_999);
        
        leftImg = [EDBaseImageView new];
        leftImg.userInteractionEnabled = YES;
        leftImg.contentMode = UIViewContentModeScaleAspectFill;
        leftImg.clipsToBounds = YES;

        [self.contentView addSubview:textLabel];
        [self.contentView addSubview:fromLab];
        [self.contentView addSubview:leftImg];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.contentView.height = self.height-1;
    
    leftImg.frame = CGRectMake(10, 8, 112, 80);
    textLabel.frame = CGRectMake(leftImg.right+16, 13, SCREEN_WIDTH-leftImg.right-25, 48);
    fromLab.frame = CGRectMake(textLabel.left, textLabel.bottom+7, textLabel.width, 18);
}

- (void)setModel:(EDHomeNewsModel *)model{
    _model = model;
    [leftImg sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"default_article_small"]];
    textLabel.text = @"学校奇葩规定：这是一个非常非常奇葩的学校规定，话题来了。";
    fromLab.text = @"知乎日报";
}

@end

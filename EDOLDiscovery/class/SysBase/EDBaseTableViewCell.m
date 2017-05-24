//
//  EDBaseTableViewCell.m
//  EDOLDiscovery
//
//  Created by song on 17/3/21.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDBaseTableViewCell.h"

@implementation EDBaseTableViewCell

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
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundColor = Cell_BACKGROUND_COLOR;
        self.contentView.backgroundColor = Cell_CONTENT_COLOR;
    }];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
@end

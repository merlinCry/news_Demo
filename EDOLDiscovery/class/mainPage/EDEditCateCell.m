//
//  EDEditCateCell.m
//  EDOLDiscovery
//
//  Created by song on 17/1/7.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDEditCateCell.h"
@interface EDEditCateCell ()
{
    UIButton *contentBtn;
    UIButton *deleteBtn;
}

@end
@implementation EDEditCateCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}


-(void)createSubViews
{
//    UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handlLongPress:)];
//    [self.contentView addGestureRecognizer:longGes];
    contentBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 8, self.width - 8, self.height - 16)];
    contentBtn.centerY = self.height/2;
    contentBtn.adjustsImageWhenHighlighted = NO;
    contentBtn.userInteractionEnabled      = NO;
    contentBtn.backgroundColor = CLEARCOLOR;
    contentBtn.titleLabel.font = FONT_Light(14);
    contentBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [contentBtn setTitleColor:COLOR_333 forState:UIControlStateNormal];
    
    deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 2, 30, 30)];
    deleteBtn.right = self.width - 2;
    deleteBtn.contentVerticalAlignment   =  UIControlContentVerticalAlignmentTop;
    deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    deleteBtn.adjustsImageWhenHighlighted = NO;
    deleteBtn.backgroundColor = CLEARCOLOR;
    [deleteBtn setImage:[UIImage imageNamed:@"deleteIcon"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(removeItemAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:contentBtn];
    [self.contentView addSubview:deleteBtn];
}

-(void)setModel:(EDCateGoryModel *)model
{
    _model = model;
    [contentBtn setTitle:_model.aliasName forState:UIControlStateNormal];
    NSURL *url = [NSURL URLWithString:_model.cateIcon];
    [contentBtn sd_setImageWithURL:url forState:UIControlStateNormal];
    
    [contentBtn setBackgroundImage:[UIImage imageNamed:@"roundRectClear"] forState:UIControlStateNormal];
    //背景颜色
    if (_model.selected) {
        [contentBtn setBackgroundImage:[UIImage imageNamed:@"roundRectFill"] forState:UIControlStateNormal];

    }
    
    //减号
    deleteBtn.hidden = !_model.editing;
    
}

-(void)handlLongPress:(UILongPressGestureRecognizer *)longGes
{

}

//删掉这个item
-(void)removeItemAction:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(edEditCateCell:deleteAtModel:)]) {
        [_delegate edEditCateCell:self deleteAtModel:_model];
        
    }
    
}


@end

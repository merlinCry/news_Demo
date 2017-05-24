//
//  EDThumbImageView.m
//  EDOLDiscovery
//
//  Created by song on 17/1/16.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDThumbImageView.h"

@implementation EDThumbImageView
{
    UIButton *deleteImage;
    UIImageView *contentImageView;

}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        contentImageView.backgroundColor = CLEARCOLOR;
        contentImageView.userInteractionEnabled = YES;
        [self addSubview:contentImageView];
        
        deleteImage = [UIButton new];
        deleteImage.frame = CGRectMake(0, 0, 30, 20);
        deleteImage.right= self.width;
        [deleteImage setImage:[UIImage imageNamed:@"deleteIcon"] forState:UIControlStateNormal];
        deleteImage.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        deleteImage.userInteractionEnabled = YES;
        [deleteImage addTarget:self action:@selector(deleteImage)forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteImage];
    }
    return self;
}

-(void)deleteImage
{
    if (_delegate && [_delegate respondsToSelector:@selector(edThumbImageViewDeleted:)]) {
        [_delegate edThumbImageViewDeleted:self];
    }
    [self removeFromSuperview];

}

-(void)setImage:(UIImage *)image
{
    contentImageView.image = image;
}
@end

//
//  EDButton.m
//  EDOLDiscovery
//
//  Created by song on 17/1/5.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDButton.h"

@implementation EDButton

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat textWidth = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}].width;
    CGSize titleSize = CGSizeMake(textWidth, self.titleLabel.height);
    CGSize imgSize   = self.imageView.size;
    CGFloat spaceV   = (self.height - titleSize.height - imgSize.height)/3;
    CGFloat spaceH   = (self.width - titleSize.width - imgSize.width)/3;
    switch (_style) {
        case EDButtonStyleUP:
        {
            self.titleLabel.frame = CGRectMake(0, spaceV, titleSize.width, titleSize.height);
            self.titleLabel.centerX = self.width/2;
            
            self.imageView.frame = CGRectMake(0,self.titleLabel.bottom+ spaceV, imgSize.width, imgSize.height);
            self.imageView.centerX  = self.width/2;
        }
            break;
        case EDButtonStyleLeft:
        {
            self.titleLabel.frame = CGRectMake(spaceH, 0, titleSize.width, titleSize.height);
            self.titleLabel.centerY = self.height/2;
            
            self.imageView.frame = CGRectMake(spaceH,self.titleLabel.right+ spaceV, imgSize.width, imgSize.height);
            self.imageView.centerY  = self.height/2;
            
        }
            break;
        case EDButtonStyleDown:
        {
            self.imageView.frame = CGRectMake(0,spaceV, imgSize.width, imgSize.height);
            self.imageView.centerX  = self.width/2;
            
            self.titleLabel.frame = CGRectMake(0,self.imageView.bottom + spaceV, titleSize.width, titleSize.height);
            self.titleLabel.centerX = self.width/2;
            

        }
            break;
            
        default:
            break;
    }
}

@end

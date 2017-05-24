//
//  EDThumbImageView.h
//  EDOLDiscovery
//
//  Created by song on 17/1/16.
//  Copyright © 2017年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EDThumbImageView;

@protocol EDThumbImageViewDelegate <NSObject>
@optional
-(void)edThumbImageViewDeleted:(EDThumbImageView *)imageView;

@end
@interface EDThumbImageView : UIView

/**
 *  注释
 */
@property (nonatomic, assign) id<EDThumbImageViewDelegate> delegate;


@property (nonatomic, strong)UIImage *image;

@end

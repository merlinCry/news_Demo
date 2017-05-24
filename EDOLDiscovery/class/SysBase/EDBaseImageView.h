//
//  EDBaseImageView.h
//  EDOLDiscovery
//
//  Created by song on 2017/4/1.
//  Copyright © 2017年 song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EDBaseImageView : UIImageView
/**
 *   mask夜间模式下的灰色mask
 */
@property (nonatomic, strong)UIView *maskView;


-(void)themeChanged;
@end

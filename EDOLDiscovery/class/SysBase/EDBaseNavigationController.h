//
//  EDBaseNavigationController.h
//  EDOLDiscovery
//
//  Created by song on 16/12/24.
//  Copyright © 2016年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
//@interface UINavigationBar (UINavigationBarCategory)
//
//- (void)setBackgroundImage:(UIImage*)image;
//
//@end
@interface UINavigationController (UINavigationControllerCategory)

-(void)resetBackground;

@end

@interface EDBaseNavigationController : UINavigationController

//是否需要全屏滑动返回手势
@property (nonatomic, assign)BOOL            fullScreenBackGes;


@end

//
//  EDPhotoBrower.h
//  EDOLDiscovery
//
//  Created by song on 16/12/28.
//  Copyright © 2016年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDPhotoCell.h"
//typedef NS_ENUM(NSInteger,EDPhotoBrowerState) {
//    EDPhotoBrowerStateStarting = 0,//开始
//    EDPhotoBrowerStateShowing,    //展现中
//    EDPhotoBrowerStateEnding,    //
//
//    
//};

@protocol EDPhotoBrowerDelegate <NSObject>

@optional
-(void)browerDismissed;

@end

@interface EDPhotoBrower : UIView


@property (nonatomic, strong)NSArray *photoArr;
@property (nonatomic, strong)UIImageView  *startView;
//正在显示
@property (nonatomic, assign)BOOL  animating;


/**
 *  注释
 */
@property (nonatomic, assign)id<EDPhotoBrowerDelegate> delegate;

//+(instancetype)shareInstance;

-(void)show:(UIView*)sourceView imgIndex:(NSInteger)index;
-(void)dismiss;
@end

//
//  PersonalCenterView.h
//  EDOLDiscovery
//
//  Created by song on 16/12/26.
//  Copyright © 2016年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,EDUserCenterDisOption) {
    EDUserCenterDisOption_None = 0,
    EDUserCenterDisOption_Login,   //消失后弹出登陆
    EDUserCenterDisOption_Register,//消失后弹出注册
};

@protocol EDUserCenterMenuDelegate <NSObject>
@optional
-(void)dismissedWithOperation:(EDUserCenterDisOption)option;

@end

@interface PersonalCenterVC : EDBaseViewController

@property (nonatomic, assign)id<EDUserCenterMenuDelegate> delegate;

-(void)show;
-(void)dismiss;

@end

//
//  EDRegisterStepView.h
//  EDOLDiscovery
//
//  Created by song on 17/1/6.
//  Copyright © 2017年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,RegisterStep) {
    RegisterStep_L = 0,
    RegisterStep_M,
    RegisterStep_R,
};
@interface EDRegisterStepView : UIView


@property (nonatomic, assign)RegisterStep step;


@property (nonatomic, strong)UILabel *textL;
@property (nonatomic, strong)UILabel *textM;
@property (nonatomic, strong)UILabel *textR;




@end

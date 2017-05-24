//
//  APPAlertView.h
//  EDOLDiscovery
//
//  Created by song on 17/1/9.
//  Copyright © 2017年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^APPInputPopViewCompletionBlock)(BOOL cancelled,id param);

@interface APPInputPopView : UIView

@property (nonatomic, strong) UILabel     *titleLab;
@property (nonatomic, strong) UITextField *inputText;
@property (nonatomic, strong) UILabel     *iconLabel;
@property(nonatomic,strong)APPInputPopViewCompletionBlock  completionBlock;



+(void)showWithTitle:(NSString *)title
                icon:(NSString *)icon
    inputPlaceHolder:(NSString *)placeHolder
         commitTitle:(NSString *)commitTitle
     completionBlock:(APPInputPopViewCompletionBlock)completion;


@end

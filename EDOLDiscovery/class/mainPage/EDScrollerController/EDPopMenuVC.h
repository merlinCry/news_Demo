//
//  EDPopMenuVC.h
//  EDPopViewVCDemo
//
//  Created by song on 2017/5/5.
//  Copyright © 2017年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^BackMenuBlock)(NSInteger index);

@interface EDPopMenuVC : UIViewController
@property(strong,nonatomic)NSArray *dataSource;

@property (nonatomic, strong)BackMenuBlock selectBlack;
@end

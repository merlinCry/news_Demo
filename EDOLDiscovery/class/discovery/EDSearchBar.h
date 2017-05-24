//
//  EDSearchBar.h
//  EDOLDiscovery
//
//  Created by fang Zhou on 2017/4/27.
//  Copyright © 2017年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDPlaceholderTextField.h"

typedef void (^EDSearchBarActionBlock)();

@interface EDSearchBar : UIControl

@property (nonatomic,strong) UIColor *barBackgroudColor;

@property (nonatomic,strong) EDPlaceholderTextField *searchTld;

@property (nonatomic,strong) EDSearchBarActionBlock textEndEditingBlock;

@property (nonatomic,strong) EDSearchBarActionBlock rightBlock;

@property (nonatomic,strong) EDSearchBarActionBlock beginBlock;

@property (nonatomic,strong) EDSearchBarActionBlock textBeginBlock;

@end

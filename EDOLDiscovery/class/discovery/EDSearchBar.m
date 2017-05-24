//
//  EDSearchBar.m
//  EDOLDiscovery
//
//  Created by fang Zhou on 2017/4/27.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDSearchBar.h"

@interface EDSearchBar ()<UITextFieldDelegate>
{
    UIView *backgroundView;
}

@end

@implementation EDSearchBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    backgroundView = [UIView new];
    backgroundView.clipsToBounds = YES;
    [self addSubview:backgroundView];
    
    _searchTld = [EDPlaceholderTextField new];
    _searchTld.backgroundColor = CLEARCOLOR;
    _searchTld.placeholderColor = UIColorFromRGB(0x969696);
    _searchTld.placeholderFont  = FONT(12);
    _searchTld.font = FONT(14);
    _searchTld.textColor = UIColorFromRGB(0x333333);
    _searchTld.delegate = self;
    _searchTld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _searchTld.returnKeyType = UIReturnKeyDone;
    [self addSubview:_searchTld];
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [leftBtn setTitleIconFontTitle:searchIcon titleSize:14 normalColor:UIColorFromRGB(0x9D9D9D) selectedColor:MAINCOLOR];
    self.searchTld.leftView = leftBtn;
    self.searchTld.leftViewMode = UITextFieldViewModeAlways;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    backgroundView.frame = self.bounds;
    backgroundView.layer.cornerRadius = self.height/2;
    
    _searchTld.frame = self.bounds;
    if (_searchTld.leftView) {
        _searchTld.leftView.height = _searchTld.height;
    }
}

- (void)setBarBackgroudColor:(UIColor *)barBackgroudColor{
    _barBackgroudColor = barBackgroudColor;
    backgroundView.backgroundColor = barBackgroudColor;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.textBeginBlock) {
        self.textBeginBlock();
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end

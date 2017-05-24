//
//  EDScrollMenu.m
//  EDOLDiscovery
//
//  Created by song on 17/1/4.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDScrollMenu.h"

@interface EDScrollMenu ()
{
    UIScrollView *scrollView;
    UIButton     *addChannelBtn;
    UIView       *flageLine;


}

@end

@implementation EDScrollMenu

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews
{
    _buttonsArr  = [NSMutableArray new];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.width - 44, self.height)];
    scrollView.backgroundColor = CLEARCOLOR;
    scrollView.contentSize     = scrollView.size;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.userInteractionEnabled         = YES;
    scrollView.scrollsToTop                   = NO;
    scrollView.alwaysBounceHorizontal         = YES;
    [self addSubview:scrollView];
    
    flageLine = [[UIView alloc]initWithFrame:CGRectMake(0,scrollView.height - 2, 60, 2)];
    flageLine.backgroundColor = MAINCOLOR;
    [scrollView addSubview:flageLine];
    
    
    addChannelBtn = [[UIButton alloc]initWithFrame:CGRectMake(scrollView.right, 0, 44, self.height)];
    addChannelBtn.backgroundColor = CLEARCOLOR;
    addChannelBtn.adjustsImageWhenHighlighted = NO;
    [addChannelBtn setTitleColor:COLOR_333 forState:UIControlStateNormal];
    [addChannelBtn setTitle:corssAdd forState:UIControlStateNormal];
    [addChannelBtn setTitleFontSize:14];
    [addChannelBtn addTarget:self action:@selector(addChannelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addChannelBtn];

}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //起始x
    CGFloat spaceing = 15;
    CGFloat x = spaceing;
    for (NSInteger i = 0; i<_buttonsArr.count; i++) {
        EDCateGoryModel *model = _dataSource[i];
        UIButton        *btn   = _buttonsArr[i];
        CGFloat width  = [model.aliasName sizeWithAttributes:@{NSFontAttributeName:FONT(16)}].width;
        btn.frame = CGRectMake(x, 0, width, scrollView.height-1);
        x += (width + spaceing*2);
        if (i == 0) {
            flageLine.frame = CGRectMake(0,scrollView.height - 2, width, 2);
            flageLine.centerX = btn.centerX;
        }
    }
    scrollView.contentSize = CGSizeMake(x, scrollView.height);
    
}


-(void)setDataSource:(NSMutableArray *)dataSource
{
    _dataSource = dataSource;
    for (UIView *view in scrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];

        }
    }
    [self.buttonsArr removeAllObjects];
    
    for (NSInteger i = 0; i<_dataSource.count; i++) {
        EDCateGoryModel *model = _dataSource[i];
        UIButton *btn = [UIButton new];
        btn.tag = 99 + i;
        btn.backgroundColor = CLEARCOLOR;
        btn.titleLabel.font = FONT(14);
        [btn setTitleColor:T_MENU_COLOR  forState:UIControlStateNormal];
        if (i == 0) {
            [btn setTitleColor:T_MENU_COLOR_LIGHT forState:UIControlStateNormal];
            btn.titleLabel.font = FONT(16);

        }
//        [btn setTitle:model.cateName forState:UIControlStateNormal];
        [btn setTitle:model.aliasName forState:UIControlStateNormal];

        
        [btn addTarget:self action:@selector(cateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:btn];
        [_buttonsArr addObject:btn];
    }
    
    [self setNeedsLayout];
    if (_selectindex != 0) {
        self.selectindex = 0;
        if (_buttonsArr.count > 0) {
            UIButton *selBtn = _buttonsArr[_selectindex];
            [selBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
        }

    }
}
-(void)cateBtnAction:(UIButton *)sender
{
    NSInteger index  = sender.tag - 99;
    self.selectindex = index;

    EDCateGoryModel *model = _dataSource[index];
    if (_delegate && [_delegate respondsToSelector:@selector(edScrollMenu:didselectAtIndex:model:)]) {
        [_delegate edScrollMenu:self didselectAtIndex:index model:model];
        
    }
}

-(void)addChannelAction:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(edScrollMenuAdd:)]) {
        [_delegate edScrollMenuAdd:self];
        
    }
}

-(void)setSelectindex:(NSInteger)selectindex
{
    //点击相同按钮 不做响应
    if (_selectindex == selectindex) {
        return;
    }
    _selectindex           = selectindex;
    UIButton *selBtn       = _buttonsArr[selectindex];
    for (UIButton *btn in _buttonsArr) {
        if (![btn isEqual:selBtn]) {
            btn.titleLabel.font = FONT(14);
            [btn setTitleColor:T_MENU_COLOR forState:UIControlStateNormal];
            
        }else{
            btn.titleLabel.font = FONT(16);
            [btn setTitleColor:T_MENU_COLOR_LIGHT forState:UIControlStateNormal];
            
        }
    }
    [self moveFlagToIndex:selectindex];
//    UMMobClickAttributes(@"home_channel",[selBtn titleForState:UIControlStateNormal]);
    EDCateGoryModel *model = _dataSource[selectindex];
    NSString *eventId = [NSString stringWithFormat:@"home_channel_%@",model.enAlias];
    UMMobClick(eventId);
}


-(void)moveFlagToIndex:(NSInteger)index
{
    if (index > _buttonsArr.count - 1) {
        return;
    }
    
    UIButton *btn = _buttonsArr[index];
    
    CGFloat leftX  = scrollView.contentOffset.x;
    CGFloat rightX = scrollView.contentOffset.x + scrollView.width;
    
    if (btn.right > rightX) {
        //滚动到最右边
        [UIView animateWithDuration:0.25 animations:^{
            scrollView.contentOffset = CGPointMake(btn.right - scrollView.width + 15, 0);
        }];
    }else if(btn.left < leftX){
        [UIView animateWithDuration:0.25 animations:^{
            scrollView.contentOffset = CGPointMake(btn.left - 15, 0);
        }];
        
    }
    flageLine.frame   = CGRectMake(btn.left, flageLine.top, btn.width, 2);

//    EDCateGoryModel *model = _dataSource[index];
//    CGFloat width = [model.aliasName sizeWithAttributes:@{NSFontAttributeName:btn.titleLabel.font}].width + 8;
//    [UIView animateWithDuration:0.25 animations:^{
//        flageLine.frame   = CGRectMake(btn.left +  (btn.width - width)/2, flageLine.top, width, 2);
//
//    }completion:^(BOOL finished) {
//        //将按钮滚动到可显示区域
//        CGFloat leftX  = scrollView.contentOffset.x;
//        CGFloat rightX = scrollView.contentOffset.x + scrollView.width;
//        
//        if (btn.right > rightX) {
//            //滚动到最右边
//            [UIView animateWithDuration:0.25 animations:^{
//                scrollView.contentOffset = CGPointMake(btn.right - scrollView.width, 0);
//            }];
//        }else if(btn.left < leftX){
//            [UIView animateWithDuration:0.25 animations:^{
//                scrollView.contentOffset = CGPointMake(btn.left, 0);
//            }];
//        
//        }
//    }];
}


-(void)transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress
{
    CGRect fromItemFrame = [self itemFrameWithIndex:fromIndex];
    CGRect toItemFrame   = [self itemFrameWithIndex:toIndex];
    
    //其实就是根据滚动百分比 改变先的长度和位置
    CGFloat  progressX,progressW;
    CGFloat  edgeing      = 0;
    CGFloat  itemSpaceing = 30;
    if (fromItemFrame.origin.x < toItemFrame.origin.x) {
        if (progress <= 0.5) {
            progressX = fromItemFrame.origin.x + edgeing + (fromItemFrame.size.width-2*edgeing)*progress;
            progressW = (toItemFrame.size.width-edgeing+edgeing+itemSpaceing)*2*progress - (toItemFrame.size.width-2*edgeing)*progress + fromItemFrame.size.width-2*edgeing-(fromItemFrame.size.width-2*edgeing)*progress;
        }else {
            progressX = fromItemFrame.origin.x + edgeing + (fromItemFrame.size.width-2*edgeing)*0.5 + (fromItemFrame.size.width-edgeing - (fromItemFrame.size.width-2*edgeing)*0.5 +edgeing+itemSpaceing)*(progress-0.5)*2;
            progressW = CGRectGetMaxX(toItemFrame)-edgeing - progressX - (toItemFrame.size.width-2*edgeing)*(1-progress);
        }
    }else {
        if (progress <= 0.5) {
            progressX = fromItemFrame.origin.x + edgeing - (toItemFrame.size.width-(toItemFrame.size.width-2*edgeing)/2-edgeing+edgeing+itemSpaceing)*2*progress;
            progressW = CGRectGetMaxX(fromItemFrame) - (fromItemFrame.size.width-2*edgeing)*progress - edgeing - progressX;
        }else {
            progressX = toItemFrame.origin.x + edgeing+(toItemFrame.size.width-2*edgeing)*(1-progress);
            progressW = (fromItemFrame.size.width-edgeing+edgeing-(fromItemFrame.size.width-2*edgeing)/2 + itemSpaceing)*(1-progress)*2 + toItemFrame.size.width - 2*edgeing - (toItemFrame.size.width-2*edgeing)*(1-progress);
        }
    }
    flageLine.frame   = CGRectMake(progressX, flageLine.top, progressW, 2);

//略晃动
//    UIButton *fromItem   = [self itemWithIndex:fromIndex];
//    UIButton *toItem     = [self itemWithIndex:toIndex];
//    //from逐渐变小到14  to逐渐变大到16
//    CGFloat fromFontSize     = 16 - 2*progress;
//    CGFloat toFontSize       = 14 + 2*progress;
//    fromItem.titleLabel.font = FONT(fromFontSize);
//    toItem.titleLabel.font   = FONT(toFontSize);
}

- (CGRect)itemFrameWithIndex:(NSInteger)index
{
    if (index<0 || index >= _buttonsArr.count) {
        return CGRectZero;
    }
    UIButton *btn = _buttonsArr[index];
    return btn.frame;
}

- (UIButton *)itemWithIndex:(NSInteger)index
{
    if (index<0 || index >= _buttonsArr.count) {
        return [UIButton new];
    }
    UIButton *btn = _buttonsArr[index];
    return btn;
}

#pragma theme
-(void)themeCheck
{
    if ([APPServant servant].nightShift) {
        [addChannelBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
        self.backgroundColor = COLOR_36;

    }else{
        [addChannelBtn setTitleColor:COLOR_333 forState:UIControlStateNormal];
        self.backgroundColor = WHITECOLOR;
    }
    if (ISEmpty(_buttonsArr)) {
        return;
    }
    UIButton *selBtn       = _buttonsArr[_selectindex];
    for (UIButton *btn in _buttonsArr) {
        if (![btn isEqual:selBtn]) {
            [btn setTitleColor:T_MENU_COLOR forState:UIControlStateNormal];
            
        }else{
            [btn setTitleColor:T_MENU_COLOR_LIGHT forState:UIControlStateNormal];
            
        }
    }
}
@end

//
//  EDHomePageCell.m
//  EDOLDiscovery
//
//  Created by song on 16/12/26.
//  Copyright © 2016年 song. All rights reserved.
//

#import "EDHomePageCell.h"
#import "EDNewsDetailVC.h"
@interface EDHomePageCell ()<CateBaseViewDelegate>
{
    CateBaseView *contextView;
}
@end

@implementation EDHomePageCell

-(void)setCateModel:(EDCateGoryModel *)cateModel
{
    _cateModel = cateModel;
    if(contextView)[contextView removeFromSuperview];
    
    switch (cateModel.viewType) {
        case HomeViewTypeDefault:
        {
            [self.contentView addSubview:[self getEDCommonView]];

        }
            break;
        case HomeViewTypeTopic:
        {//搞笑
            [self.contentView addSubview:[self getEDFunView]];
            
        }
            break;
            
        default:
            break;
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    contextView.frame = self.bounds;
//    self.contentView.backgroundColor  = [UIColor randomColor];
}


#pragma mark
#pragma mark - CateBaseViewDelegate

-(void)edCateBaseView:(CateBaseView *)view didSelectModel:(EDHomeNewsModel *)model
{
    EDHomeNewsModel *selModel = (EDHomeNewsModel *)model;
    EDNewsDetailVC *nextVC    = [EDNewsDetailVC new];
    nextVC.backArrowColor     = WHITECOLOR;
    nextVC.infoId             = selModel.infoId;
    nextVC.hasBackArrow       = YES;
    nextVC.diffTheme          = YES;
    [APPServant pushToController:nextVC animate:YES];
}


-(CateBaseView *)getEDCommonView
{
    if (!contextView) {
        contextView = [[EDHCommonView alloc]initWithFrame:self.bounds];
        contextView.delegate  = self;

    }
    contextView.cateModel = _cateModel;

    return contextView;
}

-(CateBaseView *)getEDFunView
{
    if (!contextView) {
        contextView = [[EDHomeFunView alloc]initWithFrame:self.bounds];
        contextView.delegate  = self;
        
    }
    contextView.cateModel = _cateModel;
    
    return contextView;
}
@end

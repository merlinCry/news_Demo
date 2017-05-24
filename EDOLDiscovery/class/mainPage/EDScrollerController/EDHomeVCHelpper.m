//
//  EDHomeFactory.m
//  EDOLDiscovery
//
//  Created by song on 2017/4/26.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDHomeVCHelpper.h"
#import "EDArticleListCommonVC.h"
#import "EDWTFVC.h"
@implementation EDHomeVCHelpper
+(EDBaseViewController *)viewControllerWithCate:(EDCateGoryModel *)cateModel
{
    if ([cateModel.enAlias isEqualToString:@"gaoxiao"]) {
        EDWTFVC *wtfVC = [EDWTFVC new];
        wtfVC.cateModel = cateModel;
        return wtfVC;
    }else{
        EDArticleListCommonVC *commonListVC = [EDArticleListCommonVC new];
        commonListVC.cateModel = cateModel;
        return commonListVC;
    }
}
+(NSArray *)collectViewControllers:(NSArray *)cateArr
{
    NSMutableArray *viewControllsers = [NSMutableArray new];
    for (EDCateGoryModel *model in cateArr) {
        [viewControllsers addObject:[EDHomeVCHelpper viewControllerWithCate:model]];
    }
    return viewControllsers;
}
@end

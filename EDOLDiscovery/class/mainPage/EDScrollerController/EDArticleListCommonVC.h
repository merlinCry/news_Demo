//
//  EDArticleListCommonVC.h
//  EDOLDiscovery
//
//  Created by song on 2017/4/26.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDBaseViewController.h"
#import "EDCateGoryModel.h"
#import "EDPopMenuVC.h"
@interface EDArticleListCommonVC : EDBaseViewController
/**
 *   model
 */
@property (nonatomic, strong)EDCateGoryModel *cateModel;

@property (nonatomic, assign)NSInteger pageIndex;

@property(nonatomic,strong)EDPopMenuVC *popMenuVC;
-(void)configPopMenu;
@end

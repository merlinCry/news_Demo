//
//  EDWTFVC.h
//  EDOLDiscovery
//
//  Created by song on 2017/4/26.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDBaseViewController.h"
#import "EDCateGoryModel.h"

@interface EDWTFVC : EDBaseViewController
/**
 *   model
 */
@property (nonatomic, strong)EDCateGoryModel *cateModel;

@property (nonatomic, assign)NSInteger pageIndex;

@end

//
//  EDHomeFactory.h
//  EDOLDiscovery
//
//  Created by song on 2017/4/26.
//  Copyright © 2017年 song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EDCateGoryModel.h"

@interface EDHomeVCHelpper : NSObject

+(EDBaseViewController*)viewControllerWithCate:(EDCateGoryModel *)cateModel;

//返回分类频道对应的所有vc
+(NSArray *)collectViewControllers:(NSArray *)cateArr;
@end

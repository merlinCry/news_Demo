//
//  EDPhotoCell.h
//  EDOLDiscovery
//
//  Created by song on 16/12/28.
//  Copyright © 2016年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageInfo.h"
@class EDPhotoCell;

@protocol EDPhotoCellDelegate <NSObject>
@optional
-(void)edPhotoCellTaped:(EDPhotoCell *)cell;

@end

@interface EDPhotoCell : UICollectionViewCell<UIScrollViewDelegate>

@property (nonatomic, strong)ImageInfo *photo;

@property (nonatomic, assign)id<EDPhotoCellDelegate> delegate;

@end

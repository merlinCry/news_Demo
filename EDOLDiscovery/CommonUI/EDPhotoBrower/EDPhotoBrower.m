//
//  EDPhotoBrower.m
//  EDOLDiscovery
//
//  Created by song on 16/12/28.
//  Copyright © 2016年 song. All rights reserved.
//

#import "EDPhotoBrower.h"
#import <Photos/Photos.h>
@interface EDPhotoBrower ()<UICollectionViewDelegate,UICollectionViewDataSource,EDPhotoCellDelegate>
{
    UICollectionView *contentView;
    //当前滚动到的index
    NSInteger        currentIndex;
    //一开始的index
    NSInteger        startIndex;
    UITapGestureRecognizer *tapGes;
    CGRect    startFrame;
    UIView    *blackBgView;
    
    UILabel        *numberLabel;
    UIButton       *saveBtn;
}


@end

@implementation EDPhotoBrower

//+(instancetype)shareInstance
//{
//    
//    static dispatch_once_t once;
//    
//    static id sharedInstance;
//    
//    dispatch_once(&once, ^{
//        sharedInstance = [[self alloc] init];
//    });
//    
//    return sharedInstance;
//    
//}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
//        [self addGestureRecognizer:tapGes];
        
        self.backgroundColor = CLEARCOLOR;
        [self createSubViews];
    }
    return self;
}

-(void)createSubViews
{
    blackBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    blackBgView.backgroundColor = [UIColor blackColor];
    [self addSubview:blackBgView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize                    = CGSizeMake(self.width,self.height);
    layout.minimumLineSpacing          = 0;
    layout.minimumInteritemSpacing     = 0;
    layout.sectionInset                = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.scrollDirection             = UICollectionViewScrollDirectionHorizontal;
    
    contentView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) collectionViewLayout:layout];
    contentView.backgroundColor = [UIColor blackColor];
    contentView.delegate      = self;
    contentView.dataSource    = self;
    contentView.scrollsToTop  = NO;
    contentView.pagingEnabled = YES;
    contentView.showsHorizontalScrollIndicator = NO;
    [contentView registerClass:[EDPhotoCell class] forCellWithReuseIdentifier:@"EDPhotoCellIdent"];
    [self addSubview:contentView];
    [self addOptionBtns];

}
-(void)addOptionBtns
{
    numberLabel = LABEL(FONT(16), WHITECOLOR);
    numberLabel.frame  = CGRectMake(20, 0, 100, 18);
    numberLabel.bottom =   self.height - 20;
    [self addSubview:numberLabel];
    
    saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.width - 64, 0, 44, 44)];
    saveBtn.centerY = numberLabel.centerY;
    saveBtn.titleLabel.font = FONT(15);
    [saveBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.backgroundColor = CLEARCOLOR;
    [saveBtn addTarget:self action:@selector(savePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:saveBtn];
    
}

-(void)setPhotoArr:(NSArray *)photoArr
{
    if (ISEmpty(photoArr)) {
        return;
    }
    _photoArr       = photoArr;
    [contentView reloadData];
    
}

#pragma mark
#pragma uicollectionview
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _photoArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EDPhotoCell *cell = [contentView dequeueReusableCellWithReuseIdentifier:@"EDPhotoCellIdent" forIndexPath:indexPath];
    ImageInfo *photo = _photoArr[indexPath.row];
    cell.photo       = photo;
    cell.delegate    = self;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    ImageInfo *photo = _photoArr[indexPath.row];
}



#pragma mark
#pragma mark scrollviewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //计算当前位置
    currentIndex =  scrollView.contentOffset.x/scrollView.width;
    [self updateNumberLabel];
    
    //更换startView的图片
    if (currentIndex < _photoArr.count) {
        ImageInfo *photo = _photoArr[currentIndex];
        if (photo.cachedImage) {
            _startView.image = photo.cachedImage;
        }else{
            [_startView sd_setImageWithURL:[NSURL URLWithString:photo.img]];

        }
    }
}

//更新当前显示数字
-(void)updateNumberLabel
{
    numberLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)currentIndex+1,(unsigned long)_photoArr.count];
}
-(void)show:(UIView*)sourceView imgIndex:(NSInteger)index
{
    _animating                = YES;
    contentView.hidden        = YES;
    blackBgView.alpha         = 0;
    self.alpha                = 1;

    startIndex = currentIndex = index;
    [self updateNumberLabel];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];

    //将startView初始frame转换到window上
    startFrame   = [sourceView convertRect:_startView.frame toView:keyWindow];

    //startView 添加到window
    _startView.frame = startFrame;
    [self insertSubview:_startView aboveSubview:blackBgView];

    
    //计算startView在window上的目标位置
    //宽高比
    CGFloat  whScal         = _startView.width/_startView.height;
    CGSize  targetSize      = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/whScal);
    CGRect targetFrame      = CGRectMake(0, (SCREEN_HEIGHT - targetSize.height)/2, targetSize.width, targetSize.height);
    if (_startView.height > SCREEN_HEIGHT) {
        targetFrame.origin.y = 0;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [contentView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    //将start移动到目标位置
    [UIView animateWithDuration:0.4 animations:^{
        _startView.frame  = targetFrame;
        blackBgView.alpha = 1;
    } completion:^(BOOL finished) {
        contentView.hidden = NO;
        _animating = NO;
    }];
    
    
}

-(void)dismiss
{
    if (_animating)return;
    
    if (currentIndex == startIndex) {
        [self backToOrigin];
    }else{
        [self backDismiss];
        
    }
}

//回到原处
-(void)backToOrigin
{
    _animating = YES;
    contentView.hidden = YES;
    [UIView animateWithDuration:0.4 animations:^{
        _startView.frame  = startFrame;
        blackBgView.alpha = 0;
    } completion:^(BOOL finished) {
        [_startView removeFromSuperview];
        [self removeFromSuperview];
        [self dismissCallBack];
        _animating = NO;

    }];
}

//直接消失
-(void)backDismiss
{
    _animating = YES;
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        [_startView removeFromSuperview];
        [self removeFromSuperview];
        [self dismissCallBack];
        _animating = NO;

    }];
}


-(void)dismissCallBack
{
    if (_delegate && [_delegate respondsToSelector:@selector(browerDismissed)]) {
        [_delegate browerDismissed];
    }
}

- (void)savePhoto
{
    if (currentIndex >= _photoArr.count) {
        return;
    }
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted) {
        // 因为家长控制, 导致应用无法方法相册(跟用户的选择没有关系)
        [APPServant makeToast:self title:@"无法访问相册" position:50];

    } else if (status == PHAuthorizationStatusDenied) {
        // 用户拒绝当前应用访问相册(用户当初点击了"不允许")
        [APPServant makeToast:self title:@"请在设置中润徐访问相册" position:50];

    } else if (status == PHAuthorizationStatusAuthorized) {
        // 用户允许当前应用访问相册(用户当初点击了"好")
        [self saveImage];
    } else if (status == PHAuthorizationStatusNotDetermined) {
        // 用户还没有做出选择
        // 弹框请求用户授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                // 用户点击了好
                [self saveImage];
            }
        }];
    }
}

-(void)saveImage
{
    ImageInfo *img = _photoArr[currentIndex];
    if (ISEmpty(img.cachedImage)) {
        return;
    }
    //1 必须在 block 中调用
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        //2 异步执行保存图片操作
        [PHAssetChangeRequest creationRequestForAssetFromImage:img.cachedImage];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //3 保存结束后，回调
            if (error) {
                [APPServant makeToast:KeyWindow title:@"保存失败" position:50];
            }else{
                [APPServant makeToast:KeyWindow title:@"保存成功" position:50];
                
            }
        });

    }];
}

#pragma mark EDPhotoCellDelegate
-(void)edPhotoCellTaped:(EDPhotoCell *)cell
{
    [self dismiss];
    
}

@end

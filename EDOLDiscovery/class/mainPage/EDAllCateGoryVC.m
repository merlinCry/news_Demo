//
//  EDAllCateGoryVC.m
//  EDOLDiscovery
//
//  Created by song on 17/1/7.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDAllCateGoryVC.h"

@interface EDAllCateGoryVC ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,EDEditCateCellDelegate>
{
    UICollectionView *contentView;
    NSMutableArray   *dataSource;
    NSMutableArray   *dataSourceMore;
    
    NSString         *originCateSort;
    BOOL             channelChanged;
    
}
//是否为编辑状态
@property(nonatomic,assign)BOOL     isEditing;
@property(nonatomic,strong)UILabel  *titleTip1;
@property(nonatomic,strong)UIButton *editBtn;
@property(nonatomic,strong)UILabel  *bottomTip;

@property(nonatomic,strong)UILabel *titleTip2;

@property(nonatomic,strong)UIPanGestureRecognizer *movePress;
@end


@implementation EDAllCateGoryVC

#pragma mark
#pragma mark getters
-(UILabel *)titleTip1
{
    if (!_titleTip1) {
        _titleTip1 = LABEL(FONT(16), COLOR_999);
        _titleTip1.frame    = CGRectMake(20, 30, 100, 20);
        _titleTip1.text     = @"我的频道";
    }
    return _titleTip1;
}

-(UIButton *)editBtn
{
    if (!_editBtn) {
        _editBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        _editBtn.centerY   = self.titleTip1.centerY;
        _editBtn.right     = SCREEN_WIDTH - 20;
        _editBtn.backgroundColor = CLEARCOLOR;
        _editBtn.titleLabel.font = FONT_Light(14);
        UIColor  *editTextColor   = [APPServant servant].nightShift?COLOR_999:COLOR_333;
        [_editBtn setTitleColor:editTextColor forState:UIControlStateNormal];
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_editBtn setTitle:@"完成" forState:UIControlStateSelected];
        UIImage *editImage = [UIImage iconWithInfo:TBCityIconInfoMake(editIcon, 15, editTextColor)];
        UIImage *editImageSel = [UIImage iconWithInfo:TBCityIconInfoMake(editIcon, 15, CLEARCOLOR)];
        [_editBtn setImage:editImage forState:UIControlStateNormal];
        [_editBtn setImage:editImageSel forState:UIControlStateSelected];

        [_editBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}

-(UILabel *)bottomTip
{
    if (!_bottomTip) {
        _bottomTip = LABEL(FONT(12), COLOR_999);
        _bottomTip.frame    = CGRectMake(20, 0, 150, 20);
        _bottomTip.text     = @"拖动小图标调整你的姿势";
    }
    return _bottomTip;
}

-(UILabel *)titleTip2
{
    if (!_titleTip2) {
        _titleTip2 = LABEL(FONT(16), COLOR_999);
        _titleTip2.frame    = CGRectMake(20, 20, 100, 20);
        _titleTip2.text     = @"更多姿势";
    }
    return _titleTip2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    originCateSort = @"";
    
    dataSource     = [NSMutableArray new];
    dataSourceMore = [NSMutableArray new];
    //模糊背景
    BOOL night = [APPServant servant].nightShift;
    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:night?UIBlurEffectStyleDark:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *backView = [[UIVisualEffectView alloc]initWithEffect:beffect];
    backView.frame = self.view.bounds;
    backView.contentView.backgroundColor = View_BACKGROUND_COLOR_Blur;
    [self.view addSubview:backView];
    
    [self addCloseBtn];
    [self createSubView];
    
    [self getCateGorys];
}

-(void)addCloseBtn
{
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44, 44)];
    closeBtn.right = self.view.width ;
    [closeBtn setTitle:closeIcon forState:UIControlStateNormal];
    [closeBtn setTitleColor:COLOR_999 forState:UIControlStateNormal];
    [closeBtn  setTitleFontSize:20];
    [self.view addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)createSubView
{
    CGFloat  width  = (SCREEN_WIDTH - 50)/4;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize                    = CGSizeMake(width, 51);
    layout.minimumLineSpacing          = 0;
    layout.minimumInteritemSpacing     = 0;
    layout.sectionInset                = UIEdgeInsetsMake(0, 15, 0, 10);
    layout.scrollDirection             = UICollectionViewScrollDirectionVertical;
//    layout.sectionHeadersPinToVisibleBounds = NO;//头部视图悬停设为YES
//    layout.sectionFootersPinToVisibleBounds = NO;//尾部视图悬停设为YES
    
    contentView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64,self.view.width,self.view.height - 64) collectionViewLayout:layout];
    contentView.backgroundColor = CLEARCOLOR;
    contentView.delegate      = self;
    contentView.dataSource    = self;
    contentView.scrollsToTop  = NO;
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.alwaysBounceVertical = YES;
    [contentView registerClass:[EDEditCateCell class] forCellWithReuseIdentifier:@"EDEditCateCellIdent"];
    
    [contentView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableViewHeaderIdent"];
    [contentView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableViewFooterIdent"];

    //添加长按手势来移动 item
    _movePress = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didReceiveLongPress:)];
    _movePress.enabled = NO;
    [contentView addGestureRecognizer:_movePress];
    contentView.userInteractionEnabled = YES;
    [self.view addSubview:contentView];
    
}

//长按手势状态控制移动 item
-(void)didReceiveLongPress:(UILongPressGestureRecognizer   *)longpress
{
    if (!contentView) return;
    switch (longpress.state) {
        case UIGestureRecognizerStateBegan:
        {
            //搜寻长按手势在UICollectionView上的位置，若不为nil则开启移动对应位置Cell
            NSIndexPath * indexpath = [contentView indexPathForItemAtPoint:[longpress locationInView:contentView]];
            if (indexpath == nil) {
                break;
            }
            [contentView beginInteractiveMovementForItemAtIndexPath:indexpath];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            //长按后移动的情况下，不断通过手势对应的位置更新被选中的Cell的位置
            //这里限制只在section0内拖动
            CGPoint targetPoint = [longpress locationInView:contentView];
            NSIndexPath *dindexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [contentView.collectionViewLayout layoutAttributesForDecorationViewOfKind:@"" atIndexPath:dindexPath];
            [contentView updateInteractiveMovementTargetPosition:targetPoint];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            //长按手势结束，关闭移动
            [contentView endInteractiveMovement];
        }
            break;
        default:
        {
            //其它情况，关闭移动
            [contentView endInteractiveMovement];
        }
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark
#pragma uicollectionview
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 1) {
        return dataSourceMore.count;
    }
    return dataSource.count;

}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EDEditCateCell *cell        = [contentView dequeueReusableCellWithReuseIdentifier:@"EDEditCateCellIdent" forIndexPath:indexPath];
    cell.delegate               = self;
    if (indexPath.section == 0) {
        EDCateGoryModel *cateModel  = dataSource[indexPath.row];
        cell.model              = cateModel;

    }else if(indexPath.section == 1){
        EDCateGoryModel *cateModel  = dataSourceMore[indexPath.row];
        cell.model              = cateModel;

    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(SCREEN_WIDTH, 60);
    }
    return CGSizeMake(SCREEN_WIDTH, 50);

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, 30);
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *resView;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        resView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UICollectionReusableViewHeaderIdent" forIndexPath:indexPath];
        if (indexPath.section == 0) {

            [resView addSubview:self.titleTip1];

            [resView addSubview:self.editBtn];
            
        }else if(indexPath.section == 1){

            [resView addSubview:self.titleTip2];
        }
        
        
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {

        resView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UICollectionReusableViewFooterIdent" forIndexPath:indexPath];
        if (indexPath.section == 0) {

            [resView addSubview:self.bottomTip];
        }
    }
    
    resView.backgroundColor = CLEARCOLOR;
    return resView;

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {//&& _isEditing
        //将地下的添加到上面去
        EDCateGoryModel *cateModel  = dataSourceMore[indexPath.row];
        [dataSourceMore removeObject:cateModel];
        
        cateModel.selected = YES;
        cateModel.editing  = _editBtn.isSelected;
        [dataSource addObject:cateModel];
        [contentView reloadData];
        
//        NSIndexPath *sourceIndexPath      = indexPath;
//        NSIndexPath *destinationIndexPath = [NSIndexPath indexPathForRow:dataSource.count inSection:0];
//        [contentView moveItemAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
        
    }
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(9_0)
{
    if(indexPath.section == 0 && indexPath.row == 0){
        return NO;

    }
    return YES;

}

//移动 item 行为
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath NS_AVAILABLE_IOS(9_0)
{
//这里只是在ui变化之后更新对应的数据源

    //如果secion相同则交换位置
    if(sourceIndexPath.section == destinationIndexPath.section){
        //这里不能只交换两个model的位置，移动过程中处于两个model之间的其他model位置也会变化
        if(sourceIndexPath.section == 0){
            //先取出source
            EDCateGoryModel * smodel = dataSource[sourceIndexPath.row];
            [dataSource removeObject:smodel];
            //然后将smodel插入des
            [dataSource insertObject:smodel atIndex:destinationIndexPath.row];
            
        }else{
            //先取出source
            EDCateGoryModel * smodel = dataSourceMore[sourceIndexPath.row];
            [dataSourceMore removeObject:smodel];
            //然后将smodel插入des
            [dataSourceMore insertObject:smodel atIndex:destinationIndexPath.row];
            
        }
    }else{
         //section不同
        if(sourceIndexPath.section == 0){
            //删除section0中对应数据 insert到section1中    并更改相应状态
            EDCateGoryModel * smodel = dataSource[sourceIndexPath.row];
            [dataSource removeObject:smodel];
            smodel.selected = NO;
            smodel.editing  = NO;
            [dataSourceMore insertObject:smodel atIndex:destinationIndexPath.row];
        }else{
            //删除section1中对应数据 insert到section0中    并更改相应状态
            EDCateGoryModel * smodel = dataSourceMore[sourceIndexPath.row];
            [dataSourceMore removeObject:smodel];
            smodel.selected = YES;
            smodel.editing  = YES;
            [dataSource insertObject:smodel atIndex:destinationIndexPath.row];
        }
    }
}

//计算每个频道size
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    EDCateGoryModel *cateModel  = dataSource[indexPath.row];
//    CGFloat height = 51;
//    CGFloat width = [cateModel.cateName sizeWithAttributes:@{NSFontAttributeName:FONT_Light(14)}].width + 50;
//    return CGSizeMake(width, height);
//    
//}


-(void)closeAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        //通知首页刷新
        if (channelChanged && self.BackAction) {
            //将缓存中的数据重新排个序
            [[APPServant servant].allAPPCategorys removeObjectsInArray:dataSource];
            
            [[APPServant servant].allAPPCategorys addObjectsFromArray:dataSource];
            self.BackAction(nil);
        }

    }];
}


-(void)getCateGorys
{
    for (EDCateGoryModel *model in [APPServant servant].allAPPCategorys) {
        model.editing = NO;
        if (model.selected) {
            model.editing = NO;
            [dataSource    addObject:model];
            
        }else{
            model.editing = NO;
            [dataSourceMore addObject:model];
        }
    }
     originCateSort = [self getFormateSortString:dataSource];
     [contentView reloadData];
    
}

//上传频道编辑结果
-(void)saveCateEditResult:(NSString *)idArrays
{
    //本地保存一份,如果登陆则提交至server
    [EDOLTool saveToNSUserDefaults:idArrays forKey:ED_CateGory_CacheKey_UN];
    
    if (ED_ISLogin) {
        NSDictionary *paramDic = @{@"idArrays":idArrays};
        [EDHud show];
        [[HttpRequestManager manager] GET:HOMECategory_sort parameters:paramDic success:^(NSURLSessionDataTask * task,id responseObject)
         {
             [EDHud dismiss];
             NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
             NSLog(@"获取成功:%@",dic);
             if ([[dic objectForKey:@"code"] integerValue] == 200) {
                 channelChanged = YES;
                 
             }
         }failure:^(NSURLSessionDataTask * task,NSError *errpr)
         {
             [EDHud dismiss];
             NSLog(@"failuer");
         }];

    }
}


-(void)editAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    _isEditing      = sender.isSelected;
    _movePress.enabled      = _isEditing;
    
    for (EDCateGoryModel *model in dataSource) {
        model.editing = sender.isSelected;
    }
    NSString *newSortIds = [self getFormateSortString:dataSource];
    channelChanged = ![originCateSort isEqualToString:newSortIds];
    if(!_isEditing){
        //(与初始顺序字符串进行比对)如果不同  将编辑结果提交至服务端(没登录保存在本地)
        if (channelChanged) {
            UMMobClick(@"home_channel_edit");
            [self saveCateEditResult:newSortIds];
        }
    }
    
    
    [contentView reloadData];

}



#pragma mark
#pragma mark EDEditCateCellDelegate
-(void)edEditCateCell:(EDEditCateCell *)cell deleteAtModel:(EDCateGoryModel *)model
{
    [dataSource removeObject:model];
    model.selected = NO;
    model.editing  = NO;
    [dataSourceMore addObject:model];
    [contentView reloadData];
    
//    NSIndexPath *fIndexPath = [NSIndexPath indexpath];
    
    
}


-(NSString *)getFormateSortString:(NSArray *)dataArr
{
    if (ISEmpty(dataArr)) {
        return @"";
    }
    NSString *resStr = @"";
    for (EDCateGoryModel *model in dataArr) {
        if ([resStr isEqualToString:@""]) {
            resStr = [NSString stringWithFormat:@"%@",model.cateId];
        }
        else
        {
            resStr = [NSString stringWithFormat:@"%@@%@",resStr,model.cateId];
        }
    }
    
    return resStr;
}

@end

//
//  EDModiffyUserInfoVC.m
//  EDOLDiscovery
//
//  Created by song on 17/1/7.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDModiffyUserInfoVC.h"
#import "EDCommonCell.h"
#import "APPInputPopView.h"

@interface EDModiffyUserInfoVC ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITableView *contentTable;
}
@end

@implementation EDModiffyUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLikeNavTitle:@"修改资料"];
    
    [self createSubView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createSubView
{
    CGFloat top = 0;
//    if (self.hasLickNav) {
//        top = 64;
//    }
    contentTable = [[UITableView alloc]initWithFrame:CGRectMake(0,top, self.view.width, self.view.height) style:UITableViewStylePlain];
    contentTable.backgroundColor = CLEARCOLOR;
    contentTable.separatorStyle  = UITableViewCellSeparatorStyleNone;
    contentTable.delegate   = self;
    contentTable.dataSource = self;
    contentTable.tableFooterView = [UIView new];
    [self.view addSubview:contentTable];
}

#pragma mark -----
#pragma mark --------UITableViewDelegate && UITableViewDataSource--------

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = section == 0?1:2;
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"%@ident",NSStringFromClass(self.class)];
    EDCommonCell  *cell = (EDCommonCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[EDCommonCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = 0;
    }
    UserInfo *user = [APPServant servant].user;
    
    if (indexPath.section == 0) {
        //头像
        cell.detailLab.font = ICONFONT(16);
        cell.detailLab.text = arrowRight;
        cell.nameLab.text = @"头像";
        cell.bigIcon = YES;
        NSString *headIcon = [APPServant servant].user.mHeadIcon;
        [cell.iconView sd_setImageWithURL:[NSURL URLWithString:headIcon] placeholderImage:[UIImage imageNamed:@"default_userhead"]];
        
    }else if(indexPath.section == 1){

        if (indexPath.row == 0) {
            //昵称
            cell.nameLab.text = @"昵称";
            UIImage *iconImg= [UIImage iconWithInfo:TBCityIconInfoMake(nickNameIcon, 25, T_ICON_COLOR)];
            cell.iconView.image = iconImg;
            cell.detailTextLabel.text = user.mNickname;

        }else if(indexPath.row == 1){
            cell.nameLab.text = @"性别";
            UIImage *iconImg= [UIImage iconWithInfo:TBCityIconInfoMake(sexIcon, 25, T_ICON_COLOR)];
            cell.iconView.image = iconImg;
            UserInfo *currentUser = [APPServant servant].user;
            cell.detailLab.text = currentUser.mSex == 2?@"女":@"男";
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //更换头像
            [self changeHeaderIcon];
        }
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            //修改昵称
            [APPInputPopView showWithTitle:@"修改昵称" icon:nickNameIcon inputPlaceHolder:@"请输入新的昵称" commitTitle:@"提交" completionBlock:^(BOOL cancelled,id param) {
                if (!cancelled) {
                    [self modifyNickName:param];
                }
                
            }];
            
        }else if(indexPath.row == 1){
            //修改性别
            UIActionSheet *shareSheet = [[UIActionSheet alloc]initWithTitle:@"修改性别" delegate:self cancelButtonTitle:ALERT_CANCEL destructiveButtonTitle:nil otherButtonTitles:nil,nil];
            shareSheet.delegate = self;
            shareSheet.tag = 555;
            shareSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [shareSheet addButtonWithTitle:@"男"];
            [shareSheet addButtonWithTitle:@"女"];
            [shareSheet showInView:self.view];
            
        }
    }
    
}


/**
 *  更换头像
 */
-(void)changeHeaderIcon
{
    UIActionSheet *shareSheet = [[UIActionSheet alloc]initWithTitle:@"更换头像" delegate:self cancelButtonTitle:ALERT_CANCEL destructiveButtonTitle:nil otherButtonTitles:nil,nil];
    shareSheet.delegate = self;
    shareSheet.tag = 777;
    shareSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    [shareSheet addButtonWithTitle:@"相册"];
    [shareSheet addButtonWithTitle:@"拍照"];
    [shareSheet showInView:self.view];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    if (actionSheet.tag == 555) {//修改性别

        [self modifyKind:buttonIndex];
        
    }else if(actionSheet.tag == 777){//修改头像
        if (buttonIndex == 1) {
            //相册
            UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
            
            imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imgPicker.delegate = self;
            //设置选择后的图片可被编辑
            imgPicker.allowsEditing = YES;
            [self presentViewController:imgPicker animated:YES completion:nil];
            
        }else if(buttonIndex == 2){
           //拍照
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                //设置拍照后的图片可被编辑
                picker.allowsEditing = YES;
                picker.sourceType = sourceType;
                picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                
                [self presentViewController:picker animated:YES completion:nil];
            }
        }
    }
}
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        if (image) {
            //上传头像
            [APPServant upLoadImageToAli:image scale:0.5 completionBlock:^(BOOL isSuccess, id param) {
                if (isSuccess) {
                    //将图片链接提交到后台
                    if (NOTEmpty(param)) {
                        [self uploadToServer:@"HEAD_ICO" updatedInfo:param completionBlock:^(BOOL success) {
                            if (success) {
                                UserInfo *aUser = [APPServant servant].user;
                                aUser.mHeadIcon = param;
                                [aUser updateDiskCache];

                                [contentTable reloadData];

                            }
                        }];
                        
                    }
                }else{
                    [APPServant makeToast:self.view title:@"修改失败" position:74];

                }
            }];

        }
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}
//修改昵称
-(void)modifyNickName:(NSString *)newNickname
{
    //先替换 然后默默访问服务器修改
    UserInfo *currentUser = [APPServant servant].user;
    currentUser.mNickname = newNickname;
    [currentUser updateDiskCache];
    [contentTable reloadData];
    [self uploadToServer:@"NICKNAME" updatedInfo:newNickname completionBlock:nil];

}

//修改性别 1表示男 2表示女
-(void)modifyKind:(NSInteger)index
{
    UserInfo *currentUser = [APPServant servant].user;
    currentUser.mSex = index;
    [currentUser updateDiskCache];
    [contentTable reloadData];
    [self uploadToServer:@"SEX" updatedInfo:[NSString stringWithFormat:@"%ld",(long)index] completionBlock:nil];

}

-(void)uploadToServer:(NSString *)userInfoField updatedInfo:(NSString *)updatedInfo completionBlock:(void (^)(BOOL success))block
{
    NSDictionary *paramDic =  @{
                                @"userInfoField":userInfoField,
                                @"updatedInfo":updatedInfo,
                                };
    [[HttpRequestManager manager] GET:SAVE_USERINFO parameters:paramDic success:^(NSURLSessionDataTask * task,id responseObject)
     {
         NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         
         [APPServant makeToast:KeyWindow title:[NetDataCommon stringFromDic:dic forKey:@"msg"] position:74];

          if ([[dic objectForKey:@"rescode"] integerValue] == 200) {
              if (block) {
                  block(YES);
              }
          }else{
              if (block) {
                  block(NO);
              }
          }
     }failure:^(NSURLSessionDataTask * task,NSError *errpr)
     {
         NSLog(@"failuer");
     }];
    
}
@end

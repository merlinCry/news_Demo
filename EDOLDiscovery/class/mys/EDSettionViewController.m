//
//  EDSettionViewController.m
//  EDOLDiscovery
//
//  Created by song on 17/1/6.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDSettionViewController.h"
#import "EDMainColorBtn.h"
@interface EDSettionViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITableView *contentTable;
    UISwitch *switchView;
}
@end

@implementation EDSettionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSubView];
    [self setLikeNavTitle:@"设置"];
    
    switchView = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 45, 30)];
    switchView.on = YES;
    switchView.onTintColor = MAINCOLOR;
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
    
    if ([APPServant servant].user) {
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        footerView.backgroundColor = CLEARCOLOR;
        
        CGRect btnFrame = CGRectMake(30, 56, SCREEN_WIDTH - 60, 45);
        EDMainColorBtn *nextBtn = [[EDMainColorBtn alloc]initWithFrame:btnFrame];
        nextBtn.tintColor = UIColorFromRGB(0xFF7155);
        [nextBtn.contentBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [nextBtn.contentBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
        [nextBtn.contentBtn addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:nextBtn];
        contentTable.tableFooterView = footerView;
        
    }

}

#pragma mark -----
#pragma mark --------UITableViewDelegate && UITableViewDataSource--------

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
    BOOL  nightTheme = [APPServant servant].nightShift;
    NSString *CellIdentifier = [NSString stringWithFormat:@"%@ident",NSStringFromClass(self.class)];
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = 0;
        cell.textLabel.font = FONT_Light(16);
        cell.detailTextLabel.font = FONT_Light(16);
        cell.textLabel.textColor  = nightTheme?COLOR_DDD:BLACKCOLOR;
        cell.detailTextLabel.textColor = COLOR_999;
        cell.backgroundColor = Cell_CONTENT_COLOR;

    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //推送通知
            cell.textLabel.text = @"推送通知";
            cell.accessoryView = switchView;
            UIImage *iconImg= [UIImage iconWithInfo:TBCityIconInfoMake(pushIcon, 25, nightTheme?COLOR_999:COLOR_333)];
            cell.imageView.image = iconImg;
            if (![cell viewWithTag:111]) {
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,59, SCREEN_WIDTH, 1)];
                line.backgroundColor = nightTheme? View_BACKGROUND_COLOR_night:UIColorFromRGB(0xF4F4F4);
                line.tag = 111;
                [cell.contentView addSubview:line];

            }
        }else if(indexPath.row == 1){
           //清理缓存
            cell.textLabel.text = @"清理缓存";
            UIImage *iconImg= [UIImage iconWithInfo:TBCityIconInfoMake(cleanIcon, 25, nightTheme?COLOR_999:COLOR_333)];
            cell.imageView.image = iconImg;
            SDImageCache *cache = [SDImageCache sharedImageCache];
            NSString *sizeString  = @"0.0M";
            NSInteger   cacheSize = [cache getSize];
            if (cacheSize > 0) {
                sizeString = [NSString stringWithFormat:@"%.1ldM",cacheSize/1024/1024/10];
            }
            cell.detailTextLabel.text = sizeString;
        }
        
    }else if(indexPath.section == 1){
          //检查更新
        cell.textLabel.text = @"检查更新";
        UIImage *iconImg= [UIImage iconWithInfo:TBCityIconInfoMake(refreshIcon, 25, nightTheme?COLOR_999:COLOR_333)];
        cell.imageView.image = iconImg;
        NSString *version    = [NSString stringWithFormat:@"V%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
        cell.detailTextLabel.text = version;

    
    }
    
    return cell;
}
     
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            
            SDImageCache *cache = [SDImageCache sharedImageCache];
            //清空内存中的缓存
//            [cache clearMemory];
            //清理磁盘中的缓存
            [cache clearDiskOnCompletion:^{
                [APPServant makeToast:KeyWindow title:@"清理完成" position:74];

                [contentTable reloadData];

            }];
        
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//退出登录
-(void)logoutAction
{
    [APPServant logOut];
    [self.navigationController popViewControllerAnimated:YES];


}
@end

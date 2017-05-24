//
//  EDChooseSchoolVC.m
//  EDOLDiscovery
//
//  Created by song on 17/1/7.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDChooseSchoolVC.h"

@interface EDChooseSchoolVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *contentTable;
}
@end

@implementation EDChooseSchoolVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLikeNavTitle:@"选择学校"];
    
    [self createSubViews];
}

-(void)createSubViews
{
    contentTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, self.view.height - 64)];
    contentTable.delegate = self;
    contentTable.dataSource = self;
    contentTable.backgroundColor = CLEARCOLOR;
    contentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    contentTable.sectionIndexColor = MAINCOLOR;
    [self.view addSubview:contentTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -----
#pragma mark --------UITableViewDelegate && UITableViewDataSource--------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerLabel = LABEL(FONT_Light(16), COLOR_999);
    headerLabel.frame    = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    headerLabel.backgroundColor = WHITECOLOR;
    headerLabel.text = @"  A";
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 29, SCREEN_WIDTH, 1)];
    line.backgroundColor = UIColorFromRGB(0xE9E9E9);
    [headerLabel addSubview:line];
    return headerLabel;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font = FONT_Light(16);
        cell.textLabel.textColor = COLOR_333;
    }
    cell.textLabel.text = @"南京";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    
    return @[@"A",@"B",@"C",@"D",@"E",@"F",@"A",@"B",@"C",@"D",@"E",@"F"];
}

//-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//
//{
//    
//    
//}
@end

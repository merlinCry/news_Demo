//
//  EDPopMenuVC.m
//  EDPopViewVCDemo
//
//  Created by song on 2017/5/5.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDPopMenuVC.h"

@interface EDPopMenuVC ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView *contentTable;

@end

@implementation EDPopMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSubView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)createSubView
{
    _contentTable = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _contentTable.backgroundColor = MAINCOLOR;
    if (self.dataSource.count == 1) {
        _contentTable.separatorStyle  = UITableViewCellSelectionStyleNone;
    }
    _contentTable.delegate   = self;
    _contentTable.dataSource = self;
    [self.view addSubview:_contentTable];
}

#pragma mark -----
#pragma mark --------UITableViewDelegate && UITableViewDataSource--------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"%@ident",NSStringFromClass(self.class)];
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle      = 0;
        cell.textLabel.font      = FONT_Light(14);
        cell.textLabel.textColor = COLOR_333;
        cell.backgroundColor     = CLEARCOLOR;
    }
    cell.textLabel.text = _dataSource[indexPath.row];
     return cell;
}
     
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    NSLog(@"%@",_dataSource[indexPath.row]);
    if (self.selectBlack) {
        self.selectBlack(indexPath.row);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

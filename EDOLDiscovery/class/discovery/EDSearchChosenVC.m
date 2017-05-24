//
//  EDSearchChosenVC.m
//  EDOLDiscovery
//
//  Created by fang Zhou on 2017/4/27.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDSearchChosenVC.h"
#import "EDSearchBar.h"

@interface EDSearchChosenVC () <UITableViewDelegate,UITableViewDataSource>
{
    EDSearchBar *navSearchBar;
    UITableView *searchResultTable;
    NSMutableArray *resultArray;
}

@end

@implementation EDSearchChosenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavSearchBar];
}

- (void)setNavSearchBar{
    self.navigationItem.titleView.hidden = YES;
    navSearchBar = [[EDSearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-70, 30)];
    navSearchBar.barBackgroudColor = UIColorFromRGB(0xFAFAFA);
    navSearchBar.searchTld.placeholder = @"搜索";
    navSearchBar.searchTld.returnKeyType = UIReturnKeySearch;
    navSearchBar.searchTld.clearButtonMode = UITextFieldViewModeWhileEditing;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChange:)name:UITextFieldTextDidChangeNotification object:navSearchBar.searchTld];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navSearchBar];
    
    self.navRightTitle = @"取消";
}

- (void)initTableView{
    searchResultTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ControllerView_HEIGHT)];
    searchResultTable.backgroundColor = CLEARCOLOR;
    searchResultTable.delegate = self;
    searchResultTable.dataSource = self;
    [self.view addSubview:searchResultTable];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBtnPressed{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)textChange:(NSNotification *)notif
{
    NSLog(@"%@",navSearchBar.searchTld.text);
}


#pragma mark -----
#pragma mark --------UITableViewDelegate && UITableViewDataSource--------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end

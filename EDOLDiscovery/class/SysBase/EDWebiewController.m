//
//  EDWebiewController.m
//  EDOLDiscovery
//
//  Created by song on 2017/4/7.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDWebiewController.h"
#import <WebKit/WebKit.h>
@interface EDWebiewController ()

@property(nonatomic,strong)WKWebView *contentWebview;
@property(nonatomic,strong)UIProgressView *progress;

@end

@implementation EDWebiewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.contentWebview];
    _progress = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, 375, 1)];
    _progress.progressTintColor= MAINCOLOR;
    [self.view addSubview:_progress];
    
    NSURL *posturl = [NSURL URLWithString:_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:posturl];
    [self.contentWebview loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(WKWebView *)contentWebview
{
    if (!_contentWebview) {
        _contentWebview = [[WKWebView alloc]initWithFrame:self.view.bounds];
        [_contentWebview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _contentWebview;
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        _progress.hidden   = _contentWebview.estimatedProgress == 1;
        _progress.progress = _contentWebview.estimatedProgress;
    }
}

-(void)dealloc
{
    [_contentWebview removeObserver:self forKeyPath:@"estimatedProgress"];
}
@end

//
//  LKInfoWebViewViewController.m
//  LKWallpaper
//
//  Created by Lukj on 2017/5/26.
//  Copyright © 2017年 lukj. All rights reserved.
//

#import "LKInfoWebViewViewController.h"

@interface LKInfoWebViewViewController ()

@end

@implementation LKInfoWebViewViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadUrl];
    [self.navigationController setNavigationBarHidden:NO];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
    
}

- (void)loadUrl {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    
    [self.webView loadRequest:request];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  SecondViewController.m
//  LvXiu_iOS
//
//  Created by panshen on 2017/10/12.
//  Copyright © 2017年 panshen. All rights reserved.
//

#import "SecondViewController.h"
#import "AFNetworking.h"

@interface SecondViewController ()
<NJKWebViewProgressDelegate,
UIWebViewDelegate>

@end

@implementation SecondViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.rightBtn.hidden = YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.rightBtn.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%@",_data);
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    
    __block AFNetworkReachabilityManager *weakMgr = manager;
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == 1 || status == 2) {
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_URL]]];
            
            [weakMgr stopMonitoring];
        }
        
        else {
            NSLog(@"没有网络");
        }
        
    }];
    
    
    self.progressProxy.webViewProxyDelegate = self;
    self.progressProxy.progressDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [self.progressView setProgress:progress animated:YES];
    
    self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

@end

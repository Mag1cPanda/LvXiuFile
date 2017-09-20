//
//  LvXiuViewController.m
//  LvXiu_iOS
//
//  Created by panshen on 2017/9/20.
//  Copyright © 2017年 panshen. All rights reserved.
//

#import "LvXiuViewController.h"
#import "LvXiu.h"
#import "LxStorage.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface LvXiuViewController ()
<UIWebViewDelegate,
NJKWebViewProgressDelegate>

@end

@implementation LvXiuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"LvXiu";
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://webtest.lvxiu.96007.cc/test.html"]]];
    
    self.progressProxy.webViewProxyDelegate = self;
    self.progressProxy.progressDelegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIWebViewDelegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"------:%@", [request valueForHTTPHeaderField:@"User-Agent"]);
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    JSContext *ctx = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    LvXiu *lx = [[LvXiu alloc] init];
    
    //用WebView执行某段JS代码
    NSString *URLString = [self.webView stringByEvaluatingJavaScriptFromString:@"lx.parseApiUrl($('#parseApiUrl').val());"];
    NSLog(@"%@",URLString);
    
    lx.URL = URLString;
    lx.vc = self;
    ctx[@"lx"] = lx;
    
    LxStorage *lxStorage = [LxStorage new];
    lxStorage.webView = self.webView;
    ctx[@"lxStorage"] = lxStorage;
    
    
    // 打印异常
    ctx.exceptionHandler =
    ^(JSContext *context, JSValue *exceptionValue)
    {
        context.exception = exceptionValue;
        NSLog(@"%@", exceptionValue);
    };
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"error ~ %@",error.description);
}


#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [self.progressView setProgress:progress animated:YES];
    
    //    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}




@end

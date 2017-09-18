//
//  ViewController.m
//  LvXiu_iOS
//
//  Created by panshen on 2017/9/5.
//  Copyright © 2017年 panshen. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "LvXiu.h"
#import "LxStorage.h"
#import "LRWebView.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"

@interface ViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>
{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}
@property (weak, nonatomic) IBOutlet LRWebView *webView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"LvXiu";
    self.automaticallyAdjustsScrollViewInsets = false;
    
    //去除导航栏底部黑线
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    // 仿微信进度条
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
//    [self.navigationController.navigationBar addSubview:_progressView];

    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://webtest.lvxiu.96007.cc/test.html"]]];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ButtonAction
- (IBAction)backButtonPush {
    if (self.webView.canGoBack)
    {
        [self.webView goBack];
    }
}

- (IBAction)forwardButtonPush {
    if (self.webView.canGoForward)
        
    {
        [self.webView goForward];
    }
}

- (IBAction)reloadButtonPush {
    
    [self.webView reload];
}

- (IBAction)stopButtonPush {
    
    if (self.webView.loading)
    {
        [self.webView stopLoading];
    }
    
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
    ctx[@"lx"] = lx;
    
    LxStorage *lxStorage = [LxStorage new];
    lxStorage.webView = _webView;
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
    [_progressView setProgress:progress animated:YES];
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}



@end

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
#import "LxShare.h"
#import "LxOAuth.h"
#import "LxVersion.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "AFNetworking.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>
#import "ShareViewController.h"
#import "LRNavigationController.h"
#import "SecondViewController.h"

@interface LvXiuViewController ()
<UIWebViewDelegate,
NJKWebViewProgressDelegate,
UMSocialShareMenuViewDelegate>
{
    NSString *windowURL;
}

@end

@implementation LvXiuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.title = @"LvXiu";
    
    self.navigationItem.titleView = self.titleView;
    [self.titleView setTitle:@"LvXiu" forState:0];
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),
                                               @(UMSocialPlatformType_WechatTimeLine),
                                               @(UMSocialPlatformType_WechatFavorite),
                                               @(UMSocialPlatformType_QQ),
                                               @(UMSocialPlatformType_Sina)]];
    
    //设置分享面板的显示和隐藏的代理回调
    [UMSocialUIManager setShareMenuViewDelegate:self];
    
    
//    [self.rightBtn addTarget:self action:@selector(share) forControlEvents:1<<6];
    
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    
    __block AFNetworkReachabilityManager *weakMgr = manager;
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == 1 || status == 2) {
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://webtest.lvxiu.96007.cc"]]];
            
            [weakMgr stopMonitoring];
        }
        
        else {
            NSLog(@"没有网络");
        }
        
    }];
    
    
    self.progressProxy.webViewProxyDelegate = self;
    self.progressProxy.progressDelegate = self;
    
}


- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
        
        UMSocialUserInfoResponse *resp = result;
        
        // 第三方登录数据(为空表示平台未提供)
        // 授权数据
        NSLog(@" uid: %@", resp.uid);
        NSLog(@" openid: %@", resp.openid);
        NSLog(@" accessToken: %@", resp.accessToken);
        NSLog(@" refreshToken: %@", resp.refreshToken);
        NSLog(@" expiration: %@", resp.expiration);
        
        // 用户数据
        NSLog(@" name: %@", resp.name);
        NSLog(@" iconurl: %@", resp.iconurl);
        NSLog(@" gender: %@", resp.unionGender);
        
        // 第三方平台SDK原始数据
        NSLog(@" originalResponse: %@", resp.originalResponse);
    }];
}

#pragma mark - Interface Method
-(void)openWindow
{
    [self openWindowWithData:nil];
}

-(void)openWindowWithData:(NSDictionary *)data
{
    SecondViewController *vc = [SecondViewController new];
    vc.data = data;
    vc.URL = windowURL;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UMSocialShareMenuViewDelegate
- (void)UMSocialShareMenuViewDidAppear
{
    NSLog(@"UMSocialShareMenuViewDidAppear");
}
- (void)UMSocialShareMenuViewDidDisappear
{
    NSLog(@"UMSocialShareMenuViewDidDisappear");
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
//    NSString *URLString = [self.webView stringByEvaluatingJavaScriptFromString:@"lx.parseApiUrl($('#parseApiUrl').val());"];
//    NSLog(@"URLString ~ %@",URLString);
    
    windowURL = [self.webView stringByEvaluatingJavaScriptFromString:@"$('#openWindow').val()"];
    NSLog(@"windowURL ~ %@",windowURL);
    
//    lx.URL = URLString;
    lx.vc = self;
    ctx[@"lx"] = lx;
    
    LxStorage *lxStorage = [LxStorage new];
    lxStorage.webView = self.webView;
    ctx[@"lxStorage"] = lxStorage;
    
    LxShare *lxShare = [LxShare new];
    ctx[@"lxShare"] = lxShare;
    
    LxOAuth *lxOAuth = [LxOAuth new];
    ctx[@"lxOAuth"] = lxOAuth;
    
    LxVersion *lxVersion = [LxVersion new];
    ctx[@"lxVersion"] = lxVersion;
//    lxVersion.ctx = ctx;
    
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

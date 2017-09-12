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

@interface ViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"LvXiu";
    
    //去除导航栏底部黑线
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    
//    [self makefourbtn];
    
    _webView.delegate = self;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://webtest.lvxiu.96007.cc/test.html"]]];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makefourbtn{
    NSArray *titltArr = @[@"重载",@"后退",@"前进",@"跳转"];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-50, ScreenWidth, 50)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.alpha = 0.5;
    backView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    backView.layer.borderWidth = 0.5;
    [self.view addSubview:backView];
    
    for (int i= 0 ; i<4; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10+i*((ScreenWidth-50)/4+10), 5, (ScreenWidth-50)/4, 40);
        [button setTitle:titltArr[i] forState:UIControlStateNormal];
        button.layer.borderWidth = 0.5;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = i;
//        [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:button];
    }
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    JSContext *ctx = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    ctx[@"lx"] = [[LvXiu alloc] init];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    
    return YES;
}


@end

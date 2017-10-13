//
//  BaseViewController.m
//  LvXiu_iOS
//
//  Created by panshen on 2017/9/20.
//  Copyright © 2017年 panshen. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.navigationController.navigationBar addSubview:self.progressView];
    
    [self.view addSubview:self.webView];
    
    self.webView.delegate = self.progressProxy;
    
    [self createBottemButton];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.progressView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createBottemButton
{
    NSArray *titleArr = @[@"后退",
                          @"前进",
                          @"刷新",
                          @"停止"];
    
    CGFloat btnHeight = 30;
    CGFloat btnWeight = ScreenWidth/4;
    
    for (NSInteger i=0; i<4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(btnWeight*i, ScreenHeight-30, btnWeight, btnHeight);
        [btn setTitle:titleArr[i] forState:0];
        
        SEL select = nil;
        
        switch (i) {
            case 0:
                select = @selector(backButtonClicked);
                break;
                
            case 1:
                select = @selector(forwardButtonClicked);
                break;
                
            case 2:
                select = @selector(reloadButtonClicked);
                break;
                
            case 3:
                select = @selector(stopButtonClicked);
                break;
                
            default:
                break;
        }
        
        [btn addTarget:self action:select forControlEvents:1<<6];
        
        [self.view addSubview:btn];
    }
    
}


-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Bottem Button Action
- (void)backButtonClicked
{
    if (self.webView.canGoBack){
        [self.webView goBack];
    }
}

- (void)forwardButtonClicked
{
    if (self.webView.canGoForward){
        [self.webView goForward];
    }
}

- (void)reloadButtonClicked
{
    [self.webView reload];
}

- (void)stopButtonClicked
{
    if (self.webView.loading){
        [self.webView stopLoading];
    }
}


#pragma mark - lazy
-(UIButton *)titleView
{
    if (!_titleView) {
        _titleView = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleView.frame = CGRectMake(0, 0, 100, 40);
        [_titleView setTitleColor:[UIColor blackColor] forState:0];
        _titleView.titleLabel.font = LRFont(14);
    }
    return _titleView;
}

-(UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(0, 0, 44, 44);
//        _backBtn.backgroundColor = [UIColor redColor];
        _backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
        [_backBtn addTarget:self action:@selector(backAction) forControlEvents:1 << 6];
        [_backBtn setImage:[UIImage imageNamed:@"back"] forState:0];
        
    }
    return _backBtn;
}

-(UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(0, 0, 44, 44);
//        _rightBtn.backgroundColor = [UIColor redColor];
        _rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        [_rightBtn addTarget:self action:@selector(backAction) forControlEvents:1 << 6];
        [_rightBtn setImage:[UIImage imageNamed:@"parent"] forState:0];
        
    }
    return _rightBtn;
}

-(LRWebView *)webView
{
    if (!_webView) {
        _webView = [[LRWebView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
    }
    
    return _webView;
}

-(NJKWebViewProgressView *)progressView
{
    if (!_progressView) {
        CGFloat progressBarHeight = 2.f;
        CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
        CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
    
    return _progressView;
}

-(NJKWebViewProgress *)progressProxy
{
    if (!_progressProxy) {
        _progressProxy = [[NJKWebViewProgress alloc] init];
    }
    
    return _progressProxy;
}


@end

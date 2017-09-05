//
//  ViewController.m
//  LvXiu_iOS
//
//  Created by panshen on 2017/9/5.
//  Copyright © 2017年 panshen. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController ()
<WKNavigationDelegate,WKUIDelegate>

typedef enum {
    URL_load = 0,
    HTML_load ,
    Data_load ,
    Fiel_load,
}WkwebLoadType;

//创建一个实体变量
@property(nonatomic,strong) WKWebView *webView;
// 加载type
@property(nonatomic,assign) NSInteger type;
// 设置加载进度条
@property(nonatomic,strong) UIProgressView *progressView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"LvXiu";
    
    //去除导航栏底部黑线
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    

    [self makefourbtn];
    
    // 创建进度条
    if (!self.progressView) {
        self.progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        self.progressView.frame = CGRectMake(0, 64, self.view.bounds.size.width, 2);
        // 设置进度条的色彩
        [self.progressView setTrackTintColor:[UIColor clearColor]];
        self.progressView.progressTintColor = [UIColor redColor];
        [self.view addSubview:self.progressView];
    }
    
    WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
    //允许视频播放
    configuration.allowsAirPlayForMediaPlayback = YES;
    // 允许在线播放
    configuration.allowsInlineMediaPlayback = YES;
    // 允许可以与网页交互，选择视图
    configuration.selectionGranularity = YES;
    // 是否支持记忆读取
    configuration.suppressesIncrementalRendering = YES;
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 66, ScreenWidth, ScreenHeight-66-50) configuration:configuration];
    
    [_webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_webView setNavigationDelegate:self];
    [_webView setUIDelegate:self];
    [_webView setMultipleTouchEnabled:YES];
    [_webView setAutoresizesSubviews:YES];
    [_webView.scrollView setAlwaysBounceVertical:YES];
    // 这行代码可以是侧滑返回webView的上一级，而不是根控制器（*只针对侧滑有效）
    [_webView setAllowsBackForwardNavigationGestures:true];
    
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://yurun.test.96007.cc/Test/index"]]];
    
    [self.view addSubview:self.webView];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)makefourbtn{
    NSArray * titltArr = @[@"重载",@"后退",@"前进",@"跳转"];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-50, ScreenWidth, 50)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.alpha = 0.5;
    backView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    backView.layer.borderWidth = 0.5;
    [self.view addSubview:backView];
    
    for (int i= 0 ; i<4; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10+i*((ScreenWidth-50)/4+10), 5, (ScreenWidth-50)/4, 40);
        [button setTitle:titltArr[i] forState:UIControlStateNormal];
        button.layer.borderWidth = 0.5;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:button];
    }
}


-(void)btnClicked:(UIButton *)btn{
    switch (btn.tag) {
        case 0:{
            //这个是带缓存的验证
//            [self.webView reloadFromOrigin];
            
            // 是不带缓存的验证，刷新当前页面
            [self.webView reload];
        }
            break;
        case 1:{
            // 后退
            // 首先判断网页是否可以后退
            if (self.webView.canGoBack) {
                [self.webView goBack];
            }
        }
            break;
        case 2:{
            // 前进
            // 判断是否可以前进
            if (self.webView.canGoForward) {
                [self.webView goForward];
            }
        }
            break;
        case 3:{
            //进行跳转,暂时设置跳转的返回到第一个界面
            NSLog(@"%@",self.webView.backForwardList.backList);
            if (self.webView.backForwardList.backList.count >0) {
                [self.webView goToBackForwardListItem:self.webView.backForwardList.backList[0]];
            }
        }
            break;
        default:
            break;
    }
}

//这个是网页加载完成，导航的变化
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    /*
     主意：这个方法是当网页的内容全部显示（网页内的所有图片必须都正常显示）的时候调用（不是出现的时候就调用），，否则不显示，或则部分显示时这个方法就不调用。
     */
    NSLog(@"加载完成调用");
    // 获取加载网页的标题
    NSLog(@"加载的标题：%@",self.webView.title);
    
}


//开始加载
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    //开始加载的时候，让加载进度条显示
    self.progressView.hidden = NO;
    
//    self.progressView.progress = self.webView.estimatedProgress;
    
    
    NSLog(@"开始加载的时候调用。。");
    NSLog(@"%lf",   self.webView.estimatedProgress);
    
}


//内容返回时调用
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"当内容返回的时候调用");
    NSLog(@"%lf",   self.webView.estimatedProgress);
    
}


-(void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"这是服务器请求跳转的时候调用");
}


-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    // 内容加载失败时候调用
    NSLog(@"这是加载失败时候调用");
    NSLog(@"%@",error);
}


-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"通过导航跳转失败的时候调用");
}


-(void)webViewDidClose:(WKWebView *)webView{
    NSLog(@"网页关闭的时候调用");
}


-(void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    NSLog(@"%lf",   webView.estimatedProgress);
    
}


-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    // 获取js 里面的提示
}


-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    // js 信息的交流
}


-(void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    // 交互。可输入的文本。
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    // 首先，判断是哪个路径
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        // 判断是哪个对象
        if (object == self.webView) {
            NSLog(@"进度信息：%lf",self.webView.estimatedProgress);
            if (self.webView.estimatedProgress == 1.0) {
                //隐藏
                self.progressView.hidden = YES;
            }else{
                // 添加进度数值
                self.progressView.progress = self.webView.estimatedProgress;
            }
        }
    }
}

//注意，观察的移除
-(void)dealloc{
    [self removeObserver:self forKeyPath:@"estimatedProgress"];
}


@end

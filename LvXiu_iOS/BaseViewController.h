//
//  BaseViewController.h
//  LvXiu_iOS
//
//  Created by panshen on 2017/9/20.
//  Copyright © 2017年 panshen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LRWebView.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"


@interface BaseViewController : UIViewController

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) LRWebView *webView;

@property (nonatomic, strong) UIButton *titleView;

@property (nonatomic, strong) NJKWebViewProgressView *progressView;
@property (nonatomic, strong) NJKWebViewProgress *progressProxy;

-(void)backAction;

@end

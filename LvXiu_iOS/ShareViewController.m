//
//  ShareViewController.m
//  LvXiu_iOS
//
//  Created by panshen on 2017/10/9.
//  Copyright © 2017年 panshen. All rights reserved.
//

#import "ShareViewController.h"
#import "ShareFunction.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>
#import "MBProgressHUD+PKX.h"
#import "UIImage+WebP.h"

@interface ShareViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *weixin;

@property (weak, nonatomic) IBOutlet UIImageView *timeline;

@property (weak, nonatomic) IBOutlet UIImageView *qq;

@property (weak, nonatomic) IBOutlet UIImageView *qzone;

@property (weak, nonatomic) IBOutlet UIImageView *weibo;

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //分享标题
//    self.titles = @"测试";
    
    //分享内容描述
//    self.content = @"测试测试 测试 测试 测试 测试 测试 测试 测试 测试  ";
    
    //分享缩略图图片
    self.iconImg = @"https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/bd_logo1_31bdc765.png";
    
    //分享链接地址
//    self.url = @"www.baidu.com";
    
    [self config_Gestures];
}

- (void)config_Gestures
{
    UITapGestureRecognizer *wxTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(platformType:)];
    _weixin.userInteractionEnabled = YES;
    _weixin.tag = 1;
    [_weixin addGestureRecognizer:wxTap];
    
    UITapGestureRecognizer *tlTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(platformType:)];
    _timeline.userInteractionEnabled = YES;
    _timeline.tag = 2;
    [_timeline addGestureRecognizer:tlTap];
    
    UITapGestureRecognizer *qqTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(platformType:)];
    _qq.userInteractionEnabled = YES;
    _qq.tag = 3;
    [_qq addGestureRecognizer:qqTap];
    
    UITapGestureRecognizer *qzoneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(platformType:)];
    _qzone.userInteractionEnabled = YES;
    _qzone.tag = 4;
    [_qzone addGestureRecognizer:qzoneTap];
    
    UITapGestureRecognizer *wbTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(platformType:)];
    _weibo.userInteractionEnabled = YES;
    _weibo.tag = 5;
    [_weibo addGestureRecognizer:wbTap];
}
- (void)platformType:(UITapGestureRecognizer *)tap
{
    NSLog(@"%zi",tap.view.tag);
    [self shareToPlatformType:tap.view.tag];
}

- (void)shareToPlatformType:(NSInteger )types
{
    [ShareFunction shareInstance].titles = self.shareTitle;
    [ShareFunction shareInstance].content = self.content;
    [ShareFunction shareInstance].iconImg = self.iconImg;
    [ShareFunction shareInstance].url = self.url;
    [[ShareFunction shareInstance] shareToPlatformType:types ToController:self];
}

@end

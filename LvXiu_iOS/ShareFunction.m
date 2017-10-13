//
//  ShareFunction.m
//  LvXiu_iOS
//
//  Created by panshen on 2017/9/15.
//  Copyright © 2017年 panshen. All rights reserved.
//


#import "ShareFunction.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>
#import "MBProgressHUD+PKX.h"

@implementation ShareFunction

+(ShareFunction *)shareInstance
{
    static ShareFunction *share;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        share = [[self alloc] init];
    });
    
    return share;
}

- (void)setTitles:(NSString *)titles
{
    _titles = titles;
}

- (void)setContent:(NSString *)content
{
    _content = content;
}

- (void)setUrl:(NSString *)url
{
    _url = url;
}

- (void)setIconImg:(NSString *)iconImg
{
    _iconImg = iconImg;
}

- (void)shareToController:(UIViewController *)viewController
{
    NSString *titleString = self.titles;
    NSString *downURLString = self.url;
    id iconImage = self.iconImg;
    NSString *content = self.content;
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareWebPageToPlatformType:platformType titles:titleString message:content url:downURLString img:iconImage  ToController:viewController];
    }];
}

#pragma mark - 自定义UI
- (void)shareToPlatformType:(NSInteger)types ToController:(UIViewController *)viewController
{
    NSString *titleString = self.titles;
    NSString *downURLString = self.url;
    id iconImage = self.iconImg;
    NSString *content = self.content;
    
    switch (types) {
        case 1:
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession titles:titleString message:content url:downURLString img:iconImage  ToController:viewController];
        }
            break;
        case 2:
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine titles:titleString message:content url:downURLString img:iconImage  ToController:viewController];
        }
            break;
        case 3:
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_QQ titles:titleString message:content url:downURLString img:iconImage  ToController:viewController];
        }
            break;
        case 4:
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_Qzone titles:titleString message:content url:downURLString img:iconImage ToController:viewController];
        }
            break;
            
        case 5:
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_Sina titles:titleString message:content url:downURLString img:iconImage ToController:viewController];
        }
            break;
        default:
            break;
    }
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType titles:(NSString *)titles message:(NSString *)message url:(NSString *)url img:(NSString *)imgUrl  ToController:(UIViewController *)viewController
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL =  imgUrl;
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:titles descr:message thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = url;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:viewController completion:^(id data, NSError *error) {
        if (error) {
       
            NSString *errorStr = nil;
            if (error.code == 2000 || error.code == 2001) {
                errorStr = @"分享失败";
            }
            else if (error.code == 2005) {
                errorStr = @"分享内容为空";
            }
            else if (error.code == 2006) {
                errorStr = @"分享内容不支持";
            }
            else if (error.code == 2008) {
                errorStr = @"应用未安装";
            }
            else if (error.code == 2009) {
                errorStr = @"取消分享";
            }
            else if (error.code == 2009) {
                errorStr = @"网络异常";
            }
            [MBProgressHUD showError:errorStr toView:viewController.navigationController.view];
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                [MBProgressHUD showSuccess:@"分享成功" toView:[self showView]];
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

- (UIView *)showView
{
    UIView *view = nil;
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (!window.isKeyWindow)continue;
        view = window;
        break;
    }
    return view;
}

@end

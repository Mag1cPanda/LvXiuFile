//
//  LxOAuth.m
//  LvXiu_iOS
//
//  Created by panshen on 2017/9/15.
//  Copyright © 2017年 panshen. All rights reserved.
//

#import "LxOAuth.h"
#import "Util.h"
#import "OAuthModel.h"

@implementation UMSAuthInfo

+ (instancetype)objectWithType:(UMSocialPlatformType)platform
{
    UMSAuthInfo *obj = [UMSAuthInfo new];
    obj.platform = platform;
    UMSocialUserInfoResponse *resp = nil;
    
    NSDictionary *authDic = [[UMSocialDataManager defaultManager ] getAuthorUserInfoWithPlatform:platform];
    if (authDic) {
        resp = [[UMSocialUserInfoResponse alloc] init];
        resp.uid = [authDic objectForKey:kUMSocialAuthUID];
        resp.unionId = [authDic objectForKey:kUMSocialAuthUID];
        resp.accessToken = [authDic objectForKey:kUMSocialAuthAccessToken];
        resp.expiration = [authDic objectForKey:kUMSocialAuthExpireDate];
        resp.refreshToken = [authDic objectForKey:kUMSocialAuthRefreshToken];
        resp.openid = [authDic objectForKey:kUMSocialAuthOpenID];
        
        if (platform == UMSocialPlatformType_QQ) {
            resp.uid = [authDic objectForKey:kUMSocialAuthOpenID];
        }
        if (platform == UMSocialPlatformType_QQ || platform == UMSocialPlatformType_WechatSession) {
            resp.usid = [authDic objectForKey:kUMSocialAuthOpenID];
        } else {
            resp.usid = [authDic objectForKey:kUMSocialAuthUID];
        }
        
        obj.response = resp;
    }
    return obj;
}

@end


@implementation LxOAuth

-(void)qq:(JSValue *)options
{
    NSLog(@"qq");
    UMSAuthInfo *authInfo = [UMSAuthInfo objectWithType:UMSocialPlatformType_QQ];
    [self authForPlatform:authInfo];
    
    callback = options[@"success"];
}

-(void)weixin:(JSValue *)options
{
    NSLog(@"weixin");
    UMSAuthInfo *authInfo = [UMSAuthInfo objectWithType:UMSocialPlatformType_WechatSession];
    [self authForPlatform:authInfo];
    
    callback = options[@"success"];
}

-(void)weibo:(JSValue *)options
{
    NSLog(@"weibo");
    UMSAuthInfo *authInfo = [UMSAuthInfo objectWithType:UMSocialPlatformType_Sina];
    [self authForPlatform:authInfo];
    
    callback = options[@"success"];
}

//-(void)setToken:(JSValue *)options
//{
//    
//}

- (void)authForPlatform:(UMSAuthInfo *)authInfo
{
    [[UMSocialManager defaultManager] authWithPlatform:authInfo.platform currentViewController:nil completion:^(id result, NSError *error) {

        NSString *message = nil;
            
        if (error) {
            message = @"Get info fail";
            UMSocialLogInfo(@"Get info fail with error %@",error);
        } else {
            
            if ([result isKindOfClass:[UMSocialAuthResponse class]]) {
                UMSocialAuthResponse * resp = result;
                
                UMSocialUserInfoResponse *userInfoResp = [[UMSocialUserInfoResponse alloc] init];
                userInfoResp.uid = resp.uid;
                userInfoResp.unionId = resp.unionId;
                userInfoResp.usid = resp.usid;
                userInfoResp.openid = resp.openid;
                userInfoResp.accessToken = resp.accessToken;
                userInfoResp.refreshToken = resp.refreshToken;
                userInfoResp.expiration = resp.expiration;
                authInfo.response = userInfoResp;
                
                OAuthModel *model = [OAuthModel new];
                model.uid = resp.uid;
                model.unionId = resp.unionId;
                model.usid = resp.usid;
                model.openid = resp.openid;
                model.accessToken = resp.accessToken;
//                model.refreshToken = resp.refreshToken;
                model.expiration = resp.expiration;
//                model.interfaceName = @"iOSTest";
//                model.deviceID = [[NSUUID UUID] UUIDString];
                
                NSDictionary *authResult = [Util entityToDictionary:model];
                message = [NSString stringWithFormat:@"%@",authResult];
                NSLog(@"%@",message);
                
//                [callback callWithArguments:@[authResult]];
                
                if (authInfo.platform == UMSocialPlatformType_QQ) {
                    
                }
                
                if (authInfo.platform == UMSocialPlatformType_WechatSession) {
                    
                }
                
                if (authInfo.platform == UMSocialPlatformType_Sina) {
                    
                }
                
                
            }else{
                message = @"Get info fail";
                UMSocialLogInfo(@"Get info fail with  unknow error");
            }
        }
        
        if (message) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Auth info"
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"sure", @"确定")
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
}

@end

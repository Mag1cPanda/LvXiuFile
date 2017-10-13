//
//  LxOAuth.h
//  LvXiu_iOS
//
//  Created by panshen on 2017/9/15.
//  Copyright © 2017年 panshen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UMSocialUIUtility.h>

@protocol LxOAuthExports <JSExport>

JSExportAs(qq,
           - (void)qq:(JSValue *)options);

JSExportAs(weixin,
           - (void)weixin:(JSValue *)options);

JSExportAs(weibo,
           - (void)weibo:(JSValue *)options);

//JSExportAs(setToken,
//           - (void)setToken:(JSValue *)options);

@end

@interface UMSAuthInfo : NSObject

@property (nonatomic, assign) UMSocialPlatformType platform;
@property (nonatomic, strong) UMSocialUserInfoResponse *response;

+ (instancetype)objectWithType:(UMSocialPlatformType)platform;

@end

@interface LxOAuth : NSObject <LxOAuthExports>
{
    JSValue *callback;
}
@end




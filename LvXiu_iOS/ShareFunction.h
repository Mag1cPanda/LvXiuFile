//
//  ShareFunction.h
//  LvXiu_iOS
//
//  Created by panshen on 2017/9/15.
//  Copyright © 2017年 panshen. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ShareFunction : NSObject

+(ShareFunction *)shareInstance;

/**
 分享标题
 */
@property (nonatomic, copy) NSString *titles;
/**
 分享描述
 */
@property (nonatomic, copy) NSString *content;
/**
 分享链接地址
 */
@property (nonatomic, copy) NSString *url;
/**
 分享缩略图（UIImage或者NSData类型，或者image_url）
 */
@property (nonatomic, copy) id iconImg;


/**
 友盟自带分享
 
 @param viewController 分享所在的Controller
 */
- (void)shareToController:(UIViewController *)viewController;

/**
 自定义分享UI 功能调起
 
 @param types 0 微信 1 朋友圈 2 QQ好友 3 QQ空间
 @param viewController 分享所在的Controller
 */
- (void)shareToPlatformType:(NSInteger)types ToController:(UIViewController *)viewController;
@end

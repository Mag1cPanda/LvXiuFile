//
//  ShareViewController.h
//  LvXiu_iOS
//
//  Created by panshen on 2017/10/9.
//  Copyright © 2017年 panshen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareViewController : UIViewController

/*------------------------- 分享内容 -----------------------------*/
/**
 分享标题
 */
@property (nonatomic, copy) NSString *shareTitle;
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
@property (nonatomic, copy) NSString *iconImg;

@end

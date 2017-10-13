//
//  UIImage+Extension.h
//  LvXiu_iOS
//
//  Created by panshen on 2017/9/21.
//  Copyright © 2017年 panshen. All rights reserved.
//

#import <UIKit/UIKit.h>

// 设置颜色
#define BXColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define BXAlphaColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

@interface UIImage (Extension)

/**
 *  用颜色返回一张图片
 */
+ (UIImage *)createImageWithColor:(UIColor*) color;

@end

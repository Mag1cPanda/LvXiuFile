//
//  UIImage+Extension.m
//  LvXiu_iOS
//
//  Created by panshen on 2017/9/21.
//  Copyright © 2017年 panshen. All rights reserved.
//

#import "UIImage+Extension.h"
#import <objc/message.h>

@implementation UIImage (Extension)

+ (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end

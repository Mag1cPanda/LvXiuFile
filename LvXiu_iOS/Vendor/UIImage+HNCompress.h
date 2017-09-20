//
//  UIImage+HNCompress.h
//  HnCarOwner
//
//  Created by panshen on 2017/7/22.
//  Copyright © 2017年 panshen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HNCompress)
+ (NSData *)zipImageWithImage:(UIImage *)image;

+ (UIImage *)compressImage:(UIImage *)image newWidth:(CGFloat)newImageWidth;

+ (NSString*)getImageBase64:(UIImage *) image;


+(UIImage *)getImageFromBase64:(NSString *)string;

@end

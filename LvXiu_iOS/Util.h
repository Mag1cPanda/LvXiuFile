//
//  Util.h
//  JSTestNew
//
//  Created by panshen on 2017/9/8.
//  Copyright © 2017年 panshen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Util : NSObject

+ (NSString *)encodeToBase64String:(UIImage *)image;

+ (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData;

+(NSString *)convertToJsonData:(NSDictionary *)dict;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
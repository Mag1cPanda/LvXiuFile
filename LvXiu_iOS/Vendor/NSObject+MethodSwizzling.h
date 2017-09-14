//
//  NSObject+MethodSwizzling.h
//  LvXiu_iOS
//
//  Created by panshen on 2017/9/13.
//  Copyright © 2017年 panshen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MethodSwizzling)

+ (BOOL)swizzleMethod:(SEL)origSelector withMethod:(SEL)newSelector;

@end

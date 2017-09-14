//
//  NSObject+MethodSwizzling.m
//  LvXiu_iOS
//
//  Created by panshen on 2017/9/13.
//  Copyright © 2017年 panshen. All rights reserved.
//

#import "NSObject+MethodSwizzling.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSObject (MethodSwizzling)

+ (BOOL)swizzleMethod:(SEL)origSelector withMethod:(SEL)newSelector
{
    Method origMethod = class_getInstanceMethod(self, origSelector);
    Method newMethod = class_getInstanceMethod(self, newSelector);
    
    if (origMethod && newMethod) {
        if (class_addMethod(self, origSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
            class_replaceMethod(self, newSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
        } else {
            method_exchangeImplementations(origMethod, newMethod);
        }
        return YES;
    }
    return NO;
}

@end

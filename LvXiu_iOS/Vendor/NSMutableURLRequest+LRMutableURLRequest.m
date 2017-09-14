//
//  NSMutableURLRequest+LRMutableURLRequest.m
//  LvXiu_iOS
//
//  Created by panshen on 2017/9/13.
//  Copyright © 2017年 panshen. All rights reserved.
//

#import "NSMutableURLRequest+LRMutableURLRequest.h"
#import "NSObject+MethodSwizzling.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSMutableURLRequest (LRMutableURLRequest)

- (void)newSetValue:(NSString *)value forHTTPHeaderField:(NSString *)field;
{
    if ([field isEqualToString:@"User-Agent"]) {
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *version = [infoDic objectForKey:@"CFBundleShortVersionString"];
        
        value = [value stringByAppendingString:[NSString stringWithFormat:@" LvXiu/iOS/%@",version]];
    }
    [self newSetValue:value forHTTPHeaderField:field];
}

+ (void)setupUserAgentOverwrite
{
    [self swizzleMethod:@selector(setValue:forHTTPHeaderField:)
             withMethod:@selector(newSetValue:forHTTPHeaderField:)];
}

@end

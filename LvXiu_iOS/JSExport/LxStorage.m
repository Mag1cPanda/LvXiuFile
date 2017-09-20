//
//  LxStorage.m
//  LvXiu_iOS
//
//  Created by panshen on 2017/9/15.
//  Copyright © 2017年 panshen. All rights reserved.
//

#import "LxStorage.h"
#import "Util.h"

@implementation LxStorage

- (instancetype)init
{
    self = [super init];
    if (self) {
        _data = [NSMutableDictionary dictionary];
    }
    return self;
}

-(NSString *)read:(JSValue *)options
{
    NSLog(@"read");
    
    if ([_data isEqualToDictionary:@{}]) {
        return @"";
    }
    
    else {
        return [Util convertToJsonData:_data];
    }
    
}

-(BOOL)write:(JSValue *)options
{
    NSLog(@"write");
    
    NSString *group = [self.webView stringByEvaluatingJavaScriptFromString:@"$('#storageGroup').val();"];
    
    NSString *key = [self.webView stringByEvaluatingJavaScriptFromString:@"$('#storageKey').val();"];
    
    NSString *value = [self.webView stringByEvaluatingJavaScriptFromString:@"$('#storageValue').val();"];
    
    [_data setObject:group forKey:@"group"];
    
    [_data setObject:key forKey:@"key"];
    
    [_data setObject:value forKey:@"value"];
    
    
    return true;
}

-(BOOL)delete:(JSValue *)options
{
    NSLog(@"delete");
    
    [_data removeObjectForKey:@"group"];
    
    [_data removeObjectForKey:@"key"];
    
    [_data removeObjectForKey:@"value"];
    
    return true;
}

-(NSArray *)getKeys:(JSValue *)options
{
    NSLog(@"getKeys");

    NSString *key = [_data objectForKey:@"key"];
    
    if (key) {
        return @[key];
    }
    
    else {
        return @[];
    }
    
}



@end

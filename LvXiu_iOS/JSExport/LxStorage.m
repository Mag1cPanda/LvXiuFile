//
//  LxStorage.m
//  LvXiu_iOS
//
//  Created by panshen on 2017/9/15.
//  Copyright © 2017年 panshen. All rights reserved.
//

#import "LxStorage.h"

@implementation LxStorage

- (instancetype)init
{
    self = [super init];
    if (self) {
        _groups = [NSMutableArray array];
    }
    return self;
}

-(BOOL)read:(JSValue *)options
{
    NSLog(@"read");
    
    return true;
}

-(BOOL)write:(JSValue *)options
{
    NSLog(@"write");
    
    NSString *key = [self.webView stringByEvaluatingJavaScriptFromString:@"$('#storageKey').val();"];
    
    
    return true;
}

-(BOOL)delete:(JSValue *)options
{
    NSLog(@"delete");
    
    NSString *key = [self.webView stringByEvaluatingJavaScriptFromString:@"$('#storageKey').val();"];
    
    return true;
}

-(NSArray *)getKeys:(JSValue *)options
{
    NSLog(@"getKeys");
    
    NSString *group = [self.webView stringByEvaluatingJavaScriptFromString:@"$('#storageGroup').val();"];
    
    return @[@"1",@"2"];
}



@end

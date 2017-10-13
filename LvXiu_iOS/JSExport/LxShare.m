//
//  LxShare.m
//  LvXiu_iOS
//
//  Created by panshen on 2017/9/15.
//  Copyright © 2017年 panshen. All rights reserved.
//

#import "LxShare.h"
#import "ShareViewController.h"

@implementation LxShare

#pragma mark - LxShareExports

-(void)link:(JSValue *)options
{
    NSString *title = [[options valueForProperty:@"title"] toString];
    NSString *link = [[options valueForProperty:@"link"] toString];
    NSString *imgUrl = [[options valueForProperty:@"imgUrl"] toString];
    NSString *desc = [[options valueForProperty:@"desc"] toString];
    
//    callback = [options valueForProperty:@"success"];
    
    ShareViewController *vc = [[ShareViewController alloc] init];
    vc.shareTitle = title;
    vc.url = link;
    vc.iconImg = imgUrl;
    vc.content = desc;
    
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        UINavigationController *rootViewController = (UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
        [rootViewController pushViewController:vc animated:YES];
    });

}

@end

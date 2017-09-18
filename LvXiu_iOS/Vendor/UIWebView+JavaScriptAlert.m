//
//  UIWebView+JavaScriptAlert.m
//  TestWebView
//
//  Created by panshen on 2017/9/14.
//  Copyright © 2017年 panshen. All rights reserved.
//

#import "UIWebView+JavaScriptAlert.h"



@implementation UIWebView (JavaScriptAlert)

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect *)frame {
    
    UIAlertView* customAlert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [customAlert show];
    
    
}


@end

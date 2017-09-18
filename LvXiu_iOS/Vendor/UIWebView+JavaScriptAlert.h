//
//  UIWebView+JavaScriptAlert.h
//  TestWebView
//
//  Created by panshen on 2017/9/14.
//  Copyright © 2017年 panshen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (JavaScriptAlert)

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect *)frame;

@end

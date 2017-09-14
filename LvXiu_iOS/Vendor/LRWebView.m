//
//  LRWebView.m
//  LvXiu_iOS
//
//  Created by panshen on 2017/9/13.
//  Copyright © 2017年 panshen. All rights reserved.
//

#import "LRWebView.h"

@implementation LRWebView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
   
}

@end

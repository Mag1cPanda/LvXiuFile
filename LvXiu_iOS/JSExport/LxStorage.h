//
//  LxStorage.h
//  LvXiu_iOS
//
//  Created by panshen on 2017/9/15.
//  Copyright © 2017年 panshen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <UIKit/UIKit.h>

@class LxStorage;

@protocol LxStorageExports <JSExport>

JSExportAs(read,
           - (BOOL)read:(JSValue *)options);

JSExportAs(write,
           - (BOOL)write:(JSValue *)options);

JSExportAs(delete,
           - (BOOL)delete:(JSValue *)options);

JSExportAs(getKeys,
           - (NSArray *)getKeys:(JSValue *)options);

@end

@interface LxStorage : NSObject
<LxStorageExports>

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, copy) NSMutableArray *groups;

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *value;

@end

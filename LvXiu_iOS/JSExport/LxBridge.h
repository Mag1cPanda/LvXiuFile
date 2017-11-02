//
//  LxBridge.h
//  LvXiu_iOS
//
//  Created by panshen on 2017/9/15.
//  Copyright © 2017年 panshen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <objc/runtime.h>
#import <objc/message.h>

@protocol LxBridgeExports <JSExport>

JSExportAs(callbacks,
           - (void)callbacks:(JSValue *)options);

JSExportAs(call,
           - (void)call:(JSValue *)options);

JSExportAs(callObject,
           - (void)callObject:(JSValue *)options);

JSExportAs(callStr,
           - (void)callStr:(JSValue *)options);

JSExportAs(callInt,
           - (void)callInt:(JSValue *)options);

JSExportAs(callDouble,
           - (void)callDouble:(JSValue *)options);

JSExportAs(receiveAsync,
           - (void)receiveAsync:(JSValue *)options);

@end

@interface LxBridge : NSObject <LxBridgeExports>

@end

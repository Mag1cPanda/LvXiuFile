//
//  LxShare.h
//  LvXiu_iOS
//
//  Created by panshen on 2017/9/15.
//  Copyright © 2017年 panshen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol LxShareExports <JSExport>

JSExportAs(link,
           - (void)link:(JSValue *)options);

@end

@interface LxShare : NSObject <LxShareExports>
{
    JSValue *callback;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *desc;

@end

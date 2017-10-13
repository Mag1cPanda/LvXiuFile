//
//  LxVersion.h
//  LvXiu_iOS
//
//  Created by panshen on 2017/10/11.
//  Copyright © 2017年 panshen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol LxVersionExports <JSExport>

JSExportAs(isApp,
           - (BOOL)isApp:(JSValue *)options);

@end

@interface LxVersion : NSObject<LxVersionExports>


@end

//
//  LvXiu.h
//  JSTestNew
//
//  Created by panshen on 2017/9/7.
//  Copyright © 2017年 panshen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <UIKit/UIKit.h>
#import "TZImagePickerController.h"

@class LvXiu;

@protocol LvXiuExports <JSExport>

JSExportAs(chooseImage,
           - (void)chooseImage:(NSDictionary *)options);

JSExportAs(parseApiUrl,
           - (void)parseApiUrl:(NSDictionary *)result);

@end

@interface LvXiu : NSObject
<LvXiuExports,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
TZImagePickerControllerDelegate>
{
    JSValue *callback;
}

@property (nonatomic, strong) TZImagePickerController *picker;

@end

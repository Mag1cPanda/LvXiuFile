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
#import <CoreLocation/CoreLocation.h>
#import "LvXiuViewController.h"

@class LvXiu;

@protocol LvXiuExports <JSExport>

JSExportAs(chooseImage,
           - (void)chooseImage:(JSValue *)options);

JSExportAs(getImage,
           - (NSString *)getImage:(NSString *)fileID);

JSExportAs(getImageExif,
           - (NSString *)getImageExif:(NSString *)fileID);

JSExportAs(getDeviceID,
           - (NSString *)getDeviceID:(NSString *)deviceID);

JSExportAs(hapticFeedback,
           - (void)hapticFeedback:(JSValue *)options);

JSExportAs(getLocation,
           - (void)getLocation:(JSValue *)options);

JSExportAs(parseApiUrl,
           - (NSString *)parseApiUrl:(JSValue *)options);

JSExportAs(setActionBar,
           - (void)setActionBar:(JSValue *)options);

JSExportAs(openWindow,
           - (void)openWindow:(JSValue *)options);

JSExportAs(openWindowWithData,
           - (void)openWindowWithData:(JSValue *)options);

@end

@interface LvXiu : NSObject
<LvXiuExports,
UINavigationControllerDelegate,
TZImagePickerControllerDelegate,
CLLocationManagerDelegate>
{
    JSValue *callback;
    
    JSValue *titleCallBack;
    
    JSValue *gpsCallBack;
    
    NSMutableArray *images;
    id webData;
    
    NSArray *actionsArr;
    
    NSInteger locationTimes;
}

@property (nonatomic, strong) TZImagePickerController *picker;

@property (nonatomic, strong) CLLocationManager *locationM;

@property (nonatomic, copy) NSString *URL;

@property (nonatomic, strong) LvXiuViewController *vc;

@end

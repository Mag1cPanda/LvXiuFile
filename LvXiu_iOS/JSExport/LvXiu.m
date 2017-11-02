//
//  LvXiu.m
//  JSTestNew
//
//  Created by panshen on 2017/9/7.
//  Copyright © 2017年 panshen. All rights reserved.
//

#import "LvXiu.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "Util.h"
#import "UIImage+HNCompress.h"
#import <AudioToolbox/AudioToolbox.h>
#import "AFNetworking.h"
#import "Masonry.h"
#import "PopoverView.h"
#import "LvXiuViewController.h"
#import <UMSocialCore/UMSocialCore.h>

@implementation LvXiu


- (instancetype)init
{
    self = [super init];
    if (self) {
        images = [NSMutableArray array];
        locationTimes = 0;
        [self loadData];
    }
    return self;
}


#pragma mark - TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    
    for (NSInteger i=0; i<photos.count; i++) {
        UIImage *image = photos[i];
        
        //写入到沙盒
        NSString *docsPath = [NSTemporaryDirectory() stringByStandardizingPath];
        NSString *tempFile = [NSString stringWithFormat:@"%@/PHOTO_%@.png", docsPath, [[NSUUID UUID] UUIDString]];
        [UIImagePNGRepresentation(image) writeToFile:tempFile atomically:YES];
        
        //加入到图片数组
        NSString *imgStr =[UIImage getImageBase64:image];
        NSDictionary *dic = @{@"fileID":imgStr, @"fileType":@"png"};
        [images addObject:dic];
    }
    
    NSDictionary *imgsDic = @{@"images":images};
    
    [callback callWithArguments:@[imgsDic]];
    
}


- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    NSLog(@"cancel");
}

#pragma mark - LvXiuExports
-(void)chooseImage:(JSValue *)options {
    
    NSString *maxCount = [[options valueForProperty:@"count"] toString];
    
    callback = [options valueForProperty:@"success"];
    
    NSLog(@"success ~ %@",callback);
    
    _picker = [[TZImagePickerController alloc] initWithMaxImagesCount:[maxCount integerValue] columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    _picker.delegate = self;
    
    
    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [rootViewController presentViewController:_picker animated:YES completion:nil];
}


-(NSString *)getImage:(NSString *)fileID
{
    return fileID;
}

-(NSString *)getImageExif:(NSString *)fileID{
    return fileID;
}

-(NSString *)getDeviceID:(NSString *)deviceID
{
    return [[NSUUID UUID] UUIDString];
}

-(NSString *)parseApiUrl:(JSValue *)options
{
    NSLog(@"URLSuffix ~ %@",options);
//    [_vc.webView ]
    NSString *suffix = [options toString];
    if (suffix.length > 0) {
        return [NSString stringWithFormat:@"http://webtest.lvxiu.96007.cc/%@",suffix];
    }

    else {
        return @"http://webtest.lvxiu.96007.cc/";
    }
}



-(void)hapticFeedback:(JSValue *)options
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

-(void)getLocation:(JSValue *)options
{
    gpsCallBack = [options valueForProperty:@"success"];
    NSLog(@"success ~ %@",gpsCallBack);
    
    locationTimes = 0;
    
    [self locate];
    
}

-(void)setActionBar:(JSValue *)options
{
    
    JSValue *rightButtonTitle = [options valueForProperty:@"rightButtonTitle"];
    
    JSValue *title = [options valueForProperty:@"title"];
    
    JSValue *backgroundColor = [options valueForProperty:@"backgroundColor"];
    
//    BOOL isShowRightButton = [[options valueForProperty:@"showRightButton"] toBool];
    
    JSValue *isShowReturnButton = [options valueForProperty:@"showReturnButton"];
    
    JSValue *mode = [options valueForProperty:@"mode"];
    
    JSValue *menus = [options valueForProperty:@"menus"];
    
    JSValue *titleClick = [options valueForProperty:@"titleClick"];
    
    JSValue *rightImage = [options valueForProperty:@"rightImage"];
    
    JSValue *icon = [options valueForProperty:@"icon"];
    
    NSLog(@"menus ~ %@",menus);
    
    //获取undefinedValue
    JSContext *ctx = [_vc.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    JSValue *undefinedValue = [JSValue valueWithUndefinedInContext:ctx];
    
    
    if (![backgroundColor isEqualToObject:undefinedValue]) {
        _vc.navigationController.navigationBar.backgroundColor = [UIColor colorWithHexString:[backgroundColor toString]];
        JSValue *tmpValue = [options valueForProperty:@"rightButtonClick"];
        
        callback = tmpValue;
    }
    
    if (![rightImage isEqualToObject:undefinedValue]) {
        
//        UIImage *tmpImg = [UIImage getImageFromBase64:[rightImage toString]];
//        tmpImg = [UIImage compressImage:tmpImg newWidth:20];
//        
//        [_vc.rightBtn setImage:tmpImg forState:0];
    }
    
    if (![title isEqualToObject:undefinedValue]) {
        [_vc.titleView setTitle:[title toString]forState:0];
    }
    
    if (![icon isEqualToObject:undefinedValue]) {
        
        UIImage *imgIcon = [UIImage getImageFromBase64:[icon toString]];
        imgIcon = [UIImage compressImage:imgIcon newWidth:20];
        
        [_vc.titleView setImage:imgIcon forState:0];
    }
    
    if (![titleClick isEqualToObject:undefinedValue]) {
        titleCallBack = titleClick;
        [_vc.titleView addTarget:self action:@selector(titleBtnClicked) forControlEvents:1<<6];
        
    }
    
    
//    if (!isShowRightButton) {
//        _vc.rightBtn.hidden = true;
//    }
    
    if (!![isShowReturnButton isEqualToObject:undefinedValue]) {
        _vc.backBtn.hidden = true;
    }
    
    if (rightButtonTitle) {
//        [_vc.rightBtn setTitle:title forState:0];
        [_vc.rightBtn addTarget:self action:@selector(commitBtnClicked) forControlEvents:1<<6];
    }
    
    
    if ([[mode toString] isEqualToString:@"fullscreen"]) {
        _vc.navigationController.navigationBar.hidden = true;
        
        _vc.webView.frame = [UIScreen mainScreen].bounds;
    }
    
    else {
        _vc.navigationController.navigationBar.hidden = false;
        
        _vc.webView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight-64);
    }
    
    
    if (menus) {
        
        JSValue *test1 = [menus valueForProperty:@"test1"];
        NSString *color1 = [[test1 valueForProperty:@"color"] toString];
        
        NSString *title1 = [[test1 valueForProperty:@"title"] toString];
        NSString *icon1 = [[test1 valueForProperty:@"icon"] toString];
        JSValue *callback1 = [test1 valueForProperty:@"callback"];
        
        UIImage *image1 = [UIImage getImageFromBase64:icon1];
        image1 = [UIImage compressImage:image1 newWidth:20];
        
        PopoverAction *action1 = [PopoverAction actionWithImage:image1 title:title1 color:[UIColor colorWithHexString:color1] handler:^(PopoverAction *action) {
           
            [callback1 callWithArguments:nil];
            
        }];
        
        
        JSValue *test2 = [menus valueForProperty:@"test2"];
        NSString *title2 = [[test2 valueForProperty:@"title"] toString];
        NSString *icon2 = [[test2 valueForProperty:@"icon"] toString];
        JSValue *callback2 = [test2 valueForProperty:@"callback"];
        
        UIImage *image2 = [UIImage getImageFromBase64:icon2];
        image2 = [UIImage compressImage:image2 newWidth:20];
        
        PopoverAction *action2 = [PopoverAction actionWithImage:image2 title:title2 handler:^(PopoverAction *action) {
            
            [callback2 callWithArguments:nil];
            
        }];
        
        JSValue *test3 = [menus valueForProperty:@"test3"];
        NSString *title3 = [[test3 valueForProperty:@"title"] toString];
        NSString *icon3 = [[test3 valueForProperty:@"icon"] toString];
        JSValue *callback3 = [test3 valueForProperty:@"callback"];
        
        UIImage *image3 = [UIImage getImageFromBase64:icon3];
        image3 = [UIImage compressImage:image3 newWidth:20];
        
        PopoverAction *action3 = [PopoverAction actionWithImage:image3 title:title3 handler:^(PopoverAction *action) {
            
            [callback3 callWithArguments:nil];
            
        }];
        
        actionsArr = @[action1,action2,action3];
        
        
        if (![menus isEqualToObject:undefinedValue]) {
            [_vc.rightBtn addTarget:self action:@selector(menusBtnClicked) forControlEvents:1<<6];
        }
        
    }
    
}

-(void)menusBtnClicked
{
    PopoverView *popoverView = [PopoverView popoverView];
    [popoverView showToView:_vc.rightBtn withActions:actionsArr];
}


-(void)openWindow:(JSValue *)options
{
    [_vc openWindow];
}

-(void)openWindowWithData:(JSValue *)options
{
    NSDictionary *data = [[options valueForProperty:@"data"] toDictionary];
    NSLog(@"%@",data);
    
    [_vc openWindowWithData:data];
}


#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error ~ %@",error.description);
    
//    if (error.code == kCLErrorDenied)
//    {
//        NSLog(@"访问被拒绝");
//    }
//    if (error.code == kCLErrorLocationUnknown) {
//        NSLog(@"无法获取位置信息");
//    }
}

-(void)locationManager:(nonnull CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations
{
    locationTimes ++;
    
    if (locationTimes > 1) {
        return;
    }
    
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    
    NSLog(@"每当请求到位置信息时, 都会调用此方法");
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //NSLog(@%@,placemark.name);//具体位置
             //获取城市
             NSString *city = placemark.locality;
             if (!city) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
             
             NSLog(@"定位完成:%@",city);
             
             if (currentLocation.horizontalAccuracy > 0) {//已经定位成功了
                 [manager stopUpdatingLocation];
                 
             }
             
             NSString *latitude = [NSString stringWithFormat:@"%.6f",currentLocation.coordinate.latitude];
             
             NSString *longitude = [NSString stringWithFormat:@"%.6f",currentLocation.coordinate.longitude];
             
             NSLog(@"latitude:%@ longitude:%@",latitude,longitude);
             
             [gpsCallBack callWithArguments:@[@{@"latitude":latitude, @"longitude":longitude}]];
         }
         
         else if (error == nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }
         
         else if (error != nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
     }];
}

#pragma mark - Private Method
- (void)locate{
    
    NSLog(@"locate");
    
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled]) {
        //定位初始化
        self.locationM = [[CLLocationManager alloc] init];
        self.locationM.delegate = self;
        self.locationM.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationM.distanceFilter = 10;
        if (iOS8Later) {
            //iOS8及以上添加这句
            [self.locationM requestWhenInUseAuthorization];
        }
        [self.locationM startUpdatingLocation];//开启定位
    }else {
        //提示用户无法进行定位操作
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位不成功 ,请确认开启定位" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

-(void)loadData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *URL = @"http://test.lvxiu.96007.cc";
    
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
        
    }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSLog(@"%@",responseObject);
             webData = responseObject;
             
         }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             
             NSLog(@"%@",error);  //这里打印错误信息
             webData = error.description;
         }];
}

-(void)commitBtnClicked
{
    [callback callWithArguments:nil];
}

-(void)titleBtnClicked
{
    [titleCallBack callWithArguments:nil];
}


- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"欢迎使用【友盟+】社会化组件U-Share" descr:@"欢迎使用【友盟+】社会化组件U-Share，SDK包最小，集成成本最低，助力您的产品开发、运营与推广！" thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = @"http://mobile.umeng.com/social";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //    UMSocialPlatformType
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_Sina messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}





@end

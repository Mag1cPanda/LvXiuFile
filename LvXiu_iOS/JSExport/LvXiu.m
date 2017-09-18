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

@implementation LvXiu


- (instancetype)init
{
    self = [super init];
    if (self) {
        images = [NSMutableArray array];
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


/// User click cancel button
/// 用户点击了取消
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
//    NSString *json = [Util convertToJsonData:webData];
//    
//    if (json.length > 0) {
//        return json;
//    }
//    
//    else {
//        return webData;
//    }
    
    return _URL;
    
}



-(void)hapticFeedback:(JSValue *)options
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

-(void)getLocation:(JSValue *)options
{
    callback = [options valueForProperty:@"success"];
    NSLog(@"success ~ %@",callback);
    
    [self locate];
    
}


#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(nonnull CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations
{
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    
    //    NSTimeInterval locationAge = [currentLocation.timestamp timeIntervalSinceNow];
    //    if (locationAge > 1.0){//如果调用已经一次，不再执行
    //        return;
    //    }
    
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
             //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
             [manager stopUpdatingLocation];
             
             NSString *latitude = [NSString stringWithFormat:@"%.6f",currentLocation.coordinate.latitude];
             
             NSString *longitude = [NSString stringWithFormat:@"%.6f",currentLocation.coordinate.longitude];
             
             [callback callWithArguments:@[@{@"latitude":latitude, @"longitude":longitude}]];
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
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled]) {
        //定位初始化
        self.locationM = [[CLLocationManager alloc] init];
        self.locationM.delegate = self;
        self.locationM.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationM.distanceFilter = 10;
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



@end

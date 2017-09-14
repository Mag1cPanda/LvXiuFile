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
#import "ChooseImageOut.h"
#import "ImageItem.h"
#import "Util.h"

@implementation LvXiu

-(void)chooseImage:(NSDictionary *)options {

    
    NSInteger maxCount = [options[@"count"] integerValue];
    
    callback = options[@"success"] ;
    
//    NSLog(@"success ~ %@",options[@"success"]);
    
    _picker = [[TZImagePickerController alloc] initWithMaxImagesCount:maxCount columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    _picker.delegate = self;
    
    
    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [rootViewController presentViewController:_picker animated:YES completion:nil];
}


- (void)closePicker
{
    [_picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
//    
//    // Write to the temp directory
//    NSString *docsPath = [NSTemporaryDirectory() stringByStandardizingPath];
//    NSString *tempFile = [NSString stringWithFormat:@"%@/PHOTO_%@.png", docsPath, [[NSUUID UUID] UUIDString]];
//    [UIImagePNGRepresentation(image) writeToFile:tempFile atomically:YES];
//    
//    // Return imageURI
//    [callback callWithArguments:@[[[NSURL fileURLWithPath:tempFile] absoluteString]]];
//    
//    [self closePicker];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
//    [callback callWithArguments:@[@"error"]];
//    [self closePicker];
}


#pragma mark - TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    UIImage *image = photos[0];
    
    // Write to the temp directory
    NSString *docsPath = [NSTemporaryDirectory() stringByStandardizingPath];
    NSString *tempFile = [NSString stringWithFormat:@"%@/PHOTO_%@.png", docsPath, [[NSUUID UUID] UUIDString]];
    [UIImagePNGRepresentation(image) writeToFile:tempFile atomically:YES];
    
    //        NSString *imgURL = [[NSURL fileURLWithPath:tempFile] absoluteString];
    
    //        ChooseImageOut *cio = [ChooseImageOut new];
    
    //        NSString *imgStr = [Util encodeToBase64String:image];
    
    //        ImageItem *item = [ImageItem itmeWithFileID:imgStr fileType:@"png"];
    
    //        cio.images = @[item];
    
    // Return imageURI
    
    NSString *imgStr = [Util encodeToBase64String:image];
    
    NSDictionary *dic = @{@"images":@[@{@"fileID":imgStr, @"fileType":@"png"}]};
    
//    NSString *json = [Util convertToJsonData:dic];
    
//    NSArray *arr = [NSArray arrayWithObjects:@"success",json,nil];
    
//    [callback callWithArguments:arr];
    

    if (iOS8Later) {
        for (PHAsset *phAsset in assets) {
            NSLog(@"location:%@",phAsset);
        }
    }
}


/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
     NSLog(@"cancel");
}




#pragma mark - 处理接口地址
- (void)parseApiUrl:(NSDictionary *)result
{
    // 1.创建一个网络路径
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://test.lvxiu.96007.cc/Member/OpenLogin/qqCallback"]];
    // 2.创建一个网络请求
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务：
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"从服务器获取到数据");
        /*
         对从服务器获取到的数据data进行相应的处理：
         */
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
        
        NSLog(@"%@",dict);
    }];
    // 5.最后一步，执行任务（resume也是继续执行）:
    [sessionDataTask resume];
}

@end

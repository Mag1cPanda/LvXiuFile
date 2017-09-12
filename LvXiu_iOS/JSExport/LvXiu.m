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

+ (BOOL)isSourceTypeAvailable:(NSString *)sourceType
{
    if (![sourceType isEqualToString:@"PhotoLibrary"] && ![sourceType isEqualToString:@"SavedPhotoAlbum"] && ![sourceType isEqualToString:@"Camera"]) {
        return NO;
    }
    
    UIImagePickerControllerSourceType sourceTypeClass = [self getSourceTypeClass:sourceType];
    if (![UIImagePickerController isSourceTypeAvailable:sourceTypeClass]) {
        return NO;
    }
    return YES;
}

+ (UIImagePickerControllerSourceType)getSourceTypeClass:(NSString *)sourceType
{
    if( [sourceType isEqualToString:@"PhotoLibrary"] ) {
        return UIImagePickerControllerSourceTypePhotoLibrary;
    } else if( [sourceType isEqualToString:@"SavedPhotosAlbum"] ) {
        return UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    } else if( [sourceType isEqualToString:@"Camera"] ) {
        return UIImagePickerControllerSourceTypeCamera;
    }
    return UIImagePickerControllerSourceTypePhotoLibrary;
}



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
    
    NSString *json = [Util convertToJsonData:dic];
    
    NSArray *arr = [NSArray arrayWithObjects:@"success",json,nil];
    
    [callback callWithArguments:arr];
    

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

@end

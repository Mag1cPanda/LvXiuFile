//
//  ImageItem.m
//  JSTestNew
//
//  Created by panshen on 2017/9/8.
//  Copyright © 2017年 panshen. All rights reserved.
//

#import "ImageItem.h"

@implementation ImageItem

+(instancetype)itmeWithFileID:(NSString *)fileID fileType:(NSString *)fileType
{
    ImageItem *item = [ImageItem new];
    item.fileID = fileID;
    item.fileType = fileType;
    return item;
}


@end

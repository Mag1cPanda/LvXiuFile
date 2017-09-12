//
//  ImageItem.h
//  JSTestNew
//
//  Created by panshen on 2017/9/8.
//  Copyright © 2017年 panshen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageItem : NSObject

@property (nonatomic, copy) NSString *fileID;
@property (nonatomic, copy) NSString *fileType;

+(instancetype)itmeWithFileID:(NSString *)fileID fileType:(NSString *)fileType;

@end

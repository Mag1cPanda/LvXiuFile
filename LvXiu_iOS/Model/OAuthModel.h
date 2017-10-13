//
//  OAuthModel.h
//  LvXiu_iOS
//
//  Created by panshen on 2017/10/12.
//  Copyright © 2017年 panshen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OAuthModel : NSObject

@property (nonatomic, copy) NSString  *uid;
@property (nonatomic, copy) NSString  *openid;
@property (nonatomic, copy) NSString  *refreshToken;
@property (nonatomic, strong) NSDate  *expiration;
@property (nonatomic, copy) NSString  *accessToken;
@property (nonatomic, copy) NSString  *usid;
@property (nonatomic, copy) NSString  *unionId;

@end

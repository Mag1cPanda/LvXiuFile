//
//  OAuthModel.m
//  LvXiu_iOS
//
//  Created by panshen on 2017/10/12.
//  Copyright © 2017年 panshen. All rights reserved.
//

#import "OAuthModel.h"

@implementation OAuthModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"forUndefinedKey -> %@",key);
}

-(instancetype)initWithDict:(NSDictionary *)dic
{
    [self setValuesForKeysWithDictionary:dic];
    return self;
}

+(instancetype)modelWithDict:(NSDictionary *)dic
{
    return [[self alloc] initWithDict:dic];
}


@end

//
//  MinMusic.m
//  myQQMusic
//
//  Created by 罗贤民 on 16/6/30.
//  Copyright © 2016年 罗贤民. All rights reserved.
//

#import "MinMusic.h"

@implementation MinMusic
-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}


+(instancetype)musicWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}

@end

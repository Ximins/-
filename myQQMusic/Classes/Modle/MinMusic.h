//
//  MinMusic.h
//  myQQMusic
//
//  Created by 罗贤民 on 16/6/30.
//  Copyright © 2016年 罗贤民. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MinMusic : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *filename;
@property (nonatomic, copy) NSString *lrcname;
@property (nonatomic, copy) NSString *singer;
@property (nonatomic, copy) NSString *singerIcon;
@property (nonatomic, copy) NSString *icon;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)musicWithDict:(NSDictionary *)dict;

@end

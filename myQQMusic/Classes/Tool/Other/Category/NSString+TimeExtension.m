//
//  NSString+TimeExtension.m
//  myQQMusic
//
//  Created by 罗贤民 on 16/6/30.
//  Copyright © 2016年 罗贤民. All rights reserved.
//

#import "NSString+TimeExtension.h"

@implementation NSString (TimeExtension)

+ (NSString *)stringWithTime:(NSTimeInterval)time
{
    //1.获取分钟和秒钟
    NSInteger minute = time / 60 ;
    NSInteger second = (NSInteger)time % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld",minute,second];
    
    
}

@end

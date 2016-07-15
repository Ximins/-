//
//  MinMusicTool.h
//  myQQMusic
//
//  Created by 罗贤民 on 16/6/30.
//  Copyright © 2016年 罗贤民. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MinMusic;


@interface MinMusicTool : NSObject


// 获取所有的音乐数据
+ (NSArray *)musics;

+ (void)setPlayingMusic:(MinMusic *)playingMusic;

+ (MinMusic *)playingMusic;

+ (MinMusic *)nextMusic;

+ (MinMusic *)previousMusic;

@end

//
//  MinMusicTool.m
//  myQQMusic
//
//  Created by 罗贤民 on 16/6/30.
//  Copyright © 2016年 罗贤民. All rights reserved.
//

#import "MinMusicTool.h"
#import "MinMusic.h"

@implementation MinMusicTool
static NSArray *_musics;
static MinMusic *_playingMusic;

+ (void)initialize
{
    // 1.读取文件
    NSString *musicsPath = [[NSBundle mainBundle] pathForResource:@"Musics.plist" ofType:nil];
    
    // 2.将数据加载到数组中
    NSArray *musics = [NSArray arrayWithContentsOfFile:musicsPath];
    
    // 3.遍历数组,将字典转成模型
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *dict in musics) {
        MinMusic *music = [MinMusic musicWithDict:dict];
        [tempArray addObject:music];
    }
    
    _musics = tempArray;
    
    _playingMusic = _musics[2];
}

+ (NSArray *)musics
{
    return _musics;
}

+ (void)setPlayingMusic:(MinMusic *)playingMusic
{
    _playingMusic = playingMusic;
}

+ (MinMusic *)playingMusic;
{
    return _playingMusic;
}

+ (MinMusic *)nextMusic
{
    // 1.获取当前歌曲的下标值
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    
    // 2.获取下一首歌曲的下标值
    NSInteger nextIndex = ++currentIndex;
    if (nextIndex >= _musics.count) {
        nextIndex = 0;
    }
    
    // 3.获取下一首歌曲
    MinMusic *nextMusic = _musics[nextIndex];
    
    return nextMusic;
}

+ (MinMusic *)previousMusic
{
    // 1.获取当前歌曲的下标值
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    
    // 2.获取上一首歌曲的下标值
    NSInteger previousIndex = --currentIndex;
    if (previousIndex < 0) {
        previousIndex = _musics.count - 1;
    }
    
    // 3.获取上一首歌曲
    MinMusic *previousMusic = self.musics[previousIndex];
    
    return previousMusic;
}
@end

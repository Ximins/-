//
//  MinAudioTool.h
//  myQQMusic
//
//  Created by 罗贤民 on 16/6/30.
//  Copyright © 2016年 罗贤民. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@interface MinAudioTool : NSObject

+ (void)playSoundWithName:(NSString *)soundName;

+ (AVAudioPlayer *)playMusicWithName:(NSString *)musicName;

+ (void)pauseMusicWithName:(NSString *)musicName;

+ (void)stopMusicWithName:(NSString *)musicName;
@end

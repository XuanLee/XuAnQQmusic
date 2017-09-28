//
//  LXAudioTool.h
//  QQMusic
//
//  Created by lx on 2017/9/16.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface LXAudioTool : NSObject
// 播放音乐 fileName:音乐文件
+ (AVAudioPlayer *)playMusicWithFileName:(NSString *)fileName;

// 暂停音乐 fileName:音乐文件
+ (void)pauseMusicWithFileName:(NSString *)fileName;

// 停止音乐 fileName:音乐文件
+ (void)stopMusicWithFileName:(NSString *)fileName;

// 播放音效 soundName:音效文件
+ (void)playSoundWithSoundName:(NSString *)soundName;
@end

//
//  LXMusicTool.h
//  QQMusic
//
//  Created by lx on 2017/9/16.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LXMusic;
@interface LXMusicTool : NSObject
// 所有音乐
+ (NSArray *)musics;

// 当前正在播放的音乐
+ (LXMusic *)playingMusic;

// 设置默认的音乐
+ (void)setupPlayingMusic:(LXMusic *)playingMusic;

// 返回上一首音乐
+(LXMusic *)previousMusic;

// 返回下一首音乐
+ (LXMusic *)nextMusic;
@end

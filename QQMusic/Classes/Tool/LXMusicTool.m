//
//  LXMusicTool.m
//  QQMusic
//
//  Created by lx on 2017/9/16.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import "LXMusicTool.h"
#import "LXMusic.h"
#import "MJExtension.h"
@implementation LXMusicTool


static NSArray *_musics;
static LXMusic *_playingMusic;

+(void)initialize{
    if(_musics==nil){
        _musics=[LXMusic objectArrayWithFilename:@"Musics.plist"];
    }
    if(_playingMusic==nil){
        _playingMusic=_musics[1];
    }
    
}
//类第一次运行时调用
//+(void)load{
//    if(_musics==nil){
//        _musics=[LXMusic objectArrayWithFilename:@"Musics.plist"];
//    }
//    if(_playingMusic==nil){
//        _playingMusic=_musics[1];
//    }
//}

// 所有音乐
+ (NSArray *)musics{
    return _musics;
    
}

// 当前正在播放的音乐
+ (LXMusic *)playingMusic{
    return _playingMusic;
    
}

// 设置默认的音乐
+ (void)setupPlayingMusic:(LXMusic *)playingMusic{
    
    _playingMusic = playingMusic;

}

// 返回上一首音乐
+(LXMusic *)previousMusic{

    //1.获取当前音乐的下标值
    NSInteger currentIndex=(NSInteger)[_musics indexOfObject:_playingMusic];
    
    //2 获取上一首音乐的下标值
    NSUInteger previousIndex=--currentIndex;
    
    LXMusic *previousMusic = nil;

    if(previousIndex<=0){
        previousIndex=_musics.count-1;
    }
    
    previousMusic =_musics[previousIndex];
    
    return previousMusic;
}

// 返回下一首音乐
+ (LXMusic *)nextMusic{
    //1.获取当前音乐的下标值
    NSInteger currentIndex=(NSInteger)[_musics indexOfObject:_playingMusic];
    
    //2 获取上一首音乐的下标值
    NSUInteger nextIndex=++currentIndex;
    
    LXMusic *nextMusic=nil;
    
    if(nextIndex>=_musics.count){
        nextIndex=0;
        
    }
    
    nextMusic=_musics[nextIndex];
    
    return nextMusic;
    
}
@end

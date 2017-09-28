//
//  LXAudioTool.m
//  QQMusic
//
//  Created by lx on 2017/9/16.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import "LXAudioTool.h"

@implementation LXAudioTool

static NSMutableDictionary *_soudIDs;
static NSMutableDictionary *_players;


//类第一次被调用
+(void)initialize{
    //将可变字典初始化
    _soudIDs=[NSMutableDictionary dictionary];
    _players=[NSMutableDictionary dictionary];
}

//播放音乐
+(AVAudioPlayer *)playMusicWithFileName:(NSString *)fileName{
    //1.创建空的播放器
    AVAudioPlayer *player=nil;
    
    //2.从字典中取出数据
    player=_players[fileName];
    
    //3.判断播放器是否为空
    if(player==nil){
        //4.生成对应的音乐资源
        NSURL *fileURL=[[NSBundle mainBundle]URLForResource:fileName withExtension:nil];
        
        //5.创建对应的播放器
        player=[[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:nil];
        
        //6.保存到字典中
        [_players setObject:player forKey:fileName];
        
        //7.准备播放
        [player prepareToPlay];
}
    
    //8 开始播放
    [player play];
    
    return player;
}

//暂停音乐

+(void)pauseMusicWithFileName:(NSString *)fileName{
    //1.从字典中取出播放器
    AVAudioPlayer *player=_players[fileName];
    
    //2.暂停音乐
    if(player){
        [player pause];
    }
}

//停止音乐

+ (void)stopMusicWithFileName:(NSString *)fileName{
    
    //1.从字典中去取出播放器
    
    AVAudioPlayer *player=_players[fileName];
    
    if(player){
        [player stop];
        [_players removeObjectForKey:fileName];
        player=nil;
    }
    
}
+ (void)playSoundWithSoundName:(NSString *)soundName
{
    // 1.创建soundID = 0
    SystemSoundID soundID = 0;
    
    // 2.从字典中取出soundID
    soundID = [_soudIDs[soundName] unsignedIntValue];;
    
    // 3.判断soundID是否为0
    if (soundID == 0) {
        // 3.1生成soundID
        CFURLRef url = (__bridge CFURLRef)[[NSBundle mainBundle] URLForResource:soundName withExtension:nil];
        if (url == nil) return;
        
        AudioServicesCreateSystemSoundID(url, &soundID);
        
        // 3.2将soundID保存到字典中
        [_soudIDs setObject:@(soundID) forKey:soundName];
        
    }
    
    // 4.播放音效
    AudioServicesPlaySystemSound(soundID);
}







@end

//
//  LXLrcTool.h
//  QQMusic
//
//  Created by lx on 2017/9/18.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXLrcTool : NSObject

//给一个歌词文件名 通过过滤 返回一个只有歌词数组
+ (NSArray *)lrcToolWithLrcName:(NSString *)lrcName;

@end

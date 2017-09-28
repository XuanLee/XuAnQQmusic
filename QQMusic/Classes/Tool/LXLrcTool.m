//
//  LXLrcTool.m
//  QQMusic
//
//  Created by lx on 2017/9/18.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import "LXLrcTool.h"
#import "LXLrcLine.h"
@implementation LXLrcTool

+(NSArray *)lrcToolWithLrcName:(NSString *)lrcName{
    // 1.获取路径
    NSString *path = [[NSBundle mainBundle] pathForResource:lrcName ofType:nil];
    
    // 2.获取歌词
    NSString *lrcString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    // 3.转化成歌词数组
    NSArray *lrcArray = [lrcString componentsSeparatedByString:@"\n"];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *lrcLineString in lrcArray) {
        
        /*
         [ti:简单爱]
         [ar:周杰伦]
         [al:范特西]
         
         */
        // 4.过滤不需要的字符串
        //以[ti:或者[ar:。。。。开头的就要
        if ([lrcLineString hasPrefix:@"[ti:"] ||
            [lrcLineString hasPrefix:@"[ar:"] ||
            [lrcLineString hasPrefix:@"[al:"] ||
            ![lrcLineString hasPrefix:@"["]) {
            continue;
        }
        
        // 5.将歌词转化成模型
        LXLrcLine *lrcLine = [LXLrcLine LrcLineString:lrcLineString];
        [tempArray addObject:lrcLine];
    }
    
    return tempArray;

}
@end

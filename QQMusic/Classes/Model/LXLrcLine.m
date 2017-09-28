//
//  LXLrcLine.m
//  QQMusic
//
//  Created by lx on 2017/9/18.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import "LXLrcLine.h"

@implementation LXLrcLine

+(instancetype)LrcLineString:(NSString *)lrcLineString{
    return [[self alloc]initWithLrcLineString:lrcLineString];

}

-(instancetype)initWithLrcLineString:(NSString *)lrcLineString{
    
    if (self=[super init]) {
        // [01:02.38]想你时你在天边
        //componentsSeparatedByString 将字符串切割成数组
        NSArray *lrcArray = [lrcLineString componentsSeparatedByString:@"]"];
        //[0][01:02.38]   [1]想你时你在天边
        self.text = lrcArray[1];
        self.time = [self timeWithString:[lrcArray[0] substringFromIndex:1]];

    }
    return self;
}
- (NSTimeInterval)timeWithString:(NSString *)timeString
{
    // 01:02.38 min=01,sec=02,hs38
    NSInteger min = [[timeString componentsSeparatedByString:@":"][0] integerValue];
    NSInteger sec = [[timeString substringWithRange:NSMakeRange(3, 2)] integerValue];
    NSInteger hs = [[timeString componentsSeparatedByString:@"."][1] integerValue];
    return min * 60 + sec + hs * 0.01;
}
@end

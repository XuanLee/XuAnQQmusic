//
//  LXLrcLine.h
//  QQMusic
//
//  Created by lx on 2017/9/18.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXLrcLine : NSObject
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSTimeInterval time;

- (instancetype)initWithLrcLineString:(NSString *)lrcLineString;
+ (instancetype)LrcLineString:(NSString *)lrcLineString;
@end

//
//  LXLrcLabel.m
//  QQMusic
//
//  Created by lx on 2017/9/18.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import "LXLrcLabel.h"

@implementation LXLrcLabel

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGRect fillRect = CGRectMake(0, 0, self.bounds.size.width * self.progress, self.bounds.size.height);
    [[UIColor greenColor] set];
    //    UIRectFill(fillRect);
    UIRectFillUsingBlendMode(fillRect, kCGBlendModeSourceIn);
}

@end

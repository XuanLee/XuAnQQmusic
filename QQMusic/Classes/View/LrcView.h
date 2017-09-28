//
//  LrcView.h
//  QQMusic
//
//  Created by lx on 2017/9/17.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LXLrcLabel;
@interface LrcView : UIScrollView
/** 歌词名 */
@property (nonatomic, copy) NSString *lrcName;

/** 当前播放器播放的时间 */
@property (nonatomic, assign) NSTimeInterval currentTime;

/** 主界面歌词的Lable */
@property (nonatomic, weak) LXLrcLabel *lrcLabel;

/** 当前播放器总时间时间 */
@property (nonatomic, assign) NSTimeInterval duration;
@end

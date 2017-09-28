//
//  LrcView.m
//  QQMusic
//
//  Created by lx on 2017/9/17.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import "LrcView.h"
#import "Masonry.h"
#import "LXLrcCell.h"
#import "LXLrcTool.h"
#import "LXLrcLine.h"
#import "LXLrcLabel.h"
#import "LXMusic.h"
#import "LXMusicTool.h"
#import <MediaPlayer/MediaPlayer.h>

@interface LrcView()<UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

/** 歌词数组 */
@property (nonatomic, strong) NSArray *lrcList;

/** 记录当前刷新的某行 */
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation LrcView


-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self=[super initWithCoder:aDecoder]){
       //1 初始化tableView
        [self setupTableView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        //1 初始化tableView
        [self setupTableView];
    }
    return self;
}


-(void)setupTableView{
    UITableView *tableView=[[UITableView alloc]init];
    [self addSubview:tableView];
    self.tableView=tableView;
    
    //设置数据源
    tableView.dataSource=self;
}
/*
 ①、直接调用setLayoutSubviews。
 ②、addSubview的时候触发layoutSubviews。
 ③、当view的frame发生改变的时候触发layoutSubviews。
 ④、第一次滑动UIScrollView的时候触发layoutSubviews。
 ⑤、旋转Screen会触发父UIView上的layoutSubviews事件。
 ⑥、改变一个UIView大小的时候也会触发父UIView上的layoutSubviews事件。
 */
-(void)layoutSubviews{
    [super layoutSubviews];
    // 1.添加约束
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(self.mas_height);
        make.right.equalTo(self.mas_right);
        make.left.equalTo(self.mas_left).offset(self.bounds.size.width);
        make.width.equalTo(self.mas_width);
    }];
    
    // 2.改变tableView属性
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 40;
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.bounds.size.height * 0.5, 0, self.tableView.bounds.size.height * 0.5, 0);
    
}
#pragma mark - UITableView数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lrcList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LXLrcCell *cell = [LXLrcCell lrcCellWithTableView:tableView];
    
    if (self.currentIndex == indexPath.row) {
        cell.lrcLabel.font = [UIFont systemFontOfSize:20];
    } else {
        cell.lrcLabel.font = [UIFont systemFontOfSize:14];
        cell.lrcLabel.progress = 0;
    }
    
    // 1.取出数据模型
    LXLrcLine *lrcLine = self.lrcList[indexPath.row];
    
    // 2.设置数据
    cell.lrcLabel.text = lrcLine.text;
    
    return cell;
}

#pragma mark - 重写lrcName
- (void)setLrcName:(NSString *)lrcName
{
    
    // -1让tableView滚到中间
    [self.tableView setContentOffset:CGPointMake(0, -self.tableView.bounds.size.height * 0.5) animated:NO];
    
    // 0.将currentIndex设置为0
    self.currentIndex = 0;
    
    // 1.记录歌词名
    _lrcName = [lrcName copy];
    
    // 2.解析歌词
    self.lrcList = [LXLrcTool lrcToolWithLrcName:lrcName];
    // 2.1设置第一句歌词
    LXLrcLine *firstLrcLine = self.lrcList[0];
    self.lrcLabel.text = firstLrcLine.text;
    
    // 3.刷新表格
    [self.tableView reloadData];
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    //
    //    });
}

#pragma mark - 重写currentTime set方法
- (void)setCurrentTime:(NSTimeInterval)currentTime
{
    // 1.记录当前的播放时间
    _currentTime = currentTime;
    
    // 2.判断显示哪句歌词
    NSInteger count = self.lrcList.count;
    for (NSInteger i = 0; i<count; i++) {
        // 2.1取出当前的歌词
        LXLrcLine *currentLrcLine = self.lrcList[i];
        
        // 2.2取出下一句歌词
        NSInteger nextIndex = i + 1;
        LXLrcLine *nextLrcLine = nil;
        //做保护当歌词大于歌词数组长度时，下一句歌词就是最后一句歌词
        if (nextIndex < self.lrcList.count) {
            nextLrcLine = self.lrcList[nextIndex];
        }
        
        // 2.3用当前播放器的时间,跟当前这句歌词的时间和下一句歌词的时间进行比对,如果大于等于当前歌词的时间,并且小于下一句歌词的时间,就显示当前的歌词
        if (self.currentIndex != i && currentTime >= currentLrcLine.time && currentTime < nextLrcLine.time) {
            
            // 1.获取当前这句歌词和上一句歌词的IndexPath
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            NSIndexPath *previousIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
            
            // 2.记录当前刷新的某行
            self.currentIndex = i;
            
            // 3.刷新当前这句歌词,并且刷新上一句歌词
            [self.tableView reloadRowsAtIndexPaths:@[indexPath,previousIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            // 4.将当前的这句歌词滚动到中间
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
            // 5.设置主界面歌词的文字
            self.lrcLabel.text = currentLrcLine.text;
            
//            // 6.生成锁屏图片
//            [self genaratorLockImage];
        }
        
        if (self.currentIndex == i) { // 当前这句歌词
            
            // 1.用当前播放器的时间减去当前歌词的时间除以(下一句歌词的时间-当前歌词的时间)
            CGFloat value = (currentTime - currentLrcLine.time) / (nextLrcLine.time - currentLrcLine.time);
            
            // 2.设置当前歌词播放的进度
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
            LXLrcCell *lrcCell = [self.tableView cellForRowAtIndexPath:indexPath];
            lrcCell.lrcLabel.progress = value;
            self.lrcLabel.progress = value;
        }
    }
}


@end

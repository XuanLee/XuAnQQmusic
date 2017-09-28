//
//  ViewController.m
//  QQMusic
//
//  Created by lx on 2017/9/14.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "LXMusic.h"
#import "LXMusicTool.h"
#import "LXAudioTool.h"
#import "LrcView.h"
#import "LXLrcLabel.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CALayer+PauseAimate.h"
@interface ViewController ()<UIScrollViewDelegate>
#define XMGColor(r,g,b,a)[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

/** 歌手背景图片 */
@property (weak, nonatomic) IBOutlet UIImageView *albumView;
/** 进度条 */
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
/** 歌手图片 */
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
/** 歌曲名 */
@property (strong, nonatomic) IBOutlet UIButton *playOrPauseBtn;
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
/** 歌手名 */
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
/** 当前播放时间 */
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
/** 歌曲的总时间 */
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

/** 播放器 */
@property (nonatomic, strong) AVAudioPlayer *currentPlayer;

/** 进度条时间 */
@property (nonatomic, strong) NSTimer *progressTimer;

/** 歌词的定时器 */
@property (nonatomic, strong) CADisplayLink *lrcTimer;

/** 歌词的view */
@property (weak, nonatomic) IBOutlet LrcView *lrcView;
@property (weak, nonatomic) IBOutlet LXLrcLabel *lrcLabel;

#pragma mark - 进度条事件处理
- (IBAction)start;
- (IBAction)end;
- (IBAction)progressValueChange;

- (IBAction)sliderClick:(UITapGestureRecognizer *)sender;

#pragma mark - 按钮点击事件
- (IBAction)playOrPause;
- (IBAction)next;
- (IBAction)previous;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1 添加毛玻璃效果
    [self setupBlur];
    
    //2 改变滑块的图片
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb"] forState:UIControlStateNormal];
    
    // 3.将lrcView中的lrcLable设置为主控制器的LrcLabel
    self.lrcView.lrcLabel = self.lrcLabel;
    
    //4 开始播放音乐
    [self startPlayingMusic];
    
    // 5.设置歌词view contentsize
    self.lrcView.contentSize=CGSizeMake(self.view.bounds.size.width*2, 0);
    
    self.lrcView.delegate=self;
}
#pragma mark -  开始播放音乐

-(void)startPlayingMusic{
    //1 清空当前歌曲label
    
    //2.获取当前正在播放的音乐
    LXMusic *playingMusic=[LXMusicTool playingMusic];
    
    // 3.设置界面信息
    self.albumView.image = [UIImage imageNamed:playingMusic.icon];
    self.iconView.image = [UIImage imageNamed:playingMusic.icon];
    self.songLabel.text = playingMusic.name;
    self.singerLabel.text = playingMusic.singer;
    
    //4.播放音乐
    AVAudioPlayer * currentPlayer=[LXAudioTool playMusicWithFileName:playingMusic.filename];
    
    self.currentTimeLabel.text = [self stringWithTime:currentPlayer.currentTime];
    self.totalTimeLabel.text = [self stringWithTime:currentPlayer.duration];
    self.currentPlayer = currentPlayer;
    
    // 3.1设置播放按钮
    self.playOrPauseBtn.selected = self.currentPlayer.isPlaying;
    
    // 3.2设置歌词
    self.lrcView.lrcName = playingMusic.lrcname;
    self.lrcView.duration = currentPlayer.duration;

    
    // 4.开启定时器,现将之前的定时器移除
    [self removeProgressTimer];
    [self addProgressTimer];
    [self removeLrcTimer];
    [self addLrcTimer];
    
    // 5.添加iconView的动画
    [self addIconViewAnimate];


    
}
#pragma mark - 对进度条时间的处理
//移除歌曲
-(void)removeProgressTimer{
    [self.progressTimer invalidate];
    self.progressTimer=nil;
}

-(void)addProgressTimer{
    //先更新数据
    [self updateProgressInfo];
    //添加定时器
    self.progressTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer  forMode:NSRunLoopCommonModes];


}
//更新进度条
- (void)updateProgressInfo
{
    // 1.更新播放的时间
    self.currentTimeLabel.text = [self stringWithTime:self.currentPlayer.currentTime];
    
    // 2.更新滑动条 当前播放点／当前音乐时长
    self.progressSlider.value = self.currentPlayer.currentTime / self.currentPlayer.duration;
}

#pragma mark - 对歌词定时器的处理
-(void)removeLrcTimer{
    [self.lrcTimer invalidate];
    self.lrcTimer = nil;
}


-(void)addLrcTimer{
    self.lrcTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrcInfo)];
    [self.lrcTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)updateLrcInfo{

    self.lrcView.currentTime = self.currentPlayer.currentTime;

}

#pragma mark - 添加毛玻璃效果
-(void)setupBlur{
    
    //1 初始化toolBar
    UIToolbar *tool=[[UIToolbar alloc]init];
    tool.barStyle=UIBarStyleBlack;
    [self.albumView addSubview:tool];
    
    // 2.添加约束
    tool.translatesAutoresizingMaskIntoConstraints = NO;
    [tool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.albumView);
    }];
    
    
}
//切换横竖屏时,让一个控件的位置改变,就会调用这个方法,viewWillLayoutSubviews.
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    // 添加圆角
    self.iconView.layer.cornerRadius = self.iconView.bounds.size.width * 0.5;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.borderColor = XMGColor(36, 36, 36, 1.0).CGColor;
    self.iconView.layer.borderWidth = 8;

}

#pragma mark - slider 事件处理事件
-(void)start{
    //移除定时器
    [self removeProgressTimer];
    
}

-(void)end{
    //更新播放时间
    self.currentPlayer.currentTime=self.progressSlider.value * self.currentPlayer.duration;
    //添加定时器
    [self addProgressTimer];
}
-(void)progressValueChange{
     self.currentTimeLabel.text = [self stringWithTime:self.progressSlider.value * self.currentPlayer.duration];
}

-(void)sliderClick:(UITapGestureRecognizer *)sender{
    // 1.获取点击到的点
    CGPoint point = [sender locationInView:sender.view];
    
    // 2.获取点击的比例
    CGFloat ratio = point.x / self.progressSlider.bounds.size.width;
    
    // 3.更新播放的时间
    self.currentPlayer.currentTime = self.currentPlayer.duration * ratio;
    
    // 4.更新时间和滑块的位置
    [self updateProgressInfo];
}

#pragma mark - 按钮点击事件
-(void)playOrPause{
    self.playOrPauseBtn.selected = !self.playOrPauseBtn.selected;
    if (self.currentPlayer.playing) {
        // 1.暂停播放器
        [self.currentPlayer pause];
        
        // 2.移除定时器
        [self removeProgressTimer];
        
        // 3.暂停旋转动画
        [self.iconView.layer pauseAnimate];
        
    } else {
        // 1.开始播放
        [self.currentPlayer play];
        
        // 2.添加定时器
        [self addProgressTimer];
        
        // 3.恢复动画
        [self.iconView.layer resumeAnimate];
    }


}

-(void)next{
    //1 获取下一首歌
    LXMusic * music=[LXMusicTool nextMusic];
    
    //2 播放下一首音乐
    [self playMusicWithMusic:music];
    
}
-(void)previous{
    //1 获取上一首音乐
    LXMusic *music=[LXMusicTool previousMusic];
    //2 播放上一首一首音乐
    [self playMusicWithMusic:music];
    
}
- (void)playMusicWithMusic:(LXMusic *)muisc
{
    // 1.获取当前播放的歌曲并停止
    LXMusic *currentMusic = [LXMusicTool playingMusic];
    [LXAudioTool stopMusicWithFileName:currentMusic.filename];
    
    // 2.设置上一首歌为默认播放的歌曲
    [LXMusicTool setupPlayingMusic:muisc];
    
    // 3.播放音乐,并更新界面信息
    [self startPlayingMusic];
}


#pragma mark - 添加旋转动画

- (void)addIconViewAnimate
{
    CABasicAnimation *rotateAnimate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimate.fromValue = @(0);
    rotateAnimate.toValue = @(M_PI * 2);
    rotateAnimate.repeatCount = NSIntegerMax;
    rotateAnimate.duration = 35;
    [self.iconView.layer addAnimation:rotateAnimate forKey:nil];
    
    // 更新动画是否进入后台
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"iconViewAnimate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(NSString *)stringWithTime:(NSTimeInterval)time
{
    NSInteger min = time / 60;
    NSInteger sec = (int)round(time) % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld",min,sec];
}
#pragma mark UIScrollView 代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 1.获取滑动的偏移量
    CGPoint point =  scrollView.contentOffset;
    
    // 2.获取滑动比例
    CGFloat alpha = 1 - point.x / scrollView.bounds.size.width;
    
    // 3.设置alpha
    self.iconView.alpha = alpha;
    self.lrcLabel.alpha = alpha;
}


@end

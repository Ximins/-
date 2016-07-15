//
//  ViewController.m
//  myQQMusic
//
//  Created by 罗贤民 on 16/6/30.
//  Copyright © 2016年 罗贤民. All rights reserved.
//

#import "ViewController.h"
#import "MinMusic.h"
#import "MinAudioTool.h"
#import "MinMusicTool.h"
#import "NSString+TimeExtension.h"
#import "CALayer+PauseAimate.h"
#import "MINLrcView.h"
#import "MINLrcLabel.h"
#import <MediaPlayer/MediaPlayer.h>

#define MINColor(r,g,b,a) ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a])

@interface ViewController ()<UIScrollViewDelegate, AVAudioPlayerDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
//滑块
@property (weak, nonatomic) IBOutlet UISlider *mySlder;
@property (weak, nonatomic) IBOutlet UIButton *playorPauseBtn;
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UILabel *singeer;
@property (weak, nonatomic) IBOutlet UILabel *currentTimalabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimelabel;

//歌词 滚动的视图
@property (weak, nonatomic) IBOutlet MINLrcView *lrcView;
//歌词语句
@property (weak, nonatomic) IBOutlet MINLrcLabel *LrcLabel;


/* 歌曲数据 */
@property (nonatomic, strong) NSArray *musics;

/* 定时器 */
@property (nonatomic, strong) NSTimer *progressTimer;

/* 歌词的定时器 */
@property (nonatomic, strong) CADisplayLink *lrcTimer;

/* 当前播放器 */
@property (nonatomic, strong) AVAudioPlayer *currentPlayer;

#pragma mark - 监听Slider的事件
- (IBAction)startSlider;
- (IBAction)endSlide;
- (IBAction)sliderValueChange;
- (IBAction)sliderClick:(UITapGestureRecognizer *)sender;


#pragma mark - 歌曲控制事件
- (IBAction)playOrPause;
- (IBAction)previous;
- (IBAction)next;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    //毛玻璃
    [self setupBlurView];
    
    // 2.设置滑块的图片
    [self.mySlder setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb"] forState:UIControlStateNormal];
    
    //开始播放歌曲
    [self startPalymusic];
    
     // 4.设置ScrollView的可滚动区域
    self.lrcView.contentSize = CGSizeMake(self.view.frame.size.width * 2, 0);
    self.lrcView.lrcLabel = self.LrcLabel;
    self.lrcView.backgroundColor = [UIColor clearColor];
   
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)setupBlurView
{
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    toolBar.barStyle = UIBarStyleBlack;
    [self.backgroundImageView addSubview:toolBar];
    toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    NSString *HVFL = @"H:|-0-[toolBar]-0-|";
    NSString *VVFL = @"V:|-0-[toolBar]-0-|";
    NSArray *toolbarHCons = [NSLayoutConstraint constraintsWithVisualFormat:HVFL options:0 metrics:nil views:@{@"toolBar":toolBar}];
    NSArray *toolbarVCons = [NSLayoutConstraint constraintsWithVisualFormat:VVFL options:0 metrics:nil views:@{@"toolBar":toolBar}];
    [self.backgroundImageView addConstraints:toolbarHCons];
    [self.backgroundImageView addConstraints:toolbarVCons];
    
    
}


//高斯玻璃
#pragma mark - 界面设置
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.iconImageView.layer.cornerRadius = self.iconImageView.bounds.size.width/2;
    self.iconImageView.layer.borderWidth = 5;
    self.iconImageView.layer.borderColor = MINColor(36, 36, 36, 1.0).CGColor;
    self.iconImageView.layer.masksToBounds  = YES;
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - 歌曲控制
-(void)startPalymusic
{
    //显示歌曲信息
    MinMusic *playingMusic = [MinMusicTool playingMusic];
    
    self.currentPlayer = [MinAudioTool playMusicWithName:playingMusic.filename];
    
    // 1.设置界面信息
    self.backgroundImageView.image = [UIImage imageNamed:playingMusic.singerIcon];
    self.iconImageView.image = [UIImage imageNamed:playingMusic.icon];
    self.songName.text = playingMusic.name;
    self.singeer.text = playingMusic.singer;
    self.playorPauseBtn.selected = YES;
    
    // 设置歌词信息
   self.lrcView.lrcName = playingMusic.lrcname;
    
    // 2.开始播放歌曲
    self.currentPlayer = [MinAudioTool playMusicWithName:playingMusic.filename];
    self.currentTimalabel.text = [NSString stringWithTime:self.currentPlayer.currentTime];
    self.totalTimelabel.text = [NSString stringWithTime:self.currentPlayer.duration];
    self.currentPlayer.delegate = self;
    
    //添加动画
    [self startAnimation];
    
    // 4.添加定时器
    [self removeProgressTimer];
    [self addProgressTimer];
    
    // 5.添加歌词的定时器
    [self removeLrcTimer];
    [self addLrcTimer];
    
    // 6.设置锁屏时的信息
    [self setupLockInfo];

  
}

-(void)startAnimation
{
    CABasicAnimation *rotationAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
   
    rotationAnim.duration = 40.0;
    
    rotationAnim.fromValue = @(0);
    rotationAnim.fromValue = @(M_PI*2);
    rotationAnim.repeatCount = NSIntegerMax;
    
    [self.iconImageView.layer addAnimation:rotationAnim forKey:nil];
    
}
- (void)stopAnimate
{
    [self.iconImageView.layer removeAllAnimations];
}

#pragma mark 定时器的操作
- (void)addProgressTimer
{
    [self updateProgressInfo];
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}
- (void)removeProgressTimer
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

- (void)addLrcTimer
{
    [self updateLrc];
    self.lrcTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrc)];
    [self.lrcTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)removeLrcTimer
{
    [self.lrcTimer invalidate];
    self.lrcTimer = nil;
}

#pragma mark - 更新界面
- (void)updateProgressInfo
{
    // 1.改变当前播放的时间
    self.currentTimalabel.text = [NSString stringWithTime:self.currentPlayer.currentTime];
    
    // 2.修改进度条
    // 2.1.计算当前播放的进度比例
    CGFloat progressRatio = self.currentPlayer.currentTime / self.currentPlayer.duration;
    
    // 2.2.设置进度条的比例
    self.mySlder.value = progressRatio;
}

//precviou
- (IBAction)previous {
    MinMusic *pre = [MinMusicTool previousMusic];
    [MinAudioTool playMusicWithName:pre.filename];
}
//next
- (IBAction)next {
    MinMusic *next  = [MinMusicTool nextMusic];
    [self playMusic:next];
}

- (IBAction)playOrPause {
    self.playorPauseBtn.selected = !self.playorPauseBtn.isSelected;
    
    if (self.currentPlayer.playing) {
        // 1.歌曲的控制
        [self.currentPlayer pause];
        [self removeProgressTimer];
        
        // 2.动画的控制
        [self.iconImageView.layer pauseAnimate];
    } else {
        [self.currentPlayer play];
        
        [self addProgressTimer];
        
        // 继续播放动画
        [self.iconImageView.layer resumeAnimate];
    }
}

-(void)playMusic:(MinMusic *)music
{
    //关闭当前歌曲
    [MinAudioTool stopMusicWithName:[MinMusicTool playingMusic].filename];
    //播发另一首歌曲
    [MinAudioTool playMusicWithName:music.filename];

    
    //设置另一首歌曲为当前歌曲
    [MinMusicTool setPlayingMusic:music];
    
    //更新界面
    [self startPalymusic];
    

}

- (IBAction)startSlider
{
    [self removeProgressTimer];
}

- (IBAction)endSlide
{
    self.currentPlayer.currentTime = self.mySlder.value * self.currentPlayer.duration;
    [self addProgressTimer];
}

- (IBAction)sliderValueChange {
    self.currentTimalabel.text = [NSString stringWithTime:self.mySlder.value * self.currentPlayer.duration];
}

- (IBAction)sliderClick:(UITapGestureRecognizer *)sender {
    // 1.获取点击的位置
    CGPoint point = [sender locationInView:sender.view];
    
    // 2.拿到x占据的比例
    CGFloat progress = point.x / self.mySlder.frame.size.width;
    
    // 3.设置歌曲的进度
    self.currentPlayer.currentTime = progress * self.currentPlayer.duration;
    [self updateProgressInfo];
}
#pragma mark - 更新歌词
- (void)updateLrc
{
    self.lrcView.currentTime = self.currentPlayer.currentTime;
}


#pragma mark - 实现UIScrollView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 1.获取滚动的区域
    CGFloat scrollX = scrollView.contentOffset.x;
    
    // 2.计算滚动的比例
    CGFloat alpha = 1 - scrollX / scrollView.bounds.size.width;
    
    // 3.设置内容的透明度
    self.iconImageView.alpha = alpha;
    self.LrcLabel.alpha = alpha;
}

#pragma mark - 实现AVAudioPlayer的代理方法
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag) {
        [self next];
    }
}

#pragma mark - 设置锁屏时的信息
- (void)setupLockInfo
{
    // 1.获取播放中心的实例
    MPNowPlayingInfoCenter *playingCenter = [MPNowPlayingInfoCenter defaultCenter];
    
    // 2.设置播放中心的信息
    MinMusic *playingMusic = [MinMusicTool playingMusic];
    NSMutableDictionary *playingInfo = [NSMutableDictionary dictionary];
    playingInfo[MPMediaItemPropertyAlbumTitle] = playingMusic.name;
    playingInfo[MPMediaItemPropertyArtist] = playingMusic.singer;
    playingInfo[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:playingMusic.icon]];
    playingInfo[MPMediaItemPropertyPlaybackDuration] = @(self.currentPlayer.duration);
    
    playingCenter.nowPlayingInfo = playingInfo;
    
    // 3.开始监听远程事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    // 4.让控制器成为第一响应者
    [self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
        case UIEventSubtypeRemoteControlPause:
            [self playOrPause];
            break;
            
        case UIEventSubtypeRemoteControlNextTrack:
            [self next];
            break;
            
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self previous];
            break;
            
        default:
            break;
    }
}

#pragma mark - 懒加载代码
- (NSArray *)musics
{
    if (_musics == nil) {
        _musics = [MinMusicTool musics];
    }
    return _musics;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

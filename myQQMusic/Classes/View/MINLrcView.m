//
//  MINLrcView.m
//  myQQMusic
//
//  Created by 罗贤民 on 16/7/1.
//  Copyright © 2016年 罗贤民. All rights reserved.
//

#import "MINLrcView.h"
#import "MINLrcTool.h"
#import "MINLrcline.h"
#import "MINLrcCell.h"
#import "MINLrcLabel.h"
#import "MinMusic.h"
#import "MinMusicTool.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MINLrcView() <UITableViewDataSource,UITableViewDelegate>
/* 歌词文件*/
@property(nonatomic,strong)NSArray *lrclines;

//全局列表
@property(weak,nonatomic)UITableView *tableView;

//记录当前
@property(assign,nonatomic)NSInteger currentIndex;

@end

@implementation MINLrcView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupTableView];
    }
    return self;
    
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupTableView];

    }
    return self;
}

-(void)setupTableView
{
    UITableView *lrcView = [[UITableView alloc]init];
    [self addSubview:lrcView];
    lrcView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView = lrcView;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor orangeColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 30;

}
//tableView布局
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    NSString *lrcViewVVFL = @"V:|-0-[lrcView(==hScrollView)]-0-|";
    NSArray *lrcViewCons =[NSLayoutConstraint constraintsWithVisualFormat:lrcViewVVFL options:0 metrics:nil views:@{@"lrcView" : self.tableView, @"hScrollView" : self}];
    [self addConstraints:lrcViewCons];
    
    NSLayoutConstraint *lrcViewWidthCon = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    NSLayoutConstraint *lrcViewRightCon = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self addConstraint:lrcViewWidthCon];
    [self addConstraint:lrcViewRightCon];
    NSLayoutConstraint *lrcViewLeftCon = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.bounds.size.width];
    [self addConstraint:lrcViewLeftCon];
    
    self.tableView.contentInset = UIEdgeInsetsMake(self.bounds.size.height * 0.5, 0, self.bounds.size.height * 0.5, 0);
    self.tableView.backgroundColor = [UIColor clearColor];
}

#pragma mark - 实现tableView的数据源和代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lrclines.count;
}

-(MINLrcCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建模型
    MINLrcCell *cell =  [MINLrcCell lrcCellWithTableView:tableView];
    
    if (self.currentIndex == indexPath.row) {
        cell.lrclabel.font = [UIFont systemFontOfSize:18];
    }
    else
    {
        cell.lrclabel.font = [UIFont systemFontOfSize:14];
        cell.lrclabel.lrcProgress = 0;
    }
    //取出模型
    MINLrcline *lrcline = self.lrclines[indexPath.row];
    //给cell设置数据
    cell.lrclabel.text = lrcline.text;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    
}

#pragma mark - 解析g歌词
-(void)setLrcName:(NSString *)lrcName
{
    self.lrclines = [MINLrcTool lrcToolWithLrcname:lrcName];
    [self.tableView reloadData];
    
}
#pragma mark －根据当前的时间展示歌词
-(void)setCurrentTime:(NSTimeInterval)currentTime
{
    _currentTime = currentTime;
    // 将歌词遍历,查看应该显示哪一句歌词
    NSInteger count = self.lrclines.count;
    for (int i = 0; i < count; i++) {
        
        //取出歌词
        MINLrcline *currentLrcLine = self.lrclines[i];

        //取出下一句歌词
        NSInteger nextIdex = i+1;
        MINLrcline *nextLrcLine = nil;
        if (nextIdex < count) {
            nextLrcLine = self.lrclines[nextIdex];
        }else
        {
            return;
        }
         // 3.判断当前时间是否在当前歌词和下一句歌词之间
        if (currentTime >= currentLrcLine.time && currentTime <= nextLrcLine.time && self.currentIndex != i) {
            //显示当前这句的歌词
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            NSIndexPath *previousPath =[NSIndexPath indexPathForRow:self.currentIndex inSection:0];
            
            //更新歌词信息
             //1.拿到三句歌词
            MINLrcline *previousLrcline = self.lrclines[self.currentIndex];
            NSString *previousLrc = previousLrcline.text;
            NSString *currentLrc = currentLrcLine.text;
            NSString *nextLrc = nextLrcLine.text;
            
            //2.拿到当前图片
            MinMusic *playingMusic  = [MinMusicTool playingMusic];
            UIImage *image = [UIImage imageNamed:playingMusic.icon];
            
            //上下文的大小
            //1.获取上下文
            UIGraphicsBeginImageContext(image.size);
            
            //2.绘制图片
            [image drawInRect:CGRectMake(0, 0, image.size.width,image.size.height)];
            
            //3.绘制水印文字
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle]mutableCopy];
            style.alignment = NSTextAlignmentCenter;
            
            //3.1文字的属性
            NSDictionary *dic1 = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSParagraphStyleAttributeName:style,NSParagraphStyleAttributeName:[UIColor whiteColor]};
            CGRect rect1 = CGRectMake(0, image.size.height-50, image.size.width, 25);
           
            //将文字绘制上去
             [currentLrc drawInRect:rect1 withAttributes:dic1];
            
            //3.2前一首和下一首
            NSDictionary *dic2 = @{ NSFontAttributeName:[UIFont systemFontOfSize:14],
                                    NSParagraphStyleAttributeName:style,
                                    NSForegroundColorAttributeName:[UIColor lightGrayColor]
                                    };
            CGRect rect2 = CGRectMake(0, image.size.height-25, image.size.width, 25);
            [nextLrc drawInRect:rect2 withAttributes:dic2];
            CGRect rect3 = CGRectMake(0, image.size.height-75, image.size.width, 25);
            [previousLrc drawInRect:rect3 withAttributes:dic2];
            
            //4.获取绘制到德图片
            UIImage *watermarkImage = UIGraphicsGetImageFromCurrentImageContext();
            
            //5.结束图片的绘制
            UIGraphicsEndImageContext();
            
            //1.获取播放中心的实例
            MPNowPlayingInfoCenter *playingCenter =  [MPNowPlayingInfoCenter defaultCenter];
            
           //2.设置播放中心的实列
            NSMutableDictionary *playinginfo = [NSMutableDictionary dictionary];
            playinginfo[MPMediaItemPropertyAlbumTitle] = playingMusic.name;
             playinginfo[MPMediaItemPropertyArtist] = playingMusic.singer;
            playinginfo[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:watermarkImage];
            // playingInfo[MPMediaItemPropertyPlaybackDuration] = @(self.currentPlayer.duration);
            
            playingCenter.nowPlayingInfo = playinginfo;
            
            // 3.开始监听远程事件
            [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
            
            
            // 记录当前行
            self.currentIndex = i;
            
            // 刷新当前行的歌词,让当前行字体变大
            [self.tableView reloadRowsAtIndexPaths:@[indexPath, previousPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        
        if (self.currentIndex == i) {
            // 1.获取当前的Cell
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            MINLrcCell *currentCell = (MINLrcCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            
            // 2.设置当前Cell的进度
            // 2.1.计算进度
            CGFloat lrcProgress = (currentTime - currentLrcLine.time) / (nextLrcLine.time - currentLrcLine.time);
            currentCell.lrclabel.lrcProgress = lrcProgress;
            
            // 3.设置外面歌词的Label的字体变化
            self.lrcLabel.lrcProgress = lrcProgress;
            self.lrcLabel.text = currentLrcLine.text;
        }
    }
    
}

@end



































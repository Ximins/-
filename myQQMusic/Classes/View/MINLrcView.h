//
//  MINLrcView.h
//  myQQMusic
//
//  Created by 罗贤民 on 16/7/1.
//  Copyright © 2016年 罗贤民. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MINLrcLabel;

@interface MINLrcView : UIScrollView

@property(nonatomic,copy)NSString *lrcName;

@property(nonatomic,assign)NSTimeInterval currentTime;

@property(weak,nonatomic)MINLrcLabel *lrcLabel;

@end

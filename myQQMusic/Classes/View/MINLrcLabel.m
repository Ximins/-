//
//  MINLrcLabel.m
//  myQQMusic
//
//  Created by 罗贤民 on 16/7/1.
//  Copyright © 2016年 罗贤民. All rights reserved.
//

#import "MINLrcLabel.h"

@implementation MINLrcLabel

-(void)setLrcProgress:(CGFloat)lrcProgress
{
    _lrcProgress = lrcProgress;
    [self setNeedsDisplay];
    
    
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGRect drawRect  = CGRectMake(0, 0,self.bounds.size.width*self.lrcProgress,self.bounds.size.height);
    [[UIColor greenColor]set];
    UIRectFillUsingBlendMode(drawRect, kCGBlendModeSourceIn);
}

@end



































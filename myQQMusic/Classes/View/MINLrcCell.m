//
//  MINLrcCell.m
//  myQQMusic
//
//  Created by 罗贤民 on 16/7/1.
//  Copyright © 2016年 罗贤民. All rights reserved.
//

#import "MINLrcCell.h"
#import "MINLrcLabel.h"

@implementation MINLrcCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        MINLrcLabel *lrcLabel = [[MINLrcLabel alloc]init];
        lrcLabel.font = [UIFont systemFontOfSize:14.0];
        lrcLabel.textColor = [UIColor whiteColor];
        lrcLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lrcLabel];
        
        self.lrclabel = lrcLabel;
        self.lrclabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSLayoutConstraint *labelHCon = [NSLayoutConstraint constraintWithItem:lrcLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        NSLayoutConstraint *labelVCon = [NSLayoutConstraint constraintWithItem:lrcLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        [self addConstraint:labelHCon];
        [self addConstraint:labelVCon];
    }
    return self;

}
+ (instancetype)lrcCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"LrcCell";
    MINLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[MINLrcCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.backgroundColor = [UIColor lightGrayColor];
    }
    
    return cell;
}


@end

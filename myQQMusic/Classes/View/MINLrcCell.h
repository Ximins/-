//
//  MINLrcCell.h
//  myQQMusic
//
//  Created by 罗贤民 on 16/7/1.
//  Copyright © 2016年 罗贤民. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MINLrcLabel;


@interface MINLrcCell : UITableViewCell

@property(weak,nonatomic)MINLrcLabel *lrclabel;

+(instancetype)lrcCellWithTableView:(UITableView *)tableView;




@end

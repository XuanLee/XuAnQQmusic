//
//  LXLrcCell.h
//  QQMusic
//
//  Created by lx on 2017/9/18.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LXLrcLabel;
@interface LXLrcCell : UITableViewCell
+ (instancetype)lrcCellWithTableView:(UITableView *)tableView;

/** lrcLabel */
@property (nonatomic, weak) LXLrcLabel *lrcLabel;
@end

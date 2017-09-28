//
//  LXLrcCell.m
//  QQMusic
//
//  Created by lx on 2017/9/18.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import "LXLrcCell.h"
#import "LXLrcLabel.h"
#import "Masonry.h"
@implementation LXLrcCell

+ (instancetype)lrcCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    LXLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[LXLrcCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 1.初始化XMGLrcLabel
        LXLrcLabel *lrcLabel = [[LXLrcLabel alloc] init];
        [self.contentView addSubview:lrcLabel];
        self.lrcLabel = lrcLabel;
        
        // 2.添加约束
        [lrcLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
        }];
        
        // 3.设置基本数据
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        lrcLabel.textColor = [UIColor whiteColor];
        lrcLabel.textAlignment = NSTextAlignmentCenter;
        lrcLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return self;
}
@end

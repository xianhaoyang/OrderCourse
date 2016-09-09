//
//  XHRecordCell.m
//  OrderCourse
//
//  Created by bluechips on 16/9/8.
//  Copyright © 2016年 yangxianhao. All rights reserved.
//

#import "XHRecordCell.h"

@interface XHRecordCell ()

@property (weak, nonatomic) IBOutlet UIButton *courseTypeBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation XHRecordCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"XHRecordCell";
    XHRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundView = nil;
    self.backgroundColor = [UIColor clearColor];
    
    self.courseTypeBtn.layer.cornerRadius = 22.5f;
    self.courseTypeBtn.clipsToBounds = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.cornerRadius = 5;
    //    self.bgView.clipsToBounds = YES;
    self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bgView.layer.shadowOffset = CGSizeMake(10, 10);
    self.bgView.layer.opacity = 0.8;
    self.bgView.layer.shadowRadius = 5;
}

@end

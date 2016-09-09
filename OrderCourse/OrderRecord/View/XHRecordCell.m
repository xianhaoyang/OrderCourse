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
@property (weak, nonatomic) IBOutlet UIView *titleBgView;

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
    
    self.titleBgView.layer.cornerRadius = 5.0f;
    self.titleBgView.clipsToBounds = YES;
    
    self.courseTypeBtn.layer.cornerRadius = 22.5f;
    self.courseTypeBtn.clipsToBounds = YES;
    
    self.bgView.layer.cornerRadius = 5.0f;
    self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bgView.layer.shadowOffset = CGSizeMake(5, 5);
    self.bgView.layer.shadowOpacity = 0.3;
    self.bgView.layer.shadowRadius = 5.0f;
}

@end

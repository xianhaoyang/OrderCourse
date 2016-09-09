//
//  XHRecordCell.m
//  OrderCourse
//
//  Created by bluechips on 16/9/8.
//  Copyright © 2016年 yangxianhao. All rights reserved.
//

#import "XHRecordCell.h"
#import "XHOrderedCourse.h"
#import "XHConstant.h"

@interface XHRecordCell ()

@property (weak, nonatomic) IBOutlet UIButton *courseTypeBtn;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
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

- (void)setCourse:(XHOrderedCourse *)course
{
    _course = course;
    if ([course.CourseType isEqualToString:@"小班课"]) {
        self.courseTypeBtn.backgroundColor = kRGBColor(245, 131, 193);
    } else if ([course.CourseType isEqualToString:@"沙龙课"]) {
        self.courseTypeBtn.backgroundColor = kRGBColor(250, 168, 136);
    } else { // 应用课
        self.courseTypeBtn.backgroundColor = kRGBColor(53, 185, 190);
    }
    [self.courseTypeBtn setTitle:course.CourseType forState:UIControlStateNormal];
    self.courseNameLabel.text = course.CourseName;
    self.timeLabel.text = course.BeginTime;
    NSString *stateStr = [course.state substringToIndex:3];
    self.statusLabel.text = stateStr;
    if ([stateStr isEqualToString:@"已预订"]) {
        self.statusLabel.textColor = kRGBColor(108, 209, 0);
    } else {
        self.statusLabel.textColor = kRGBColor(255, 145, 0);
    }
    
}

@end

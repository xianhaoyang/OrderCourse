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
#import "NSDate+Escort.h"
#import "NSDate+Calculations.h"

@interface XHRecordCell ()

@property (weak, nonatomic) IBOutlet UIButton *courseTypeBtn;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *titleBgView;
@property (weak, nonatomic) IBOutlet UIButton *cancelOrderBtn;

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

- (void)setOrderedCourse:(XHOrderedCourse *)orderedCourse
{
    _orderedCourse = orderedCourse;
    if ([orderedCourse.course.CourseType isEqualToString:@"小班课"]) {
        self.courseTypeBtn.backgroundColor = kRGBColor(245, 131, 193);
    } else if ([orderedCourse.course.CourseType isEqualToString:@"沙龙课"]) {
        self.courseTypeBtn.backgroundColor = kRGBColor(250, 168, 136);
    } else { // 应用课
        self.courseTypeBtn.backgroundColor = kRGBColor(53, 185, 190);
    }
    [self.courseTypeBtn setTitle:orderedCourse.course.CourseType forState:UIControlStateNormal];
    self.courseNameLabel.text = orderedCourse.course.CourseName;
    self.timeLabel.text = orderedCourse.course.BeginTime;
    NSString *stateStr = [orderedCourse.state substringToIndex:3];
    self.statusLabel.text = stateStr;
    if ([stateStr isEqualToString:@"已预订"]) {
        NSString *str = [orderedCourse.course.BeginTime substringWithRange:NSMakeRange(3, 10)];
        NSDate *date = [NSDate dateFromString:str format:@"yyyy年MM月dd日"];
        NSString *dateStr = [NSDate datestrFromDate:date withDateFormat:@"yyyy-MM-dd"];
        dateStr = [dateStr stringByAppendingString:@" "];
        NSRange rang = [orderedCourse.course.BeginTime rangeOfString:@"\n"];
        NSString *timeStr = [orderedCourse.course.BeginTime substringWithRange:NSMakeRange(rang.location - 5, 5)];
        NSString *beginStr = [dateStr stringByAppendingString:timeStr];
        NSDate *beginDate = [NSDate dateFromString:beginStr format:@"yyyy-MM-dd HH:mm"];
        NSInteger timeDiff = [[NSDate date] minutesBeforeDate:beginDate];
//         开课时间在6个小时以内就不能取消课程
        if (timeDiff < 60 * 6) {
            self.cancelOrderBtn.hidden = YES;
        } else {
            self.cancelOrderBtn.hidden = NO;
        }
        self.statusLabel.textColor = kRGBColor(108, 209, 0);
    } else { // 已完成
        self.statusLabel.textColor = kRGBColor(255, 145, 0);
        self.cancelOrderBtn.hidden = YES;
    }
}

- (IBAction)clickCancelOrder {
    XHLog(@"%s", __func__);
    if ([self.delegate respondsToSelector:@selector(recordCellDidClickCancelOrderBtn:)]) {
        [self.delegate recordCellDidClickCancelOrderBtn:self];
    }
}

@end

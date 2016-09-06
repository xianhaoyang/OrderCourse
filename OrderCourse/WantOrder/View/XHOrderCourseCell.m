//
//  XHOrderCourseCell.m
//  OrderCourse
//
//  Created by 杨先豪 on 16/9/3.
//  Copyright © 2016年 yangxianhao. All rights reserved.
//

#import "XHOrderCourseCell.h"
#import "XHCourse.h"

#define kRBGColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface XHOrderCourseCell ()

@property (weak, nonatomic) IBOutlet UIImageView *statusImg;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIView *timeBgView;
@property (weak, nonatomic) IBOutlet UIView *topicBgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topicBgH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeTopicMargin;

@end

@implementation XHOrderCourseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.timeBgView.layer.cornerRadius = 5.0f;
    self.timeBgView.clipsToBounds = YES;
    self.topicBgView.layer.cornerRadius = 5.0f;
    self.topicBgView.clipsToBounds = YES;
    self.btn.layer.cornerRadius = 15.0f;
    self.btn.clipsToBounds = YES;
    self.backgroundView = nil;
    self.backgroundColor = [UIColor clearColor];
}

- (void)setCourse:(XHCourse *)course
{
    _course = course;
    self.courseNameLabel.text = course.CourseName;
    NSString *dateStr = [course.BeginTime substringWithRange:NSMakeRange(5, 5)];
    dateStr = [[dateStr stringByReplacingOccurrencesOfString:@"-" withString:@"月"] stringByAppendingString:@"日"];
    NSString *weekStr = [course.BeginTime substringToIndex:10];
    NSDate *date = [NSDate dateFromString:weekStr withFormatter:@"yyyy-MM-dd"];
    NSString *weekDay = [NSDate weekdayStringFromDate:date];
    NSString *timeStr = [course.BeginTime substringWithRange:NSMakeRange(11, 5)];
    self.startTimeLabel.text = [NSString stringWithFormat:@"%@\n%@ %@", dateStr, weekDay, timeStr];
    // 白天黑夜
    if ([[course.BeginTime substringWithRange:NSMakeRange(11, 2)] integerValue] < 18) {
        [self.statusImg setImage:[UIImage imageNamed:@"sun"]];
    } else {
        [self.statusImg setImage:[UIImage imageNamed:@"moon"]];
    }
    // 订课人数
    if ([course.OrderNumber integerValue] < [course.Capacity integerValue]) {
        self.orderNumLabel.text = [NSString stringWithFormat:@"%@/%@", course.OrderNumber, course.Capacity];
        self.orderNumLabel.textColor = kRBGColor(125, 208, 32);
        self.btn.backgroundColor = kRBGColor(67, 219, 212);
        [self.btn setTitle:@"预定" forState:UIControlStateNormal];
    } else {
        self.orderNumLabel.text = @"已满";
        self.orderNumLabel.textColor = kRBGColor(253, 109, 127);
        self.btn.backgroundColor = kRBGColor(243, 165, 54);
        [self.btn setTitle:@"排队" forState:UIControlStateNormal];
    }
    // 级别
    self.levelLabel.text = course.CourseLevel;
    // 主题
    if (course.Topic.length == 0) {
        self.topicBgH.constant = self.timeTopicMargin.constant = 0;
    } else {
        self.topicBgH.constant = 35;
        self.timeTopicMargin.constant = 10;
        self.topicLabel.text = [NSString stringWithFormat:@"Topic:%@", course.Topic];
    }
}

- (IBAction)clickBtn {
    NSLog(@"%s--%@", __func__, self.btn.currentTitle);
    if ([self.delegate respondsToSelector:@selector(orderCourseCell:didClickBtn:)]) {
        [self.delegate orderCourseCell:self didClickBtn:self.btn];
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"XHOrderCourseCell";
    XHOrderCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    }
    return cell;
}

@end

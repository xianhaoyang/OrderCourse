//
//  XHCourseDetailController.m
//  OrderCourse
//
//  Created by 杨先豪 on 16/9/4.
//  Copyright © 2016年 yangxianhao. All rights reserved.
//

#import "XHCourseDetailController.h"
#import "XHCourse.h"

@interface XHCourseDetailController ()

@property (weak, nonatomic) IBOutlet UIImageView *teacherImageView;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;
@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *classRoomLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseTopicLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

@end

@implementation XHCourseDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化UI
    self.title = @"课程详情";
    self.actionBtn.layer.cornerRadius = 5.0f;
    self.actionBtn.clipsToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 设置数据
    self.teacherImageView.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.course.Teacher ofType:@"JPG"]];
    self.teacherLabel.text = [NSString stringWithFormat:@"授课老师:%@", self.course.Teacher];
    self.courseTypeLabel.text = [NSString stringWithFormat:@"课程类型:%@", self.course.CourseType];
    self.courseNameLabel.text = [NSString stringWithFormat:@"课程名称:%@", self.course.CourseName];
    self.courseTopicLabel.text = [NSString stringWithFormat:@"课程主题:%@", self.course.Topic];
    self.classRoomLabel.text = [NSString stringWithFormat:@"上课地点:%@", self.course.ClassRoom];
}

- (void)setCourse:(XHCourse *)course
{
    _course = course;
}

@end

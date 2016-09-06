//
//  XHCourseDetailController.m
//  OrderCourse
//
//  Created by 杨先豪 on 16/9/4.
//  Copyright © 2016年 yangxianhao. All rights reserved.
//

#import "XHCourseDetailController.h"
#import "UIView+YXH.h"
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

@property (nonatomic, strong) NSArray *teacherList;
@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation XHCourseDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.teacherList = @[@"Circle张媛", @"enya李璟妍", @"Julia.LunevaJulia.Luneva", @"Megan.li李耀明", @"Rachel陈畅", @"William.HaytonWilliam Hayton"];
    
    // 初始化UI
    self.title = @"课程详情";
    self.actionBtn.layer.cornerRadius = 5.0f;
    self.actionBtn.clipsToBounds = YES;
    // 老师图片点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSmallTeacherImageView)];
    [self.teacherImageView addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 设置数据
    UIImage *img = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.course.Teacher ofType:@"JPG"]];
    if (img) {
        self.teacherImageView.image = img;
    }
    self.teacherLabel.text = [NSString stringWithFormat:@"授课老师:%@", self.course.Teacher];
    self.courseTypeLabel.text = [NSString stringWithFormat:@"课程类型:%@", self.course.CourseType];
    self.courseNameLabel.text = [NSString stringWithFormat:@"课程名称:%@", self.course.CourseName];
    self.courseTopicLabel.text = [NSString stringWithFormat:@"课程主题:%@", self.course.Topic];
    self.classRoomLabel.text = [NSString stringWithFormat:@"上课地点:%@", self.course.ClassRoom];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 创建图片浏览器
    NSInteger imageCount = [self isValidTeacher] ? 2 : 1;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.hidden = YES;
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(self.view.width * imageCount, 0);
    [self.view.window addSubview:scrollView];
    self.scrollView = scrollView;
    for (NSInteger i = 0; i < imageCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBigTeacherImageView)];
        [imageView addGestureRecognizer:tap];
        imageView.frame = CGRectMake(i * scrollView.width, 0, scrollView.width, scrollView.height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.userInteractionEnabled = YES;
        NSString *imageName = nil;
        if (imageCount == 1) {
            imageName = @"Person";
            imageView.image = [UIImage imageNamed:@"Person"];
        } else {
            imageName = [NSString stringWithFormat:@"%@%@", self.course.Teacher, i * 2 ? @"2" : @""];
            imageView.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"JPG"]];
        }
        [scrollView addSubview:imageView];
    }
}

- (void)tapSmallTeacherImageView
{
    NSLog(@"%s", __func__);
    self.scrollView.frame = self.teacherImageView.frame;
    self.scrollView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.frame = self.view.bounds;
    }];
    
}

- (void)tapBigTeacherImageView
{
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.frame = self.teacherImageView.frame;
    } completion:^(BOOL finished) {
        self.scrollView.hidden = YES;
        self.scrollView.contentOffset = CGPointZero;
    }];
}

#pragma mark - 验证教师名称是否合法
- (BOOL)isValidTeacher
{
    BOOL valid = NO;
    for (NSString *teacherName in self.teacherList) {
        if ([self.course.Teacher isEqualToString:teacherName]) {
            valid = YES;
            break;
        }
    }
    return valid;
}

- (void)setCourse:(XHCourse *)course
{
    _course = course;
}

@end

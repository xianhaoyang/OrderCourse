//
//  XHCourseDetailController.m
//  OrderCourse
//
//  Created by 杨先豪 on 16/9/4.
//  Copyright © 2016年 yangxianhao. All rights reserved.
//

#import "XHCourseDetailController.h"
#import "NSDate+Calculations.h"
#import "UIView+YXH.h"
#import "XHCourse.h"
#import "XHConstant.h"
#import "NSDate+Escort.h"
#import "MBProgressHUD+XMG.h"
#import "AFNetworking.h"

@interface XHCourseDetailController () <UIAlertViewDelegate, UIScrollViewDelegate>

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
@property (nonatomic, weak) UIPageControl *pageControl;

@end

@implementation XHCourseDetailController

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.teacherList = @[@"Circle张媛", @"enya李璟妍", @"Julia.LunevaJulia.Luneva", @"Megan.li李耀明", @"Rachel陈畅", @"William.HaytonWilliam Hayton"];
    
    // 初始化UI
    self.title = @"课程详情";
    self.actionBtn.layer.cornerRadius = 5.0f;
    self.actionBtn.clipsToBounds = YES;
    self.actionBtn.hidden = self.fromControllerType;
    // 老师图片点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSmallTeacherImageView)];
    [self.teacherImageView addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 设置数据
    BOOL existTeacher = [self isValidTeacher];
    UIImage *img = nil;
    if (existTeacher) {
        img = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.course.Teacher ofType:@"JPG"]];
    } else {
        img = [UIImage imageNamed:@"Person"];
    }
    self.teacherImageView.image = img;
    self.teacherLabel.text = [NSString stringWithFormat:@"授课老师: %@", self.course.Teacher];
    self.courseTypeLabel.text = [NSString stringWithFormat:@"课程类型: %@", self.course.CourseType];
    self.courseNameLabel.text = [NSString stringWithFormat:@"课程名称: %@", self.course.CourseName];
    self.courseTopicLabel.text = [NSString stringWithFormat:@"课程主题: %@", self.course.Topic];
    self.classRoomLabel.text = [NSString stringWithFormat:@"上课地点: %@", self.course.ClassRoom];
    // 级别
    self.levelLabel.text = [NSString stringWithFormat:@"适用级别: %@", self.course.CourseLevel];
    // 开始时间
    NSString *dateStr = [self.course.BeginTime substringWithRange:NSMakeRange(5, 5)];
    dateStr = [[dateStr stringByReplacingOccurrencesOfString:@"-" withString:@"月"] stringByAppendingString:@"日"];
    NSString *weekStr = [self.course.BeginTime substringToIndex:10];
    NSDate *date = [NSDate dateFromString:weekStr format:@"yyyy-MM-dd"];
    NSString *weekDay = [NSDate weekdayStringFromDate:date];
    NSString *timeStr = [self.course.BeginTime substringWithRange:NSMakeRange(11, 5)];
    self.startTimeLabel.text = [NSString stringWithFormat:@"开始时间: %@ %@ %@", dateStr, weekDay, timeStr];
    
    
    if (self.fromControllerType) return;
    // 订课人数
    if ([self.course.OrderNumber integerValue] < [self.course.Capacity integerValue]) {
        self.orderNumLabel.text = [NSString stringWithFormat:@"订课人数: %@/%@", self.course.OrderNumber, self.course.Capacity];
        if (self.course.isReserved) {
            [self disableActionBtnWithTitle:@"已预订"];
        } else {
            self.actionBtn.backgroundColor = kRGBColor(67, 219, 212);
            [self.actionBtn setTitle:@"预定" forState:UIControlStateNormal];
            self.actionBtn.enabled = YES;
        }
    } else {
        self.orderNumLabel.text = @"订课人数: 已满";
        if (self.course.isReserved) {
            [self disableActionBtnWithTitle:@"已预订"];
        } else {
            self.actionBtn.backgroundColor = kRGBColor(243, 165, 54);
            [self.actionBtn setTitle:@"排队" forState:UIControlStateNormal];
            self.actionBtn.enabled = YES;
        }
    }
    // 时间是否有冲突
    if (self.course.isEnableOrder) {
        [self disableActionBtnWithTitle:@"您已预订的课程与此课程的时间有冲突"];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 创建图片浏览器
    NSInteger imageCount = [self isValidTeacher] ? 2 : 1;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.delegate = self;
    scrollView.hidden = YES;
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(self.view.width * imageCount, 0);
    [self.view.window addSubview:scrollView];
    self.scrollView = scrollView;
    // 创建pageControl
    if (imageCount == 2) {
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.numberOfPages = imageCount;
        pageControl.hidden = YES;
        pageControl.center = CGPointMake(self.view.window.centerX, self.view.window.height * 0.9);
        [self.view.window addSubview:pageControl];
        self.pageControl = pageControl;
    }
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
    } completion:^(BOOL finished) {
        self.pageControl.hidden = NO;
    }];
    
}

- (void)tapBigTeacherImageView
{
    self.pageControl.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.frame = self.teacherImageView.frame;
    } completion:^(BOOL finished) {
        self.scrollView.hidden = YES;
        self.scrollView.contentOffset = CGPointZero;
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"%s", __func__);
    self.pageControl.currentPage = scrollView.contentOffset.x / scrollView.width;
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

- (IBAction)clickActionBtn {
    NSLog(@"%s", __func__);
    // 显示会话框
    UIAlertView *alertView = [[UIAlertView alloc] init];
    alertView.delegate = self;
    [alertView addButtonWithTitle:@"取消"];
    [alertView addButtonWithTitle:@"确定"];
    if ([self.actionBtn.currentTitle isEqualToString:@"预定"]) {
        // 显示预定会话框
        NSString *alertTitle = @"您要预订该课程吗？";
        NSString *alertMsg = @"预订后可提前6小时取消";
        // 处理时间
        NSString *beginTimeStr = [self.course.BeginTime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        NSDate *beginTimeDate = [NSDate dateFromString:beginTimeStr format:@"yyyy-MM-dd HH:mm:ss"];
        NSInteger timeDiff = [[NSDate date] minutesBeforeDate:beginTimeDate];
        if (timeDiff < 60 * 6) {
            alertMsg = @"6小时内即将开始的课程\n预订后不可取消";
        }
        alertView.title = alertTitle;
        alertView.message = alertMsg;
    } else {
        // 显示排队会话框
        alertView.title = @"你要加入排队队列吗？";
        alertView.message = @"加入排队队列后，如有人取消预订，我们会第一时间通知您。";
    }
    [alertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%zd--%@", buttonIndex, self.actionBtn.currentTitle);
    if (buttonIndex == 1) {
        [MBProgressHUD showMessage:@"预定中，请稍等..."];
        // 发送预定请求
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 3.0f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSString *urlStr = nil;
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"appUserId"] = userid;
        parameters[@"courseGuid"] = self.course.CourseGuid;
        if ([self.actionBtn.currentTitle isEqualToString:@"预定"]) {
            urlStr = [NSString stringWithFormat:@"%@%@", baseURL, orderCourseURL];
            parameters[@"openId"] = openid;
            parameters[@"contractGuid"] = contractGuid;
            [manager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary  *_Nullable responseObject) {
                NSLog(@"订课成功:%@", responseObject);
                [MBProgressHUD hideHUD];
                if ([responseObject[@"state"] integerValue] == 1) {
                    [MBProgressHUD showSuccess:@"预定成功!"];
                    self.course.Reserved = YES;
                    [self refreshOrderNumber];
                    [self disableActionBtnWithTitle:@"已预订"];
                    // 将订课成功的对象存入已订课数组
                    [self broadcastSaveReserveInfo:responseObject];
                    // TODO:此处还可以查看订课详情
                } else {
                    [MBProgressHUD showError:responseObject[@"message"]];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"订课失败:%@", error);
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"当前网络不好，请检查网络"];
            }];
        } else {
            // 发送排队请求
            urlStr = [NSString stringWithFormat:@"%@%@", baseURL, reminderQueueURL];
            [manager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"排队成功:%@", responseObject);
                [MBProgressHUD hideHUD];
                if ([responseObject[@"state"] integerValue] == 1) {
                    [MBProgressHUD showSuccess:@"排队成功!"];
                } else {
                    [MBProgressHUD showError:responseObject[@"message"]];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"排队失败:%@", error);
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"当前网络不好，请检查网络"];
            }];
        }
    }
}

- (void)disableActionBtnWithTitle:(NSString *)title
{
    self.actionBtn.backgroundColor = [UIColor grayColor];
    [self.actionBtn setTitle:title forState:UIControlStateNormal];
    self.actionBtn.enabled = NO;
}

- (void)broadcastSaveReserveInfo:(NSDictionary *)responseObject
{
    NSDictionary *dict = [NSDictionary dictionaryWithObject:responseObject forKey:kResponseObjectKey];
    [kNotificationCenter postNotificationName:kCourseDetailControllerReserveCourseSuccessNotification object:self userInfo:dict];
}

#pragma mark - 刷新订课人数
- (void)refreshOrderNumber
{
    // 订课人数+1
    self.course.OrderNumber = [NSString stringWithFormat:@"%zd", [self.course.OrderNumber integerValue] + 1];
    if ([self.course.OrderNumber integerValue] < [self.course.Capacity integerValue]) {
        self.orderNumLabel.text = [NSString stringWithFormat:@"订课人数: %@/%@", self.course.OrderNumber, self.course.Capacity];
    } else {
        self.orderNumLabel.text = @"订课人数: 已满";
    }
}

- (void)setCourse:(XHCourse *)course
{
    _course = course;
}

- (void)setFromControllerType:(XHFromControllerType)fromControllerType
{
    _fromControllerType = fromControllerType;
}

@end

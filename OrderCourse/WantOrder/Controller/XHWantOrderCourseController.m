//
//  XHWantOrderCourseController.m
//  OrderCourse
//
//  Created by 杨先豪 on 16/9/2.
//  Copyright © 2016年 yangxianhao. All rights reserved.
//

#import "XHWantOrderCourseController.h"
#import "XHCourseDetailController.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "XHCourse.h"
#import "XHConstant.h"
#import "XHOrderCourseCell.h"
#import "NSDate+Escort.h"
#import "MBProgressHUD+XMG.h"
#import "MJRefresh.h"

#define kBtnW 80
#define kBtnH 50
#define kIncrease 10
#define kTopMargin 74

@interface XHWantOrderCourseController () <UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource, XHOrderCourseCellDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *privateClassBtn;
@property (weak, nonatomic) IBOutlet UIButton *solonClassBtn;
@property (weak, nonatomic) IBOutlet UIButton *applicationClassBtn;
@property (weak, nonatomic) IBOutlet UIImageView *checkImage1;
@property (weak, nonatomic) IBOutlet UIImageView *checkImage2;
@property (weak, nonatomic) IBOutlet UIImageView *checkImage3;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *privateBtnW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *privateBtnH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *solonBtnW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *solonBtnH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *applicationBtnW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *applicationBtnH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnTop;

@property (nonatomic, strong) NSMutableArray *privateList;
@property (nonatomic, strong) NSMutableArray *solonList;
@property (nonatomic, strong) NSMutableArray *appList;
@property (nonatomic, strong) NSArray *dataList;

@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIButton *selectedBtn;
@property (nonatomic, strong) XHCourse *course;
@property (nonatomic, weak) UIWebView *webView;

@end

@implementation XHWantOrderCourseController

#pragma mark - lazy load
- (NSMutableArray *)privateList
{
    if (!_privateList) {
        _privateList = [NSMutableArray array];
    }
    return _privateList;
}

- (NSMutableArray *)solonList
{
    if (!_solonList) {
        _solonList = [NSMutableArray array];
    }
    return _solonList;
}

- (NSMutableArray *)appList
{
    if (!_appList) {
        _appList = [NSMutableArray array];
    }
    return _appList;
}

- (NSArray *)dataList
{
    if (!_dataList) {
        _dataList = [NSArray array];
    }
    return _dataList;
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    webView.delegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHomeData)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshCurrentCourseTypeTableViewData];
}

- (void)refreshHomeData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/wap/course/index/wid=1!openid=%@", baseURL, openid];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *lJs = @"document.documentElement.innerHTML";//获取当前网页的html
    NSString *jsCodeStr = [webView stringByEvaluatingJavaScriptFromString:lJs];
    [self handleDataWithTargetStr:jsCodeStr];
}

- (void)handleDataWithTargetStr:(NSString *)targetStr
{
    // 先清除旧数据
    [self.privateList removeAllObjects];
    [self.solonList removeAllObjects];
    [self.appList removeAllObjects];
    // 再加载新数据
    NSString *str1 = @"var centerCourseListJson = JSON.parse('";
    NSString *str2 = @"var othercenterCourseListJson = JSON.parse('[]');";
    NSRange range1 = [targetStr rangeOfString:str1];
    NSRange range2 = [targetStr rangeOfString:str2];
    NSString *jsonStr = [targetStr substringWithRange:NSMakeRange(range1.location + range1.length, range2.location - (range1.location + range1.length))];
    jsonStr = [jsonStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    jsonStr = [jsonStr substringToIndex:jsonStr.length - 3];
    NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *dictList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray *courseList = [XHCourse mj_objectArrayWithKeyValuesArray:dictList];
    for (XHCourse *course in courseList) {
        if ([course.CourseType isEqualToString:@"小班课"]) {
            [self.privateList addObject:course];
        } else if ([course.CourseType isEqualToString:@"沙龙课"]) {
            [self.solonList addObject:course];
        } else {
            [self.appList addObject:course];
        }
    }
    [self.tableView.mj_header endRefreshing];
    if (!self.checkImage1.isHidden) {
        [self clickPrivateClassBtn];
    } else if (!self.checkImage2.isHidden) {
        [self clickSolonClassBtn];
    } else if (!self.checkImage3.isHidden) {
        [self clickAppClassBtn];
    } else {
        [self clickPrivateClassBtn];
    }
}

#pragma mark - 初始化UI
- (void)setupUI
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    // 按钮设置圆角
    [self cornerRadiusWithBtn:self.privateClassBtn];
    [self cornerRadiusWithBtn:self.solonClassBtn];
    [self cornerRadiusWithBtn:self.applicationClassBtn];
    // 隐藏勾选
    self.checkImage1.hidden = YES;
    self.checkImage2.hidden = YES;
    self.checkImage3.hidden = YES;
}

- (void)cornerRadiusWithBtn:(UIButton *)btn
{
    btn.layer.cornerRadius = 5.0f;
    btn.clipsToBounds = YES;
}

- (IBAction)clickPrivateClassBtn {
    self.checkImage1.hidden = NO;
    self.checkImage2.hidden = YES;
    self.checkImage3.hidden = YES;
    if (self.privateClassBtn.isEnabled) {
        self.privateBtnW.constant += kIncrease;
        self.privateBtnH.constant += kIncrease;
    }
    self.solonBtnW.constant = kBtnW;
    self.solonBtnH.constant = kBtnH;
    self.applicationBtnW.constant = kBtnW;
    self.applicationBtnH.constant = kBtnH;
    self.btnTop.constant = kTopMargin;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
    [self changeTypeBtnEnable:self.privateClassBtn];
    self.dataList = self.privateList;
    [self.tableView reloadData];
    [self.tableView  scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

- (IBAction)clickSolonClassBtn {
    self.checkImage1.hidden = YES;
    self.checkImage2.hidden = NO;
    self.checkImage3.hidden = YES;
    self.privateBtnW.constant = kBtnW;
    self.privateBtnH.constant = kBtnH;
    if (self.solonClassBtn.isEnabled) {
        self.solonBtnW.constant += kIncrease;
        self.solonBtnH.constant += kIncrease;
    }
    self.applicationBtnW.constant = kBtnW;
    self.applicationBtnH.constant = kBtnH;
    self.btnTop.constant = kTopMargin - kIncrease * 0.5;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
    [self changeTypeBtnEnable:self.solonClassBtn];
    self.dataList = self.solonList;
    [self.tableView reloadData];
    [self.tableView  scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

- (IBAction)clickAppClassBtn {
    self.checkImage1.hidden = YES;
    self.checkImage2.hidden = YES;
    self.checkImage3.hidden = NO;
    self.privateBtnW.constant = kBtnW;
    self.privateBtnH.constant = kBtnH;
    self.solonBtnW.constant = kBtnW;
    self.solonBtnH.constant = kBtnH;
    if (self.applicationClassBtn.isEnabled) {
        self.applicationBtnW.constant += kIncrease;
        self.applicationBtnH.constant += kIncrease;
    }
    self.btnTop.constant = kTopMargin;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
    [self changeTypeBtnEnable:self.applicationClassBtn];
    self.dataList = self.appList;
    [self.tableView reloadData];
    [self.tableView  scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

- (void)changeTypeBtnEnable:(UIButton *)typeBtn
{
    self.selectedBtn.enabled = YES;
    typeBtn.enabled = NO;
    self.selectedBtn = typeBtn;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"%s", __func__);
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"%s", __func__);
    XHOrderCourseCell *cell = [XHOrderCourseCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.course = self.dataList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%s", __func__);
    return self.checkImage1.isHidden == NO ? 105 : 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHCourseDetailController *detailController = [[XHCourseDetailController alloc] init];
    XHCourse *course = nil;
    if (!self.checkImage1.isHidden) {
        course = self.privateList[indexPath.row];
    } else if (!self.checkImage2.isHidden) {
        course = self.solonList[indexPath.row];
    } else {
        course = self.appList[indexPath.row];
    }
    detailController.course = course;
    [self.navigationController pushViewController:detailController animated:YES];
}

#pragma mark - XHOrderCourseCellDelegate
- (void)orderCourseCell:(XHOrderCourseCell *)cell didClickBtn:(UIButton *)btn
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    XHCourse *course = nil;
    if (!self.checkImage1.isHidden) {
        NSLog(@"private");
        course = self.privateList[indexPath.row];
    } else if (!self.checkImage2.isHidden) {
        NSLog(@"solon");
        course = self.solonList[indexPath.row];
    } else {
        NSLog(@"application");
        course = self.appList[indexPath.row];
    }
    // 存储btn和course，alertview的代理里会用到
    self.btn = btn;
    self.course = course;
    // 显示会话框
    UIAlertView *alertView = [[UIAlertView alloc] init];
    alertView.delegate = self;
    [alertView addButtonWithTitle:@"取消"];
    [alertView addButtonWithTitle:@"确定"];
    if ([btn.currentTitle isEqualToString:@"预定"]) {
        // 显示预定会话框
        NSString *alertTitle = @"您要预订该课程吗？";
        NSString *alertMsg = @"预订后可提前6小时取消";
        // 处理时间
        NSString *beginTimeStr = [course.BeginTime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        NSDate *beginTimeDate = [NSDate dateFromString:beginTimeStr withFormatter:@"yyyy-MM-dd HH:mm:ss"];
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
    NSLog(@"%zd--%@", buttonIndex, self.btn.currentTitle);
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
        if ([self.btn.currentTitle isEqualToString:@"预定"]) {
            urlStr = [NSString stringWithFormat:@"%@%@", baseURL, orderCourseURL];
            parameters[@"openId"] = openid;
            parameters[@"contractGuid"] = contractGuid;
            [manager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"订课成功:%@", responseObject);
                [MBProgressHUD hideHUD];
                if ([responseObject[@"state"] integerValue] == 1) {
                    self.course.Reserved = YES;
                    [MBProgressHUD showSuccess:@"预定成功!"];
                    // 刷新当前课程类型表格
                    [self refreshCurrentCourseTypeTableViewData];
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

- (void)refreshCurrentCourseTypeTableViewData
{
    NSLog(@"%s", __func__);
    if (!self.checkImage1.isHidden) {
        self.dataList = self.privateList;
    } else if (!self.checkImage2.isHidden) {
        self.dataList = self.solonList;
    } else {
        self.dataList = self.appList;
    }
    [self.tableView reloadData];
}

@end

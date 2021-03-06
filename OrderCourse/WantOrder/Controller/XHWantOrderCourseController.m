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

@property (nonatomic, strong) NSMutableArray *orderedCourseList;
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
- (NSMutableArray *)orderedCourseList
{
    if (!_orderedCourseList) {
        _orderedCourseList = [NSMutableArray array];
    }
    return _orderedCourseList;
}

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

#pragma mark - life cycle
- (void)dealloc
{
    XHLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    XHLog(@"kOrderedCourseSavePath:%@", kOrderedCourseSavePath);
    [self setupUI];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    webView.delegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHomeData)];
    [self.tableView.mj_header beginRefreshing];
    
    [kNotificationCenter addObserver:self selector:@selector(saveOrderInfo:) name:kCourseDetailControllerReserveCourseSuccessNotification object:nil];
    [kNotificationCenter addObserver:self selector:@selector(updateBtnStateUI:) name:kCancelCourseSuccessNotification object:nil];
}

#pragma mark - 请求数据
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

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD showError:@"当前网络状态不佳，请稍后再试..."];
    [self.tableView.mj_header endRefreshing];
}

#pragma mark - 从网页元素中截取数据信息
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
    self.orderedCourseList = [NSKeyedUnarchiver unarchiveObjectWithFile:kOrderedCourseSavePath];
    for (XHCourse *course in courseList) {
        for (XHOrderedCourse *orderedCourse in self.orderedCourseList) {
            if ([course.CourseGuid isEqualToString:orderedCourse.course.CourseGuid]) {
                course.Reserved = YES;
//                break;
            } else {
                NSString *orderedBeginTime = orderedCourse.course.BeginTime;
                NSString *courseBeginTime = course.BeginTime;
//                XHLog(@"-----");
                if ([orderedBeginTime isEqualToString:courseBeginTime]) {
                    course.EnableOrder = YES;
                }
            }
        }
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

#pragma mark - 初始化按钮UI
- (void)cornerRadiusWithBtn:(UIButton *)btn
{
    btn.layer.cornerRadius = 5.0f;
    btn.clipsToBounds = YES;
}

#pragma mark - xib action
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
    //XHLog(@"%s", __func__);
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //XHLog(@"%s", __func__);
    XHOrderCourseCell *cell = [XHOrderCourseCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.course = self.dataList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //XHLog(@"%s", __func__);
    return self.checkImage1.isHidden == NO ? 90 : 120;
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
    XHLog(@"CourseGuid : %@, %@", course.CourseGuid, course.BeginTime);
    detailController.course = course;
    detailController.fromControllerType = XHFromControllerTypeWantOrder;
    // 此处一定需要这句话，因为用户可能在课程详情里预定课程，而在加入数组方法里有self.course.BeginTime取出课程开始时间，而此时的self.course是XHOrderCourseCellDelegate里取到的course，所以此处要覆盖
    self.course = course;
    [self.navigationController pushViewController:detailController animated:YES];
}

#pragma mark - XHOrderCourseCellDelegate
- (void)orderCourseCell:(XHOrderCourseCell *)cell didClickBtn:(UIButton *)btn
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    XHCourse *course = nil;
    if (!self.checkImage1.isHidden) {
        XHLog(@"private");
        course = self.privateList[indexPath.row];
    } else if (!self.checkImage2.isHidden) {
        XHLog(@"solon");
        course = self.solonList[indexPath.row];
    } else {
        XHLog(@"application");
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
    XHLog(@"%zd--%@", buttonIndex, self.btn.currentTitle);
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
            [manager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary  *_Nullable responseObject) {
                XHLog(@"订课成功:%@", responseObject);
                [MBProgressHUD hideHUD];
                if ([responseObject[@"state"] integerValue] == 1) {
                    [MBProgressHUD showSuccess:@"预定成功!"];
                    // 修改此课程订课状态
                    self.course.Reserved = YES;
                    // 订课人数+1
                    self.course.OrderNumber = [NSString stringWithFormat:@"%zd", [self.course.OrderNumber integerValue] + 1];
                    // 修改时间是否冲突状态
                    [self findSameTimeCourseWithArray:self.privateList targetValue:YES];
                    [self findSameTimeCourseWithArray:self.solonList targetValue:YES];
                    [self findSameTimeCourseWithArray:self.appList targetValue:YES];
                    // 刷新当前课程类型表格
                    [self refreshCurrentCourseTypeTableViewData];
                    // 将订课成功的对象存入数组
                    [self saveReserveInfoInArrayWithDict:responseObject];
                    // TODO:此处还可以查看订课详情
                } else {
                    [MBProgressHUD showError:responseObject[@"message"]];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                XHLog(@"订课失败:%@", error);
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"当前网络不好，请检查网络"];
            }];
        } else {
            // 发送排队请求
            urlStr = [NSString stringWithFormat:@"%@%@", baseURL, reminderQueueURL];
            [manager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                XHLog(@"排队成功:%@", responseObject);
                [MBProgressHUD hideHUD];
                if ([responseObject[@"state"] integerValue] == 1) {
                    [MBProgressHUD showSuccess:@"排队成功!"];
                } else {
                    [MBProgressHUD showError:responseObject[@"message"]];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                XHLog(@"排队失败:%@", error);
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"当前网络不好，请检查网络"];
            }];
        }
    }
}

#pragma mark - 课程详情页面订课成功发送过来的通知
- (void)saveOrderInfo:(NSNotification *)note
{
    // 修改时间是否冲突状态
    [self findSameTimeCourseWithArray:self.privateList targetValue:YES];
    [self findSameTimeCourseWithArray:self.solonList targetValue:YES];
    [self findSameTimeCourseWithArray:self.appList targetValue:YES];
    // 刷新表格
    [self refreshCurrentCourseTypeTableViewData];
    // 存入数组
    NSDictionary *responseObject = note.userInfo[kResponseObjectKey];
    [self saveReserveInfoInArrayWithDict:responseObject];
}

//不管是在XHWantOrderCourseController页面订课还是在XHCourseDetailController页面订课，最终都会来到这里
#pragma mark - 将订课信息存入数组
- (void)saveReserveInfoInArrayWithDict:(NSDictionary *)responseObject
{
    NSString *objectMsg = responseObject[@"message"];
    NSString *orderedID = [objectMsg substringFromIndex:objectMsg.length - 36];
    XHOrderedCourse *orderedCourse = [XHOrderedCourse orderedCourseWithOrderedID:orderedID course:self.course];
    [self.orderedCourseList addObject:orderedCourse];
    [NSKeyedArchiver archiveRootObject:self.orderedCourseList toFile:kOrderedCourseSavePath];
    XHLog(@"orderedID:%@", orderedID);
    // 更新订课记录页面数据
    [kNotificationCenter postNotificationName:kOrderCourseSuccessNotification object:self];
}

#pragma mark - 重新刷新表格数据
- (void)refreshCurrentCourseTypeTableViewData
{
    XHLog(@"%s", __func__);
    if (!self.checkImage1.isHidden) {
        self.dataList = self.privateList;
    } else if (!self.checkImage2.isHidden) {
        self.dataList = self.solonList;
    } else {
        self.dataList = self.appList;
    }
    [self.tableView reloadData];
}

- (void)findSameTimeCourseWithArray:(NSMutableArray *)Array targetValue:(BOOL)value
{
    for (XHCourse *course in Array) {
        if ([course.BeginTime isEqualToString:self.course.BeginTime] && course != self.course && course.EnableOrder == !value) {
            course.EnableOrder = value;
        }
    }
}

#pragma mark - 订课记录页面取消课程发送过来的通知，更新本页面的订课按钮状态
- (void)updateBtnStateUI:(NSNotification *)note
{
    NSString *cancelCourseID = note.userInfo[kCancelCourseIDKey];
    NSString *cancelCourseType = note.userInfo[kCancelCourseTypeKey];
    if ([cancelCourseType isEqualToString:@"小班课"]) {
        [self exchangeCourseStatus:cancelCourseID withTargetList:self.privateList];
    } else if ([cancelCourseType isEqualToString:@"沙龙课"]) {
        [self exchangeCourseStatus:cancelCourseID withTargetList:self.solonList];
    } else {
        [self exchangeCourseStatus:cancelCourseID withTargetList:self.appList];
    }
}

- (void)exchangeCourseStatus:(NSString *)courseID withTargetList:(NSMutableArray *)targetList
{
    for (XHCourse *course in targetList) {
        if ([course.CourseGuid isEqualToString:courseID]) {
            course.Reserved = NO;
            if ([course.OrderNumber integerValue] > 0) {
                course.OrderNumber = [NSString stringWithFormat:@"%zd", [self.course.OrderNumber integerValue] - 1];
            }
            self.course = course;
            break;
        }
    }
    // 修改时间是否冲突状态
    [self findSameTimeCourseWithArray:self.privateList targetValue:NO];
    [self findSameTimeCourseWithArray:self.solonList targetValue:NO];
    [self findSameTimeCourseWithArray:self.appList targetValue:NO];
    [self refreshCurrentCourseTypeTableViewData];
}

@end

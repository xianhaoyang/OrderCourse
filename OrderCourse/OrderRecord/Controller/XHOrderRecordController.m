//
//  XHOrderRecordController.m
//  OrderCourse
//
//  Created by 杨先豪 on 16/9/2.
//  Copyright © 2016年 yangxianhao. All rights reserved.
//

#import "XHOrderRecordController.h"
#import "XHRecordCell.h"
#import "XHOrderedCourse.h"
#import "XHConstant.h"
#import "HTMLParser.h"
#import "MBProgressHUD+XMG.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "XHCourseDetailController.h"

#define kOrderIDLength 36
#define kCourseIDLength kOrderIDLength
#define kListCount     20

@interface XHOrderRecordController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, XHRecordCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *orderedCourseList;
@property (nonatomic, strong) XHOrderedCourse *selectedOrderCourse;

@end

@implementation XHOrderRecordController

- (NSMutableArray *)orderedCourseList
{
    if (!_orderedCourseList) {
        _orderedCourseList = [NSMutableArray array];
    }
    return _orderedCourseList;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableviewUI];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestMyOrderedCourse)];
    [self.tableView.mj_header beginRefreshing];
    
    [kNotificationCenter addObserver:self selector:@selector(requestMyOrderedCourse) name:kOrderCourseSuccessNotification object:nil];
}

#pragma mark - 初始化tableViewUI
- (void)setupTableviewUI
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 160;
}

#pragma mark - 截取数据
- (void)requestMyOrderedCourse
{
    // HTMLParser
    NSString *urlStr = [NSString stringWithFormat:@"%@/wap/course/my_order/wid=1!openid=%@", baseURL, openid];
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:urlStr] error:&error];
    if (error) {
        [MBProgressHUD showError:@"当前网络状态不佳，请稍后再试..."];
        [self.tableView.mj_header endRefreshing];
        XHLog(@"Error: %@", error);
        return;
    }
    // 创建10个XHOrderedCourse对象
    [self.orderedCourseList removeAllObjects];
    for (NSInteger i = 0; i < kListCount; i++) {
        XHOrderedCourse *orderedCourse = [[XHOrderedCourse alloc] init];
        XHCourse *course = [[XHCourse alloc] init];
        orderedCourse.course = course;
        [self.orderedCourseList addObject:orderedCourse];
    }
    HTMLNode *bodyNode = [parser body];
    // 找出订课非orderid数据
    NSArray *spanNodes = [bodyNode findChildTags:@"div"];
    NSInteger i = 0;
    for (HTMLNode *spanNode in spanNodes) {
        if (i >= self.orderedCourseList.count) break;
        XHOrderedCourse *orderedCourse = self.orderedCourseList[i];
        if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"courseIcon"]) {
            NSString *str = [spanNode allContents];
            orderedCourse.course.CourseType = str;
        }
        if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"coureseRecordTitle"]) {
            NSString *str = [[spanNode allContents] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//            str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//            str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            orderedCourse.course.CourseName = str;
        }
        if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"courseRecordTime"]) {
            NSString *str = [[spanNode allContents] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//            str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
            orderedCourse.course.BeginTime = str;
        }
        if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"courseRecordState"]) {
            NSString *str = [[spanNode allContents] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//            str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//            str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            orderedCourse.state = str;
            i++;
        }
    }
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
    // 找出订课orderid数据
    NSArray *spanNodes1 = [bodyNode findChildTags:@"a"];
    NSInteger index = 0;
    for (HTMLNode *spanNode in spanNodes1) {
        if (index >= self.orderedCourseList.count) break;
        NSString *valueStr = [spanNode getAttributeNamed:@"href"];
//        XHLog(@"valueStr:%@", valueStr);
        NSString *orderID = [valueStr substringFromIndex:valueStr.length - kOrderIDLength];
        NSRange rang = [valueStr rangeOfString:openid];
        NSString *courseID = [valueStr substringWithRange:NSMakeRange(rang.location + rang.length + 1, kCourseIDLength)];
        XHOrderedCourse *orderedCourse = self.orderedCourseList[index];
        orderedCourse.orderID = orderID;
        orderedCourse.course.CourseGuid = courseID;
        index++;
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderedCourseList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHRecordCell *cell = [XHRecordCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.orderedCourse = self.orderedCourseList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHLog(@"%s--%zd", __func__, indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XHOrderedCourse *orderedCourse = self.orderedCourseList[indexPath.row];
    NSString *stateStr = [orderedCourse.state substringToIndex:3];
    if ([stateStr isEqualToString:@"已完成"]) return;
    NSArray *localOrderList = [NSKeyedUnarchiver unarchiveObjectWithFile:kOrderedCourseSavePath];
    for (XHOrderedCourse *localOrderCourse in localOrderList) {
        if ([localOrderCourse.course.CourseGuid isEqualToString:orderedCourse.course.CourseGuid]) {
            orderedCourse = localOrderCourse;
            break;
        }
    }
    XHCourseDetailController *detailController = [[XHCourseDetailController alloc] init];
    detailController.course = orderedCourse.course;
    detailController.fromControllerType = XHFromControllerTypeOrderRecord;
    [self.navigationController pushViewController:detailController animated:YES];
}

#pragma mark - XHRecordCellDelegate
- (void)recordCellDidClickCancelOrderBtn:(XHRecordCell *)recordCell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:recordCell];
    XHOrderedCourse *orderedCourse = self.orderedCourseList[indexPath.row];
    self.selectedOrderCourse = orderedCourse;
    NSString *title = [NSString stringWithFormat:@"您确定要取消该课程的预订吗?\n%@:%@\n%@", orderedCourse.course.CourseType, orderedCourse.course.CourseName, orderedCourse.course.BeginTime];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    XHLog(@"%s--%zd", __func__, buttonIndex);
    if (buttonIndex == 0) {
        [MBProgressHUD showMessage:@"取消中，请稍等..."];
        // 发送预定请求
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 3.0f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSString *urlStr = [NSString stringWithFormat:@"%@%@", baseURL, cancelOrderURL];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"appUserId"] = userid;
        parameters[@"openId"] = openid;
        parameters[@"orderGuid"] = self.selectedOrderCourse.orderID;
        parameters[@"courseGuid"] = self.selectedOrderCourse.course.CourseGuid;
        parameters[@"contractGuid"] = contractGuid;
        [manager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary  *_Nullable responseObject) {
            XHLog(@"取消成功:%@", responseObject);
            [MBProgressHUD hideHUD];
            if ([responseObject[@"state"] integerValue] == 1) {
                [MBProgressHUD showSuccess:@"取消成功!"];
                // 更新界面数据
                [self requestMyOrderedCourse];
                // 更新本地订课数组记录, 删除取消的课程
                [self refreshLocalOrderedCourseArray];
                // 通知首页更新订课状态UI
                [self updateHomeStateUI];
            } else {
                [MBProgressHUD showError:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            XHLog(@"取消失败:%@", error);
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"当前网络不好，请检查网络"];
        }];
    }
}

#pragma mark - 通知首页更新订课状态UI
- (void)updateHomeStateUI
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[kCancelCourseIDKey] = self.selectedOrderCourse.course.CourseGuid;
    dict[kCancelCourseTypeKey] = self.selectedOrderCourse.course.CourseType;
    [kNotificationCenter postNotificationName:kCancelCourseSuccessNotification object:self userInfo:dict];
}

#pragma mark - 更新本地订课数组记录
- (void)refreshLocalOrderedCourseArray
{
    NSArray *orderedCourseList = [NSKeyedUnarchiver unarchiveObjectWithFile:kOrderedCourseSavePath];
    NSMutableArray *temp = [NSMutableArray arrayWithArray:orderedCourseList];
    for (XHOrderedCourse *orderedcourse in orderedCourseList) {
        if ([orderedcourse.orderID isEqualToString:self.selectedOrderCourse.orderID]) {
            [temp removeObject:orderedcourse];
            break;
        }
    }
    [NSKeyedArchiver archiveRootObject:temp toFile:kOrderedCourseSavePath];
}

@end

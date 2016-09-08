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

#define kOrderIDLength 36
#define kListCount     10

@interface XHOrderRecordController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *orderedCourseList;

@end

@implementation XHOrderRecordController

- (NSMutableArray *)orderedCourseList
{
    if (!_orderedCourseList) {
        _orderedCourseList = [NSMutableArray array];
    }
    return _orderedCourseList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 160;
    
    [self requestMyOrderedCourse];
}

- (void)requestMyOrderedCourse
{
    // HTMLParser
    NSString *urlStr = [NSString stringWithFormat:@"%@/wap/course/my_order/wid=1!openid=%@", baseURL, openid];
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:urlStr] error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
        return;
    }
    // 创建10个XHOrderedCourse对象
    for (NSInteger i = 0; i < kListCount; i++) {
        XHOrderedCourse *orderedCourse = [[XHOrderedCourse alloc] init];
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
            orderedCourse.CourseType = [spanNode allContents];
        }
        if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"coureseRecordTitle"]) {
            NSString *str = [[spanNode allContents] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//            str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//            str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            orderedCourse.CourseName = str;
        }
        if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"courseRecordTime"]) {
            NSString *str = [[spanNode allContents] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//            str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//            str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            orderedCourse.BeginTime = str;
        }
        if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"courseRecordState"]) {
            NSString *str = [[spanNode allContents] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//            str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//            str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            orderedCourse.state = str;
            i++;
        }
    }
    // 找出订课orderid数据
    NSArray *spanNodes1 = [bodyNode findChildTags:@"a"];
    NSInteger index = 0;
    for (HTMLNode *spanNode in spanNodes1) {
        if (index >= self.orderedCourseList.count) break;
        NSString *valueStr = [spanNode getAttributeNamed:@"href"];
        NSString *orderid = [valueStr substringFromIndex:valueStr.length - kOrderIDLength];
        XHOrderedCourse *course = self.orderedCourseList[index];
        course.orderID = orderid;
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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

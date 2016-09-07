//
//  XHOrderRecordController.m
//  OrderCourse
//
//  Created by 杨先豪 on 16/9/2.
//  Copyright © 2016年 yangxianhao. All rights reserved.
//

#import "XHOrderRecordController.h"
#import "XHOrderedCourse.h"
#import "XHConstant.h"
#import "HTMLParser.h"

#define kOrderIDLength 36

@interface XHOrderRecordController ()

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
    
    [self requestMyOrderedCourse];
}

- (void)requestMyOrderedCourse
{
    // HTMLParser
    NSString *urlStr = [NSString stringWithFormat:@"%@/wap/course/my_order/wid=1!openid=oXoOjt9tI9bAOy0TVyt4CvZLDwDQ", baseURL];
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:urlStr] error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
        return;
    }
    HTMLNode *bodyNode = [parser body];
    // 找出订课非orderid数据
    NSArray *spanNodes = [bodyNode findChildTags:@"div"];
    for (HTMLNode *spanNode in spanNodes) {
        XHOrderedCourse *orderedCourse = [[XHOrderedCourse alloc] init];
        if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"courseIcon"]) {
            orderedCourse.CourseType = [spanNode allContents];
        }
        if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"coureseRecordTitle"]) {
            orderedCourse.CourseName = [[spanNode allContents] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"courseRecordTime"]) {
            orderedCourse.BeginTime = [[spanNode allContents] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"courseRecordState"]) {
            orderedCourse.state = [[spanNode allContents] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        [self.orderedCourseList addObject:orderedCourse];
    }
    // 找出订课orderid数据
    NSArray *spanNodes1 = [bodyNode findChildTags:@"a"];
    NSInteger index = 0;
    for (HTMLNode *spanNode in spanNodes1) {
        NSString *valueStr = [spanNode getAttributeNamed:@"href"];
        NSString *orderid = [valueStr substringFromIndex:valueStr.length - kOrderIDLength];
        XHOrderedCourse *course = self.orderedCourseList[index];
        course.orderID = orderid;
        index++;
        if (index > self.orderedCourseList.count) break;
    }
    NSLog(@"---");
}

@end

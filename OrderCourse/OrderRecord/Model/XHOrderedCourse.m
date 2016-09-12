//
//  XHOrderedCourse.m
//  OrderCourse
//
//  Created by bluechips on 16/9/7.
//  Copyright © 2016年 yangxianhao. All rights reserved.
//

#import "XHOrderedCourse.h"

static NSString *orderedID = @"orderedID";
static NSString *courseGuID = @"courseGuID";
static NSString *beginTimeStr = @"beginTimeStr";

@implementation XHOrderedCourse

+ (instancetype)orderedCourseWithOrderedID:(NSString *)orderedID courseGuID:(NSString *)courseGuID beginTimeStr:(NSString *)beginTimeStr
{
    XHOrderedCourse *orderedCourse = [[self alloc] init];
    orderedCourse.orderID = orderedID;
    orderedCourse.CourseGuid = courseGuID;
    orderedCourse.BeginTime = beginTimeStr;
    return orderedCourse;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.orderID forKey:orderedID];
    [encoder encodeObject:self.CourseGuid forKey:courseGuID];
    [encoder encodeObject:self.BeginTime forKey:beginTimeStr];
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.orderID = [decoder decodeObjectForKey:orderedID];
        self.CourseGuid = [decoder decodeObjectForKey:courseGuID];
        self.BeginTime = [decoder decodeObjectForKey:beginTimeStr];
    }
    return self;
}

@end

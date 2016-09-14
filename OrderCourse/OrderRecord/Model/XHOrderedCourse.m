//
//  XHOrderedCourse.m
//  OrderCourse
//
//  Created by bluechips on 16/9/7.
//  Copyright © 2016年 yangxianhao. All rights reserved.
//

#import "XHOrderedCourse.h"

static NSString *orderedID = @"orderedID";
static NSString *course = @"course";

@implementation XHOrderedCourse

+ (instancetype)orderedCourseWithOrderedID:(NSString *)orderedID course:(XHCourse *)course
{
    XHOrderedCourse *orderedCourse = [[self alloc] init];
    orderedCourse.orderID = orderedID;
    orderedCourse.course = course;
    return orderedCourse;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.orderID forKey:orderedID];
    [encoder encodeObject:self.course forKey:course];
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.orderID = [decoder decodeObjectForKey:orderedID];
        self.course = [decoder decodeObjectForKey:course];
    }
    return self;
}

@end

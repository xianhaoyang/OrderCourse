//
//  XHOrderedCourse.m
//  OrderCourse
//
//  Created by bluechips on 16/9/7.
//  Copyright © 2016年 yangxianhao. All rights reserved.
//

#import "XHOrderedCourse.h"

static NSString *orderedID = @"orderedID";
static NSString *Teacher = @"Teacher";
static NSString *CourseType = @"CourseType";
static NSString *CourseName = @"CourseName";
static NSString *Topic = @"Topic";
static NSString *ClassRoom = @"ClassRoom";
static NSString *BeginTime = @"BeginTime";
static NSString *Capacity = @"Capacity";
static NSString *OrderNumber = @"OrderNumber";
static NSString *CourseLevel = @"CourseLevel";

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
    [encoder encodeObject:self.course.Teacher forKey:Teacher];
    [encoder encodeObject:self.course.CourseType forKey:CourseType];
    [encoder encodeObject:self.course.CourseName forKey:CourseName];
    [encoder encodeObject:self.course.Topic forKey:Topic];
    [encoder encodeObject:self.course.ClassRoom forKey:ClassRoom];
    [encoder encodeObject:self.course.BeginTime forKey:BeginTime];
    [encoder encodeObject:self.course.Capacity forKey:Capacity];
    [encoder encodeObject:self.course.OrderNumber forKey:OrderNumber];
    [encoder encodeObject:self.course.CourseLevel forKey:CourseLevel];
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.orderID = [decoder decodeObjectForKey:orderedID];
        self.course.Teacher = [decoder decodeObjectForKey:Teacher];
        self.course.CourseType = [decoder decodeObjectForKey:CourseType];
        self.course.CourseName = [decoder decodeObjectForKey:CourseName];
        self.course.Topic = [decoder decodeObjectForKey:Topic];
        self.course.ClassRoom = [decoder decodeObjectForKey:ClassRoom];
        self.course.BeginTime = [decoder decodeObjectForKey:BeginTime];
        self.course.Capacity = [decoder decodeObjectForKey:Capacity];
        self.course.OrderNumber = [decoder decodeObjectForKey:OrderNumber];
        self.course.CourseLevel = [decoder decodeObjectForKey:CourseLevel];
    }
    return self;
}

@end

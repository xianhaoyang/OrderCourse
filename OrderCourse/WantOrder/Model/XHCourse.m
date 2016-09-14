//
//  XHCourse.m
//  OrderCourse
//
//  Created by 杨先豪 on 16/9/2.
//  Copyright © 2016年 yangxianhao. All rights reserved.
//

#import "XHCourse.h"

static NSString *CourseGuid = @"CourseGuid";
static NSString *Teacher = @"Teacher";
static NSString *CourseType = @"CourseType";
static NSString *CourseName = @"CourseName";
static NSString *Topic = @"Topic";
static NSString *ClassRoom = @"ClassRoom";
static NSString *BeginTime = @"BeginTime";
static NSString *Capacity = @"Capacity";
static NSString *OrderNumber = @"OrderNumber";
static NSString *CourseLevel = @"CourseLevel";

@implementation XHCourse

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.CourseGuid forKey:CourseGuid];
    [encoder encodeObject:self.Teacher forKey:Teacher];
    [encoder encodeObject:self.CourseType forKey:CourseType];
    [encoder encodeObject:self.CourseName forKey:CourseName];
    [encoder encodeObject:self.Topic forKey:Topic];
    [encoder encodeObject:self.ClassRoom forKey:ClassRoom];
    [encoder encodeObject:self.BeginTime forKey:BeginTime];
    [encoder encodeObject:self.Capacity forKey:Capacity];
    [encoder encodeObject:self.OrderNumber forKey:OrderNumber];
    [encoder encodeObject:self.CourseLevel forKey:CourseLevel];
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.CourseGuid = [decoder decodeObjectForKey:CourseGuid];
        self.Teacher = [decoder decodeObjectForKey:Teacher];
        self.CourseType = [decoder decodeObjectForKey:CourseType];
        self.CourseName = [decoder decodeObjectForKey:CourseName];
        self.Topic = [decoder decodeObjectForKey:Topic];
        self.ClassRoom = [decoder decodeObjectForKey:ClassRoom];
        self.BeginTime = [decoder decodeObjectForKey:BeginTime];
        self.Capacity = [decoder decodeObjectForKey:Capacity];
        self.OrderNumber = [decoder decodeObjectForKey:OrderNumber];
        self.CourseLevel = [decoder decodeObjectForKey:CourseLevel];
    }
    return self;
}

@end

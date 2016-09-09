//
//  XHReservedCourse.m
//  OrderCourse
//
//  Created by 杨先豪 on 16/9/9.
//  Copyright © 2016年 yangxianhao. All rights reserved.
//

#import "XHReservedCourse.h"

static NSString *reserveID = @"reserveID";
static NSString *courseGuID = @"courseGuID";
static NSString *reserveTimeStr = @"reserveTimeStr";

@implementation XHReservedCourse

+ (instancetype)reservedCourseWithReserveID:(NSString *)reserveID courseGuID:(NSString *)courseGuID reserveTimeStr:(NSString *)reserveTimeStr
{
    XHReservedCourse *reservedCourse = [[self alloc] init];
    reservedCourse.reserveID = reserveID;
    reservedCourse.courseGuID = courseGuID;
    reservedCourse.reserveTimeStr = reserveTimeStr;
    return reservedCourse;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.reserveID forKey:reserveID];
    [encoder encodeObject:self.courseGuID forKey:courseGuID];
    [encoder encodeObject:self.reserveTimeStr forKey:reserveTimeStr];
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.reserveID = [decoder decodeObjectForKey:reserveID];
        self.courseGuID = [decoder decodeObjectForKey:courseGuID];
        self.reserveTimeStr = [decoder decodeObjectForKey:reserveTimeStr];
    }
    return self;
}

@end

//
//  XHReservedCourse.m
//  OrderCourse
//
//  Created by 杨先豪 on 16/9/9.
//  Copyright © 2016年 yangxianhao. All rights reserved.
//

#import "XHReservedCourse.h"

@implementation XHReservedCourse

- (instancetype)initWithReserveID:(NSString *)reserveID timeStr:(NSString *)timeStr
{
    if (self = [super init]) {
        self.reserveID = reserveID;
        self.reserveTimeStr = timeStr;
    }
    return self;
}

@end

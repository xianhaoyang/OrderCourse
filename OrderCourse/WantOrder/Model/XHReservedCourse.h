//
//  XHReservedCourse.h
//  OrderCourse
//
//  Created by 杨先豪 on 16/9/9.
//  Copyright © 2016年 yangxianhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHReservedCourse : NSObject<NSCoding>

+ (instancetype)reservedCourseWithReserveID:(NSString *)reserveID courseGuID:(NSString *)courseGuID reserveTimeStr:(NSString *)reserveTimeStr;
/**
 *  就是orderID
 */
@property (nonatomic, copy, readwrite) NSString *reserveID;
/**
 *  课程id
 */
@property (nonatomic, copy, readwrite) NSString *courseGuID;
/**
 *  预订课程时间
 */
@property (nonatomic, copy, readwrite) NSString *reserveTimeStr;

@end

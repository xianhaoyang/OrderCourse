//
//  XHOrderedCourse.h
//  OrderCourse
//
//  Created by bluechips on 16/9/7.
//  Copyright © 2016年 yangxianhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHCourse.h"

@interface XHOrderedCourse : NSObject

+ (instancetype)orderedCourseWithOrderedID:(NSString *)orderedID course:(XHCourse *)course;
/**
 *  预定成功返回的orderID
 */
@property (nonatomic, readwrite, copy) NSString *orderID;
@property (nonatomic, copy, readwrite) NSString *state;
@property (nonatomic, strong) XHCourse *course;

@end

//
//  XHReservedCourse.h
//  OrderCourse
//
//  Created by 杨先豪 on 16/9/9.
//  Copyright © 2016年 yangxianhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHReservedCourse : NSObject

- (instancetype)initWithReserveID:(NSString *)reserveID timeStr:(NSString *)timeStr;

/**
 *  就是orderID
 */
@property (nonatomic, copy, readwrite) NSString *reserveID;
/**
 *  预订课程时间
 */
@property (nonatomic, copy, readwrite) NSString *reserveTimeStr;

@end

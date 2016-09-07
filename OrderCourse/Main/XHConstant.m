//
//  XHConstant.m
//  OrderCourse
//
//  Created by 杨先豪 on 16/9/3.
//  Copyright © 2016年 yangxianhao. All rights reserved.
//

#import "XHConstant.h"

@implementation XHConstant

@end
// 可变常量
NSString *const openid = @"";
NSString *const userId = @"";
NSString *const contractGuid = @"";

// 不变常量
NSString *const baseURL = @"http://ols.webi.com.cn";
// 订课
NSString *const orderCourseURL = @"/api/course/confirm_order";
// 排队提醒
NSString *const reminderQueueURL = @"/api/course/add_reminder_queue";
// 取消订课
NSString *const cancelOrderURL = @"/api/course/cancle_order";
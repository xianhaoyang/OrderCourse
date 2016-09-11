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
NSString *const openid = @"oXoOjt9tI9bAOy0TVyt4CvZLDwDQ";
NSString *const userid = @"660aaf5e-b7ab-4157-b333-ae2e3328ab02";
NSString *const contractGuid = @"ad36003e-5b52-e611-80d1-02bf0a00005b";

// 不变常量
NSString *const baseURL = @"http://ols.webi.com.cn";
// 订课
NSString *const orderCourseURL = @"/api/course/confirm_order";
// 排队提醒
NSString *const reminderQueueURL = @"/api/course/add_reminder_queue";
// 取消订课
NSString *const cancelOrderURL = @"/api/course/cancle_order";


NSString *const kCourseDetailControllerReserveCourseSuccessNotification = @"kCourseDetailControllerReserveCourseSuccessNotification";
NSString *const kResponseObjectKey = @"kResponseObjectKey";
NSString *const kCancelCourseSuccessNotification = @"kCancelCourseSuccessNotification";
NSString *const kCancelCourseIDKey = @"kCancelCourseIDKey";
NSString *const kCancelCourseTypeKey = @"kCancelCourseTypeKey";




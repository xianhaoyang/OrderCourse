//
//  XHConstant.h
//  OrderCourse
//
//  Created by 杨先豪 on 16/9/3.
//  Copyright © 2016年 yangxianhao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kNotificationCenter [NSNotificationCenter defaultCenter]
#define kOrderedCourseSavePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"orderedCourse.data"]

@interface XHConstant : NSObject

@end

extern NSString *const openid;
extern NSString *const userid;
extern NSString *const contractGuid;
extern NSString *const baseURL;
extern NSString *const orderCourseURL;
extern NSString *const reminderQueueURL;
extern NSString *const cancelOrderURL;

extern NSString *const kCourseDetailControllerReserveCourseSuccessNotification;
extern NSString *const kResponseObjectKey;
extern NSString *const kCancelCourseSuccessNotification;
extern NSString *const kCancelCourseIDKey;
extern NSString *const kCancelCourseTypeKey;


//
//  XHConstant.h
//  OrderCourse
//
//  Created by 杨先豪 on 16/9/3.
//  Copyright © 2016年 yangxianhao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kRBGColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface XHConstant : NSObject

@end

extern NSString *const openid;
extern NSString *const userid;
extern NSString *const contractGuid;
extern NSString *const baseURL;
extern NSString *const orderCourseURL;
extern NSString *const reminderQueueURL;
extern NSString *const cancelOrderURL;
//
//  XHCourseDetailController.h
//  OrderCourse
//
//  Created by 杨先豪 on 16/9/4.
//  Copyright © 2016年 yangxianhao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XHCourse;

typedef NS_ENUM(NSUInteger, XHFromControllerType) {
    XHFromControllerTypeWantOrder = 0,
    XHFromControllerTypeOrderRecord = 1,
};
@interface XHCourseDetailController : UIViewController

@property (nonatomic, strong) XHCourse *course;
@property (nonatomic, assign) XHFromControllerType fromControllerType;

@end
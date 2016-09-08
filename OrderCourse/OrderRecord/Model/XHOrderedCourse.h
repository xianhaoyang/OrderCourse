//
//  XHOrderedCourse.h
//  OrderCourse
//
//  Created by bluechips on 16/9/7.
//  Copyright © 2016年 yangxianhao. All rights reserved.
//

#import "XHCourse.h"

@interface XHOrderedCourse : XHCourse

@property (nonatomic, readwrite, copy) NSString *orderID;
@property (nonatomic, copy, readwrite) NSString *state;

@end

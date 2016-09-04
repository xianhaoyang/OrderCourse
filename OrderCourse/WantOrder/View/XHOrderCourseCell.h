//
//  XHOrderCourseCell.h
//  OrderCourse
//
//  Created by 杨先豪 on 16/9/3.
//  Copyright © 2016年 yangxianhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate+Calculations.h"
@class XHCourse, XHOrderCourseCell;

@protocol XHOrderCourseCellDelegate <NSObject>

@optional
- (void)orderCourseCell:(XHOrderCourseCell *)cell didClickBtn:(UIButton *)btn;

@end

@interface XHOrderCourseCell : UITableViewCell

@property (nonatomic, strong) XHCourse *course;
@property (nonatomic, weak) id<XHOrderCourseCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

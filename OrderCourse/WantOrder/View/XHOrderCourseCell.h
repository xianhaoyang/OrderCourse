//
//  XHOrderCourseCell.h
//  OrderCourse
//
//  Created by 杨先豪 on 16/9/3.
//  Copyright © 2016年 yangxianhao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XHCourse;

@interface XHOrderCourseCell : UITableViewCell

@property (nonatomic, strong) XHCourse *course;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

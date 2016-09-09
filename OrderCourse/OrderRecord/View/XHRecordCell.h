//
//  XHRecordCell.h
//  OrderCourse
//
//  Created by bluechips on 16/9/8.
//  Copyright © 2016年 yangxianhao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XHOrderedCourse;

@interface XHRecordCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) XHOrderedCourse *course;

@end

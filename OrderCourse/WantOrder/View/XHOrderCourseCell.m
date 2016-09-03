//
//  XHOrderCourseCell.m
//  OrderCourse
//
//  Created by 杨先豪 on 16/9/3.
//  Copyright © 2016年 yangxianhao. All rights reserved.
//

#import "XHOrderCourseCell.h"

@interface XHOrderCourseCell ()

@property (weak, nonatomic) IBOutlet UIImageView *statusImg;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIView *timeBgView;
@property (weak, nonatomic) IBOutlet UIView *topicBgView;

@end

@implementation XHOrderCourseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.timeBgView.layer.cornerRadius = 5.0f;
    self.timeBgView.clipsToBounds = YES;
    self.topicBgView.layer.cornerRadius = 5.0f;
    self.topicBgView.clipsToBounds = YES;
    self.btn.layer.cornerRadius = 10.0f;
    self.btn.clipsToBounds = YES;
    self.backgroundView = nil;
    self.backgroundColor = [UIColor clearColor];
}

- (void)setCourse:(XHCourse *)course
{
    _course = course;
    
}

- (IBAction)clickBtn {
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"XHOrderCourseCell";
    XHOrderCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    }
    return cell;
}

@end

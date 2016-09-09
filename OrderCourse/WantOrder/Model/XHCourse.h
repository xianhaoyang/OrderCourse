//
//  XHCourse.h
//  OrderCourse
//
//  Created by 杨先豪 on 16/9/2.
//  Copyright © 2016年 yangxianhao. All rights reserved.
//

#import <Foundation/Foundation.h>

//"CenterGuid": "4e0e8db0-c743-e411-80d7-000c2957ec4f",
//"CenterName": "武汉光谷中心",
//"City": "武汉",
//"CourseGuid": "6c837cb5-d069-e611-80ce-02bf0a00005b",
//"CourseName": "Begn-S-16",
//"CourseType": "沙龙课",
//"ClassRoom": "Salon Room 1",
//"Teacher": "gg esl1gg esl1",
//"Topic": "Stem Sentences.",
//"BeginTime": "2016-09-03T11:00:00",
//"EndTime": "2016-09-03T12:00:00",
//"Capacity": 10,
//"OrderNumber": 10,
//"CourseLevel": "B",
//"CurrentLevelOrder": "4",
//"CourseOrder": 16,
//"WebExMettingId": null,
//"AttendanceState": null,
//"ResultState": null,
//"Score": null,
//"Comment": null,
//"IsInvited": false
/*******自己添加属性*******/
//@"Reserve"

@interface XHCourse : NSObject
/**
 *  是否预定了课程
 */
@property (nonatomic, assign, getter=isReserved) BOOL Reserved;
/**
 *  中心id
 */
@property (nonatomic, copy, readwrite) NSString *CenterGuid;
/**
 *  中心名称
 */
@property (nonatomic, copy, readwrite) NSString *CenterName;
/**
 *  城市
 */
@property (nonatomic, copy, readwrite) NSString *City;
/**
 *  课程id
 */
@property (nonatomic, copy, readwrite) NSString *CourseGuid;
/**
 *  课程名
 */
@property (nonatomic, copy, readwrite) NSString *CourseName;
/**
 *  课程类型
 */
@property (nonatomic, copy, readwrite) NSString *CourseType;
/**
 *  上课教室
 */
@property (nonatomic, copy, readwrite) NSString *ClassRoom;
/**
 *  上课老师
 */
@property (nonatomic, copy, readwrite) NSString *Teacher;
/**
 *  课程主题
 */
@property (nonatomic, copy, readwrite) NSString *Topic;
/**
 *  开始时间
 */
@property (nonatomic, copy, readwrite) NSString *BeginTime;
/**
 *  结束时间
 */
@property (nonatomic, copy, readwrite) NSString *EndTime;
/**
 *  课程容量
 */
@property (nonatomic, copy, readwrite) NSString *Capacity;
/**
 *  预定人数
 */
@property (nonatomic, copy, readwrite) NSString *OrderNumber;
/**
 *  课程级别
 */
@property (nonatomic, copy, readwrite) NSString *CourseLevel;
/**
 *  课程排队人数
 */
@property (nonatomic, copy, readwrite) NSString *CourseOrder;
/**
 *  <#Description#>
 */
@property (nonatomic, copy, readwrite) NSString *CurrentLevelOrder;
/**
 *  <#Description#>
 */
@property (nonatomic, copy, readwrite) NSString *WebExMettingId;
/**
 *  <#Description#>
 */
@property (nonatomic, copy, readwrite) NSString *AttendanceState;
/**
 *  <#Description#>
 */
@property (nonatomic, copy, readwrite) NSString *ResultState;
/**
 *  <#Description#>
 */
@property (nonatomic, copy, readwrite) NSString *Score;
/**
 *  <#Description#>
 */
@property (nonatomic, copy, readwrite) NSString *Comment;
/**
 *  <#Description#>
 */
@property (nonatomic, assign) BOOL IsInvited;

@end

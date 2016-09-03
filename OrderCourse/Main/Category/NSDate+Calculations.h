//
//  NSDate+Calculations.h
//  NSDateCalculations
//
//  Created by Oscar Del Ben on 2/27/11.
//  Copyright 2011 DibiStore. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (Calculations)
///**
// *  将一个形如“12月03日”的字符串转换成当前年形如“2015-12-3”的日期类型
// */
//+ (NSDate *)dateFromString:(NSString *)dateStr;
/**
 *  将一个形如“2015-12-3”的字符串转化成一个日期类型
 */
+ (NSDate *)dateFromString:(NSString *)dateStr withFormatter:(NSString *)fmr;
/**
 *  计算特定日期是周几
 */
+ (NSString *)weekdayStringFromDate:(NSDate*)inputDate;
+ (NSDate *)dateWithYear:(int)year month:(int)month day:(int)day hour:(int)hour minute:(int)minute second:(int)second;
+ (NSDate *)createDate:(int)year month:(int)month day:(int)day hour:(int)hour minute:(int)minute second:(int)second; /* DEPRECATED */

- (NSDate *)beginningOfDay;
- (NSDate *)beginningOfMonth;
- (NSDate *)beginningOfQuarter;
- (NSDate *)beginningOfWeek;
- (NSDate *)beginningOfYear;

- (NSDate *)endOfDay;
- (NSDate *)endOfMonth;
- (NSDate *)endOfQuarter;
- (NSDate *)endOfWeek;
- (NSDate *)endOfYear;

- (NSDate *)advance:(int)years months:(int)months weeks:(int)weeks days:(int)days 
			  hours:(int)hours minutes:(int)minutes seconds:(int)seconds;

- (NSDate *)ago:(int)years months:(int)months weeks:(int)weeks days:(int)days 
			  hours:(int)hours minutes:(int)minutes seconds:(int)seconds;

- (NSDate *)change:(NSDictionary *)changes;

- (NSUInteger)daysInMonth;

- (NSDate *)monthsSince:(int)months;
- (NSDate *)yearsSince:(int)years;

- (NSDate *)nextMonth;
- (NSDate *)nextWeek;
- (NSDate *)nextYear;

- (NSDate *)prevMonth;
- (NSDate *)prevYear;
- (NSDate *)yearsAgo:(int)years;
- (NSDate *)yesterday;

- (NSDate *)tomorrow;

- (BOOL)future;
- (BOOL)past;
- (BOOL)today;

@end

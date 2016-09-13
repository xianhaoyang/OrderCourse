//
//  NSDate+Calculations.h
//  NSDateCalculations
//
//  Created by Oscar Del Ben on 2/27/11.
//  Copyright 2011 DibiStore. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (Calculations)

/**
 *  字符串转NSDate
 *
 *  @param theTime 字符串时间
 *  @param format  转化格式 如yyyy-MM-dd HH:mm:ss,即2015-07-15 15:00:00
 *
 *  @return <#return value description#>
 */
+ (NSDate *)dateFromString:(NSString *)timeStr format:(NSString *)format;
/**
 *  NSDate转字符串
 *
 *  @param date   NSDate时间
 *  @param format 转化格式 如yyyy-MM-dd HH:mm:ss,即2015-07-15 15:00:00
 *
 *  @return 返回字符串格式时间
 */
+ (NSString *)datestrFromDate:(NSDate *)date withDateFormat:(NSString *)format;
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

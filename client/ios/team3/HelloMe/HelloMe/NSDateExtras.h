//
//  NSDateExtras.h
//  HelloMe
//
//  Created by Smartphone25 on 2013/12/17.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef __LN_DATE_EXTRAS__
#define __LN_DATE_EXTRAS__

#define LN_DATE_FORMAT @"yyyy/M/d"

@interface NSDate (Extras)
-(NSString *)stringFormat:(NSString *)format;
-(NSString *)toShortDateString;

-(NSDate *)addDay:(NSInteger)days;
-(NSDate *)addDay:(NSInteger) days withCalendar:(NSCalendar *)calendar;
-(NSDate *)addMonth:(NSInteger)month;
+(NSDate *)today;
+(NSDate *)dateYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+(NSDate *)firstDayOfCurrentMonth;
+(NSInteger)numberOfDaysInMonth:(NSDate *)month;
-(NSDate *)roundAtDay;
-(NSDate *)firstDayOfMonth;
-(BOOL)greaterThan:(NSDate *)other;
-(BOOL)greaterEqual:(NSDate *)other;
-(BOOL)lessThan:(NSDate *)other;
-(BOOL)lessEqual:(NSDate *)other;
-(BOOL)equals:(NSDate *)other;
-(NSInteger)dayIntervalSinceDate:(NSDate *)other;
-(NSNumber *)millisecondsSinceNow;
+(NSDate *)dateWithMillisecondsSinceNow:(NSNumber *)msec;
-(NSInteger)day;
+(NSDate*)dateFromRFC1123:(NSString*)value_;
- (NSArray *)arrayOfDateTo:(NSDate *)to;
+(NSDate *)dateFromString:(NSString*)dateString withFormat:(NSString*)format;
-(int) intValueWithYMD;
-(NSNumber*) numberValueWithYMD;
+(NSDate*) dateFromNumberOfYMD:(NSNumber*)number;
+(NSDate*)dateFromShortDateString:(NSString*)dateString;
+(NSDate*)dateFromLongDateString:(NSString*)dateString;
+(NSDate *)now;
+(NSString *)addSlashToShortDateString:(NSString*)dateString;
+(NSString *)deleteSlashFromDateString:(NSString*)dateStringWithSlash;
+(NSDate*)dateFromYYMMDDHHMM:(NSString*)value;


+(NSDate *)dateFromZero:(NSDate *)date;
+(NSDate *)firstDayOfTheMonth:(NSDate *)day;
+(NSDate *)lastDayOfTheMonth:(NSDate *)day;
@end

#endif

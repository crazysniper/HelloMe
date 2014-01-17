//
//  NSDateExtras.m
//  HelloMe
//
//  Created by eva.yuanzi on 2013/12/17.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import "NSDateExtras.h"

@implementation NSDate (Extras)
-(NSString *)stringFormat:(NSString *)format {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	[formatter setLocale:usLocale];
    
	if (format == nil || [format length] == 0) {
		[formatter setDateFormat:LN_DATE_FORMAT];
	} else {
		[formatter setDateFormat:format];
	}
	NSString *dateLabel = [formatter stringFromDate:self];
	return dateLabel;
}

-(NSString *)toShortDateString {
	return [self stringFormat:@"yyyy/MM/dd"];
}


+(NSDate *)dateFromZero:(NSDate *)date {
    NSString *strDate = [NSString stringWithFormat:@"%@000000000", [[date stringFormat:@"yyyyMMddHHmmssSSS"] substringToIndex:8]];
    
    static NSDateFormatter *dataFormat = nil;
    if(dataFormat == nil)
    {
        dataFormat = [[NSDateFormatter alloc] init];
        dataFormat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        dataFormat.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        dataFormat.dateFormat = @"yyyyMMddHHmmssSSS";
    }
    
    return [dataFormat dateFromString:strDate];
}

-(NSDate *)addDay:(NSInteger) days {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *comps = [calendar components:0xff fromDate:self];
	[comps setDay:([comps day] + days)];
	return [calendar dateFromComponents:comps];
}
-(NSDate *)addDay:(NSInteger) days withCalendar:(NSCalendar *)calendar {
	NSDateComponents *comps = [calendar components:0xff fromDate:self];
	[comps setDay:([comps day] + days)];
	return [calendar dateFromComponents:comps];
}
-(NSDate *)addMonth:(NSInteger) month {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *comps = [calendar components:0xff fromDate:self];
	[comps setMonth:([comps month] + month)];
	return [calendar dateFromComponents:comps];
}

+(NSDate *)today {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *comps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
	return [calendar dateFromComponents:comps];
}

+(NSDate *)now {
    //	NSCalendar *calendar = [NSCalendar currentCalendar];
    //	NSDateComponents *comps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:[NSDate date]];
    //	return [calendar dateFromComponents:comps];
    return [[NSDate alloc] init];
}

+(NSDate *)dateYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setYear:year];
	[comps setMonth:month];
	[comps setDay:day];
	NSDate* _d = [calendar dateFromComponents:comps];
	return _d;
}
+(NSDate *)firstDayOfCurrentMonth {
	NSDate *now = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *comps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:now];
	[comps setDay:1]; // 当月の1日をセット
	return [calendar dateFromComponents:comps];
}

+(NSDate *)firstDayOfTheMonth:(NSDate *)day{
    NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *comps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:day];
	[comps setDay:1]; // 当月の1日をセット
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
	return [calendar dateFromComponents:comps];
}

+(NSDate *)lastDayOfTheMonth:(NSDate *)day {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:day];
    NSDateComponents *comps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[[self firstDayOfTheMonth:day]addDay:(range.length - 1)]];
    [comps setHour:23];
    [comps setMinute:59];
    [comps setSecond:59];
    return [calendar dateFromComponents:comps];;
}

-(NSDate *)firstDayOfMonth {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *comps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
	[comps setDay:1]; // 当月の1日をセット
	return [calendar dateFromComponents:comps];
}
-(NSInteger)day {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *comps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
	return [comps day];
}

+(NSInteger)numberOfDaysInMonth:(NSDate *)firstDayOfMonth {
	NSDateComponents *addOneMonthSubtractOneDay = [[NSDateComponents alloc] init];
	[addOneMonthSubtractOneDay setMonth:1];
	[addOneMonthSubtractOneDay setDay:-1];
    
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDate *lastDayOfMonth = [calendar dateByAddingComponents:addOneMonthSubtractOneDay toDate:firstDayOfMonth options:0];
	
	NSDateComponents *resultComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:lastDayOfMonth];
	return [resultComps day];
}
-(NSDate *)roundAtDay {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *comps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
	return [calendar dateFromComponents:comps];
}

-(BOOL)greaterThan:(NSDate *)other {
	return ([self compare:other] == NSOrderedDescending);
}
-(BOOL)greaterEqual:(NSDate *)other {
	return ([self greaterThan:other] || [self compare:other] == NSOrderedSame);
}
-(BOOL)lessThan:(NSDate *)other {
	return ([self compare:other] == NSOrderedAscending);
}
-(BOOL)lessEqual:(NSDate *)other {
	return ([self lessThan:other] || [self compare:other] == NSOrderedSame);
}
-(BOOL)equals:(NSDate *)other {
	return ([self compare:other] == NSOrderedSame);
}

-(NSInteger)dayIntervalSinceDate:(NSDate *)other {
	NSTimeInterval _i = [[self roundAtDay] timeIntervalSinceDate:[other roundAtDay]];
	return _i / (24 * 60 * 60);
}
-(NSNumber *)millisecondsSinceNow {
	NSTimeInterval itvl = [self timeIntervalSinceNow];
	double d = itvl * 1000;
	long long ll = d;
	return [NSNumber numberWithLongLong:ll];
}
+(NSDate *)dateWithMillisecondsSinceNow:(NSNumber *)msec {
	// 1970からのミリ秒を、TimeIntervalの形式(秒)に変換する
	NSTimeInterval itvl = [msec doubleValue] / 1000;
	NSDate *tempDate = [NSDate dateWithTimeIntervalSinceNow:itvl];
	return tempDate;
	
	// 時間は不要なので落とす
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *cmps = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit)
										 fromDate:tempDate];
	return [calendar dateFromComponents:cmps];
}

+(NSDate*)dateFromRFC1123:(NSString*)value_{
    if(value_ == nil)
        return nil;
    static NSDateFormatter *rfc1123 = nil;
    if(rfc1123 == nil)
    {
        rfc1123 = [[NSDateFormatter alloc] init];
        rfc1123.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        rfc1123.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        rfc1123.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss z";
    }
    NSDate *ret = [rfc1123 dateFromString:value_];
    if(ret != nil)
        return ret;
	
    static NSDateFormatter *rfc850 = nil;
    if(rfc850 == nil)
    {
        rfc850 = [[NSDateFormatter alloc] init];
        rfc850.locale = rfc1123.locale;
        rfc850.timeZone = rfc1123.timeZone;
        rfc850.dateFormat = @"EEEE',' dd'-'MMM'-'yy HH':'mm':'ss z";
    }
    ret = [rfc850 dateFromString:value_];
    if(ret != nil)
        return ret;
	
    static NSDateFormatter *asctime = nil;
    if(asctime == nil)
    {
        asctime = [[NSDateFormatter alloc] init];
        asctime.locale = rfc1123.locale;
        asctime.timeZone = rfc1123.timeZone;
        asctime.dateFormat = @"EEE MMM d HH':'mm':'ss yyyy";
    }
    return [asctime dateFromString:value_];
}

// レシーバからtoまでの日が格納された配列を返す
- (NSArray *)arrayOfDateTo:(NSDate *)to {
	if ([self compare:to] == NSOrderedSame) {
		// fromとtoが同じ場合は要素がひとつだけの配列を返す
		return [NSArray arrayWithObject:self];
	} else if ([self compare:to] == NSOrderedDescending) {
		// from > to の場合は要素が空の配列を返す
		return [NSArray array];
	} else {
		NSDate *date = [NSDate dateWithTimeIntervalSinceNow: [self timeIntervalSinceNow]];
		NSMutableArray *result = [NSMutableArray array];
		// date < To の間ぐるぐるまわす
		while ([date compare:to] == NSOrderedAscending) {
			[result addObject:date];
			date = [date addDay:1];
		}
		[result addObject:to];
		return result;
	}
}

+(NSDate *)dateFromString:(NSString*)dateString withFormat:(NSString*)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	[formatter setLocale:usLocale];
    [formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}

+(NSDate*)dateFromShortDateString:(NSString*)dateString
{
    return [NSDate dateFromString:dateString withFormat:@"yyyy/MM/dd"];
}

+(NSDate*)dateFromLongDateString:(NSString*)dateString
{
    return [NSDate dateFromString:dateString withFormat:@"yyyy/MM/dd HH:mm:ss"];
}

-(int) intValueWithYMD{
    //dateをyyyyMMddに変換後、intにして返す。
    return [[self stringFormat:@"yyyyMMdd"] intValue];
}

-(NSNumber*) numberValueWithYMD{
    //dateをyyyyMMddに変換後、NSNumberにして返す。
    return [NSDecimalNumber decimalNumberWithString:[self stringFormat:@"yyyyMMdd"]];
}

+(NSDate*) dateFromNumberOfYMD:(NSNumber*)number{
    //CoreDataから取得したNSNumberの数値をNSDate型にして返す。
    NSString *str = [number stringValue];
    return [NSDate dateFromString:str withFormat:@"yyyyMMdd"];
}

+(NSString *)addSlashToShortDateString:(NSString*)dateString {
    return [[NSDate dateFromShortDateString:dateString] stringFormat:@"yyyy/MM/dd"];
}

+(NSDate*)dateFromYYMMDDHHMM:(NSString*)value{
    if(value == nil)
        return nil;
    static NSDateFormatter *dataFormat = nil;
    if(dataFormat == nil)
    {
        dataFormat = [[NSDateFormatter alloc] init];
        dataFormat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        dataFormat.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        dataFormat.dateFormat = @"yyyy/MM/dd HH:mm";
    }
    
    return [dataFormat dateFromString:value];
}

+(NSString *)deleteSlashFromDateString:(NSString*)dateStringWithSlash {
    return [[NSDate dateFromString:dateStringWithSlash withFormat:@"yyyy/MM/dd"] stringFormat:@"yyyyMMdd"];
}



@end



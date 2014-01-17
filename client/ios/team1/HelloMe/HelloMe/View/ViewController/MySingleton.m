//
//  MySingleton.m
//  HelloMe
//
//  Created by wuhh on 12/20/13.
//  Copyright (c) 2013 wuhh. All rights reserved.
//

#import "MySingleton.h"

@implementation MySingleton

@synthesize testGlobal;

+ (MySingleton *)sharedSingleton
{
    static MySingleton *sharedSingleton;
    
    @synchronized(self)
    {
        if (!sharedSingleton)
            sharedSingleton = [[MySingleton alloc] init];
        
        return sharedSingleton;
    }
}

+(NSString *)getNowTime
{
    //当前的系统时间 yyyyMMddHHmm
    NSDate * newDate = [NSDate date];
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyyMMddHHmmss"];
    NSString * newDateOne = [dateformat stringFromDate:newDate];
    [dateformat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    newDateOne=[newDateOne substringToIndex:12];
    return newDateOne;
}

+(NSString *)getNowTimeDetail
{
    //当前的系统时间 yyyyMMddHHmm
    NSDate * newDate = [NSDate date];
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyyMMddHHmmss"];
    NSString * newDateOne = [dateformat stringFromDate:newDate];
    [dateformat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    return newDateOne;
}

@end

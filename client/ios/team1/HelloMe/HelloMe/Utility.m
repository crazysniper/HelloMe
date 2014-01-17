//
//  Utility.m
//  ShozenKantei
//
//  Created by iPhone on 10/10/28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Utility.h"
#import "Define.h"
#import <math.h>
#import "GFFileManager.h"

@implementation Utility


// char型ポインタのデータが文字列のデータに変更する
+ (NSString *)CharToNSString:(char *)message {
	if (message != nil) {
		return [NSString stringWithUTF8String:message];
	} else {
		return @"";
	}
}

// NSDate形日付をNSString形日付に転化する
+ (NSString *)NSDateToNSString:(NSDate *)date
{
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy/MM/dd"];
	NSString* strDate = [formatter stringFromDate:date];
	return strDate;
}

// 数値データが文字列のデータに変更する
+ (NSString *)NSIntegerToNSStringText:(NSInteger)day {
	if (day < 10) {
		return [NSString stringWithFormat:@"0%i", day];
	} else {
		return [NSString stringWithFormat:@"%i", day];
	}
}

// 文字列の非空チェック処理
+ (BOOL)checkNSString:(NSString *)message {
	if ((message != nil) && (![message isEqualToString:@""])) {
		return YES;
	}
	return NO;
}


/*!
 @method
 @abstract get current version
 @result   int current version
 */
+ (NSString *)getCurrentVersion
{
    NSObject *versionObj = [[NSBundle bundleForClass:[Utility class]] objectForInfoDictionaryKey:@"CFBundleVersion"];
    if (versionObj != nil) {
        return (NSString *) versionObj;
    } else {
        return @"1.0.0";
    }
}

/*!
 @method
 @abstract get current version database name
 @result   int current version database name
 */
+ (NSString *)getCurrentVersionDBName
{
    return [NSString stringWithFormat:sDynDBFileName, [self getCurrentVersion]];
}


@end

//
//  Message.m
//  HelloMe
//
//  Created by 于翔 on 13-12-18.
//  Copyright (c) 2013年 于翔. All rights reserved.
//

#import "Message.h"

@implementation Message

@synthesize messageID;
@synthesize boxID;
@synthesize topic;
@synthesize text;
@synthesize sendYear;
@synthesize sendMonth;
@synthesize sendDay;
@synthesize sendHour;
@synthesize sendMinute;
@synthesize receiveYear;
@synthesize receiveMonth;
@synthesize receiveDay;
@synthesize receiveHour;
@synthesize receiveMinute;
@synthesize sendFileUrl;
@synthesize userName;
@synthesize sendImageString;
@synthesize sendImageName;

- (id)initWithDivision
{
	if(self = [super init]) {
		self.sendYear = @"2014";
		self.sendMonth = @"01";
		self.sendDay = @"01";
		self.sendHour = @"00";
		self.sendMinute = @"00";
	}
	return self;
}

// 生年月日の表示名を取得
-(NSString *)getSendDayViewText {
	return [NSString stringWithFormat:@"%@年%@月%@日", sendYear, sendMonth, sendDay];
}

// 出生時刻の表示名を取得
-(NSString *)getSendTimeViewText {
    
    return [NSString stringWithFormat:@"%@点%@分", sendHour, sendMinute];
}

@end

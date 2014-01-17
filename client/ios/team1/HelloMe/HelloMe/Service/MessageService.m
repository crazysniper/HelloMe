//
//  MessageService.m
//  HelloMeTeam1
//
//  Created by 于翔 on 13/12/17.
//  Copyright 2013 于翔. All rights reserved.
//

#import "MessageService.h"
#import "MessageInfoObtainer.h"
#import "Define.h"

@implementation MessageService

/*!
 @method
 @abstract	根据邮箱区分检索邮箱一览数据
 @param		division 收件箱，回收箱，草稿箱
 @result	取得结果
 */
- (NSMutableArray *)getProfileInfoWithDivision:(NSString *)division {
	if ([division length] <= 0) {
		return nil;
	}
	
	MessageInfoObtainer *obtainer = [[MessageInfoObtainer alloc] init];
	NSMutableArray *result = [obtainer getMessageInfoWithDivision:division];
	return result;
}

// 取得信件的详细信息
- (Message *)getMessagesWithCondition:(Message *)messageInfo {
    MessageInfoObtainer *obtainer = [[MessageInfoObtainer alloc] init];
	NSArray *list = [obtainer getMessagesWithCondition:messageInfo];
	if (list == nil ||[list count] == 0) {
		return nil;
	}
	return [list objectAtIndex:0];
}

/*!
 @method
 @abstract	信件详细信息追加
 @param		信件详细信息
 @result	追加结果
 */
- (BOOL)insertMessageInfo:(Message *)messageInfo {
	if (messageInfo == nil) {
		return NO;
	}
	
	MessageInfoObtainer *obtainer = [[MessageInfoObtainer alloc] init];
	BOOL result = [obtainer insertMessageInfo:messageInfo];
	return result;
}

/*!
 @method
 @abstract	信件详细删除变更
 @param		messageInfo 信件详细信息
 @result	更新结果
 */
- (BOOL)updateMessageInfo:(Message *)messageInfo {
	if ((messageInfo == nil) || ([messageInfo.messageID length] <= 0)) {
		return NO;
	}
	
	MessageInfoObtainer *obtainer = [[MessageInfoObtainer alloc] init];
	BOOL result = [obtainer updateMessageInfo:messageInfo];
	return result;
}

/*!
 @method
 @abstract	信件详细信息删除
 @param		profileID
 @result	删除结果
 */
- (BOOL)deleteMessageInfo:(NSString *)profileID {
	if ([profileID length] <= 0) {
		return NO;
	}
	
	MessageInfoObtainer *obtainer = [[MessageInfoObtainer alloc] init];
	BOOL result = [obtainer deleteMessageInfo:profileID];
	return result;
}
/*!
 @method
 @abstract	根据邮箱区分检索邮件件数
 @param		division 收件箱，回收箱，草稿箱
 @result	取得结果
 */
- (NSString *)getCountWithDivision:(NSString *)division {
	if ([division length] <= 0) {
		return nil;
	}
    
	MessageInfoObtainer *obtainer = [[MessageInfoObtainer alloc] init];
	NSString *result = [obtainer getCountInfoWithDivision:division];
	return result;
}

/*!
 @method
 @abstract	信件信息逻辑删除
 @param		profileID
 @result	逻辑删除结果
 */
- (BOOL)motifyMessageInfo:(NSString *)profileID {
    NSLog(@"~~motifyMessageInfo~11111~");
	if ([profileID length] <= 0) {
		return NO;
	}
	
	MessageInfoObtainer *obtainer = [[MessageInfoObtainer alloc] init];
	BOOL result = [obtainer motifyMessageInfo:profileID];
	return result;
}


@end



//
//  MessageService.m
//  HelloMe
//
//  Created by yux on 2013/12/17.
//  Copyright (c) 2013年 wuhh. All rights reserved.
//

#import "MessageService.h"
#import "MessageInfoObtainer.h"
#import "Define.h"

@implementation MessageService

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
 @abstract	プロフィール情報を編集する
 @param		profileInfo 編集するプロフィール情報
 @result		編集結果
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
 @abstract	プロフィール情報を削除する
 @param		profileID 削除するプロフィールID
 @result		削除結果
 */
- (BOOL)deleteMessageInfo:(NSString *)profileID {
	if ([profileID length] <= 0) {
		return NO;
	}
	
	MessageInfoObtainer *obtainer = [[MessageInfoObtainer alloc] init];
	BOOL result = [obtainer deleteMessageInfo:profileID];
	return result;
}

@end



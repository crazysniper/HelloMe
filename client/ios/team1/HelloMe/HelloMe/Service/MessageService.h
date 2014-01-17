//
//  MessageService.h
//  HelloMeTeam1
//
//  Created by 于翔 on 13/12/17.
//  Copyright 2013 于翔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"

/*!
 @class		MessageService
 @abstract	信件的service
 */
@interface MessageService : NSObject {
    
}

/*!
 @method
 @abstract	各区分信件信息检索
 @param		division 邮箱区分
 @result	详细信息检索
 */
- (NSMutableArray *)getProfileInfoWithDivision:(NSString *)division;

/*!
 @method
 @abstract	信件信息检索
 @param		messageInfo 检索信件中的明细信息
 @result	编辑画面详细信息检索
 */
- (Message *)getMessagesWithCondition:(Message *)messageInfo;

/*!
 @method
 @abstract	信件信息追加
 @param		messageInfo 需要追加的信件信息
 @result	追加结果
 */
- (BOOL)insertMessageInfo:(Message *)messageInfo;

/*!
 @method
 @abstract	草稿箱的信件信息变更
 @param		messageInfo 需要变更的信件信息
 @result	变更结果
 */
- (BOOL)updateMessageInfo:(Message *)messageInfo;

/*!
 @method
 @abstract  邮箱中的信件删除
 @param		messageInfo 需要删除的信件ID
 @result	删除结果
 */
- (BOOL)deleteMessageInfo:(NSString *)messageInfo;

/*!
 @method
 @abstract	根据邮箱区分检索邮件件数
 @param		division 收件箱，回收箱，草稿箱
 @result	取得结果
 */
- (NSString *)getCountWithDivision:(NSString *)division;
/*!
 @method
 @abstract	プロフィール情報を逻辑削除する
 @param		profileID 削除するプロフィールID
 @result		逻辑削除結果
 */
- (BOOL)motifyMessageInfo:(NSString *)profileID;
@end

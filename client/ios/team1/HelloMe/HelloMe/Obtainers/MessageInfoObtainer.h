//
//  MessageInfoObtainer.h
//  HelloMeTeam1
//
//  Created by 于翔 on 13/12/17.
//  Copyright 2013 于翔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "Message.h"

/*!
	@class		MessageInfoObtainer
	@abstract	信件箱的资料库
 */
@interface MessageInfoObtainer : NSObject {
	sqlite3	*database;
}

#pragma mark -
#pragma mark protocol
/*!
	@protocol 
	@abstract	信件箱的资料库
 */
@property (nonatomic, assign) sqlite3 *database;

#pragma mark -
#pragma mark method
/*!
	@method 
	@abstract	资料库初始化
	@result		对象调用方法
 */
- (id)init;

/*!
    @method 
    @abstract   数据库DAOの初始化
    @param      databaseFilePath    数据库的路径
    @result		实例
 */
- (id)initWithDatabaseFilePath:(NSString *)databaseFilePath;

/*!
     @method
     @abstract	根据邮箱区分检索邮箱中的一览数据
     @param		division 邮箱区分
     @result    取得结果
 */
- (NSMutableArray *)getMessageInfoWithDivision:(NSString *)division;

/*!
    @method
    @abstract	取得信件的详细信息
    @param		condProfile 检索条件
    @result		取得结果
 */
- (NSMutableArray *)getMessagesWithCondition:(Message *)condMessage;

/*!
	@method 
	@abstract	追加信件的详细信息
	@param		profileInfo 追加信件的详细信息
	@result		追加结果
 */
- (BOOL)insertMessageInfo:(Message *)messageInfo;

/*!
	@method 
	@abstract	更新草稿箱信件的详细信息
	@param		profileInfo 更新草稿箱信件
	@result		更新结果
 */
- (BOOL)updateMessageInfo:(Message *)messageInfo;

/*!
	@method 
	@abstract	删除邮箱的信件
	@param		profileID 待删除信件的信件ID
	@result		删除结果
 */
- (BOOL)deleteMessageInfo:(NSString *)messageID;

/*!
 @method
 @abstract	根据邮箱区分检索邮件件数
 @param		division 收件箱，回收箱，草稿箱
 @result	取得结果
 */
- (NSString *)getCountInfoWithDivision:(NSString *)division;

/*!
 @method
 @abstract	プロフィール情報を逻辑削除する
 @param		profileID 削除するプロフィールID
 @result		逻辑削除結果
 */
- (BOOL)motifyMessageInfo:(NSString *)profileID;
@end

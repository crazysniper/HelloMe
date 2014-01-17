//
//  MessageInfoObtainer.h
//  HelloMeTeam1
//
//  Created by yux on 13/12/18.
//  Copyright 2013 YWG. All rights reserved.
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
    @abstract	取得信件的详细信息
    @param		condProfile 检索条件
    @result		取得结果
 */
- (NSArray *)getMessagesWithCondition:(Message *)condMessage;

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

@end

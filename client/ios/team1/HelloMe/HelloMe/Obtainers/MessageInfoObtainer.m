//
//  MessageInfoObtainer.m
//  HelloMeTeam1
//
//  Created by 于翔 on 13/12/17.
//  Copyright 2013 于翔. All rights reserved.
//

#import "MessageInfoObtainer.h"
#import "Utility.h"
#import "Define.h"
#import "MySingleton.h"

@implementation MessageInfoObtainer

@synthesize database;

// 数据库初始化
- (id)init {
	if(self = [super init]){
        database = nil;
		// 数据库作成
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentDirectory = [paths objectAtIndex:0];
		NSString *filepath = nil;
        
        filepath = [documentDirectory stringByAppendingPathComponent:sDBFileName];
		
		if (sqlite3_open([filepath UTF8String], &database) != SQLITE_OK) {
			sqlite3_close(database);
			database = nil;
			return self;
		}
		char *errorMsg;
        
		// 信件明细表作成
        const char *createSQL = "CREATE TABLE IF NOT EXISTS MAILBOX(MAIL_ID INTEGER PRIMARY KEY, BOX_ID INTEGER(1),USER_ID VARCHAR(20), SEND_TIME VARCHAR(12), RECEIVE_TIME VARCHAR(12), SUBJECT VARCHAR(100), TEXT VARCHAR(200), SEND_FILE_NAME VARCHAR(100),IMAGE_BUFFER TEXT)";
		sqlite3_exec(database, createSQL, NULL, NULL, &errorMsg);
        
	}
	return self;
    
}

/*!
 @method 
 @abstract   数据库DAOの初期化
 @param      databaseFilePath    数据库的路径
 @result	 实例
 */
- (id)initWithDatabaseFilePath:(NSString *)databaseFilePath
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:databaseFilePath]) {
        return nil;
    }
    
    if (self = [super init]) {
        if (sqlite3_open([databaseFilePath UTF8String], &database) != SQLITE_OK) {
			sqlite3_close(database);
			return nil;
		}
    }
    return self;
}

#pragma mark -
#pragma mark ProfileInfoObtainer
/*!
 @method
 @abstract 不同的邮件箱的明细数据取得
 @param    division 收件箱，草稿箱，回收箱
 @result   取得结果
 */
- (NSMutableArray *)getMessageInfoWithDivision:(NSString *)division {
	if (database == nil) {
		return nil;
	}
    NSMutableArray *result = [[NSMutableArray alloc] init];
    sqlite3_stmt *stmt;
    
	if([division isEqualToString:@"1"]){
        //已经收到的邮件
        char *sql = "SELECT * FROM MAILBOX WHERE BOX_ID = ? AND USER_ID = ?  AND RECEIVE_TIME < ?  ORDER BY MAIL_ID DESC";
        if(sqlite3_prepare_v2(database, sql, -1, &stmt, nil) == SQLITE_OK) {
            //邮箱种别
            sqlite3_bind_text(stmt, 1, [division UTF8String], -1, NULL);
            //账户
            NSString *user = [MySingleton sharedSingleton].testGlobal;
            sqlite3_bind_text(stmt, 2, [user UTF8String], -1, NULL);
            //当前的系统时间 yyyyMMddHHmm
            NSString *newDateOne = [MySingleton getNowTime];
           sqlite3_bind_text(stmt, 3, [newDateOne UTF8String], -1, NULL);}
    }else{
        char *sql = "SELECT * FROM MAILBOX WHERE BOX_ID = ? AND USER_ID = ? ORDER BY MAIL_ID DESC";
        if(sqlite3_prepare_v2(database, sql, -1, &stmt, nil) == SQLITE_OK) {
            //邮箱种别
            sqlite3_bind_text(stmt, 1, [division UTF8String], -1, NULL);
            //账户
            NSString *user = [MySingleton sharedSingleton].testGlobal;
            sqlite3_bind_text(stmt, 2, [user UTF8String], -1, NULL);
        }
    }
    
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        Message *data = [[Message alloc] init];
        data.messageID = [NSString stringWithFormat:@"%i", sqlite3_column_int(stmt, 0)];
        data.boxID = [NSString stringWithFormat:@"%i", sqlite3_column_int(stmt, 1)];
        if ([Utility CharToNSString:(char *)sqlite3_column_text(stmt, 3)].length >= 12) {
            data.sendYear = [[Utility CharToNSString:(char *)sqlite3_column_text(stmt, 3)] substringWithRange:NSMakeRange(0,4)];
            data.sendMonth = [[Utility CharToNSString:(char *)sqlite3_column_text(stmt, 3)] substringWithRange:NSMakeRange(4,2)];
            data.sendDay = [[Utility CharToNSString:(char *)sqlite3_column_text(stmt, 3)] substringWithRange:NSMakeRange(6,2)];
            data.sendHour = [[Utility CharToNSString:(char *)sqlite3_column_text(stmt, 3)] substringWithRange:NSMakeRange(8,2)];
            data.sendMinute = [[Utility CharToNSString:(char *)sqlite3_column_text(stmt, 3)] substringWithRange:NSMakeRange(10,2)];
        }
        if ([Utility CharToNSString:(char *)sqlite3_column_text(stmt, 4)].length >= 12) {
            data.receiveYear = [[Utility CharToNSString:(char *)sqlite3_column_text(stmt, 4)] substringWithRange:NSMakeRange(0,4)];
            data.receiveMonth = [[Utility CharToNSString:(char *)sqlite3_column_text(stmt, 4)] substringWithRange:NSMakeRange(4,2)];
            data.receiveDay = [[Utility CharToNSString:(char *)sqlite3_column_text(stmt, 4)] substringWithRange:NSMakeRange(6,2)];
            data.receiveHour = [[Utility CharToNSString:(char *)sqlite3_column_text(stmt, 4)] substringWithRange:NSMakeRange(8,2)];
            data.receiveMinute = [[Utility CharToNSString:(char *)sqlite3_column_text(stmt, 4)] substringWithRange:NSMakeRange(10,2)];
        }
        
        data.topic = [Utility CharToNSString:(char *)sqlite3_column_text(stmt, 5)];
        data.text = [Utility CharToNSString:(char *)sqlite3_column_text(stmt, 6)];
        data.sendImageName = [Utility CharToNSString:(char *)sqlite3_column_text(stmt, 7)];
        data.sendImageString = [Utility CharToNSString:(char *)sqlite3_column_text(stmt, 8)];
        [result addObject:data];
    }
    
    if (stmt != nil) {
        sqlite3_finalize(stmt);
        stmt = nil;
    }
    return result;
    
}

/*!
 @method 
 @abstract	信件详细信息取得
 @param		condMessage 检索条件
 @result	取得结果
 */
- (NSMutableArray *)getMessagesWithCondition:(Message *)condMessage;
{
    if (database == nil) {
		return nil;
	}
    
    // create sql, add condition
    void(^addCond)(NSMutableDictionary*, NSString*, NSString*) = 
        ^void(NSMutableDictionary *mdic, NSString *columnName, NSString *value) {
            if (value != nil) {
                [mdic setObject:value forKey:columnName];
            }
        };
    
    NSMutableString *sqlMStr = [[NSMutableString alloc] initWithString:@"SELECT * FROM MAILBOX "];
    NSMutableDictionary *condMDic = [[NSMutableDictionary alloc] init];
    if (condMessage.messageID != nil) {
        addCond(condMDic, @"MAIL_ID", condMessage.messageID);
        addCond(condMDic, @"BOX_ID", condMessage.boxID);
    }
    
    NSArray *keys = [condMDic allKeys];
    if ([condMDic count] != 0) {
        [sqlMStr appendString:@"WHERE USER_ID = ?"];
        for (int i = 1; i < [keys count]; i++) {
            if (i > 1) {
                [sqlMStr appendString:@"AND "];
            }
            
            [sqlMStr appendString:[keys objectAtIndex:i]];
            [sqlMStr appendString:@" = ? "];
        }
    }
    const char *sql = [sqlMStr UTF8String];
    
    // query
    NSMutableArray *result = [[NSMutableArray alloc] init];
	sqlite3_stmt *stmt;
	if(sqlite3_prepare_v2(database, sql, -1, &stmt, nil) == SQLITE_OK) {
        NSString *user = [MySingleton sharedSingleton].testGlobal;
        sqlite3_bind_text(stmt, 1, [user UTF8String], -1, NULL);
        for (int i = 1; i < [keys count]; i++) {
            sqlite3_bind_text(stmt, i + 1, [[condMDic objectForKey:[keys objectAtIndex:i]] UTF8String], -1, NULL);
        }
		
		while (sqlite3_step(stmt) == SQLITE_ROW) {
			Message *data = [[Message alloc] init];
			data.messageID = [NSString stringWithFormat:@"%i", sqlite3_column_int(stmt, 0)];
			data.boxID = [NSString stringWithFormat:@"%i", sqlite3_column_int(stmt, 1)];
            if ([Utility CharToNSString:(char *)sqlite3_column_text(stmt, 3)].length >= 12) {
                data.sendYear = [[Utility CharToNSString:(char *)sqlite3_column_text(stmt, 3)] substringWithRange:NSMakeRange(0,4)];
                data.sendMonth = [[Utility CharToNSString:(char *)sqlite3_column_text(stmt, 3)] substringWithRange:NSMakeRange(4,2)];
                data.sendDay = [[Utility CharToNSString:(char *)sqlite3_column_text(stmt, 3)] substringWithRange:NSMakeRange(6,2)];
                data.sendHour = [[Utility CharToNSString:(char *)sqlite3_column_text(stmt, 3)] substringWithRange:NSMakeRange(8,2)];
                data.sendMinute = [[Utility CharToNSString:(char *)sqlite3_column_text(stmt, 3)] substringWithRange:NSMakeRange(10,2)];
            }
           if ([Utility CharToNSString:(char *)sqlite3_column_text(stmt, 4)].length >= 12) {
                data.receiveYear = [[Utility CharToNSString:(char *)sqlite3_column_text(stmt, 4)] substringWithRange:NSMakeRange(0,4)];
                data.receiveMonth = [[Utility CharToNSString:(char *)sqlite3_column_text(stmt, 4)] substringWithRange:NSMakeRange(4,2)];
                data.receiveDay = [[Utility CharToNSString:(char *)sqlite3_column_text(stmt, 4)] substringWithRange:NSMakeRange(6,2)];
                data.receiveHour = [[Utility CharToNSString:(char *)sqlite3_column_text(stmt, 4)] substringWithRange:NSMakeRange(8,2)];
                data.receiveMinute = [[Utility CharToNSString:(char *)sqlite3_column_text(stmt, 4)] substringWithRange:NSMakeRange(10,2)];
            }
			data.topic = [Utility CharToNSString:(char *)sqlite3_column_text(stmt, 5)];
            data.text = [Utility CharToNSString:(char *)sqlite3_column_text(stmt, 6)];
			data.sendFileUrl = [Utility CharToNSString:(char *)sqlite3_column_text(stmt, 7)];

			[result addObject:data];
		}
	}
	if (stmt != nil) {
		sqlite3_finalize(stmt);
	}
    
	return result;
}

/*!
 @method 
 @abstract 信件详细信息插入
 @param    messageInfo 追加信件信息
 @result   追加结果
 */
- (BOOL)insertMessageInfo:(Message *)messageInfo {
	BOOL result = NO;
	if (database == nil) {
		return result;
	}
	
	char *sql = "INSERT INTO MAILBOX VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?)";
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2(database, sql, -1, &stmt, nil) == SQLITE_OK) {
		sqlite3_bind_text(stmt, 1, [messageInfo.boxID UTF8String], -1, NULL);
        // 获取送信时间
        NSString* strSendTime = sNoValue;
        NSString* strSendYear = messageInfo.receiveYear;
        NSString* strSendMonth = messageInfo.receiveMonth;
        NSString* strSendDay = messageInfo.receiveDay;
        NSString* strSendHour = messageInfo.receiveHour;
        NSString* strSendMinute = messageInfo.receiveMinute;
        strSendTime = [NSString stringWithFormat:@"%@%@%@%@%@",strSendYear,strSendMonth,strSendDay,strSendHour,strSendMinute];
        //当前的系统时间 yyyyMMddHHmm
        NSString *newDateOne = [MySingleton getNowTime];
        NSLog(@"request start time%@",newDateOne);
        //获取账号
        NSString* user=[MySingleton sharedSingleton].testGlobal;
        
        sqlite3_bind_text(stmt, 2, [user UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [newDateOne UTF8String], -1, NULL);
		sqlite3_bind_text(stmt, 4, [strSendTime UTF8String], -1, NULL);
		sqlite3_bind_text(stmt, 5, [messageInfo.topic UTF8String], -1, NULL);
		sqlite3_bind_text(stmt, 6, [messageInfo.text UTF8String], -1, NULL);
		sqlite3_bind_text(stmt, 7, [messageInfo.sendFileUrl UTF8String], -1, NULL);
		sqlite3_bind_text(stmt, 8, [messageInfo.sendImageString UTF8String], -1, NULL);
		if (sqlite3_step(stmt) == SQLITE_DONE) {
			result = YES;
		}
	}
	if (stmt != nil) {
		sqlite3_finalize(stmt);
		stmt = nil;
	}
	return result;
}

/*!
 @method 
 @abstract 信件信息更新
 @param    messageInfo 更新信件信息
 @result   更新结果
 */
- (BOOL)updateMessageInfo:(Message *)messageInfo {
	BOOL result = NO;
	if (database == nil) {
		return result;
	}
	
	char *sql = "UPDATE MAILBOX SET SEND_TIME = ?, SUBJECT = ?, TEXT = ?, SEND_FILE_NAME = ? WHERE MAIL_ID = ?";
	sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(database, sql, -1, &stmt, nil) == SQLITE_OK) {
        // 获取送信时间
        NSString* strSendTime = sNoValue;
        NSString* strSendYear = messageInfo.sendYear;
        NSString* strSendMonth = messageInfo.sendMonth;
        NSString* strSendDay = messageInfo.sendDay;
        NSString* strSendHour = messageInfo.sendHour;
        NSString* strSendMinute = messageInfo.sendMinute;
        strSendTime = [NSString stringWithFormat:@"%@%@%@%@%@",strSendYear,strSendMonth,strSendDay,strSendHour,strSendMinute];
		sqlite3_bind_text(stmt, 1, [strSendTime UTF8String], -1, NULL);
		sqlite3_bind_text(stmt, 2, [messageInfo.topic UTF8String], -1, NULL);
		sqlite3_bind_text(stmt, 3, [messageInfo.text UTF8String], -1, NULL);
		sqlite3_bind_text(stmt, 4, [messageInfo.sendFileUrl UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 5, [messageInfo.messageID UTF8String], -1, NULL);
		if (sqlite3_step(stmt) == SQLITE_DONE) {
			result = YES;
		}
	}
	if (stmt != nil) {
		sqlite3_finalize(stmt);
		stmt = nil;
	}
	return result;
}

/*!
 @method 
 @abstract 信件详细信息删除
 @param    messageID 待删除信件的删除ID
 @result   删除结果
 */
- (BOOL)deleteMessageInfo:(NSString *)messageID {
	BOOL result = NO;
	if (database == nil) {
		return result;
	}
	
	char *sql = "DELETE FROM MAILBOX WHERE MAIL_ID = ?";
	sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(database, sql, -1, &stmt, nil) == SQLITE_OK) {
		sqlite3_bind_int(stmt, 1, [messageID intValue]);
        
		if (sqlite3_step(stmt) == SQLITE_DONE) {
			result = YES;
		}
	}
	if (stmt != nil) {
		sqlite3_finalize(stmt);
		stmt = nil;
	}
	return result;
}

/*!
 @method
 @abstract	根据邮箱区分检索邮件件数
 @param		division 收件箱，回收箱，草稿箱，发信箱
 @result	取得结果
 */
- (NSString *)getCountInfoWithDivision:(NSString *)division{
    
    if (database == nil) {
		return 0;
	}
    
    NSString *result = [[NSString alloc] init];
    sqlite3_stmt *stmt;
    char *sql;
    if ([division isEqualToString:@"1"]||[division isEqualToString:@"4"]) {
        
        if ([division isEqualToString:@"1"]) {
            sql= "SELECT count(1) FROM MAILBOX WHERE BOX_ID = 1 AND RECEIVE_TIME < ? AND USER_ID = ?";
        }else {
            sql = "SELECT count(1) FROM MAILBOX WHERE BOX_ID = 1 AND RECEIVE_TIME > ? AND USER_ID = ?";
        }
        
        if(sqlite3_prepare_v2(database, sql, -1, &stmt, nil) == SQLITE_OK) {
            //当前的系统时间 yyyyMMddHHmm
            NSString *newDateOne = [MySingleton getNowTime];
            sqlite3_bind_text(stmt, 1, [newDateOne UTF8String], -1, NULL);
            //账户
            NSString *user = [MySingleton sharedSingleton].testGlobal;
            sqlite3_bind_text(stmt, 2, [user UTF8String], -1, NULL);
            
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                result = [NSString stringWithFormat:@"%i", sqlite3_column_int(stmt, 0)];
            }
            if (stmt != nil) {
                sqlite3_finalize(stmt);
                stmt = nil;
            }
        }
    }else{
        sql = "SELECT count(1) FROM MAILBOX WHERE BOX_ID = ? AND USER_ID = ?";
     
        if(sqlite3_prepare_v2(database, sql, -1, &stmt, nil) == SQLITE_OK) {
            sqlite3_bind_text(stmt, 1, [division UTF8String], -1, NULL);
            NSString *user = [MySingleton sharedSingleton].testGlobal;
            sqlite3_bind_text(stmt, 2, [user UTF8String], -1, NULL);
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                result = [NSString stringWithFormat:@"%i", sqlite3_column_int(stmt, 0)];
            }
            if (stmt != nil) {
                sqlite3_finalize(stmt);
                stmt = nil;
            }
        }
    }

	return result;
}

/*!
 @method
 @abstract	プロフィール情報を逻辑削除する
 @param		profileID 削除するプロフィールID
 @result		逻辑削除結果
 */
- (BOOL)motifyMessageInfo:(NSString *)profileID{

    BOOL result = NO;
	if (database == nil) {
		return result;
	}
	
	char *sql = "UPDATE MAILBOX SET BOX_ID = ? WHERE MAIL_ID = ?";
	sqlite3_stmt *stmt;

    if(sqlite3_prepare_v2(database, sql, -1, &stmt, nil) == SQLITE_OK) {
		sqlite3_bind_text(stmt, 1, [@"3" UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [profileID UTF8String], -1, NULL);
		if (sqlite3_step(stmt) == SQLITE_DONE) {
			result = YES;
		}
	}

	if (stmt != nil) {
		sqlite3_finalize(stmt);
		stmt = nil;
	}

	return result;
}
@end

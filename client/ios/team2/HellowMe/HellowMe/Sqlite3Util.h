//
//  Sqlite3Util.h
//  HellowMe
//
//  Created by Smartphone18 on 13-12-17.
//  Copyright (c) 2013年 Smartphone18. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Sqlite3Util : NSObject
@property sqlite3 *database;
- (void)initDataBase;
- (void)createTables;
- (void)insertTable:(NSString *)tableName withArgs:(NSMutableDictionary *)args;
- (void)deleteTable:(NSString *)tableName withArgs:(NSMutableDictionary *)args;
- (NSMutableDictionary *)selectMailBox:(NSString *)userId withReceiveTime:(NSString *)receiveTime withBoxId:(NSString *)boxId;
- (void)deleteTableTemp:(NSString *)tableName withArgs:(NSMutableDictionary *)args;
- (NSMutableDictionary *)selectMail:(NSString *)userId WithMailId:(NSString *)mailId withBoxId:(NSString *)boxId;
- (void)closeDB;

@end

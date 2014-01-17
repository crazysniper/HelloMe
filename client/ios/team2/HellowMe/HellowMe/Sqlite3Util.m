//
//  Sqlite3Util.m
//  HellowMe
//
//  Created by Smartphone18 on 13-12-17.
//  Copyright (c) 2013年 Smartphone18. All rights reserved.
//

#import "Sqlite3Util.h"
#import <sqlite3.h>

@implementation Sqlite3Util
// 初始化DB
- (void)initDataBase{
    NSArray *documentsPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
                                                                , NSUserDomainMask
                                                                , YES);
    NSString *databaseFilePath=[[documentsPaths objectAtIndex:0] stringByAppendingPathComponent:@"mydb"];
    
    if (sqlite3_open([databaseFilePath UTF8String], &_database)==SQLITE_OK) {
        NSLog(@"open sqlite db ok.");
    }

}
// 关闭数据库
- (void)closeDB{
    sqlite3_close(_database);
}

// 创建表
- (void)createTables{
    char *errorMsg;
    const char *createSql1="create table if not exists user (user_id integer primary key autoincrement,user_name text,password text)";
    
    if (sqlite3_exec(_database, createSql1, NULL, NULL, &errorMsg)==SQLITE_OK) {
        NSLog(@"create ok.");
    }else {
        NSLog(@"error: %s",errorMsg);
        sqlite3_free(errorMsg);
    }
    
//    const char *createSql3="drop table mailbox";
    
//    if (sqlite3_exec(_database, createSql3, NULL, NULL, &errorMsg)==SQLITE_OK) {
//        NSLog(@"drop ok.");
//    }else {
//        NSLog(@"error: %s",errorMsg);
//        sqlite3_free(errorMsg);
//    }
    
    const char *createSql2="create table if not exists mailbox (mail_id integer primary key autoincrement,box_id integer,user_id integer,send_time text,receive_time text,subject text,content text,send_file_name text)";
    
    if (sqlite3_exec(_database, createSql2, NULL, NULL, &errorMsg)==SQLITE_OK) {
        NSLog(@"create ok.");
    }else {
        NSLog(@"error: %s",errorMsg);
        sqlite3_free(errorMsg);
    }
}
// 插表
- (void)insertTable:(NSString *)tableName withArgs:(NSMutableDictionary *)args{
    // 向mailbox表插入一条数据
    if ([tableName isEqualToString:@"user"]) {
        
    }else if([tableName isEqualToString:@"mailbox"]){
        NSString *insertMailBoxSql = @"insert into mailbox(box_id,user_id,send_time,receive_time,subject,content,send_file_name)values(?,?,?,?,?,?,?)";
        sqlite3_stmt *statement;
        // 读取参数
        NSString *box_id = [args objectForKey:@"box_id"];
        NSString *user_id = [args objectForKey:@"user_id"];
        NSString *send_time = [args objectForKey:@"send_time"];
        NSString *receive_time = [args objectForKey:@"receive_time"];
        NSString *subject = [args objectForKey:@"subject"];
        NSString *content = [args objectForKey:@"content"];
        NSString *sendfilename = [args objectForKey:@"send_file_name"];
        if (sqlite3_prepare_v2(_database, [insertMailBoxSql UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [box_id UTF8String], -1,NULL);
            sqlite3_bind_text(statement, 2, [user_id UTF8String], -1,NULL);
            sqlite3_bind_text(statement, 3, [send_time UTF8String], -1,NULL);
            sqlite3_bind_text(statement, 4, [receive_time UTF8String], -1,NULL);
            sqlite3_bind_text(statement, 5, [subject UTF8String], -1,NULL);
            sqlite3_bind_text(statement, 6, [content UTF8String], -1,NULL);
            sqlite3_bind_text(statement, 7, [sendfilename UTF8String], -1,NULL);
        }
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSAssert(0, @"插入数据失败！");
            sqlite3_finalize(statement);
        }
    }
}

// 还原信件
- (void)deleteTable:(NSString *)tableName withArgs:(NSMutableDictionary *)args{
    NSString *deleteMailBoxSql = @"update mailbox set box_id = ? where user_id = ? and mail_id = ?";
    sqlite3_stmt *statement;
    
    // 读取参数
    NSString *box_id = [args objectForKey:@"box_id"];
    NSString *mail_id = [args objectForKey:@"mail_id"];
    NSString *user_id = [args objectForKey:@"user_id"];
    NSString *isAll = [args objectForKey:@"isAll"];
    
    if([isAll isEqualToString:@"YES"]){
        deleteMailBoxSql = @"update mailbox set box_id = ? where user_id = ?";
    }
    
    if (sqlite3_prepare_v2(_database, [deleteMailBoxSql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [box_id UTF8String], -1,NULL);
        sqlite3_bind_text(statement, 2, [user_id UTF8String], -1,NULL);
        if([isAll isEqualToString:@"YES"]){
        }else{
            sqlite3_bind_text(statement, 3, [mail_id UTF8String], -1,NULL);
        }
    }
    if (sqlite3_step(statement) != SQLITE_DONE) {
        NSAssert(0, @"删除数据失败！");
        sqlite3_finalize(statement);
    }
}

// 清空草稿箱
- (void)deleteTableTemp:(NSString *)tableName withArgs:(NSMutableDictionary *)args{
    NSString *deleteMailBoxSql = @"delete from mailbox where user_id = ? and box_id = ? and mail_id = ?";
    sqlite3_stmt *statement;
    
    // 读取参数
    NSString *box_id = [args objectForKey:@"box_id"];
    NSString *mail_id = [args objectForKey:@"mail_id"];
    NSString *user_id = [args objectForKey:@"user_id"];
    NSString *isAll = [args objectForKey:@"isAll"];
    
    if([isAll isEqualToString:@"YES"]){
        deleteMailBoxSql = @"delete from mailbox where user_id = ? and box_id = ?";
    }
    
    if (sqlite3_prepare_v2(_database, [deleteMailBoxSql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [user_id UTF8String], -1,NULL);
        sqlite3_bind_text(statement, 2, [box_id UTF8String], -1,NULL);
        if([isAll isEqualToString:@"YES"]){
        }else{
            sqlite3_bind_text(statement, 3, [mail_id UTF8String], -1,NULL);
        }
    }
    if (sqlite3_step(statement) != SQLITE_DONE) {
        NSAssert(0, @"删除数据失败！");
        sqlite3_finalize(statement);
    }
}

// 收件箱查询到期的邮件
- (NSMutableDictionary *)selectMailBox:(NSString *)userId withReceiveTime:(NSString *)receiveTime withBoxId:(NSString *)boxId{
    // 收件箱字典
    NSMutableDictionary *mailBoxDic = [[NSMutableDictionary alloc]init];
    // 初始化数组
    NSMutableArray *mailBoxsSection = [[NSMutableArray alloc]init];
    NSString *tempSection = nil;
    BOOL hasData = NO;

    char *selectSql;
    
    if([boxId isEqualToString:@"2"] || [boxId isEqualToString:@"3"]){
        // 检索SQL
        selectSql="select mail_id,box_id,user_id,send_time,receive_time,subject,content,send_file_name from mailbox where user_id = ? and box_id = ? order by receive_time";
    }else{
        // 检索SQL
        selectSql="select mail_id,box_id,user_id,send_time,receive_time,subject,content,send_file_name from mailbox where user_id = ? and ? >= receive_time and box_id = ? order by receive_time";
    }
    
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, selectSql, -1, &statement, nil)==SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [userId UTF8String], -1, NULL);
        if([boxId isEqualToString:@"2"] || [boxId isEqualToString:@"3"]){
            sqlite3_bind_text(statement, 2, [boxId UTF8String], -1, NULL);
        }else{
            sqlite3_bind_text(statement, 2, [receiveTime UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 3, [boxId UTF8String], -1, NULL);
        }
    }
    while (sqlite3_step(statement)==SQLITE_ROW) {
        hasData = YES;
        NSString *receive_time = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding];
        NSString *year = [[receive_time substringToIndex:4] stringByAppendingString:@"年"];
        NSString *month = [[receive_time substringWithRange:NSMakeRange(4,2)] stringByAppendingString:@"月"];
        NSString *section = [year stringByAppendingString:month];
        
        NSMutableDictionary *mailsDic = [NSMutableDictionary dictionaryWithCapacity:(5)];
        
        // 给字典设置key value
        [mailsDic setValue:[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding] forKey:@"mail_id"];
        [mailsDic setValue:[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding] forKey:@"box_id"];
        [mailsDic setValue:[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding] forKey:@"user_id"];
        [mailsDic setValue:[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding] forKey:@"send_time"];
        [mailsDic setValue:receive_time forKey:@"receive_time"];
        [mailsDic setValue:[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 5) encoding:NSUTF8StringEncoding] forKey:@"subject"];
        [mailsDic setValue:[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 6) encoding:NSUTF8StringEncoding] forKey:@"content"];
        [mailsDic setValue:[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 7) encoding:NSUTF8StringEncoding] forKey:@"send_file_name"];
        NSLog(@"mail_id:%@" , [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding]);
        NSLog(@"box_id:%@" , [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding]);
        NSLog(@"user_id:%@" , [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding]);
        NSLog(@"send_time:%@" , [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding]);
        NSLog(@"receive_time:%@" , receive_time);
        NSLog(@"subject:%@" , [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 5) encoding:NSUTF8StringEncoding]);
        NSLog(@"content:%@" , [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 6) encoding:NSUTF8StringEncoding]);
        
        if([section isEqualToString:tempSection] || tempSection == nil){
            // 保存至数组
            [mailBoxsSection addObject:mailsDic];
        }else if(![section isEqualToString:tempSection] && tempSection != nil){
            // 把上个section的数组保存至字典里
            [mailBoxDic setValue:mailBoxsSection forKey:tempSection];
            // 创建新的数组
            mailBoxsSection = [[NSMutableArray alloc]init];
            [mailBoxsSection addObject:mailsDic];
        }
        
        tempSection = section;
    }
    
    if (hasData) {
        // 保存最后一个section
        [mailBoxDic setValue:mailBoxsSection forKey:tempSection];
    }
    
    return mailBoxDic;
}

- (NSMutableDictionary *)selectMail:(NSString *)userId WithMailId:(NSString *)mailId withBoxId:(NSString *)boxId{
    NSMutableDictionary *mailsDic = [NSMutableDictionary dictionaryWithCapacity:(5)];
    // 初始化数组

    BOOL hasData = NO;
    
    char *selectSql;
    // 检索SQL
    selectSql="select mail_id,box_id,user_id,send_time,receive_time,subject,content,send_file_name from mailbox where user_id = ? and mail_id = ? and box_id = ?";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, selectSql, -1, &statement, nil)==SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [userId UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 2, [mailId UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 3, [boxId UTF8String], -1, NULL);
    }
    while (sqlite3_step(statement)==SQLITE_ROW) {
        hasData = YES;
        // 给字典设置key value
        [mailsDic setValue:[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding] forKey:@"mail_id"];
        [mailsDic setValue:[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding] forKey:@"box_id"];
        [mailsDic setValue:[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding] forKey:@"user_id"];
        [mailsDic setValue:[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding] forKey:@"send_time"];
        [mailsDic setValue:[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding] forKey:@"receive_time"];
        [mailsDic setValue:[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 5) encoding:NSUTF8StringEncoding] forKey:@"subject"];
        [mailsDic setValue:[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 6) encoding:NSUTF8StringEncoding] forKey:@"content"];
        [mailsDic setValue:[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 7) encoding:NSUTF8StringEncoding] forKey:@"send_file_name"];
        NSLog(@"查看邮件内容");
        NSLog(@"mail_id:%@" , [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding]);
        NSLog(@"box_id:%@" , [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding]);
        NSLog(@"user_id:%@" , [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding]);
        NSLog(@"send_time:%@" , [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding]);
        NSLog(@"receive_time:%@" , [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding]);
        NSLog(@"subject:%@" , [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 5) encoding:NSUTF8StringEncoding]);
        NSLog(@"content:%@" , [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 6) encoding:NSUTF8StringEncoding]);
        NSLog(@"send_file_name:%@" , [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 7) encoding:NSUTF8StringEncoding]);
        
    }
    return mailsDic;
};
@end

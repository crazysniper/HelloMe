//
//  EmailLogic.m
//  HelloMe
//
//  Created by 陳威 on 13-12-18.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import "EmailLogic.h"
#import "CommonDao.h"
#import "ContextManager.h"
#import "KeychainAccessor.h"
#import "MailDTO.h"
#import "Mailbox.h"
@implementation EmailLogic


//把email存本地DB
+ (BOOL)addMailInfoTOLoaclDB:(MailDTO *)dto{
    CommonDao *commonDao = [[CommonDao alloc] initWithContext:[[ContextManager instance] createNewContext]];
    
    Mailbox *mailbox = (Mailbox *)[commonDao createEntity:[Mailbox class]];
    mailbox.mailId = [NSNumber numberWithInt:dto.mailId];
    mailbox.boxId = [NSNumber numberWithInt:dto.boxId];
    mailbox.sendTime = dto.sendTime;
    mailbox.text = dto.text;
    mailbox.receiveTime = dto.receiveTime;
    mailbox.subject = dto.subject;
    mailbox.image = dto.image;
    mailbox.userName = [KeychainAccessor stringForKey:USER_ACCOUNT];
    return [commonDao saveAction];
}

//根据用户名得到本地全部Email
+ (NSMutableArray *)getMailInfoByUserName{
    CommonDao *commonDao = [[CommonDao alloc] initWithContext:[[ContextManager instance] createNewContext]];
    NSString *userAccount = [KeychainAccessor stringForKey:USER_ACCOUNT];
    NSMutableArray *resultArray;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName = %@ ", userAccount];
    [commonDao getEntities:&resultArray withEntityClass:[Mailbox class] byConditionWithPredicate:predicate];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < [resultArray count]; i++) {
        MailDTO *dto = [[MailDTO alloc] init];
        
        Mailbox *mailbox = [resultArray objectAtIndex:i];
        dto.mailId = [mailbox.mailId intValue];
        dto.boxId = [mailbox.boxId intValue];
        dto.sendTime = mailbox.sendTime;
        dto.receiveTime = mailbox.receiveTime;
        dto.subject = mailbox.subject;
        dto.text = mailbox.text;
        dto.sendFileName = mailbox.sendFileName;
        dto.image = mailbox.image;
        dto.userName = mailbox.userName;
        [array addObject:dto];
    }
    return array;
}
//根据boxId得到垃圾箱的email
+ (NSMutableArray *)getMailInfoBoxIDLAJI{
    CommonDao *commonDao = [[CommonDao alloc] initWithContext:[[ContextManager instance] createNewContext]];
    NSString *userAccount = [KeychainAccessor stringForKey:USER_ACCOUNT];
    NSMutableArray *resultArray;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName = %@ and boxId = %d", userAccount,EMAILBOX_ID_LAJI];
    [commonDao getEntities:&resultArray withEntityClass:[Mailbox class] byConditionWithPredicate:predicate orderBy:@"receiveTime" asc:SORT_TYPE_DECEND];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < [resultArray count]; i++) {
        MailDTO *dto = [[MailDTO alloc] init];
        
        Mailbox *mailbox = [resultArray objectAtIndex:i];
        dto.mailId = [mailbox.mailId intValue];
        dto.boxId = [mailbox.boxId intValue];
        dto.sendTime = mailbox.sendTime;
        dto.receiveTime = mailbox.receiveTime;
        dto.subject = mailbox.subject;
        dto.text = mailbox.text;
        dto.sendFileName = mailbox.sendFileName;
        dto.image = mailbox.image;
        dto.userName = mailbox.userName;
        [array addObject:dto];
    }
    return array;
}
//根据boxId得到草稿箱的email
+ (NSMutableArray *)getMailInfoBoxIDCAOGAO{
    CommonDao *commonDao = [[CommonDao alloc] initWithContext:[[ContextManager instance] createNewContext]];
    NSString *userAccount = [KeychainAccessor stringForKey:USER_ACCOUNT];
    NSMutableArray *resultArray;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName = %@ and boxId = %d", userAccount,EMAILBOX_ID_CAOGAO];
    [commonDao getEntities:&resultArray withEntityClass:[Mailbox class] byConditionWithPredicate:predicate orderBy:@"receiveTime" asc:SORT_TYPE_DECEND];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < [resultArray count]; i++) {
        MailDTO *dto = [[MailDTO alloc] init];
        
        Mailbox *mailbox = [resultArray objectAtIndex:i];
        dto.mailId = [mailbox.mailId intValue];
        dto.boxId = [mailbox.boxId intValue];
        dto.sendTime = mailbox.sendTime;
        dto.receiveTime = mailbox.receiveTime;
        dto.subject = mailbox.subject;
        dto.text = mailbox.text;
        dto.sendFileName = mailbox.sendFileName;
        dto.image = mailbox.image;
        dto.userName = mailbox.userName;
        [array addObject:dto];
    }
    return array;
}

// 根据boxId得到收件箱的email
+ (NSMutableArray *)getMailInfoBoxIDSHOUJIAN{
    CommonDao *commonDao = [[CommonDao alloc] initWithContext:[[ContextManager instance] createNewContext]];
    NSString *userAccount = [KeychainAccessor stringForKey:USER_ACCOUNT];
    NSMutableArray *resultArray;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName = %@ and boxId = %d", userAccount,EMAILBOX_ID_SHOUJIAN];
//    [commonDao getEntities:&resultArray withEntityClass:[Mailbox class] byConditionWithPredicate:predicate];
    [commonDao getEntities:&resultArray withEntityClass:[Mailbox class] byConditionWithPredicate:predicate orderBy:@"receiveTime" asc:SORT_TYPE_DECEND];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < [resultArray count]; i++) {
        MailDTO *dto = [[MailDTO alloc] init];
        
        Mailbox *mailbox = [resultArray objectAtIndex:i];
        dto.mailId = [mailbox.mailId intValue];
        dto.boxId = [mailbox.boxId intValue];
        dto.sendTime = mailbox.sendTime;
        dto.receiveTime = mailbox.receiveTime;
        dto.subject = mailbox.subject;
        dto.text = mailbox.text;
        dto.sendFileName = mailbox.sendFileName;
        dto.image = mailbox.image;
        dto.userName = mailbox.userName;
        
        [array addObject:dto];
    }
    return array;
}

// 删除草稿
+ (BOOL)delateCAOGAO:(MailDTO *)dto{
    CommonDao *commonDao = [[CommonDao alloc] initWithContext:[[ContextManager instance] createNewContext]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sendTime = %@ and userName = %@",dto.sendTime,dto.userName];
    NSLog(@"sendTime******%@",dto.sendTime);
    BOOL result = [commonDao removeEntity:[Mailbox class] byConditionWithPredicate:predicate];
    [commonDao saveAction];
    return result;
}

// 收件箱 → 垃圾箱
+ (BOOL)deleteSHOUJIAN:(MailDTO *)dto{
    CommonDao *commonDao = [[CommonDao alloc] initWithContext:[[ContextManager instance] createNewContext] ];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sendTime = %@ and userName = %@",dto.sendTime,dto.userName];
     BOOL result = [commonDao removeEntity:[Mailbox class] byConditionWithPredicate:predicate];
    [commonDao saveAction];
    
    return result;
}


@end

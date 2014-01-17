//
//  EmailLogic.h
//  HelloMe
//
//  Created by 陳威 on 13-12-18.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MailDTO.h"
@interface EmailLogic : NSObject
//把email存本地DB
+ (BOOL)addMailInfoTOLoaclDB:(MailDTO *)dto;
//根据用户名得到本地Email
+ (NSMutableArray *)getMailInfoByUserName;

+ (NSMutableArray *)getMailInfoBoxIDLAJI;

+ (NSMutableArray *)getMailInfoBoxIDCAOGAO;

+ (NSMutableArray *)getMailInfoBoxIDSHOUJIAN;

+ (BOOL)delateCAOGAO:(MailDTO *)dto;

+ (BOOL)deleteSHOUJIAN:(MailDTO *)dto;
@end

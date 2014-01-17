//
//  getLAJIemailTest.m
//  HelloMe
//
//  Created by Smartphone25 on 2013/12/20.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EmailLogic.h"
#import "CommonDao.h"
#import "ContextManager.h"
#import "Mailbox.h"
#import "MailDTO.h"
#import "KeychainAccessor.h"
@interface getLAJIemailTest : XCTestCase

@end

@implementation getLAJIemailTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testExample
{
    CommonDao *commonDao = [[CommonDao alloc] initWithContext:[[ContextManager instance] createNewContext]];
    [commonDao removeAllEntity:[Mailbox class]];
    [commonDao saveAction];
    for (int i = 0; i<7; i++) {
        MailDTO *dto = [[MailDTO alloc] init];
        dto.mailId = i+1;
        dto.boxId = EMAILBOX_ID_LAJI;
        
        dto.sendTime = @"2013/12/12";
        dto.receiveTime = @"2013/12/13";
        dto.subject = @"写给未来sdsd的自己";
        dto.text = @"想说的是哪家快递就是不好dadasdfsadsads好山东黄金倒数第八十级大师的都是的撒打算减肥的发生步伐加快是否可骄傲的是否觉得少部分回家的房间卡恢复健康的放到手机客服即可上发挥而恢复到付款几点开始奋斗是空间发的顺丰快递";
        dto.image = @"/null/ul";
        // dto.userName = [KeychainAccessor stringForKey:USER_ACCOUNT];
        dto.userName = @"tester@email.com";
        if (i==5) {
            dto.boxId = EMAILBOX_ID_CAOGAO;
            dto.subject = @"写给未caogao";
        }
        if (i == 2) {
            dto.boxId  = EMAILBOX_ID_SHOUJIAN;
            dto.subject = @"saisai";
        }
        [EmailLogic addMailInfoTOLoaclDB:dto];
    }
    
    NSMutableArray *array = [EmailLogic getMailInfoBoxIDLAJI];
    for (int i=0; i<array.count; i++) {
        MailDTO *mailDTO = [array objectAtIndex:i];
        NSLog(@"标题：%@",mailDTO.subject);
    }
}

@end

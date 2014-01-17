//
//  EmailLogicTest.m
//  HelloMe
//
//  Created by 陳威 on 13-12-18.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EmailLogic.h"
#import "CommonDao.h"
#import "ContextManager.h"
#import "Mailbox.h"
#import "MailDTO.h"
#import "KeychainAccessor.h"
@interface EmailLogicTest : XCTestCase

@end

@implementation EmailLogicTest

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
   // [KeychainAccessor setString:@"tester@email.com" forKey:USER_ACCOUNT];
    CommonDao *commonDao = [[CommonDao alloc] initWithContext:[[ContextManager instance] createNewContext]];
    [commonDao removeAllEntity:[Mailbox class]];
    [commonDao saveAction];
    for (int i = 0; i<7; i++) {
        MailDTO *dto = [[MailDTO alloc] init];
        dto.mailId = i+1;
        dto.boxId = EMAILBOX_ID_SHOUJIAN;
        dto.sendTime = @"2013/12/12";
        dto.receiveTime = @"2013/12/13";
        dto.subject = @"写给未来的自己";
        dto.text = @"想说的是哪家快递就是不好就是符合技术部分和骄傲是不大好山东黄金倒数第八十级大师的都是的撒打算减肥的发生步伐加快是否可骄傲的是否觉得少部分回家的房间卡恢复健康的放到手机客服即可上发挥而恢复到付款几点开始奋斗是空间发的顺丰快递";
        dto.image = @"1.png";
        // dto.userName = [KeychainAccessor stringForKey:USER_ACCOUNT];
        dto.userName = @"tester@email.com";
        [EmailLogic addMailInfoTOLoaclDB:dto];
    }
    
    NSMutableArray *array = [EmailLogic getMailInfoByUserName];
    for (int i=0; i<array.count; i++) {
        MailDTO *mailDTO = [array objectAtIndex:i];
        NSLog(@"标题：%@",mailDTO.subject);
    }
   // XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end

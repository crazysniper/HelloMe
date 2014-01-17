//
//  MailDTO.h
//  HelloMe
//
//  Created by 陳威 on 13-12-18.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MailDTO : NSObject

@property (nonatomic) int  mailId;
@property (nonatomic) int  boxId;
@property (nonatomic) NSString * sendTime;//发送时间
@property (nonatomic) NSString * receiveTime;// 收件时间
@property (nonatomic) NSString * subject;//标题
@property (nonatomic) NSString * text;//内容
@property (nonatomic) NSString * sendFileName;
@property (nonatomic) NSString * image;//图片名
@property (nonatomic) NSString * userName;//用户名
@end

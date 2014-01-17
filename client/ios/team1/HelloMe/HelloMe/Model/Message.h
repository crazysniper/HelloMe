//
//  Message.h
//  HelloMe
//
//  Created by 于翔 on 13-12-18.
//  Copyright (c) 2013年 于翔. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
	@class		Message
	@abstract	プロフィール登録情報
 */
@interface Message : NSObject {
	NSString *messageID;
    NSString *boxID;
	NSString *topic;
	NSString *text;
	NSString *sendYear;
	NSString *sendMonth;
	NSString *sendDay;
	NSString *sendHour;
	NSString *sendMinute;
	NSString *receiveYear;
	NSString *receiveMonth;
	NSString *receiveDay;
	NSString *receiveHour;
	NSString *receiveMinute;
    NSString *sendFileUrl;
    NSString *userName;
    NSString *sendFileName;
    NSString *sendImageString;

}

/*!
	@protocol 
	@abstract	用户ID
 */
@property (nonatomic, retain)NSString *messageID;
/*!
    @protocol
    @abstract	用户名
 */
@property (nonatomic, retain)NSString *boxID;
/*!
	@protocol 
	@abstract	主题
 */
@property (nonatomic, retain)NSString *topic;
/*!
	@protocol 
	@abstract	正文
 */
@property (nonatomic, retain)NSString *text;
/*!
	@protocol 
	@abstract	发送年度
 */
@property (nonatomic, retain)NSString *sendYear;
/*!
	@protocol 
	@abstract	发送月份
 */
@property (nonatomic, retain)NSString *sendMonth;
/*!
	@protocol 
	@abstract	发送日期
 */
@property (nonatomic, retain)NSString *sendDay;
/*!
	@protocol 
	@abstract	发送小时
 */
@property (nonatomic, retain)NSString *sendHour;
/*!
	@protocol 
	@abstract	发送分钟
 */
@property (nonatomic, retain)NSString *sendMinute;
/*!
    @protocol
    @abstract	收取年度
 */
@property (nonatomic, retain)NSString *receiveYear;
/*!
    @protocol
    @abstract	收取月份
 */
@property (nonatomic, retain)NSString *receiveMonth;
/*!
    @protocol
    @abstract	收取日期
 */
@property (nonatomic, retain)NSString *receiveDay;
/*!
    @protocol
    @abstract	收取小时
 */
@property (nonatomic, retain)NSString *receiveHour;
/*!
    @protocol
    @abstract	收取分钟
 */
@property (nonatomic, retain)NSString *receiveMinute;
/*!
	@protocol 
	@abstract	文件路径
 */
@property (nonatomic, retain)NSString *sendFileUrl;
/*!
    @protocol
    @abstract   文件路径
 */
@property (nonatomic, retain)NSString *userName;
/*!
    @protocol
    @abstract	图片流
 */
@property (nonatomic, retain)NSString *sendImageString;
/*!
     @protocol
     @abstract	图片名
 */
@property (nonatomic, retain)NSString *sendImageName;

// 发信日期的表示取得
-(NSString *)getSendDayViewText;

// 发信时间的表示取得
-(NSString *)getSendTimeViewText;

- (id)initWithDivision;

@end

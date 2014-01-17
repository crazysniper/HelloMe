//
//  MessageService.h
//  HelloMe
//
//  Created by yux on 2013/12/17.
//  Copyright (c) 2013年 wuhh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"

/*!
 @class		MessageService
 @abstract	信件的service
 */
@interface MessageService : NSObject {
    
}

/*!
 @method
 @abstract	信件信息追加
 @param		messageInfo 需要追加的信件信息
 @result	追加结果
 */
- (BOOL)insertMessageInfo:(Message *)messageInfo;

/*!
 @method
 @abstract	草稿箱的信件信息变更
 @param		messageInfo 需要变更的信件信息
 @result	变更结果
 */
- (BOOL)updateMessageInfo:(Message *)messageInfo;

/*!
 @method
 @abstract  邮箱中的信件删除
 @param		messageInfo 需要删除的信件ID
 @result	删除结果
 */
- (BOOL)deleteMessageInfo:(Message *)messageInfo;

@end

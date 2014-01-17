//
//  Mailbox.h
//  HelloMe
//
//  Created by 陳威 on 13-12-18.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Mailbox : NSManagedObject

@property (nonatomic, retain) NSNumber * mailId;
@property (nonatomic, retain) NSNumber * boxId;
@property (nonatomic, retain) NSString * sendTime;
@property (nonatomic, retain) NSString * receiveTime;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * sendFileName;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * userName;

@end

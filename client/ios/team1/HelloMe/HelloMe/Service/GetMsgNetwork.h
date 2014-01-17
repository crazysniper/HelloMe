//
//  GetMsgNetwork.h
//  HelloMe
//
//  Created by 高丰 on 2013/12/21.
//  Copyright (c) 2013年 高丰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"


@interface GetMsgNetwork : NSObject<NSXMLParserDelegate,NSURLConnectionDelegate>

@property(nonatomic,retain) NSMutableData *webData;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic,retain)NSDictionary *result;

- (void)getMsg:(Message *)msgInfo;

@end

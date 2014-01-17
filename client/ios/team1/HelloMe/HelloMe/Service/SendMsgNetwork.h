//
//  SendMsgNetwork.h
//  HelloMe
//
//  Created by 高丰 on 2013/12/21.
//  Copyright (c) 2013年 高丰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"

@protocol delegateSend <NSObject>
-(void)linkServerAlert;
-(void)sendFailure;
-(void)sendOK;
@end

@interface SendMsgNetwork : NSObject<NSXMLParserDelegate,NSURLConnectionDelegate>{
       id<delegateSend> delegate;
}

@property(nonatomic,retain) NSMutableData *webData;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic,strong)NSDictionary *result;
@property(nonatomic, retain) id<delegateSend> delegate;


-(void)sendMsg:(Message *)msgInfo;

@end

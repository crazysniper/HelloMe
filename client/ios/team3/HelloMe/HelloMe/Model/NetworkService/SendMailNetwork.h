//
//  SendMailNetwork.h
//  HelloMe
//
//  Created by Smartphone21 on 12/20/13.
//  Copyright (c) 2013 ldns. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MailDTO.h"
//委托
@protocol sendMailDelegate <NSObject>
- (void)sendSuccessd;
- (void)sendFailed;
- (void)sendNetworkError;
@end
@interface SendMailNetwork:NSObject<NSXMLParserDelegate>{
    id <sendMailDelegate> delegate;
}

@property(nonatomic,retain) NSMutableData *webData;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic,strong)NSDictionary *result;
@property (nonatomic, retain) id <sendMailDelegate> delegate;
- (void)saveMail:(MailDTO *)dto;
@end

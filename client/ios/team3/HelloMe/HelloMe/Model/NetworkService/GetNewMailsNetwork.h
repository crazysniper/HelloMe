//
//  GetNewMailsNetwork.h
//  HelloMe
//
//  Created by Smartphone21 on 12/20/13.
//  Copyright (c) 2013 ldns. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MailDTO.h"
//委托
@protocol GetNewMailsDelegate <NSObject>
- (void)getNewMailsSuccessd;
- (void)getNewMailsFailed;
@end

@interface GetNewMailsNetwork : NSObject<NSXMLParserDelegate>
{
    NSDictionary *result;
    id <GetNewMailsDelegate> delegate;
}
@property(nonatomic,retain) NSMutableData *webData;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic,strong)NSDictionary *result;
@property (nonatomic, retain) id <GetNewMailsDelegate> delegate;
- (void)getNewMails:(MailDTO *)dto;

@end

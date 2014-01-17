//
//  LoginNetwork.h
//  HelloMe
//
//  Created by 陳威 on 13-12-19.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginDTO.h"
//委托
@protocol loginDelegate <NSObject>
- (void)loginSuccessd;
- (void)loginFailed;
- (void)loginNetworkError;
@end

@interface LoginNetwork : NSObject<NSXMLParserDelegate>{
    id <loginDelegate> delegate;
    LoginDTO *mDTO;
}

@property(nonatomic) NSMutableData *webData;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property (nonatomic, retain) id <loginDelegate> delegate;
- (void)login:(LoginDTO *)dto;
@end

//
//  LoginNetwork.h
//  HelloMe
//
//  Created by 高丰 on 2013/12/21.
//  Copyright (c) 2013年 高丰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@protocol delegateLogin <NSObject>
-(void) linkServerAlert;
-(void) loginFailuer;
-(void) loginOK;
@end

@interface LoginNetwork : NSObject<NSXMLParserDelegate,NSURLConnectionDelegate>{
        id<delegateLogin> delegate;
}

@property(nonatomic) NSMutableData *webData;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) id<delegateLogin> delegate;

- (void)login:(User *)user;

@end

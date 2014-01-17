//
//  RegisterNetwork.h
//  HelloMe
//
//  Created by 高丰 on 2013/12/21.
//  Copyright (c) 2013年 高丰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@protocol delegateRegister <NSObject>
-(void)linkServerAlert;
-(void)registerFailuer;
-(void)registerOK;
@end

@interface RegisterNetwork : NSObject<NSXMLParserDelegate,NSURLConnectionDelegate>{
    id<delegateRegister> delegate;
}

@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) id<delegateRegister> delegate;

-(void)register:(User *)user;

@end

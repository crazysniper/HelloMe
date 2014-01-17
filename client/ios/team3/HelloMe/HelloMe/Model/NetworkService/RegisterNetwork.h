//
//  RegisterNetwork.h
//  HelloMe
//
//  Created by 陳威 on 13-12-19.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginDTO.h"
//委托
@protocol registerDelegate <NSObject>
- (void)registerSuccessd;
- (void)registerFailed;
- (void)registerNetworkError;
@end

@interface RegisterNetwork : NSObject<NSXMLParserDelegate>{
    id <registerDelegate> delegate;
}



@property(nonatomic) NSMutableData *webData;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic,strong)NSDictionary *result;
@property (nonatomic, retain) id <registerDelegate> delegate;
- (void)register:(LoginDTO *)dto;
@end
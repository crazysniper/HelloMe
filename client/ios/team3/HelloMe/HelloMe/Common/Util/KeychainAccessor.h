//
//  KeychainAccessor.h
//  HelloMe
//
//  Created by 陳威 on 13-12-18.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeychainAccessor : NSObject
+ (void)deleteStringForKey:(NSString *)aKey;
+ (void)setString:(NSString *)aString forKey:(NSString *)aKey;
+ (NSString *)stringForKey:(NSString *)aKey;

@end

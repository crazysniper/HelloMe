//
//  KeychainAccessor.m
//  HelloMe
//
//  Created by 陳威 on 13-12-18.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import "KeychainAccessor.h"

@implementation KeychainAccessor

+ (void)deleteStringForKey:(NSString *)aKey {
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    [query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [query setObject:(id)aKey forKey:(__bridge id)kSecAttrAccount];
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
    
    if (status != noErr) {
        NSLog(@"[KeychainAccessor]>>> SecItemDelete result in error:(%d)", (int)status);
    }
}

+ (void)setString:(NSString *)aString forKey:(NSString *)aKey {
    
    NSData *savingData = [aString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [attributes setObject:(id)aKey forKey:(__bridge id)kSecAttrAccount];
    [attributes setObject:savingData forKey:(__bridge id)kSecValueData];
    
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)attributes, NULL);
    
    if (status != noErr) {
        NSLog(@"[KeychainAccessor]>>> SecItemAdd result in error:(%d)", (int)status);
    }
}

+ (NSString *)stringForKey:(NSString *)aKey {
    
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    [query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [query setObject:(id)aKey forKey:(__bridge id)kSecAttrAccount];
    [query setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [query setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    CFDataRef result = nil;
    
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query,(CFTypeRef*)&result);
    
    if (status != noErr) {
        if (status == errSecItemNotFound) {
            NSLog(@"[KeychainAccessor]>>> SecItemCopyMatching result NOT-FOUND.");
        } else {
            NSLog(@"[KeychainAccessor]>>> SecItemCopyMatching result in error:(%d)", (int)status);
        }
        return nil;
    }
    
    NSData *theValue = [(__bridge NSData*)result copy];
    return [[NSString alloc] initWithData:theValue encoding:NSUTF8StringEncoding];
}
@end
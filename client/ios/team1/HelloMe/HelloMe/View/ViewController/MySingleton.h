//
//  MySingleton.h
//  HelloMe
//
//  Created by wuhh on 12/20/13.
//  Copyright (c) 2013 wuhh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySingleton : NSObject
{
  NSString *testGlobal;
}

+ (MySingleton *)sharedSingleton;
+ (NSString *)getNowTime;
+(NSString *)getNowTimeDetail;
@property (nonatomic,retain) NSString *testGlobal;

@end

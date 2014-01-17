//
//  ThemeManager.h
//  HelloMe
//
//  Created by 陳威 on 13-12-23.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeManager : NSObject
@property (strong, nonatomic) NSString *theme;

+ (ThemeManager *)sharedInstance;

- (UIImage *)imageWithImageName:(NSString *)imageName;
- (UIColor *)colorWithColorName;
@end

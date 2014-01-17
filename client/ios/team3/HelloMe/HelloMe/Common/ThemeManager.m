//
//  ThemeManager.m
//  HelloMe
//
//  Created by 陳威 on 13-12-23.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import "ThemeManager.h"
#import "ColorUtil.h"
@implementation ThemeManager
@synthesize theme = _theme;
+ (ThemeManager *)sharedInstance
{
    static dispatch_once_t once;
    static ThemeManager *instance = nil;
    dispatch_once( &once, ^{ instance = [[ThemeManager alloc] init]; } );
    return instance;
}
- (void)setTheme:(NSString *)theme
{
     [[NSUserDefaults standardUserDefaults] setObject:theme forKey:@"setting.theme"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    _theme = [theme copy];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:ThemeDidChangeNotification
     object:nil];
}
- (UIImage *)imageWithImageName:(NSString *)imageName
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName
                                                          ofType:@"png"
                                                     inDirectory:nil];
    
    return [UIImage imageWithContentsOfFile:imagePath];
}
- (UIColor *)colorWithColorName{
    NSArray *themes = @[kThemeRed, kThemeBlue, kThemePray,kThemeGreen,kThemePurple,kThemePink];
    NSArray *themesColor = @[[UIColor redColor],
                             [UIColor blueColor],
                             [ColorUtil colorFromColorString:@"363636"],
                             [ColorUtil colorFromColorString:@"CB6C0B"],
                             [ColorUtil colorFromColorString:@"7B256F"],
                             [ColorUtil colorFromColorString:@"E61C9E"]];
    
    for (int i = 0; i < [themes count]; i++) {
        if ([self.theme isEqualToString:themes[i]]) {
            return themesColor[i];
        }
    }
    return [UIColor redColor];
}

- (NSString *)theme
{
    _theme = [[NSUserDefaults standardUserDefaults] objectForKey:@"setting.theme"];
    if ( _theme == nil )
    {
        return @"green";
    }
    return _theme;
}
@end
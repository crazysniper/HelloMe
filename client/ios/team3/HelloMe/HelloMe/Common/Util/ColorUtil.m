//
//  ColorUtil.m
//  HelloMe
//
//  Created by 陳威 on 13-12-16.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import "ColorUtil.h"

@implementation ColorUtil
+ (UIColor *)colorFromColorString:(NSString *)colorString {
    NSScanner *scanner = [[NSScanner alloc] initWithString:colorString];
    unsigned color = 0;
    [scanner scanHexInt:&color];
    unsigned r = (color >> 16) & 0x000000FF;
    unsigned g = (color >> 8) & 0x000000FF;
    unsigned b = color & 0x000000FF;
    CGFloat rf = (CGFloat)r / 255.f;
    CGFloat gf = (CGFloat)g / 255.f;
    CGFloat bf = (CGFloat)b / 255.f;
    return [UIColor colorWithRed:rf green:gf blue:bf alpha:1.0f];
}
@end

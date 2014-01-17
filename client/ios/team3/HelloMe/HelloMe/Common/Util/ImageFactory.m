//
//  ImageFactory.m
//  HelloMe
//
//  Created by 陳威 on 13-12-16.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import "ImageFactory.h"

@implementation ImageFactory
+ (UIImage *)imageRectangleWithColor:(UIColor *)color size:(CGSize)size {
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}



+ (UIImage *)imageRectStrokeWithColor:(UIColor *)color size:(CGSize)size lineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextSetLineWidth(context, lineWidth);
    CGContextAddRect(context, rect);
    CGContextStrokePath(context);
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}
@end

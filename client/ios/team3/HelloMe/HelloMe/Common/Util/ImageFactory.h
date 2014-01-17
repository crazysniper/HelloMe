//
//  ImageFactory.h
//  HelloMe
//
//  Created by 陳威 on 13-12-16.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageFactory : NSObject
+ (UIImage *)imageRectangleWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)imageRectStrokeWithColor:(UIColor *)color size:(CGSize)size lineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth;
@end

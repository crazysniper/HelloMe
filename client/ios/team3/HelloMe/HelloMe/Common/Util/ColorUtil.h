//
//  ColorUtil.h
//  HelloMe
//
//  Created by 陳威 on 13-12-16.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorUtil : NSObject
/*将十六进制颜色代码转化为RGB的UIColor
 */
+ (UIColor *)colorFromColorString:(NSString *)colorString;
@end

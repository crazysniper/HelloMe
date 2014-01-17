//
//  Line.h
//  Draw
//
//  Created by student on 12-8-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Line : NSObject
{
    NSMutableArray *Points;
    UIColor *color;
    float width;
}

@property  NSMutableArray *Points;
@property  UIColor *color;
@property  float width;

@end

//
//  Draw.h
//  Draw
//
//  Created by student on 12-8-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface DrawView : UIView
{
    NSMutableArray *Points;
    NSMutableArray *Lines;
    
    UIColor *color;
    float width;

    CGContextRef context;
}

@property (strong, nonatomic) NSMutableArray *Points;
@property (strong, nonatomic) NSMutableArray *Lines;
@property (nonatomic,strong) UIImage *drawImageObj;


@property (strong, nonatomic) UIColor *color;
@property (nonatomic) float width;


@property (nonatomic) CGContextRef context;

@end

//
//  CustomTextField.m
//  HelloMe
//
//  Created by 陳威 on 13-12-16.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import "CustomTextField.h"
#import "ImageFactory.h"
#import "ColorUtil.h"
@implementation CustomTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    UIImage *image = [ImageFactory imageRectStrokeWithColor:[UIColor clearColor] size:CGSizeMake(290, 50) lineColor:[ColorUtil colorFromColorString:@"ffffff"] lineWidth:4.0f];
    self.background = image;
    self.textColor = [UIColor whiteColor];
}
- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect inset = CGRectMake(bounds.origin.x +8, bounds.origin.y +10, 30, 30);
    return inset;
}
- (void)drawPlaceholderInRect:(CGRect)rect
{
    [[UIColor colorWithRed:(255.0f / 255.0f) green:(255.0f / 255.0f) blue:(255.0f / 255.0f) alpha:0.6f] setFill];
    [self.placeholder drawInRect:rect withFont:[UIFont systemFontOfSize:15.0f]];
}

-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    if (IOS_VERSION>=7) {
        CGRect inset = CGRectMake(bounds.origin.x + 55, bounds.origin.y+15, bounds.size.width - 10, bounds.size.height);
        return inset;
    }else{
        CGRect inset = CGRectMake(bounds.origin.x + 55, bounds.origin.y, bounds.size.width - 10, bounds.size.height);
        return inset;
    }
    
    
}

-(CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x + 55, bounds.origin.y, bounds.size.width - 10, bounds.size.height);
    return inset;
}

-(CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x + 55, bounds.origin.y, bounds.size.width - 10, bounds.size.height);
    return inset;
}
@end

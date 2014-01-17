//
//  Draw.m
//  Draw
//
//  Created by student on 12-8-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DrawView.h"
#import "Line.h"
#import "PictureViewController.h"

@implementation DrawView

@synthesize Points;
@synthesize Lines;
@synthesize color;
@synthesize width;

@synthesize context;
@synthesize drawImageObj;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.Points = [NSMutableArray array];
        self.Lines = [NSMutableArray array];
        
        if (color == nil || width == 0)
        {
            color = [UIColor blackColor];
            width = 2.0;
        }
    }
    return self;
}


#pragma mark draw

- (void)drawRect:(CGRect)rect
{
    //NSLog(@"%f",width);

    
    context = UIGraphicsGetCurrentContext();
	CGContextSetLineCap(context, kCGLineCapRound);
	CGContextSetLineJoin(context, kCGLineJoinRound);   
//    CGContextSetLineWidth(context, 4.0f);    
//    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);    


    //CGContextSetBlendMode(context,kCGBlendModeNormal);    

    

    
    if (Lines.count>0)//画之前线
    {
        for (int i=0 ; i<Lines.count ; i++)
        {
            Line *line = [Lines objectAtIndex:i];
            
            UIColor *Color = line.color;
            float Width = line.width;
            
            if ([line.color isEqual:[UIColor clearColor]])
            {
                //NSLog(@"相同");
                CGContextSetBlendMode(context, kCGBlendModeClear);
            }
            else {
                CGContextSetBlendMode(context,kCGBlendModeNormal);
            }
            
            
            CGContextSetLineWidth(context, Width);    
            CGContextSetStrokeColorWithColor(context, Color.CGColor); 
            
            
            for (int j=0 ; j<line.Points.count-1 ; j++)
            {
                CGPoint p1 = [[line.Points objectAtIndex:j] CGPointValue];
                CGPoint p2 = [[line.Points objectAtIndex:j+1] CGPointValue];
                CGContextMoveToPoint(context, p1.x, p1.y);
                CGContextAddLineToPoint(context, p2.x, p2.y);
                CGContextStrokePath(context);
            }
        }
    }
    
    
    if (Points && Points.count>2)//画当前线
    {        
        for (int i=0 ; i<Points.count-1 ; i++)
        {
            if ([color isEqual:[UIColor clearColor]])
            {
                NSLog(@"相同");
                CGContextSetBlendMode(context, kCGBlendModeClear);
            }
            else {
                CGContextSetBlendMode(context,kCGBlendModeNormal);
            }
            
            CGContextSetLineWidth(context, width);    
            CGContextSetStrokeColorWithColor(context, color.CGColor);              
            
            
            CGPoint p1 = [[Points objectAtIndex:i] CGPointValue];
            CGPoint p2 = [[Points objectAtIndex:i+1] CGPointValue];
            CGContextMoveToPoint(context, p1.x, p1.y);
            CGContextAddLineToPoint(context, p2.x, p2.y);
            CGContextStrokePath(context);
        }
    }    
    
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    self.drawImageObj = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    
}

#pragma mark touch

-(BOOL)isMultipleTouchEnabled
{
    return NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[Points removeAllObjects];
    
    //PictureViewController *p = [PictureViewController new];
    //[p.tempLines removeAllObjects];
    
    //NSLog(@"-----%i",p.tempLines.count);
    
    
    //NSLog(@"begin");
    
    CGPoint point = [[touches anyObject] locationInView:self];
    [self.Points addObject:[NSValue valueWithCGPoint:point]];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    [self.Points addObject:[NSValue valueWithCGPoint:point]];
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{   
    //NSLog(@"end");
    
    
    CGPoint point = [[touches anyObject] locationInView:self];
    [self.Points addObject:[NSValue valueWithCGPoint:point]];
    
    Line *line = [Line new];
    line.Points = [NSArray arrayWithArray:Points];
    line.color = color;
    line.width = width;
    
    if (line.Points.count >2)
    {
        [Lines addObject:line];
    }
    
    [Points removeAllObjects];


//    PictureViewController *p = [PictureViewController new];
//    p.delegate = self;    
    
    
    
 
    
//    NSArray *ar = [NSArray arrayWithArray:Points];
//    
//    if (ar.count >2)
//    {
//        [Lines addObject:ar];
//    }
    
}


@end

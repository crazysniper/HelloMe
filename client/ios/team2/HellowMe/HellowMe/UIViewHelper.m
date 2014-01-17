//
//  Created by 涛 傅 on 12-1-31.
//  Copyright (c) 2011年 com.emobilesoft. All rights reserved.
//


#import "UIViewHelper.h"
#import <QuartzCore/QuartzCore.h>


#define kCoinImageViewTag2 99999999991
#define kCoinNumLabel2 99999999992
#define kCoinAnimationLabel2 9999999993

///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation UIView (Helper)
- (CGPoint)centerPoint {
	return CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
}
- (CGPoint)midpoint
{
    CGRect frame = [self frame];
    CGPoint midpoint = CGPointMake(frame.origin.x + (frame.size.width/2),
                                   frame.origin.y + (frame.size.height/2));
    return midpoint;
}
- (void)setMidpoint:(CGPoint)midpoint
{
    CGRect frame = [self frame];
    frame.origin = CGPointMake(midpoint.x - (frame.size.width/2),
                               midpoint.y - (frame.size.height/2));
	self.frame = frame;
}

- (CGFloat)x {
	return self.frame.origin.x;
}
- (void)setX:(CGFloat)x {
	CGRect frame = self.frame;
	frame.origin.x = x;
	self.frame = frame;
}
- (CGFloat)y {
	return self.frame.origin.y;
}
- (void)setY:(CGFloat)y {
	CGRect frame = self.frame;
	frame.origin.y = y;
	self.frame = frame;
}
- (CGFloat)width {
	return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width {
	CGRect frame = self.frame;
	frame.size.width = width;
	self.frame = frame;
}
- (CGFloat)height {
	return self.frame.size.height;
}
- (void)setHeight:(CGFloat)height {
	CGRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}
- (void)centerInRect:(CGRect)rect;
{
    [self setCenter:CGPointMake(floorf(CGRectGetMidX(rect)) + ((int)floorf([self width]) % 2 ? .5 : 0) , floorf(CGRectGetMidY(rect)) + ((int)floorf([self height]) % 2 ? .5 : 0))];
}

- (void)centerVerticallyInRect:(CGRect)rect;
{
    [self setCenter:CGPointMake([self center].x, floorf(CGRectGetMidY(rect)) + ((int)floorf([self height]) % 2 ? .5 : 0))];
}

- (void)centerHorizontallyInRect:(CGRect)rect;
{
    [self setCenter:CGPointMake(floorf(CGRectGetMidX(rect)) + ((int)floorf([self width]) % 2 ? .5 : 0), [self center].y)];
}


- (void)removeAllSubviews {
	while (self.subviews.count) {
		UIView* child = self.subviews.lastObject;
		[child removeFromSuperview];
	}
}
- (void)removeAllSubviewsToNull {
	while (self.subviews.count) {
		UIView* child = self.subviews.lastObject;
        if ([child respondsToSelector:@selector(setDelegate:)]) {
            [child performSelector:@selector(setDelegate:) withObject:nil];
        }
        [child removeFromSuperview];
        child = nil;
	}
}
-(UIView *)findView:(UIView *)aView className:(NSString *)className{
	Class cl = [aView class];
	NSString *desc = [cl description];
	
	if ([className isEqualToString:desc])
		return aView;
	
	for (NSUInteger i = 0; i < [aView.subviews count]; i++)
	{
		UIView *subView = [aView.subviews objectAtIndex:i];
		subView = [self findView:subView className:className];
		if (subView)
			return subView;
	}
	
    return nil;	
}

-(NSArray *)findViews:(UIView *)aView className:(NSString *)className{
	Class cl = [aView class];
	NSString *desc = [cl description];
	
	if ([className isEqualToString:desc])
		return [NSArray arrayWithObject:aView];
    
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
	for (NSUInteger i = 0; i < [aView.subviews count]; i++)
	{
		UIView *subView = [aView.subviews objectAtIndex:i];
		subView = [self findView:subView className:className];
		if (subView)
			[array addObject:subView];
	}
	return array;	
}
- (UIImage*)currentContextImage {
    UIImage *viewImage = nil;
//    if (NULL != UIGraphicsBeginImageContextWithOptions)
//        UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, 0);
//    else
//        UIGraphicsBeginImageContext(self.frame.size);
    UIGraphicsBeginImageContext(self.frame.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    viewImage = UIGraphicsGetImageFromCurrentImageContext(); 
    
    UIGraphicsEndImageContext();
    
#if __has_feature(objc_arc)
    return [viewImage copy];
#else
    return [[viewImage copy] autorelease];
#endif
}



@end

///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation UIView (background)
// 设置背景
- (void)setBackgroundViewWithImage:(UIImage *)image withFrame:(CGRect)frame
{
    int nBackgroundViewTag = 0x110119;
    
    id vTmp = [self viewWithTag:nBackgroundViewTag];
    
    if ([[vTmp class] isSubclassOfClass:[UIImageView class]]) {

        UIImageView* oldView = (UIImageView *)[self viewWithTag:nBackgroundViewTag];
        if (oldView) [oldView removeFromSuperview];
        
    }
    
    
    if (image) {
        UIImageView* bgview = [[UIImageView alloc] initWithFrame:frame];
        bgview.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
        bgview.tag = nBackgroundViewTag;
        bgview.image = image;
        if ([self.subviews count] >0) { // 如果当前VIEW上面还有其他VIEW。
            [self insertSubview:bgview belowSubview:[self.subviews objectAtIndex:0]];
        }
        else{
            
            [self addSubview:bgview];  // 否则置顶
        }
#if !__has_feature(objc_arc)
        [bgview release]; 
#endif
    }
}

- (void)setBackgroundViewWithImage:(UIImage *)image
{

    [self setBackgroundViewWithImage:image withFrame:self.bounds];

}

@end
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation UIWindow (Additions)


- (UIView*)findFirstResponder {
    return [self findFirstResponderInView:self];
}

- (UIView*)findFirstResponderInView:(UIView*)topView {
    if ([topView isFirstResponder]) {
        return topView;
    }
    
    for (UIView* subView in topView.subviews) {
        if ([subView isFirstResponder]) {
            return subView;
        }
        
        UIView* firstResponderCheck = [self findFirstResponderInView:subView];
        if (nil != firstResponderCheck) {
            return firstResponderCheck;
        }
    }
    return nil;
}


@end



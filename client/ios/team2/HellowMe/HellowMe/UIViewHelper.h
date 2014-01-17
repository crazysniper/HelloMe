//
//  Created by 涛 傅 on 12-1-31.
//  Copyright (c) 2011年 com.emobilesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
///////////////////////////////////////////////////////////////////////////////////////////////////


static const CGFloat kDefaultRowHeight = 44.0f;

static const CGFloat kDefaultPortraitToolbarHeight   = 44.0f;
static const CGFloat kDefaultLandscapeToolbarHeight  = 33.0f;

static const CGFloat kDefaultPortraitKeyboardHeight      = 216.0f;
static const CGFloat kDefaultLandscapeKeyboardHeight     = 160.0f;
static const CGFloat kDefaultPadPortraitKeyboardHeight   = 264.0f;
static const CGFloat kDefaultPadLandscapeKeyboardHeight  = 352.0f;

static const CGFloat kGroupedTableCellInset = 9.0f;
static const CGFloat kGroupedPadTableCellInset = 42.0f;

static const CGFloat kDefaultTransitionDuration      = 0.3f;
static const CGFloat kDefaultFastTransitionDuration  = 0.2f;
static const CGFloat kDefaultFlipTransitionDuration  = 0.7f;

/**
 * Example result: CGRectMake(x, y, w - dx, h - dy)
 */
NS_INLINE CGRect mkRectContract(CGRect rect, CGFloat dx, CGFloat dy){
    return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width - dx, rect.size.height - dy);
}

/**
 * Example result: CGRectMake(x + dx, y + dy, w - dx, h - dy)
 */
NS_INLINE CGRect mkRectShift(CGRect rect, CGFloat dx, CGFloat dy){
    return CGRectMake(rect.origin.x + dx, rect.origin.y + dy, rect.size.width - dx, rect.size.height - dy);
    
}

/**
 * Example result: CGRectMake(x + left, y + top, w - (left + right), h - (top + bottom))
 */
NS_INLINE CGRect mkRectInset(CGRect rect, UIEdgeInsets insets){
    return CGRectMake(rect.origin.x + insets.left, rect.origin.y + insets.top,
                      rect.size.width - (insets.left + insets.right),
                      rect.size.height - (insets.top + insets.bottom));
}




///////////////////////////////////////////////////////////////////////////////////////////////////
@interface UIView (Helper)




@property (nonatomic,readonly) CGPoint centerPoint; // (frame.size.width / 2, frame.size.height / 2)
@property (nonatomic) CGPoint midpoint;

@property (nonatomic) CGFloat x; // frame.origin.x 
@property (nonatomic) CGFloat y; // frame.origin.y
@property (nonatomic) CGFloat width; // frame.size.width
@property (nonatomic) CGFloat height; // frame.size.height

- (void)centerInRect:(CGRect)rect;
- (void)centerVerticallyInRect:(CGRect)rect;
- (void)centerHorizontallyInRect:(CGRect)rect;
/**
 * 移除所有子视图.
 */
- (void)removeAllSubviews ;
- (void)removeAllSubviewsToNull;
/**
 * 找出视图
 */
-(UIView *)findView:(UIView *)aView className:(NSString *)className;
-(NSArray *)findViews:(UIView *)aView className:(NSString *)className;

/**
 * 截图.
 */
- (UIImage*)currentContextImage;


@end

///////////////////////////////////////////////////////////////////////////////////////////////////
@interface UIView (background)

// 设置背景
- (void)setBackgroundViewWithImage:(UIImage *)image;

- (void)setBackgroundViewWithImage:(UIImage *)image withFrame:(CGRect)frame;

@end


///////////////////////////////////////////////////////////////////////////////////////////////////
@interface UIWindow (Additions)

/**
 * Searches the view hierarchy recursively for the first responder, starting with this window.
 */
- (UIView*)findFirstResponder;

/**
 * Searches the view hierarchy recursively for the first responder, starting with topView.
 */
- (UIView*)findFirstResponderInView:(UIView*)topView;

@end



